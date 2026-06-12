import os

filepath = r"C:\Users\User\Documents\antigravity\db_all\frontend\src\pages\Landing.jsx"

with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

start_marker = "          {/* Right Side: Abstract Geometric / Minimalist Visuals */}"
end_marker = "      {/* Footer */}"

if start_marker in content and end_marker in content:
    before = content.split(start_marker)[0]
    after = end_marker + content.split(end_marker)[1]
    
    new_right_side = """          {/* Right Side: Feature Cards Stack */}
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

"""
    
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(before + new_right_side + after)
