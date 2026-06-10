import os

filepath_home = r"C:\Users\User\Documents\antigravity\db_all\frontend\src\pages\Home.jsx"
filepath_css = r"C:\Users\User\Documents\antigravity\db_all\frontend\src\App.css"

with open(filepath_home, 'r', encoding='utf-8') as f:
    home_content = f.read()

# Replace sorting logic
old_sort = """              .sort((a, b) => {
                const currentUserId = localStorage.getItem('user_id');
                const isAHost = currentUserId && (
                  (a.creator_id && String(a.creator_id) === String(currentUserId)) || 
                  (a.participants?.[0]?.id && String(a.participants[0].id) === String(currentUserId)) || 
                  a.participants?.[0] === '我 (主揪)' || 
                  a.participants?.[0] === '主揪人' ||
                  (a.user_id && String(a.user_id) === String(currentUserId))
                );
                const isBHost = currentUserId && (
                  (b.creator_id && String(b.creator_id) === String(currentUserId)) || 
                  (b.participants?.[0]?.id && String(b.participants[0].id) === String(currentUserId)) || 
                  b.participants?.[0] === '我 (主揪)' || 
                  b.participants?.[0] === '主揪人' ||
                  (b.user_id && String(b.user_id) === String(currentUserId))
                );

                if (isAHost && !isBHost) return -1;
                if (!isAHost && isBHost) return 1;
                return 0;
              });"""

new_sort = """              .sort((a, b) => {
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
              });"""

home_content = home_content.replace(old_sort, new_sort)

# Replace classname assignment
old_classname = """<div key={party.id} className={`party-card clickable-card ${isHost ? 'hosted-party' : ''}`} onClick={() => navigate(`/party/${party.id}`, { state: { party } })}>"""
new_classname = """<div key={party.id} className={`party-card clickable-card ${isHost ? 'hosted-party' : (isParticipant || isWaitlisted) ? 'joined-party' : ''}`} onClick={() => navigate(`/party/${party.id}`, { state: { party } })}>"""

home_content = home_content.replace(old_classname, new_classname)

with open(filepath_home, 'w', encoding='utf-8') as f:
    f.write(home_content)

# Update App.css
with open(filepath_css, 'a', encoding='utf-8') as f:
    f.write("\n\n/* --- Joined Party Styles --- */\n")
    f.write(".party-card.joined-party {\n")
    f.write("  background-color: #f0f9ff;\n")
    f.write("  border-color: #bae6fd;\n")
    f.write("  box-shadow: 0 4px 15px rgba(186, 230, 253, 0.4);\n")
    f.write("}\n\n")
    f.write(".party-card.joined-party:hover {\n")
    f.write("  box-shadow: 0 10px 25px rgba(186, 230, 253, 0.6);\n")
    f.write("}\n")
