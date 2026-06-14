import { useNavigate } from 'react-router-dom';
import { Users, CalendarHeart, Trophy, PlayCircle } from 'lucide-react';
import confetti from 'canvas-confetti';
import './Landing.css';

function Landing() {
  const navigate = useNavigate();

  const triggerConfetti = (e) => {
    const rect = e.currentTarget.getBoundingClientRect();
    const x = (rect.left + rect.width / 2) / window.innerWidth;
    const y = (rect.top + rect.height / 2) / window.innerHeight;
    
    confetti({
      particleCount: 50,
      spread: 70,
      origin: { x, y },
      disableForReducedMotion: true,
      zIndex: 1000
    });
  };

  return (
    <div className="landing-container">
      {/* Header */}
      <header className="landing-header">
        <div className="landing-logo">
          <div className="landing-logo-icon">
            <PlayCircle size={20} color="white" />
          </div>
          不揪ㄛ Nojo
        </div>
        <div className="landing-nav">
          <span 
            onClick={() => navigate('/login')}
            className="landing-nav-link"
          >
            登入
          </span>
          <button 
            onClick={() => navigate('/register')}
            className="landing-btn-register"
          >
            免費註冊
          </button>
        </div>
      </header>

      {/* Hero Section */}
      <main className="landing-main">
        <div className="hero-container">
          {/* Left Side: Typography & CTA */}
          <div className="hero-left">
            <div className="hero-badge">
              全新的運動社群
            </div>
            <h1 onMouseEnter={triggerConfetti} className="hero-title">
              欸!<br />
              不揪<span className="hero-title-accent">ㄛ!</span>
            </h1>
            <p className="hero-desc">
              「不揪ㄛ」為熱愛運動與麻將的您打造。告別混亂的群組約戰，用最純粹的方式遇見程度相仿的對手。
            </p>
            
            <div className="hero-cta-wrapper">
              <button 
                onClick={() => navigate('/register')}
                className="hero-cta-btn"
              >
                開始探索球局
              </button>
            </div>
          </div>

          {/* Right Side: Feature Cards Stack */}
          <div className="hero-right">
            {[
              { icon: <Users size={24} color="#7995a5" />, title: '乾淨的揪團體驗', desc: '極簡流暢的介面，去除非必要元素，讓你專注於尋找完美局。' },
              { icon: <CalendarHeart size={24} color="#7995a5" />, title: '智能分級系統', desc: '內建客觀的能力參考表，大幅降低雙方認知落差，確保優質體驗。' },
              { icon: <Trophy size={24} color="#7995a5" />, title: '實名信用評價', desc: '嚴格的信用積分機制，自動過濾放鳥常客，打造信任社群。' },
            ].map((feature, idx) => (
              <div key={idx} className="feature-card" onMouseEnter={(e) => triggerConfetti(e)}>
                <div className="feature-icon-wrapper">
                  {feature.icon}
                </div>
                <div className="feature-text-wrapper">
                  <h3 className="feature-title">{feature.title}</h3>
                  <p className="feature-desc">{feature.desc}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="landing-footer">
        <div className="landing-footer-text">
          © 2026 不揪ㄛ Nojo.
        </div>
      </footer>
    </div>
  );
}

export default Landing;
