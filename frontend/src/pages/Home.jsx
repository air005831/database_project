import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { CloudSun, MapPin, Clock, Bell, HelpCircle, Star, AlertTriangle, CheckCircle2, CalendarX } from 'lucide-react';
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
  const [alertData, setAlertData] = useState({ show: false, msg: '', type: 'error' });
  const showAlert = (msg, type = 'error') => {
    setAlertData({ show: true, msg, type });
    if (type === 'success') {
      setTimeout(() => {
        setAlertData(prev => prev.show && prev.msg === msg ? { ...prev, show: false } : prev);
      }, 1500);
    }
  };
  const closeAlert = () => setAlertData({ ...alertData, show: false });

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
  const [dbRegions, setDbRegions] = useState({});

  // 2. 所有 Function 宣告
  const fetchData = async (showLoading = true) => {
    try {
      const results = await Promise.allSettled([
        fetchParties(showLoading),
        notificationsApi.getNotifications(),
        weatherApi.getWeatherAqi({
          city: selectedFilterRegion !== 'all' ? selectedFilterRegion : undefined,
          district: selectedFilterDistrict !== 'all' ? selectedFilterDistrict : undefined
        }),
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
              city: v.city || v.address_detail?.city || '其他',
              district: v.district || v.address_detail?.district || '其他',
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
    navigate('/login');
  };

  const handleSendFeedback = async (e) => {
    e.preventDefault();
    try {
      await adminApi.submitFeedback(feedback);
      showAlert('感謝您的回饋！管理員將會盡快查看。', 'success');
      setIsFeedbackOpen(false);
      setFeedback({ type: feedbackTypes[0]?.name || 'Bug 回報 (系統出錯)', content: '' });
    } catch (error) {
      console.error('Feedback error:', error);
      showAlert('送出失敗，請稍後再試。');
    }
  };

  const handleCreateParty = async (e) => {
    e.preventDefault();

    if (newParty.genderLimit && newParty.genderLimit !== '不限') {
      const userGender = userProfile?.gender || '未公開';
      if (
        (newParty.genderLimit === '限男' && userGender !== '男') ||
        (newParty.genderLimit === '限女' && userGender !== '女')
      ) {
        showAlert(`主揪性別為「${userGender}」，無法發起「${newParty.genderLimit}」的揪團！`);
        return;
      }
    }

    const userLevelInSportStr = userProfile?.levels?.[newParty.type] || 'C';
    const userLevelInSport = userLevelInSportStr.charAt(0).toUpperCase();
    const rankValue = { 'S': 4, 'A': 3, 'B': 2, 'C': 1 };
    const requiredRank = { '高手': 3, '業餘': 2, '休閒': 1 };

    if (rankValue[userLevelInSport] < requiredRank[newParty.level]) {
      showAlert(`你的${newParty.type}程度為 ${userLevelInSport}，無法發起${newParty.level}喔！`);
      return;
    }

    const sportMap = {
      '籃球': 1,
      '羽球': 2,
      '排球': 3,
      '桌球': 4,
      '麻將': 5
    };

    const venue_id = venueMap[newParty.venue] || 1;
    const dateObj = new Date(newParty.time);

    if (dateObj < new Date()) {
      showAlert('球局時間不能早於現在時間！');
      return;
    }
    const booking_date = dateObj.toISOString().split('T')[0]; // "YYYY-MM-DD"
    const startHour = dateObj.getHours().toString().padStart(2, '0');
    const startMin = dateObj.getMinutes().toString().padStart(2, '0');
    
    // Parse duration "2 小時" or "1.5 小時"
    const durationHours = parseFloat(newParty.duration);
    const endDateObj = new Date(dateObj.getTime() + durationHours * 60 * 60 * 1000);
    const endHour = endDateObj.getHours().toString().padStart(2, '0');
    const endMin = endDateObj.getMinutes().toString().padStart(2, '0');
    
    const time_slot = `${startHour}:${startMin}-${endHour}:${endMin}`;

    const payload = {
      sport_id: sportMap[newParty.type] || 1,
      venue_id,
      most_players: parseInt(newParty.maxPlayers, 10),
      least_players: parseInt(newParty.minPlayers, 10),
      target_level: newParty.level,
      booking_date,
      start_time: `${startHour}:${startMin}`,
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
      setNewParty({ 
        title: '', type: '籃球', level: '休閒', genderLimit: '不限', city: '桃園市', district: '桃園區', venue: '桃園國民運動中心', description: '', price: '', time: '', duration: '2 小時', minPlayers: 2, maxPlayers: 4 
      });
      fetchData(false);
      showAlert('發起成功！', 'success');
    } catch (error) {
      console.error('Create party error:', error);
      const backendError = error.response?.data ? JSON.stringify(error.response.data) : '伺服器未回應';
      showAlert(`發起揪團失敗：${backendError}`);
    }
  };

  const handleCityChange = (e) => {
    const selectedCity = e.target.value;
    const districts = taiwanRegions[selectedCity] || {};
    const firstDistrict = Object.keys(districts)[0] || '';
    const venuesList = districts[firstDistrict] || [];
    const firstVenue = venuesList[0] || '其他';
    setNewParty({
      ...newParty,
      city: selectedCity,
      district: firstDistrict,
      venue: firstVenue
    });
  };

  const handleDistrictChange = (e) => {
    const selectedDistrict = e.target.value;
    const venuesList = taiwanRegions[newParty.city]?.[selectedDistrict] || [];
    const firstVenue = venuesList[0] || '其他';
    setNewParty({
      ...newParty,
      district: selectedDistrict,
      venue: firstVenue
    });
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

        // Clean up placeholder if active data exists
        delete mergedRegions['未選擇'];

        setTaiwanRegions(mergedRegions);
        setRegions(mergedRegions);
        setVenueFacilities(mergedFacilities);
        setVenueMap(vMap);

        // Pre-fill create party defaults using first available database records
        const firstCity = Object.keys(mergedRegions)[0];
        if (firstCity) {
          const firstDist = Object.keys(mergedRegions[firstCity])[0] || '';
          const firstVenue = (mergedRegions[firstCity][firstDist] || [])[0] || '';
          setNewParty(prev => ({
            ...prev,
            city: firstCity,
            district: firstDist,
            venue: firstVenue
          }));
        }
      }
    });
  }, []);

  useEffect(() => {
    adminApi.getFeedbackTypes().then(data => {
      const list = Array.isArray(data) ? data : (data.results || []);
      setFeedbackTypes(list);
    });
  }, []);

  useEffect(() => {
    venuesApi.getRegions().then(data => {
      if (Array.isArray(data)) {
        const map = {};
        data.forEach(item => {
          if (!map[item.city]) {
            map[item.city] = [];
          }
          if (!map[item.city].includes(item.district)) {
            map[item.city].push(item.district);
          }
        });
        setDbRegions(map);
      }
    }).catch(err => {
      console.error('Lobby fetch regions error:', err);
    });
  }, []);

  useEffect(() => {
    const fetchSelectedWeather = async () => {
      try {
        const params = {};
        if (selectedFilterRegion && selectedFilterRegion !== 'all') {
          params.city = selectedFilterRegion;
        }
        if (selectedFilterDistrict && selectedFilterDistrict !== 'all') {
          params.district = selectedFilterDistrict;
        }
        const weatherResult = await weatherApi.getWeatherAqi(params);
        setAqi(weatherResult?.aqi ?? '--');
        setTemperature(weatherResult?.temperature ?? '--');
        if (weatherResult?.location) setWeatherLocation(weatherResult.location);
      } catch (error) {
        console.error('Fetch weather for selected region error:', error);
      }
    };
    fetchSelectedWeather();
  }, [selectedFilterRegion, selectedFilterDistrict]);

  useEffect(() => {
    if (allVenues.length === 0) return;

    // 後端資料庫裡的運動名稱是英文，需要對應
    const sportMap = {
      '籃球': 'Basketball',
      '排球': 'Volleyball',
      '羽球': 'Badminton',
      '麻將': 'Mahjohn',
      '桌球': 'Table Tennis'
    };
    const dbSportName = (sportMap[newParty.type] || newParty.type).toLowerCase();

    const filteredVenues = allVenues.filter(v => 
      v.sports.some(s => s.toLowerCase() === dbSportName || s.toLowerCase() === newParty.type.toLowerCase()) || 
      v.sports.length === 0
    );
    
    // 若該運動目前無可用場地，給個防呆
    if (filteredVenues.length === 0) {
      setTaiwanRegions({ '未選擇': { '未選擇': ['無適用場地'] } });
      setVenueFacilities({});
      setVenueMap({});
      setNewParty(prev => ({ ...prev, city: '未選擇', district: '未選擇', venue: '無適用場地' }));
      return;
    }

    const regions = {};
    const facilities = {};
    const vMap = {};

    filteredVenues.forEach(v => {
      const city = v.city || '其他';
      const district = v.district || '其他';
      if (!regions[city]) regions[city] = {};
      if (!regions[city][district]) regions[city][district] = [];
      regions[city][district].push(v.name);
      facilities[v.name] = v.facilities;
      vMap[v.name] = v.id;
    });

    setTaiwanRegions(regions);
    setVenueFacilities(facilities);
    setVenueMap(vMap);

    // 檢查目前選的場地是否還在新的清單裡，不在的話重設為第一個
    const currentCityValid = regions[newParty.city];
    const currentDistValid = currentCityValid && regions[newParty.city][newParty.district];
    const currentVenueValid = currentDistValid && regions[newParty.city][newParty.district].includes(newParty.venue);

    if (!currentVenueValid) {
      const firstCity = Object.keys(regions)[0];
      const firstDist = firstCity ? Object.keys(regions[firstCity])[0] : '未選擇';
      const firstVenue = firstDist ? regions[firstCity][firstDist][0] : '無適用場地';
      
      setNewParty(prev => ({
        ...prev,
        city: firstCity,
        district: firstDist,
        venue: firstVenue
      }));
    }
  }, [newParty.type, allVenues]);

  const renderModalContent = () => {
    if (!selectedAnnouncement) return null;
    const content = selectedAnnouncement.content;
    
    // 1. 回饋回覆結構化格式
    if (selectedAnnouncement.title === '系統通知' && content.includes('[Feedback]\n') && content.includes('[Reply]\n')) {
      const parts = content.split('\n');
      const feedbackHeaderIdx = parts.indexOf('[Feedback]');
      const replyHeaderIdx = parts.indexOf('[Reply]');
      
      let feedbackText = '';
      let replyText = '';
      
      if (feedbackHeaderIdx !== -1 && replyHeaderIdx !== -1) {
        feedbackText = parts.slice(feedbackHeaderIdx + 1, replyHeaderIdx).join('\n').trim();
        replyText = parts.slice(replyHeaderIdx + 1).join('\n').trim();
      } else {
        return <div style={{ whiteSpace: 'pre-wrap' }}>{content}</div>;
      }
      
      return (
        <div style={{ display: 'flex', flexDirection: 'column', gap: '16px', textAlign: 'left', marginTop: '10px' }}>
          <div style={{ padding: '14px 18px', backgroundColor: '#f8fafc', borderRadius: '12px', border: '1px solid #e2e8f0' }}>
            <div style={{ fontSize: '13px', fontWeight: '700', color: '#64748b', marginBottom: '6px' }}>您的意見回饋：</div>
            <div style={{ fontSize: '14px', color: '#334155', lineHeight: '1.5', whiteSpace: 'pre-wrap' }}>{feedbackText}</div>
          </div>
          <div style={{ padding: '14px 18px', backgroundColor: '#f0fdf4', borderRadius: '12px', border: '1px solid #bbf7d0', borderLeft: '4px solid #22c55e' }}>
            <div style={{ fontSize: '13px', fontWeight: '700', color: '#166534', marginBottom: '6px' }}>
              管理員回覆：
            </div>
            <div style={{ fontSize: '14px', color: '#14532d', lineHeight: '1.5', whiteSpace: 'pre-wrap', fontWeight: '500' }}>{replyText}</div>
          </div>
        </div>
      );
    }
    
    // 2. 檢舉通知格式
    if (selectedAnnouncement.title === '系統通知' && content.startsWith('收到檢舉回覆：') && content.includes('管理員回覆：')) {
      const cleanContent = content.replace('收到檢舉回覆：', '').trim();
      const replyPrefix = '管理員回覆：';
      const prefixIndex = cleanContent.indexOf(replyPrefix);
      
      let infoText = '';
      let replyText = '';
      
      if (prefixIndex !== -1) {
        infoText = cleanContent.substring(0, prefixIndex).trim();
        replyText = cleanContent.substring(prefixIndex + replyPrefix.length).trim();
      } else {
        infoText = cleanContent;
      }
      
      return (
        <div style={{ display: 'flex', flexDirection: 'column', gap: '16px', textAlign: 'left', marginTop: '10px' }}>
          {infoText && (
            <div style={{ padding: '14px 18px', backgroundColor: '#f8fafc', borderRadius: '12px', border: '1px solid #e2e8f0' }}>
              <div style={{ fontSize: '13px', fontWeight: '700', color: '#64748b', marginBottom: '6px' }}>檢舉詳情：</div>
              <div style={{ fontSize: '14px', color: '#334155', lineHeight: '1.5' }}>{infoText}</div>
            </div>
          )}
          {replyText && (
            <div style={{ padding: '14px 18px', backgroundColor: '#f0fdf4', borderRadius: '12px', border: '1px solid #bbf7d0', borderLeft: '4px solid #22c55e' }}>
              <div style={{ fontSize: '13px', fontWeight: '700', color: '#166534', marginBottom: '6px' }}>
                管理員回覆：
              </div>
              <div style={{ fontSize: '14px', color: '#14532d', lineHeight: '1.5', whiteSpace: 'pre-wrap', fontWeight: '500' }}>{replyText}</div>
            </div>
          )}
        </div>
      );
    }
    
    return <div style={{ whiteSpace: 'pre-wrap' }}>{content}</div>;
  };

  const getFilterCities = () => {
    if (Object.keys(dbRegions).length > 0) {
      return Object.keys(dbRegions);
    }
    return Object.keys(regions).filter(c => c !== '未選擇');
  };

  const getFilterDistricts = (city) => {
    if (Object.keys(dbRegions).length > 0) {
      return dbRegions[city] || [];
    }
    if (regions[city]) {
      return Object.keys(regions[city]).filter(d => d !== '未選擇');
    }
    return [];
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
              <>
                <div 
                  style={{ position: 'fixed', top: 0, left: 0, right: 0, bottom: 0, zIndex: 999 }} 
                  onClick={() => setShowNotifications(false)}
                ></div>
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
                                  showAlert('刪除通知失敗，請稍後再試。');
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
              </>
            )}
          </div>
          <button className="btn-outline" onClick={() => setIsFeedbackOpen(true)}>意見回饋</button>
          <button className="btn-primary" onClick={() => navigate('/profile')}>個人</button>
          <button className="btn-outline" onClick={handleLogout}>登出</button>
        </div>
      </nav>

      <main className="main-content">
        <div className="content-header">
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', flexWrap: 'wrap', gap: '16px', marginBottom: '16px' }}>
            <h2 style={{ margin: 0 }}>揪團大廳</h2>
            <div className="weather-widget" style={{ display: 'flex', alignItems: 'center', gap: '12px', padding: '6px 16px', borderRadius: '9999px', border: '1px solid #cbd5e1', backgroundColor: '#ffffff', fontSize: '13px', fontWeight: '500', color: '#475569', boxShadow: '0 2px 6px rgba(0,0,0,0.02)' }}>
              <CloudSun size={16} color="#7995a5" />
              <span>{weatherLocation} {temperature}°C</span>
              <div style={{ width: '1px', height: '14px', backgroundColor: '#cbd5e1' }}></div>
              <span>AQI: {aqi}</span>
            </div>
          </div>
          <div style={{ display: 'flex', gap: '8px', marginTop: '10px' }}>
            <select className="region-select" value={selectedFilterRegion} onChange={e => { setSelectedFilterRegion(e.target.value); setSelectedFilterDistrict('all'); }}>
              <option value="all">所有縣市</option>
              {getFilterCities().map(c => <option key={c} value={c}>{c}</option>)}
            </select>
            {selectedFilterRegion !== 'all' && (
              <select className="region-select" value={selectedFilterDistrict} onChange={e => setSelectedFilterDistrict(e.target.value)}>
                <option value="all">所有區域</option>
                {getFilterDistricts(selectedFilterRegion).map(d => <option key={d} value={d}>{d}</option>)}
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
          {(() => {
            const filteredParties = parties
              .filter(party => selectedFilterRegion === 'all' || (party.location && party.location.includes(selectedFilterRegion)))
              .filter(party => selectedFilterDistrict === 'all' || (party.location && party.location.includes(selectedFilterDistrict)))
              .filter(party => selectedCategory === '全部' || party.type === selectedCategory)
              .sort((a, b) => {
                const currentUserId = localStorage.getItem('user_id');
                const getPriority = (party) => {
                const isHost = currentUserId && (
                  (party.creator_id && String(party.creator_id) === String(currentUserId)) || 
                  (party.participants?.[0]?.id && String(party.participants[0].id) === String(currentUserId)) || 
                  party.participants?.[0] === '我 (主揪)' || 
                  party.participants?.[0] === '主揪人' ||
                  (party.user_id && String(party.user_id) === String(currentUserId))
                );
                if (isHost) return 1;
                
                const isParticipant = currentUserId && (
                  party.participants?.some(p => String(p.id || p.user_id || p) === String(currentUserId)) ||
                  party.participant_ids?.some(id => String(id) === String(currentUserId))
                );
                const isWaitlisted = currentUserId && (
                  party.waitlist?.some(p => String(p.id || p.user_id || p) === String(currentUserId)) ||
                  party.waitlist_ids?.some(id => String(id) === String(currentUserId))
                );
                if (isParticipant || isWaitlisted) return 2;
                
                return 3;
              };

              return getPriority(a) - getPriority(b);
            });

            if (filteredParties.length === 0) {
              return (
                <div style={{ padding: '60px 20px', textAlign: 'center', gridColumn: '1 / -1', backgroundColor: '#f8fafc', borderRadius: '16px', border: '1px dashed #cbd5e1' }}>
                  <div style={{ marginBottom: '16px', display: 'flex', justifyContent: 'center' }}><CalendarX size={48} color="#94a3b8" strokeWidth={1.5} /></div>
                  <h3 style={{ color: '#475569', margin: '0 0 8px 0', fontSize: '18px', fontWeight: 'bold' }}>暫無球局，換你來揪吧！</h3>
                  <p style={{ color: '#94a3b8', margin: 0, fontSize: '14px' }}>目前這個分類還沒有人發起揪團，點擊右下角發起第一場吧</p>
                </div>
              );
            }

            return filteredParties.map(party => {
            const currentUserId = localStorage.getItem('user_id');
            const isHost = currentUserId && (
              (party.creator_id && String(party.creator_id) === String(currentUserId)) || 
              (party.participants?.[0]?.id && String(party.participants[0].id) === String(currentUserId)) || 
              party.participants?.[0] === '我 (主揪)' || 
              party.participants?.[0] === '主揪人' ||
              (party.user_id && String(party.user_id) === String(currentUserId))
            );
            const isParticipant = currentUserId && (
              party.participants?.some(p => String(p.id || p.user_id || p) === String(currentUserId)) ||
              party.participant_ids?.some(id => String(id) === String(currentUserId))
            );
            const isWaitlisted = currentUserId && (
              party.waitlist?.some(p => String(p.id || p.user_id || p) === String(currentUserId)) ||
              party.waitlist_ids?.some(id => String(id) === String(currentUserId))
            );

            const isFull = party.currentPlayers >= party.maxPlayers;
            const isWaitlistFull = party.currentWaitlist >= party.maxWaitlist;

            let statusText = `缺 ${party.maxPlayers - party.currentPlayers} 人`;
            let statusColor = '#ef4444'; // Red
            if (isFull && isWaitlistFull) {
              statusText = '已完全額滿';
              statusColor = '#94a3b8'; // Gray
            } else if (isFull) {
              statusText = `候補 ${party.currentWaitlist}/${party.maxWaitlist}`;
              statusColor = '#f59e0b'; // Orange
            }

            let badgeStatusText = '';
            let badgeStatusColor = '';

            const backendStatus = party.match_status || party.status || party.game_status;
            
            if (backendStatus === '已開始' || backendStatus === 'started' || backendStatus === 'playing') {
              badgeStatusText = '已開始';
              badgeStatusColor = '#10b981'; // Green
            } else if (backendStatus === '已關閉' || backendStatus === 'closed' || backendStatus === 'failed_to_start') {
              badgeStatusText = '已關閉';
              badgeStatusColor = '#64748b'; // Gray
            } else if (backendStatus === '已滿' || backendStatus === 'full') {
              if (!isWaitlistFull) {
                badgeStatusText = '可候補';
                badgeStatusColor = '#f59e0b'; // Orange
              } else {
                badgeStatusText = '已滿';
                badgeStatusColor = '#94a3b8'; // Gray
              }
            } else if (backendStatus === '可候補' || backendStatus === 'waitlisting') {
              badgeStatusText = '可候補';
              badgeStatusColor = '#f59e0b'; // Orange
            } else if (backendStatus === '缺人' || backendStatus === 'recruiting') {
              badgeStatusText = '缺人';
              badgeStatusColor = '#ef4444'; // Red
            } else {
              if (isFull && isWaitlistFull) {
                badgeStatusText = '已滿';
                badgeStatusColor = '#94a3b8';
              } else if (isFull) {
                badgeStatusText = '可候補';
                badgeStatusColor = '#f59e0b';
              } else {
                badgeStatusText = '缺人';
                badgeStatusColor = '#ef4444';
              }
            }

            return (
              <div key={party.id} className={`party-card clickable-card ${isHost ? 'hosted-party' : (isParticipant || isWaitlisted) ? 'joined-party' : ''}`} onClick={() => navigate(`/party/${party.id}`, { state: { party } })}>
                <div className="party-card-header">
                  <div style={{ display: 'flex', gap: '8px', alignItems: 'center' }}>
                    {isHost && (
                      <Star size={20} fill="#d8a7a7" color="#d8a7a7" style={{ marginRight: '4px' }} />
                    )}
                    <span className="party-type">{party.type}</span>
                    <span className="party-level">{party.level}</span>
                    {party.venueStatus === 'confirmed' && (
                      <span className="party-level" style={{ backgroundColor: '#10b981', color: 'white', fontWeight: 'bold' }}>
                        ✅ 場地已確認
                      </span>
                    )}
                    {party.venueStatus === 'failed' && (
                      <span className="party-level" style={{ backgroundColor: '#ef4444', color: 'white', fontWeight: 'bold' }}>
                        ❌ 未借到場地
                      </span>
                    )}
                    {party.genderLimit && party.genderLimit !== '不限' && (
                      <span className="party-level">{party.genderLimit}</span>
                    )}
                    {badgeStatusText && (
                      <span className="party-level" style={{ backgroundColor: badgeStatusColor, color: 'white', fontWeight: 'bold' }}>
                        {badgeStatusText}
                      </span>
                    )}
                  </div>
                  {badgeStatusText !== '已關閉' && (
                    <span className="party-status" style={{ color: statusColor }}>{statusText}</span>
                  )}
                </div>
                <h3 className="party-title">{party.title}</h3>
                <div className="party-info">
                  <p><MapPin size={16} /> {party.location}</p>
                  <p><Clock size={16} /> {party.time}</p>
                </div>
                <div className="party-card-footer">
                  <span className="player-count">目前人數: {party.currentPlayers} / {party.maxPlayers}</span>
                  <button className="btn-join" onClick={(e) => {
                    e.stopPropagation();
                    navigate(`/party/${party.id}`, { state: { party } });
                  }}>
                    {isHost ? '管理' : isParticipant ? '已參加' : isWaitlisted ? '已候補' : isFull && isWaitlistFull ? '名額已滿' : isFull ? '申請候補' : '報名參加'}
                  </button>
                </div>
              </div>
            );
          });
          })()}
        </div>
      </main>

      <div className="fab-container">
        <button className="fab-btn" onClick={() => {
          if (reputationScore <= 60) {
            showAlert(`⚠️ 你的信譽分數過低（目前：${reputationScore}分），已遭到警告，目前無法發起新揪團。請保持良好參與紀錄以恢復信譽。`);
            return;
          }
          setIsModalOpen(true);
        }}>
          <span className="fab-icon">+</span>
          發起揪團
        </button>
      </div>

      {isModalOpen && (
        <div className="modal-overlay" onClick={() => setIsModalOpen(false)}>
          <div className="modal-content" onClick={e => e.stopPropagation()} style={{ maxWidth: '750px', maxHeight: '90vh', overflow: 'hidden', display: 'flex', flexDirection: 'column', padding: 0, position: 'relative' }}>
            <div className="modal-header" style={{
              position: 'absolute',
              top: 0,
              left: 0,
              right: 0,
              height: '72px',
              backgroundColor: 'white',
              borderBottom: '1px solid #f1f5f9',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between',
              padding: '0 32px',
              zIndex: 10,
              margin: 0
            }}>
              <h3 style={{ margin: 0 }}>發起新揪團</h3>
              <button type="button" className="modal-close" style={{ padding: 0, margin: 0 }} onClick={() => setIsModalOpen(false)}>×</button>
            </div>
            <form onSubmit={handleCreateParty} style={{ overflowY: 'auto', padding: '96px 32px 32px 32px', flex: 1 }}>
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
                      min={new Date(new Date().getTime() - new Date().getTimezoneOffset() * 60000).toISOString().slice(0, 16)}
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
                    <select 
                      className="form-input" 
                      value={newParty.venue} 
                      onChange={e => setNewParty({...newParty, venue: e.target.value})}
                      required
                    >
                      {(() => {
                        const filtered = allVenues.filter(v => 
                          v.city === newParty.city && 
                          v.district === newParty.district && 
                          (v.sports || []).includes(newParty.type)
                        );
                        if (filtered.length === 0) {
                          return <option value="">此區域無提供該運動之場地</option>;
                        }
                        return filtered.map(v => (
                          <option key={v.id} value={v.name}>{v.name}</option>
                        ));
                      })()}
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

      {alertData.show && (
        <div className="modal-overlay" onClick={closeAlert} style={{ zIndex: 99999 }}>
          <div className="modal-content" onClick={e => e.stopPropagation()} style={{ maxWidth: '350px', textAlign: 'center', padding: '32px', borderRadius: '20px' }}>
            <div style={{ width: '64px', height: '64px', borderRadius: '50%', backgroundColor: alertData.type === 'success' ? '#dcfce3' : '#fee2e2', display: 'flex', alignItems: 'center', justifyContent: 'center', margin: '0 auto 16px' }}>
              {alertData.type === 'success' ? <CheckCircle2 size={32} color="#22c55e" /> : <AlertTriangle size={32} color="#ef4444" />}
            </div>
            {alertData.type !== 'success' && <h3 style={{ fontSize: '20px', fontWeight: 'bold', marginBottom: '12px', color: '#1e293b' }}>提示</h3>}
            <p style={{ fontSize: '16px', color: '#475569', marginBottom: alertData.type === 'success' ? '0' : '24px', lineHeight: '1.5' }}>{alertData.msg}</p>
            {alertData.type !== 'success' && (
              <button 
                className="btn-primary" 
                onClick={closeAlert}
                style={{ width: '100%', padding: '12px', borderRadius: '12px', fontSize: '16px', fontWeight: 'bold' }}
              >
                我知道了
              </button>
            )}
          </div>
        </div>
      )}
    </div>
  );
}

export default Home;

