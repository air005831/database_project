import React from 'react';
import { useNavigate } from 'react-router-dom';
import { Users, CalendarHeart, Trophy, PlayCircle, Activity } from 'lucide-react';
import confetti from 'canvas-confetti';

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
    <div style={{
      minHeight: '100vh',
      display: 'flex',
      flexDirection: 'column',
      fontFamily: '"Inter", sans-serif',
      backgroundColor: 'var(--bg-main)',
      color: 'var(--primary-color)',
      overflowX: 'hidden'
    }}>
      {/* Header */}
      <header style={{
        padding: '24px 48px',
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
        position: 'absolute',
        width: '100%',
        boxSizing: 'border-box',
        top: 0,
        zIndex: 100,
      }}>
        <div style={{ fontSize: '22px', fontWeight: '800', color: 'var(--text-main)', display: 'flex', alignItems: 'center', gap: '10px', letterSpacing: '-0.5px' }}>
          <div style={{ width: '32px', height: '32px', borderRadius: '8px', backgroundColor: 'var(--primary-color)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            <PlayCircle size={20} color="white" />
          </div>
          不揪ㄛ Nojo
        </div>
        <div style={{ display: 'flex', gap: '24px', alignItems: 'center' }}>
          <span 
            onClick={() => navigate('/login')}
            style={{ fontWeight: '600', color: 'var(--text-muted)', cursor: 'pointer', transition: 'color 0.2s' }}
            onMouseOver={(e) => e.target.style.color = 'var(--text-main)'}
            onMouseOut={(e) => e.target.style.color = 'var(--text-muted)'}
          >
            登入
          </span>
          <button 
            onClick={() => navigate('/register')}
            style={{ padding: '10px 24px', borderRadius: '8px', border: 'none', backgroundColor: 'var(--primary-color)', color: 'white', fontWeight: 'bold', fontSize: '15px', cursor: 'pointer', transition: 'all 0.2s' }}
            onMouseOver={(e) => e.currentTarget.style.backgroundColor = 'var(--primary-hover)'}
            onMouseOut={(e) => e.currentTarget.style.backgroundColor = 'var(--primary-color)'}
          >
            免費註冊
          </button>
        </div>
      </header>

      {/* Hero Section - Split Layout */}
      <main style={{
        flex: 1,
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        paddingTop: '120px'
      }}>
        
        <div style={{
          display: 'flex',
          flexDirection: 'row',
          alignItems: 'center',
          justifyContent: 'space-between',
          maxWidth: '1200px',
          width: '100%',
          padding: '40px',
          gap: '60px',
          minHeight: '60vh'
        }}>
          {/* Left Side: Typography & CTA */}
          <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'flex-start', zIndex: 10 }}>
            <div style={{ display: 'inline-block', padding: '6px 16px', backgroundColor: 'var(--border-color)', color: 'var(--primary-color)', borderRadius: '20px', fontSize: '13px', fontWeight: 'bold', marginBottom: '24px', letterSpacing: '1px' }}>
              全新的運動社群
            </div>
            <h1 onMouseEnter={triggerConfetti} style={{ fontSize: '88px', fontWeight: '900', color: 'var(--text-main)', marginBottom: '24px', lineHeight: '1.05', letterSpacing: '-0.03em', cursor: 'pointer' }}>
              欸!<br />
              不揪<span style={{ color: 'var(--primary-color)' }}>ㄛ!</span>
            </h1>
            <p style={{ fontSize: '18px', color: 'var(--text-muted)', maxWidth: '480px', marginBottom: '48px', lineHeight: '1.7' }}>
              「不揪ㄛ」為熱愛運動與麻將的您打造。告別混亂的群組約戰，用最純粹的方式遇見程度相仿的對手。
            </p>
            
            <div style={{ display: 'flex', gap: '16px' }}>
              <button 
                onClick={() => navigate('/register')}
                style={{ padding: '16px 36px', borderRadius: '12px', border: 'none', backgroundColor: 'var(--primary-color)', color: 'white', fontWeight: 'bold', fontSize: '16px', cursor: 'pointer', transition: 'all 0.3s', boxShadow: '0 10px 25px -5px rgba(71, 85, 105, 0.4)' }}
                onMouseOver={(e) => { e.currentTarget.style.transform = 'translateY(-2px)'; e.currentTarget.style.backgroundColor = 'var(--primary-hover)'; }}
                onMouseOut={(e) => { e.currentTarget.style.transform = 'translateY(0)'; e.currentTarget.style.backgroundColor = 'var(--primary-color)'; }}
              >
                開始探索球局
              </button>
            </div>
          </div>

          {/* Right Side: Feature Cards Stack */}
          <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: '20px', paddingLeft: '40px', justifyContent: 'center' }}>
            {[
              { icon: <Users size={24} color="#7995a5" />, title: '乾淨的揪團體驗', desc: '極簡流暢的介面，去除非必要元素，讓你專注於尋找完美局。' },
              { icon: <CalendarHeart size={24} color="#7995a5" />, title: '智能分級系統', desc: '內建客觀的能力參考表，大幅降低雙方認知落差，確保優質體驗。' },
              { icon: <Trophy size={24} color="#7995a5" />, title: '實名信用評價', desc: '嚴格的信用積分機制，自動過濾放鳥常客，打造信任社群。' },
            ].map((feature, idx) => (
              <div key={idx} style={{
                backgroundColor: 'rgba(255, 255, 255, 0.6)',
                backdropFilter: 'blur(10px)',
                padding: '24px 32px',
                borderRadius: '20px',
                border: '1px solid var(--border-color)',
                boxShadow: '0 4px 20px -2px rgba(0, 0, 0, 0.02)',
                display: 'flex',
                alignItems: 'flex-start',
                gap: '20px',
                transition: 'transform 0.2s',
              }}
              onMouseEnter={(e) => triggerConfetti(e)}
              onMouseOver={(e) => e.currentTarget.style.transform = 'translateX(-8px)'}
              onMouseOut={(e) => e.currentTarget.style.transform = 'translateX(0)'}
              >
                <div style={{ width: '56px', height: '56px', borderRadius: '16px', backgroundColor: '#f1f5f9', display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}>
                  {feature.icon}
                </div>
                <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
                  <h3 style={{ fontSize: '18px', fontWeight: 'bold', color: 'var(--text-main)', margin: '0' }}>{feature.title}</h3>
                  <p style={{ fontSize: '14px', color: 'var(--text-muted)', margin: 0, lineHeight: '1.6' }}>{feature.desc}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer style={{ borderTop: '1px solid #e2e8f0', padding: '40px', textAlign: 'center', marginTop: '80px' }}>
        <div style={{ fontSize: '14px', color: '#94a3b8', fontWeight: '500' }}>
          © 2026 不揪ㄛ Nojo.
        </div>
      </footer>
    </div>
  );
}

export default Landing;
