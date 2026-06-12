import os

filepath = r"C:\Users\User\Documents\antigravity\db_all\frontend\src\pages\Profile.jsx"

with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Update imports
import_search = "import { Cake, MapPin, Clock, Phone, Camera, HelpCircle, X, Star } from 'lucide-react';"
import_replace = "import { Cake, MapPin, Clock, Phone, Camera, HelpCircle, X, Star, AlertTriangle, CheckCircle2 } from 'lucide-react';"
content = content.replace(import_search, import_replace)

# 2. Add state and functions
state_search = "  const [isEditing, setIsEditing] = useState(false);"
state_replace = """  const [isEditing, setIsEditing] = useState(false);
  const [alertData, setAlertData] = useState({ show: false, msg: '', type: 'error' });
  
  const showAlert = (msg, type = 'error') => {
    setAlertData({ show: true, msg, type });
    if (type === 'success') {
      setTimeout(() => {
        setAlertData(prev => prev.show && prev.msg === msg ? { ...prev, show: false } : prev);
      }, 1500);
    }
  };
  const closeAlert = () => setAlertData(prev => ({ ...prev, show: false }));"""

content = content.replace(state_search, state_replace)

# 3. Replace alerts
content = content.replace("alert('請輸入正確的手機號碼格式 (例如: 0912345678)！');", "showAlert('請輸入正確的手機號碼格式 (例如: 0912345678)！', 'error');")
content = content.replace("alert('個人資料已更新！');", "showAlert('個人資料已更新！', 'success');")
content = content.replace("alert('更新失敗，請稍後再試！');", "showAlert('更新失敗，請稍後再試！', 'error');")

# 4. Add UI modal at the end before final closing div
end_search = """      </main>
    </div>
  );
}

export default Profile;"""

end_replace = """      </main>

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

export default Profile;"""

content = content.replace(end_search, end_replace)

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)
