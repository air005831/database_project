import os

filepath_home = r"C:\Users\User\Documents\antigravity\db_all\frontend\src\pages\Home.jsx"

with open(filepath_home, 'r', encoding='utf-8') as f:
    home_content = f.read()

# Replace start of showNotifications block
old_start = """            {showNotifications && (
              <div className="notification-dropdown">"""

new_start = """            {showNotifications && (
              <>
                <div 
                  style={{ position: 'fixed', top: 0, left: 0, right: 0, bottom: 0, zIndex: 999 }} 
                  onClick={() => setShowNotifications(false)}
                ></div>
                <div className="notification-dropdown">"""

home_content = home_content.replace(old_start, new_start)

# Replace end of showNotifications block
old_end = """                  )}
                </div>
              </div>
            )}
          </div>"""

new_end = """                  )}
                </div>
              </div>
              </>
            )}
          </div>"""

home_content = home_content.replace(old_end, new_end)

with open(filepath_home, 'w', encoding='utf-8') as f:
    f.write(home_content)
