import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { CloudSun, MapPin, Clock, Bell, HelpCircle, Star } from 'lucide-react';
import gamesApi from '../api/games';
import notificationsApi from '../api/notifications';
import weatherApi from '../api/weather';
import adminApi from '../api/admin';
import usersApi from '../api/users';
import venuesApi from '../api/venues';
import useGameStore from '../store/useGameStore';
import SafeImage from '../components/SafeImage';
import '../App.css';

function Home() {
  const navigate = useNavigate();
  const { parties, isPageLoading, fetchParties, connectSSE, disconnectSSE } = useGameStore();

  // 1. 所有 State 宣告放在最前面
  const [reputationScore, setReputationScore] = useState(100);
  const [showNotifications, setShowNotifications] = useState(false);
  const [showAqiInfo, setShowAqiInfo] = useState(false);
  const [showLevelInfo, setShowLevelInfo] = useState(false);
  const [selectedAnnouncement, setSelectedAnnouncement] = useState(null);
  const [notifications, setNotifications] = useState([]);
  const [systemAnnouncements, setSystemAnnouncements] = useState([]);
  const [aqi, setAqi] = useState('--');
  const [temperature, setTemperature] = useState('--');
  const [weatherLocation, setWeatherLocation] = useState('桃園市');
  const [userProfile, setUserProfile] = useState(null);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isFeedbackOpen, setIsFeedbackOpen] = useState(false);
  const [feedbackTypes, setFeedbackTypes] = useState([
    { id: 1, name: 'Bug 回報 (系統出錯)' },
    { id: 2, name: '功能建議 (想要更多)' },
    { id: 3, name: '場地/活動問題' },
    { id: 4, name: '其他' }
  ]);
  const [feedback, setFeedback] = useState({ type: 'Bug 回報 (系統出錯)', content: '' });
  const [selectedFilterRegion, setSelectedFilterRegion] = useState('all');
  const [selectedFilterDistrict, setSelectedFilterDistrict] = useState('all');
  const [selectedCategory, setSelectedCategory] = useState('全部');
  const [newParty, setNewParty] = useState({ 
    title: '', 
    type: '籃球', 
    level: '休閒', 
    genderLimit: '不限',
    city: '桃園市', 
    district: '桃園區', 
    venue: '桃園國民運動中心',
    note: '', 
    description: '',
    price: '',
    time: '', 
    duration: '2 小時',
    minPlayers: 2,
    maxPlayers: 4 
  });

  const [allVenues, setAllVenues] = useState([]); 
  const [taiwanRegions, setTaiwanRegions] = useState({
    '未選擇': { '未選擇': ['無場地'] }
  });
  const [venueFacilities, setVenueFacilities] = useState({});
  const [venueMap, setVenueMap] = useState({});
  const [regions, setRegions] = useState(taiwanRegions);

  // 2. 所有 Function 宣告
  const fetchData = async (showLoading = true) => {
    try {
      const results = await Promise.allSettled([
        fetchParties(showLoading),
        notificationsApi.getNotifications(),
        weatherApi.getWeatherAqi(),
        usersApi.getUserProfile(),
        venuesApi.getCourts(),
        adminApi.getSystemAnnouncements()
      ]);
      
      const notificationsResult = results[1].status === 'fulfilled' ? results[1].value : [];
      const weatherResult = results[2].status === 'fulfilled' ? results[2].value : {};
      const userProfileResult = results[3].status === 'fulfilled' ? results[3].value : null;
      const venuesResult = results[4].status === 'fulfilled' ? results[4].value : [];
      const announcementsResult = results[5]?.status === 'fulfilled' ? results[5].value : [];
      
      const rawAnnouncements = Array.isArray(announcementsResult) ? announcementsResult : (announcementsResult.results || []);
      const mappedAnnouncements = rawAnnouncements.map(a => {
        const photoRegex = /\n\n\[Photos\]\n([^\n]+)/;
        const match = String(a.content || '').match(photoRegex);
        let cleanContent = a.content || '';
        let photo = [];
        if (match) {
          photo = match[1].split(',').filter(Boolean);
          cleanContent = cleanContent.replace(photoRegex, '');
        }
        return {
          ...a,
          content: cleanContent,
          photo: photo
        };
      });
      setSystemAnnouncements(mappedAnnouncements);
      
      if (userProfileResult) {
        setUserProfile(userProfileResult);
        setReputationScore(userProfileResult.credit_point ?? 100);
      }

      const venuesList = Array.isArray(venuesResult) ? venuesResult : (venuesResult.results || []);
      if (venuesList.length > 0) {
        const venueDict = {};
        venuesList.forEach(court => {
          if (!court.venue_detail) return;
          const v = court.venue_detail;
          if (!venueDict[v.id]) {
            venueDict[v.id] = {
              id: v.id,
              name: v.name,
              city: v.address_detail?.city || '未分類縣市',
              district: v.address_detail?.district || '未分類區域',
              facilities: v.facilities || [],
              sports: new Set()
            };
          }
          if (court.sports && Array.isArray(court.sports)) {
            court.sports.forEach(s => venueDict[v.id].sports.add(s));
          }
        });
        const aggregatedVenues = Object.values(venueDict).map(v => ({
          ...v,
          sports: Array.from(v.sports)
        }));
        setAllVenues(aggregatedVenues);
      }

      const mappedNotifications = (Array.isArray(notificationsResult) ? notificationsResult : []).map(n => ({
        id: n.notification_id || n.id,
        text: n.message || '',
        read: n.is_read !== undefined ? n.is_read : false,
        time: n.created_at ? new Date(n.created_at).toLocaleString('zh-TW', { year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit' }) : '',
        match_id: n.match_id || n.game_id
      }));

      const validNotifications = mappedNotifications.filter(n => {
        if (n.text && n.text.includes('場地狀態已更新')) {
          const currentUserId = localStorage.getItem('user_id');
          const party = parties.find(g => g.id === n.match_id);
          const isHost = party ? (String(party.creator_id) === String(currentUserId) || String(party.creator) === String(currentUserId)) : false;
          if (isHost) return false;
        }
        return true;
      });
      setNotifications(validNotifications);
      setAqi(weatherResult?.aqi ?? '--');
      setTemperature(weatherResult?.temperature ?? '--');
      if (weatherResult?.location) setWeatherLocation(weatherResult.location);
    } catch (error) {
      console.error('Home fetchData error:', error);
    } finally {
      if (showLoading) setIsPageLoading(false);
    }
  };

  const handleLogout = () => {
    navigate('/');
  };

  const handleSendFeedback = async (e) => {
    e.preventDefault();
    try {
      await adminApi.submitFeedback(feedback);
      alert('感謝您的回饋！');
      setIsFeedbackOpen(false);
      setFeedback({ type: feedbackTypes[0]?.name || 'Bug 回報 (系統出錯)', content: '' });
    } catch (error) {
      console.error('Feedback error:', error);
    }
  };

  const handleCreateParty = async (e) => {
    e.preventDefault();
    const sportMap = { '籃球': 1, '羽球': 2, '排球': 3, '桌球': 4, '麻將': 5 };
    const venue_id = venueMap[newParty.venue] || 1;
    const dateObj = new Date(newParty.time);
    const booking_date = dateObj.toISOString().split('T')[0];
    const time_slot = `${dateObj.getHours()}:00-${dateObj.getHours()+2}:00`;

    const payload = {
      sport_id: sportMap[newParty.type] || 1,
      venue_id,
      most_players: parseInt(newParty.maxPlayers, 10),
      least_players: parseInt(newParty.minPlayers, 10),
      target_level: newParty.level,
      booking_date,
      start_time: `${dateObj.getHours()}:00`,
      time_slot,
      duration: newParty.duration,
      total_price: parseFloat(newParty.price) || 0,
      gender_limit: newParty.genderLimit,
      game_name: newParty.title,
      game_note: newParty.description
    };

    try {
      await gamesApi.createGame(payload);
      setIsModalOpen(false);
      fetchData(false);
      alert('發起成功！');
    } catch (error) {
      console.error('Create error:', error);
    }
  };

  const handleCityChange = (e) => {
    const city = e.target.value;
    const firstDist = Object.keys(taiwanRegions[city] || {})[0] || '';
    const firstVenue = (taiwanRegions[city]?.[firstDist] || [])[0] || '其他';
    setNewParty({ ...newParty, city, district: firstDist, venue: firstVenue });
  };

  const handleDistrictChange = (e) => {
    const district = e.target.value;
    const firstVenue = (taiwanRegions[newParty.city]?.[district] || [])[0] || '其他';
    setNewParty({ ...newParty, district, venue: firstVenue });
  };

  // 3. Effects
  useEffect(() => {
    fetchData();
    // 降級方案：Metadata 每 30 秒更新一次即可
    const poll = setInterval(() => fetchData(false), 30000);

    // 主動推送機制 (Active Push via SSE)
    connectSSE();

    return () => {
      clearInterval(poll);
      // 注意：如果是要在全域持續連線，這裡可以不中斷，或是由 Store 決定
      // 這裡選擇由首頁控制連線週期，或是你也可以放在 App.jsx
    };
  }, []);

  useEffect(() => {
    venuesApi.getVenues().then(data => {
      const list = Array.isArray(data) ? data : (data.results || []);
      if (list.length > 0) {
        const mergedRegions = { ...taiwanRegions };
        const mergedFacilities = { ...venueFacilities };
        const vMap = { ...venueMap };

        list.forEach(v => {
          const c = v.city || v.address_detail?.city || '其他';
          const d = v.district || v.address_detail?.district || '其他';
          if (!mergedRegions[c]) mergedRegions[c] = {};
          if (!mergedRegions[c][d]) mergedRegions[c][d] = [];
          mergedRegions[c][d].push(v.name);
          mergedFacilities[v.name] = v.facilities;
          vMap[v.name] = v.id;
        });

        setTaiwanRegions(mergedRegions);
        setRegions(mergedRegions);
        setVenueFacilities(mergedFacilities);
        setVenueMap(vMap);
      }
    });
  }, []);

  useEffect(() => {
    adminApi.getFeedbackTypes().then(data => {
      const list = Array.isArray(data) ? data : (data.results || []);
      setFeedbackTypes(list);
    });
  }, []);

  const renderModalContent = () => {
    if (!selectedAnnouncement) return null;
    return <div style={{ whiteSpace: 'pre-wrap' }}>{selectedAnnouncement.content}</div>;
  };

  return (
    <div className="home-container">
      <nav className="navbar">
        <div className="navbar-logo">不揪ㄛ</div>
        <div className="navbar-actions" style={{ display: 'flex', gap: '10px' }}>
          <div style={{ position: 'relative' }}>
            <button className="btn-outline" onClick={() => setShowNotifications(!showNotifications)}>
              <Bell size={18} />
            </button>
            {showNotifications && (
              <div className="notification-dropdown">
                <div style={{ padding: '12px 16px', borderBottom: '1px solid #f1f5f9', fontWeight: '700', color: '#1e293b', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                  通知中心
                  <div style={{ display: 'flex', gap: '12px', alignItems: 'center' }}>
                    <span 
                      style={{ fontSize: '12px', color: '#7995a5', cursor: 'pointer', fontWeight: 'normal' }}
                      onClick={async () => {
                        const unreadNotifs = notifications.filter(n => !n.read);
                        if (unreadNotifs.length > 0) {
                          try {
                             await Promise.all(unreadNotifs.map(n => notificationsApi.markAsRead(n.id)));
                          } catch (e) { console.error('Failed to mark all as read', e); }
                        }
                        setNotifications(notifications.map(n => ({...n, read: true})));
                      }}
                    >
                      全部標示為已讀
                    </span>
                    <span 
                      style={{ fontSize: '12px', color: '#ef4444', cursor: 'pointer', fontWeight: 'normal' }}
                      onClick={async () => {
                        if (window.confirm('確定要刪除所有已讀通知嗎？')) {
                          try {
                            await notificationsApi.deleteAllNotifications();
                            setNotifications(notifications.filter(n => !n.read));
                          } catch (e) {
                            console.error('Failed to delete read notifications', e);
                            alert('刪除通知失敗，請稍後再試。');
                          }
                        }
                      }}
                    >
                      一鍵刪除
                    </span>
                  </div>
                </div>
                <div style={{ maxHeight: '300px', overflowY: 'auto' }}>
                  {notifications.length > 0 ? (
                    notifications.map(n => (
                      <div 
                        key={n.id} 
                        style={{ padding: '12px 16px', borderBottom: '1px solid #f8fafc', display: 'flex', gap: '12px', cursor: 'pointer', backgroundColor: n.read ? 'white' : '#f0f9ff', alignItems: 'center' }}
                        onClick={async () => {
                          if (!n.read) {
                            try {
                              await notificationsApi.markAsRead(n.id);
                            } catch (e) { console.error('Failed to mark as read', e); }
                          }
                          setNotifications(notifications.map(item => item.id === n.id ? {...item, read: true} : item));
                          
                          // 處理點擊通知以彈窗展開
                          if (n.text) {
                            const refMatch = n.text.match(/\(Ref:\s*#(\d+)\)/);
                            let title = '系統通知';
                            let content = n.text;
                            let photos = [];
                            
                            if (refMatch) {
                              const announcementId = Number(refMatch[1]);
                              const found = systemAnnouncements.find(a => a.id === announcementId);
                              if (found) {
                                title = found.title.replace(/【通知 - 房主】|【通知 - 房間所有人】|【公告】/g, '').trim();
                                photos = found.photo || [];
                                if (!n.text.includes('給【')) {
                                  content = found.content;
                                }
                                
                                // 1. 清理 (Ref: #...) 標記與圖片區塊 [Photos]
                                content = content.replace(/\(Ref:\s*#\d+\)/g, '').split('\n\n[Photos]')[0].trim();
                                
                                // 2. 清理重複的標題與冒號
                                const escapedTitle = title.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&');
                                const titleRegex = new RegExp(escapedTitle + '\\s*[:：]\\s*', 'g');
                                content = content.replace(titleRegex, '').trim();
                              }
                            } else {
                              if (n.text.includes('【系統公告】')) {
                                const cleanText = n.text.replace('【系統公告】', '');
                                const colonIndex = cleanText.indexOf('：');
                                if (colonIndex !== -1) {
                                  title = cleanText.substring(0, colonIndex).trim();
                                  content = cleanText.substring(colonIndex + 1).trim();
                                } else {
                                  content = cleanText;
                                }
                              }
                            }
                            
                            setSelectedAnnouncement({ title, content, time: n.time, photos });
                          }
                        }}
                      >
                        <div style={{ width: '8px', display: 'flex', justifyContent: 'center' }}>
                          {!n.read && <div style={{ width: '6px', height: '6px', borderRadius: '50%', backgroundColor: '#0284c7' }}></div>}
                        </div>
                        <div style={{ flex: 1 }}>
                          <p style={{ margin: '0 0 4px 0', fontSize: '13px', color: n.read ? '#64748b' : '#0f172a', lineHeight: '1.4' }}>
                            {n.text.startsWith('【回饋處理通知】') ? '【回饋處理通知】' : (n.text.includes('\n') ? n.text.split('\n')[0] : n.text)}
                          </p>
                          <p style={{ margin: 0, fontSize: '11px', color: '#94a3b8' }}>{n.time}</p>
                        </div>
                        {/* 已讀後顯示刪除通知按鈕 */}
                        {n.read && (
                          <button
                            onClick={async (e) => {
                              e.stopPropagation(); // 阻止觸發外層已讀與彈窗事件
                              if (window.confirm('確定要刪除此通知嗎？')) {
                                try {
                                  await notificationsApi.deleteNotification(n.id);
                                  setNotifications(notifications.filter(item => item.id !== n.id));
                                } catch (err) {
                                  console.error('Failed to delete notification', err);
                                  alert('刪除通知失敗，請稍後再試。');
                                }
                              }
                            }}
                            style={{
                              background: 'none',
                              border: 'none',
                              color: '#94a3b8',
                              cursor: 'pointer',
                              fontSize: '18px',
                              fontWeight: 'normal',
                              padding: '4px 8px',
                              display: 'flex',
                              alignItems: 'center',
                              justifyContent: 'center',
                              marginLeft: 'auto'
                            }}
                            title="刪除通知"
                          >
                            &times;
                          </button>
                        )}
                      </div>
                    ))
                   ) : (
                    <div style={{ padding: '24px', textAlign: 'center', color: '#94a3b8', fontSize: '13px' }}>目前沒有新通知</div>
                  )}
                </div>
              </div>
            )}
          </div>
          <button className="btn-outline" onClick={() => setIsFeedbackOpen(true)}>意見回饋</button>
          <button className="btn-primary" onClick={() => navigate('/profile')}>個人</button>
          <button className="btn-outline" onClick={handleLogout}>登出</button>
        </div>
      </nav>

      <main className="main-content">
        <div className="content-header">
          <h2>揪團大廳</h2>
          <div className="weather-widget">
            <span>{weatherLocation} {temperature}°C AQI:{aqi}</span>
          </div>
          <div style={{ display: 'flex', gap: '8px', marginTop: '10px' }}>
            <select value={selectedFilterRegion} onChange={e => { setSelectedFilterRegion(e.target.value); setSelectedFilterDistrict('all'); }}>
              <option value="all">所有縣市</option>
              {Object.keys(regions).filter(c => c !== '未選擇').map(c => <option key={c} value={c}>{c}</option>)}
            </select>
            {selectedFilterRegion !== 'all' && regions[selectedFilterRegion] && (
              <select className="region-select" value={selectedFilterDistrict} onChange={e => setSelectedFilterDistrict(e.target.value)}>
                <option value="all">所有區域</option>
                {Object.keys(regions[selectedFilterRegion]).filter(d => d !== '未選擇').map(d => <option key={d} value={d}>{d}</option>)}
              </select>
            )}
            <div className="filter-chips">
              {['全部', '籃球', '麻將', '桌球', '羽球', '排球'].map(cat => (
                <span key={cat} className={`chip ${selectedCategory === cat ? 'active' : ''}`} onClick={() => setSelectedCategory(cat)}>{cat}</span>
              ))}
            </div>
          </div>
        </div>

        <div className="party-grid">
          {parties
            .filter(party => selectedFilterRegion === 'all' || (party.location && party.location.includes(selectedFilterRegion)))
            .filter(party => selectedCategory === '全部' || party.type === selectedCategory)
            .sort((a, b) => {
              const currentUserId = localStorage.getItem('user_id');
              const isAHost = currentUserId && (
                (a.creator_id && String(a.creator_id) === String(currentUserId)) || 
                a.participants?.[0] === '我 (主揪)' || 
                (a.user_id && String(a.user_id) === String(currentUserId))
              );
              const isAParticipant = currentUserId && (
                a.participants?.some(p => String(p.id || p.user_id || p) === String(currentUserId)) ||
                a.participant_ids?.some(id => String(id) === String(currentUserId))
              );
              const isBHost = currentUserId && (
                (b.creator_id && String(b.creator_id) === String(currentUserId)) || 
                b.participants?.[0] === '我 (主揪)' || 
                (b.user_id && String(b.user_id) === String(currentUserId))
              );
              const isBParticipant = currentUserId && (
                b.participants?.some(p => String(p.id || p.user_id || p) === String(currentUserId)) ||
                b.participant_ids?.some(id => String(id) === String(currentUserId))
              );

              const scoreA = (isAHost ? 2 : 0) + (isAParticipant ? 1 : 0);
              const scoreB = (isBHost ? 2 : 0) + (isBParticipant ? 1 : 0);
              return scoreB - scoreA;
            })
            .map(party => {
              const currentUserId = localStorage.getItem('user_id');
              const isHost = currentUserId && (
                (party.creator_id && String(party.creator_id) === String(currentUserId)) || 
                party.participants?.[0] === '我 (主揪)' || 
                (party.user_id && String(party.user_id) === String(currentUserId))
              );
              const isParticipant = currentUserId && (
                party.participants?.some(p => String(p.id || p.user_id || p) === String(currentUserId)) ||
                party.participant_ids?.some(id => String(id) === String(currentUserId))
              );
              
              const isFull = party.currentPlayers >= party.maxPlayers;
              const statusText = isFull ? '已額滿' : `缺 ${party.maxPlayers - party.currentPlayers} 人`;
              const statusColor = isFull ? '#94a3b8' : '#ef4444';

              return (
                <div 
                  key={party.id} 
                  className={`party-card clickable-card ${isHost ? 'hosted-party' : (isParticipant ? 'joined-party' : '')}`} 
                  onClick={() => navigate(`/party/${party.id}`, { state: { party } })}
                >
                  <div className="party-card-header">
                    <div style={{ display: 'flex', gap: '8px', alignItems: 'center' }}>
                      {(isHost || isParticipant) && (
                        <Star size={18} fill="#f59e0b" color="#f59e0b" style={{ marginRight: '4px' }} />
                      )}
                      <span className="party-type">{party.type}</span>
                      <span className="party-level">{party.level}</span>
                    </div>
                    <span className="party-status" style={{ color: statusColor }}>{statusText}</span>
                  </div>
                  <h3 className="party-title">{party.title}</h3>
                  <div className="party-info">
                    <p><MapPin size={16} /> {party.location}</p>
                    <p><Clock size={16} /> {party.time}</p>
                  </div>
                  <div className="party-card-footer">
                    <span className="player-count">目前人數: {party.currentPlayers} / {party.maxPlayers}</span>
                    <button className="btn-join">
                      {isHost ? '管理' : (isParticipant ? '已參加' : '報名參加')}
                    </button>
                  </div>
                </div>
              );
            })}
        </div>
      </main>

      <div className="fab-container">
        {reputationScore <= 60 ? (
          <button
            className="fab-btn warning"
            style={{
              backgroundColor: '#d97706',
              color: '#ffffff',
              boxShadow: '0 4px 15px rgba(217, 119, 6, 0.4)'
            }}
            onClick={() => {
              alert(`⚠️ 你的信譽分數過低（目前：${reputationScore}分），已遭到警告，目前無法發起新揪團。請保持良好參與紀錄以恢復信譽。`);
            }}
          >
            <span className="fab-icon" style={{ marginRight: '6px' }}>⚠️</span>
            信譽積分不足，無法開啟新揪團
          </button>
        ) : (
          <button className="fab-btn" onClick={() => setIsModalOpen(true)}>
            <span className="fab-icon">+</span>
            發起揪團
          </button>
        )}
      </div>

      {isModalOpen && (
        <div className="modal-overlay" onClick={() => setIsModalOpen(false)}>
          <div className="modal-content" onClick={e => e.stopPropagation()} style={{ maxWidth: '750px', maxHeight: '90vh', overflowY: 'auto' }}>
            <div className="modal-header">
              <h3>發起新揪團</h3>
              <button type="button" className="modal-close" onClick={() => setIsModalOpen(false)}>×</button>
            </div>
            <form onSubmit={handleCreateParty}>
              <div className="form-group">
                <label className="form-label">揪團標題</label>
                <input required type="text" className="form-input" placeholder="例如：今晚巨蛋鬥牛缺二" value={newParty.title} onChange={e => setNewParty({...newParty, title: e.target.value})} />
              </div>
              
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '0 24px' }}>
                {/* 左欄：活動細節 */}
                <div>
                  <div className="form-group">
                    <label className="form-label">活動類型</label>
                    <select className="form-input" value={newParty.type} onChange={e => setNewParty({...newParty, type: e.target.value})}>
                      <option value="籃球">籃球</option>
                      <option value="麻將">麻將</option>
                      <option value="桌球">桌球</option>
                      <option value="羽球">羽球</option>
                      <option value="排球">排球</option>
                    </select>
                  </div>
                  <div className="form-group">
                    <label className="form-label" style={{ display: 'flex', alignItems: 'center', gap: '6px', overflow: 'visible' }}>
                      程度
                      <div 
                        style={{ position: 'relative', display: 'flex', alignItems: 'center' }}
                        onMouseEnter={() => setShowLevelInfo(true)}
                        onMouseLeave={() => setShowLevelInfo(false)}
                      >
                        <HelpCircle size={14} style={{ cursor: 'pointer', color: '#94a3b8' }} />
                        {showLevelInfo && (
                          <div style={{ position: 'absolute', bottom: '100%', left: '-8px', marginBottom: '8px', width: '240px', backgroundColor: '#1e293b', color: 'white', padding: '12px', borderRadius: '8px', fontSize: '13px', fontWeight: 'normal', zIndex: 50, boxShadow: '0 10px 15px -3px rgba(0, 0, 0, 0.1)', lineHeight: '1.5', cursor: 'default' }}>
                            <div style={{ fontWeight: 'bold', marginBottom: '8px' }}>各程度推薦參加者</div>
                            <ul style={{ margin: 0, paddingLeft: '16px', color: '#e2e8f0' }}>
                              <li style={{ marginBottom: '4px' }}><strong>休閒：</strong> 推薦 C (新手)、B (熟練)</li>
                              <li style={{ marginBottom: '4px' }}><strong>業餘：</strong> 推薦 A (高手)、B (熟練)</li>
                              <li><strong>高手：</strong> 推薦 S (菁英)、A (高手)</li>
                            </ul>
                            <div style={{ position: 'absolute', bottom: '-4px', left: '11px', width: '8px', height: '8px', backgroundColor: '#1e293b', borderRadius: '2px', rotate: '45deg' }}></div>
                          </div>
                        )}
                      </div>
                    </label>
                    <select className="form-input" value={newParty.level} onChange={e => setNewParty({...newParty, level: e.target.value})}>
                      <option value="休閒">休閒</option>
                      <option value="業餘">業餘</option>
                      <option value="高手">高手</option>
                    </select>
                  </div>
                  <div className="form-group">
                    <label className="form-label">性別限制</label>
                    <div style={{ display: 'flex', gap: '12px' }}>
                      <button type="button" className={`gender-btn ${newParty.genderLimit === '不限' ? 'active' : ''}`} onClick={() => setNewParty({...newParty, genderLimit: '不限'})}>不限</button>
                      <button type="button" className={`gender-btn ${newParty.genderLimit === '限男' ? 'active' : ''}`} onClick={() => setNewParty({...newParty, genderLimit: '限男'})}>限男</button>
                      <button type="button" className={`gender-btn ${newParty.genderLimit === '限女' ? 'active' : ''}`} onClick={() => setNewParty({...newParty, genderLimit: '限女'})}>限女</button>
                    </div>
                  </div>
                  <div className="form-group">
                    <label className="form-label">活動時間</label>
                    <input 
                      type="datetime-local" 
                      className="form-input custom-date-input" 
                      value={newParty.time} 
                      onChange={e => setNewParty({...newParty, time: e.target.value})} 
                      min={new Date().toISOString().slice(0, 16)}
                      required 
                    />
                  </div>
                  <div className="form-group">
                    <label className="form-label">預計時長</label>
                    <select className="form-input" value={newParty.duration} onChange={e => setNewParty({...newParty, duration: e.target.value})}>
                      <option value="1 小時">1 小時</option>
                      <option value="1.5 小時">1.5 小時</option>
                      <option value="2 小時">2 小時</option>
                      <option value="2.5 小時">2.5 小時</option>
                      <option value="3 小時">3 小時</option>
                      <option value="4 小時">4 小時</option>
                      <option value="5 小時">5 小時</option>
                    </select>
                  </div>
                </div>

                {/* 右欄：地點資訊 */}
                <div>
                  <div className="form-group">
                    <label className="form-label">地點 (縣市)</label>
                    <select className="form-input" value={newParty.city} onChange={handleCityChange}>
                      {Object.keys(taiwanRegions).map(city => (
                        <option key={city} value={city}>{city}</option>
                      ))}
                    </select>
                  </div>
                  <div className="form-group">
                    <label className="form-label">地點 (區域)</label>
                    <select className="form-input" value={newParty.district} onChange={handleDistrictChange}>
                      {Object.keys(taiwanRegions[newParty.city] || {}).map(dist => (
                        <option key={dist} value={dist}>{dist}</option>
                      ))}
                    </select>
                  </div>
                  <div className="form-group">
                    <label className="form-label">地點 (場館/球場)</label>
                    <select className="form-input" value={newParty.venue} onChange={e => setNewParty({...newParty, venue: e.target.value})}>
                      {(taiwanRegions[newParty.city]?.[newParty.district] || []).map(v => (
                        <option key={v} value={v}>{v}</option>
                      ))}
                    </select>
                  </div>
                  <div className="form-group">
                    <label className="form-label">總額費用</label>
                    <input 
                      type="number" 
                      className="form-input" 
                      placeholder="輸入場地總額 (若為免費請輸入 0)" 
                      value={newParty.price} 
                      onChange={e => setNewParty({...newParty, price: e.target.value})}
                      min="0"
                      max="10000"
                      required
                    />
                    <div style={{ fontSize: '12px', color: '#94a3b8', marginTop: '6px' }}>* 系統將會依據人數自動為您計算分攤金額</div>
                  </div>
                </div>
              </div>

              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '24px' }}>
                <div className="form-group">
                  <label className="form-label" style={{ display: 'flex', alignItems: 'center', gap: '6px', marginBottom: '4px' }}>
                    人數需求 (最少 ~ 最多)
                  </label>
                  <div style={{ fontSize: '12px', color: '#94a3b8', marginBottom: '8px' }}>* 請填寫包含主揪在內的總人數！</div>
                  <div style={{ display: 'flex', gap: '12px', alignItems: 'center' }}>
                    <input required type="number" min="1" max="100" className="form-input" value={newParty.minPlayers} onChange={e => setNewParty({...newParty, minPlayers: e.target.value})} />
                    <span style={{ color: '#64748b' }}>~</span>
                    <input required type="number" min="2" max="100" className="form-input" value={newParty.maxPlayers} onChange={e => setNewParty({...newParty, maxPlayers: e.target.value})} />
                  </div>
                </div>
              </div>

              <div className="form-group">
                <label className="form-label">揪團說明 / 備註 (選填)</label>
                <textarea 
                  className="form-input" 
                  rows="3" 
                  placeholder="寫下你的規則、或想對大家說的話..." 
                  value={newParty.description} 
                  onChange={e => setNewParty({...newParty, description: e.target.value})}
                  style={{ resize: 'none' }}
                />
              </div>

              <div style={{ display: 'flex', gap: '16px', marginTop: '24px' }}>
                <button type="button" className="btn-outline" style={{ flex: 1, margin: 0, padding: '12px', borderRadius: '12px' }} onClick={() => setIsModalOpen(false)}>
                  取消
                </button>
                <button type="submit" className="login-button" style={{ flex: 1, margin: 0, padding: '12px', borderRadius: '12px' }}>
                  確認發起
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {isFeedbackOpen && (
        <div className="modal-overlay" onClick={() => setIsFeedbackOpen(false)}>
          <div className="modal-content" onClick={e => e.stopPropagation()}>
            <h3>意見回饋</h3>
            <form onSubmit={handleSendFeedback}>
              <div className="form-group">
                <label className="form-label">回饋類型</label>
                <select className="form-input" value={feedback.type} onChange={e => setFeedback({...feedback, type: e.target.value})}>
                  {feedbackTypes.map(t => (
                    <option key={t.id} value={t.name}>{t.name}</option>
                  ))}
                </select>
              </div>
              <div className="form-group">
                <label className="form-label">內容說明</label>
                <textarea 
                  required 
                  className="form-input" 
                  rows="5" 
                  placeholder="請詳細描述您的想法或遇到的問題..." 
                  value={feedback.content} 
                  onChange={e => setFeedback({...feedback, content: e.target.value})}
                  style={{ resize: 'none' }}
                />
              </div>
              <button type="submit" className="login-button" style={{ marginTop: '10px' }}>送出回饋</button>
            </form>
          </div>
        </div>
      )}

      {selectedAnnouncement && (
        <div className="modal-overlay" onClick={() => setSelectedAnnouncement(null)}>
          <div className="modal-content">
            {renderModalContent()}
          </div>
        </div>
      )}
    </div>
  );
}

export default Home;
