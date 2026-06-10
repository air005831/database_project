import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import authApi from '../api/auth';
import '../App.css';

function Register() {
  const [nickname, setNickname] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [passwordError, setPasswordError] = useState('');
  const [modal, setModal] = useState({ show: false, message: '', title: '', type: 'error', onConfirm: null });
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      setModal({ show: true, title: '格式錯誤', message: '請輸入有效的電子郵件格式！', type: 'error' });
      return;
    }
    if (password.length < 6) {
      setPasswordError('密碼長度請至少包含 6 個字元！');
      return;
    } else {
      setPasswordError('');
    }
    if (password !== confirmPassword) {
      setModal({ show: true, title: '密碼不一致', message: '兩次密碼輸入不一致喔！', type: 'error' });
      return;
    }

    setIsLoading(true);
    try {
      localStorage.removeItem('token');
      localStorage.removeItem('role');
      const response = await authApi.register({ name: nickname, email, password });

      if (response && response.token) {
        localStorage.setItem('token', response.token);
      }
      if (response && response.user_id) {
        localStorage.setItem('user_id', response.user_id);
      }
      if (response && response.role) {
        localStorage.setItem('role', response.role);
      }
      
      setModal({ 
        show: true, 
        title: '註冊成功 🎉', 
        message: '歡迎加入不揪ㄛ！請繼續完成個人檔案設定。', 
        type: 'success'
      });
      setTimeout(() => {
        setModal(prev => ({ ...prev, show: false }));
        navigate('/setup-profile');
      }, 2000);
    } catch (error) {
      console.error('Register error:', error);
      // 解析後端錯誤訊息
      const errData = error.response?.data;
      let msg = '請確認信箱是否已被使用或伺服器狀態！';
      if (errData) {
        msg = errData.detail
          || errData.email?.[0]
          || errData.name?.[0]
          || errData.password?.[0]
          || Object.values(errData).flat().join('、')
          || '註冊失敗，請稍後再試。';
        
        // 將特定的英文錯誤翻譯為友善的中文提示
        if (msg === 'Email already exists.') {
          msg = '此電子信箱已被註冊使用！';
        } else if (msg === 'Invalid email format.') {
          msg = '電子信箱格式錯誤！';
        } else if (msg === 'name, email and password are required.') {
          msg = '暱稱、電子信箱與密碼皆為必填！';
        }
      }
      setModal({ show: true, title: '註冊失敗', message: msg, type: 'error' });
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="login-container">
      <div className="login-card">
        <div className="login-header">
          <h1 className="login-title">加入<span style={{ color: '#7995a5' }}>不揪ㄛ</span></h1>
          <p className="login-subtitle">註冊新帳號，開始你的第一局！</p>
        </div>
        
        <form onSubmit={handleSubmit}>
          <div className="form-group">
            <label className="form-label" htmlFor="nickname">暱稱 <span style={{ color: '#ef4444' }}>(必填)</span></label>
            <input
              id="nickname"
              type="text"
              className="form-input"
              placeholder="大家怎麼稱呼你？"
              value={nickname}
              onChange={(e) => setNickname(e.target.value)}
              required
            />
          </div>

          <div className="form-group">
            <label className="form-label" htmlFor="email">電子信箱 <span style={{ color: '#ef4444' }}>(必填)</span></label>
            <input
              id="email"
              type="email"
              className="form-input"
              placeholder="輸入你的信箱"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
            />
          </div>
          
          <div className="form-group">
            <label className="form-label" htmlFor="password">密碼 <span style={{ color: '#ef4444' }}>(必填)</span></label>
            <input
              id="password"
              type="password"
              className="form-input"
              placeholder="設定密碼"
              value={password}
              onChange={(e) => {
                setPassword(e.target.value);
                if (passwordError) setPasswordError('');
              }}
              required
            />
            {passwordError && <div style={{ color: '#ef4444', fontSize: '12px', marginTop: '6px' }}>{passwordError}</div>}
          </div>

          <div className="form-group">
            <label className="form-label" htmlFor="confirmPassword">確認密碼 <span style={{ color: '#ef4444' }}>(必填)</span></label>
            <input
              id="confirmPassword"
              type="password"
              className="form-input"
              placeholder="再次輸入密碼"
              value={confirmPassword}
              onChange={(e) => setConfirmPassword(e.target.value)}
              required
            />
          </div>
          
          <button type="submit" className="login-button" style={{ marginTop: '10px' }} disabled={isLoading}>
            {isLoading ? '註冊中...' : '完成註冊'}
          </button>
        </form>

        <div className="register-link">
          已經有帳號了？
          <Link to="/">返回登入</Link>
        </div>
      </div>

      {modal.show && (
        <div style={{
          position: 'fixed', top: 0, left: 0, right: 0, bottom: 0,
          backgroundColor: 'rgba(15, 23, 42, 0.4)', backdropFilter: 'blur(4px)',
          display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 9999,
          animation: 'fadeIn 0.2s ease-out'
        }}>
          <div style={{
            backgroundColor: '#fff', borderRadius: '16px', padding: '32px',
            width: '90%', maxWidth: '360px', textAlign: 'center',
            boxShadow: '0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04)',
            transform: 'scale(1)', animation: 'popIn 0.3s cubic-bezier(0.16, 1, 0.3, 1)'
          }}>
            <div style={{
              width: '48px', height: '48px', borderRadius: '50%', margin: '0 auto 16px',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              backgroundColor: modal.type === 'success' ? '#dcfce7' : '#fee2e2',
              color: modal.type === 'success' ? '#16a34a' : '#ef4444'
            }}>
              {modal.type === 'success' ? (
                <svg width="24" height="24" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>
              ) : (
                <svg width="24" height="24" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
              )}
            </div>
            <h3 style={{ margin: '0 0 8px', fontSize: '20px', fontWeight: '700', color: '#1e293b' }}>{modal.title}</h3>
            <p style={{ margin: '0 0 24px', color: '#64748b', fontSize: '15px', lineHeight: '1.5' }}>{modal.message}</p>
            {modal.type !== 'success' && (
              <button
                onClick={() => {
                  setModal({ ...modal, show: false });
                  if (modal.onConfirm) modal.onConfirm();
                }}
                style={{
                  width: '100%', padding: '12px', borderRadius: '8px', border: 'none',
                  backgroundColor: '#ef4444',
                  color: 'white', fontWeight: '600', fontSize: '15px', cursor: 'pointer',
                  transition: 'opacity 0.2s'
                }}
                onMouseOver={(e) => e.target.style.opacity = 0.9}
                onMouseOut={(e) => e.target.style.opacity = 1}
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

export default Register;
