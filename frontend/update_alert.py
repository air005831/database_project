import os

filepath_home = r"C:\Users\User\Documents\antigravity\db_all\frontend\src\pages\Home.jsx"

with open(filepath_home, 'r', encoding='utf-8') as f:
    home_content = f.read()

# Replace showAlert function
old_show_alert = "  const showAlert = (msg, type = 'error') => setAlertData({ show: true, msg, type });"
new_show_alert = """  const showAlert = (msg, type = 'error') => {
    setAlertData({ show: true, msg, type });
    if (type === 'success') {
      setTimeout(() => {
        setAlertData(prev => prev.show && prev.msg === msg ? { ...prev, show: false } : prev);
      }, 1500);
    }
  };"""

home_content = home_content.replace(old_show_alert, new_show_alert)

# Replace alert UI
old_alert_ui = """      {alertData.show && (
        <div className="modal-overlay" onClick={closeAlert} style={{ zIndex: 99999 }}>
          <div className="modal-content" onClick={e => e.stopPropagation()} style={{ maxWidth: '350px', textAlign: 'center', padding: '32px', borderRadius: '20px' }}>
            <div style={{ width: '64px', height: '64px', borderRadius: '50%', backgroundColor: alertData.type === 'success' ? '#dcfce3' : '#fee2e2', display: 'flex', alignItems: 'center', justifyContent: 'center', margin: '0 auto 16px' }}>
              {alertData.type === 'success' ? <CheckCircle2 size={32} color="#22c55e" /> : <AlertTriangle size={32} color="#ef4444" />}
            </div>
            <h3 style={{ fontSize: '20px', fontWeight: 'bold', marginBottom: '12px', color: '#1e293b' }}>提示</h3>
            <p style={{ fontSize: '16px', color: '#475569', marginBottom: '24px', lineHeight: '1.5' }}>{alertData.msg}</p>
            <button 
              className="btn-primary" 
              onClick={closeAlert}
              style={{ width: '100%', padding: '12px', borderRadius: '12px', fontSize: '16px', fontWeight: 'bold' }}
            >
              我知道了
            </button>
          </div>
        </div>
      )}"""

new_alert_ui = """      {alertData.show && (
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
      )}"""

home_content = home_content.replace(old_alert_ui, new_alert_ui)

with open(filepath_home, 'w', encoding='utf-8') as f:
    f.write(home_content)
