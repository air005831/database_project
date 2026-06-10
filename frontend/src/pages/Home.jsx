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
  const [reputationScore] = useState(100);
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
  const [feedback, setFeedback] = useState({ type: '建議', content: '' });
  const [feedbackTypes, setFeedbackTypes] = useState([]);
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

      const reverseLevelMap = {
        'C': '休閒', 'B': '業餘', 'A': '高手', 'S': '高手',
        '新手': '休閒', '休閒': '休閒', '高手': '高手'
      };

      const formattedGames = (Array.isArray(gamesResult) ? gamesResult : gamesResult.results || []).map(party => {
        const rawType = party.type || party.sport_type || party.sport_name || '運動';
        const originalLevel = party.level || party.target_level || 'C';
        const rawLevel = reverseLevelMap[originalLevel] || originalLevel;
        let venueStatus = 'pending';
        if (party.booking_status === '已佔到/已預約' || party.booking_status === 'confirmed') {
          venueStatus = 'confirmed';
        } else if (party.booking_status === '未佔到/未預約' || party.booking_status === 'failed') {
          venueStatus = 'failed';
        }
        
        return {
          ...party,
          id: party.id,
          venueStatus,
          title: party.game_name || party.title || '無標題揪團',
          type: rawType,
          level: rawLevel,
          genderLimit: party.genderLimit || party.gender_limit || '不限',
          location: party.location || party.venue_name || '地點未定',
          time: party.time || (party.booking_date ? `${party.booking_date} ${party.time_slot || ''}` : '時間未定'),
          currentPlayers: party.currentPlayers ?? party.current_players ?? 0,
          maxPlayers: party.maxPlayers ?? party.most_players ?? 6,
          currentWaitlist: party.currentWaitlist ?? party.current_waitlist ?? 0,
          maxWaitlist: party.maxWaitlist ?? party.max_waitlist ?? 2,
          description: party.game_note || party.description,
          participants: party.participants || [],
          participant_ids: party.participant_ids || [],
          waitlist_ids: party.waitlist_ids || [],
          creator_id: party.creator_id,
        };
      });
      
      setParties(formattedGames);
      const mappedNotifications = (Array.isArray(notificationsResult) ? notificationsResult : []).map(n => ({
        id: n.notification_id || n.id,
        text: n.message || '',
        read: n.is_read !== undefined ? n.is_read : false,
        time: n.created_at ? new Date(n.created_at).toLocaleString('zh-TW') : '',
        match_id: n.match_id || n.game_id
      }));

      setNotifications(mappedNotifications);
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
      setFeedback({ type: '建議', content: '' });
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
                {notifications.map(n => (
                  <div key={n.id} style={{ padding: '12px' }}>{n.text}</div>
                ))}
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
        <button className="fab-btn" onClick={() => setIsModalOpen(true)}>發起揪團</button>
      </div>

      {isModalOpen && (
        <div className="modal-overlay" onClick={() => setIsModalOpen(false)}>
          <div className="modal-content" onClick={e => e.stopPropagation()}>
            <h3>發起揪團</h3>
            <form onSubmit={handleCreateParty}>
              <input type="text" placeholder="標題" value={newParty.title} onChange={e => setNewParty({...newParty, title: e.target.value})} />
              <button type="submit">確認發起</button>
            </form>
          </div>
        </div>
      )}

      {isFeedbackOpen && (
        <div className="modal-overlay" onClick={() => setIsFeedbackOpen(false)}>
          <div className="modal-content" onClick={e => e.stopPropagation()}>
            <h3>意見回饋</h3>
            <form onSubmit={handleSendFeedback}>
              <textarea value={feedback.content} onChange={e => setFeedback({...feedback, content: e.target.value})} />
              <button type="submit">送出</button>
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
