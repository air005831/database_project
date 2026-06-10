import os

filepath = r"C:\Users\User\Documents\antigravity\db_all\frontend\src\pages\Home.jsx"

with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Update lucide-react imports
content = content.replace(
    "import { CloudSun, MapPin, Clock, Bell, HelpCircle, Star } from 'lucide-react';",
    "import { CloudSun, MapPin, Clock, Bell, HelpCircle, Star, AlertTriangle, CheckCircle2 } from 'lucide-react';"
)

# 2. Add state
state_code = "const [userProfile, setUserProfile] = useState(null);\n  const [alertData, setAlertData] = useState({ show: false, msg: '', type: 'error' });\n  const showAlert = (msg, type = 'error') => setAlertData({ show: true, msg, type });\n  const closeAlert = () => setAlertData({ ...alertData, show: false });"
content = content.replace("const [userProfile, setUserProfile] = useState(null);", state_code)

# 3. Replace all alert( with showAlert(
content = content.replace("alert(", "showAlert(")

# 4. For success messages, use 'success' type
content = content.replace("showAlert('發起成功！')", "showAlert('發起成功！', 'success')")

# 5. Insert Modal at the end of the component
modal_code = """
      {alertData.show && (
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
      )}
    </div>
  );
}

export default Home;
"""

content = content.replace("    </div>\n  );\n}\n\nexport default Home;", modal_code)

# 6. Apply the past time validation and min attribute fixes that I lost during git checkout
# Time validation fix
time_validation_old = "    // 計算時間\n    const dateObj = new Date(newParty.time);\n    const booking_date = dateObj.toISOString().split('T')[0];"
time_validation_new = "    // 計算時間\n    const dateObj = new Date(newParty.time);\n    if (dateObj < new Date()) {\n      showAlert('球局時間不能早於現在時間！');\n      return;\n    }\n    const booking_date = dateObj.toISOString().split('T')[0];"
content = content.replace(time_validation_old, time_validation_new)

# Min attribute fix
min_attr_old = "min={new Date().toISOString().slice(0, 16)}"
min_attr_new = "min={new Date(new Date().getTime() - new Date().getTimezoneOffset() * 60000).toISOString().slice(0, 16)}"
content = content.replace(min_attr_old, min_attr_new)

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)
