import os

filepath = r"C:\Users\User\Documents\antigravity\db_all\frontend\src\pages\Home.jsx"

with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

old_block = """        <div className="party-grid">
          {parties
            .filter(party => selectedFilterRegion === 'all' || (party.location && party.location.includes(selectedFilterRegion)))
            .filter(party => selectedFilterDistrict === 'all' || (party.location && party.location.includes(selectedFilterDistrict)))
            .filter(party => selectedCategory === '全部' || party.type === selectedCategory)
            .sort((a, b) => {"""

new_block = """        <div className="party-grid">
          {(() => {
            const filteredParties = parties
              .filter(party => selectedFilterRegion === 'all' || (party.location && party.location.includes(selectedFilterRegion)))
              .filter(party => selectedFilterDistrict === 'all' || (party.location && party.location.includes(selectedFilterDistrict)))
              .filter(party => selectedCategory === '全部' || party.type === selectedCategory)
              .sort((a, b) => {"""

content = content.replace(old_block, new_block)

old_map = """              if (isAHost && !isBHost) return -1;
              if (!isAHost && isBHost) return 1;
              return 0;
            })
            .map(party => {"""

new_map = """              if (isAHost && !isBHost) return -1;
              if (!isAHost && isBHost) return 1;
              return 0;
            });

            if (filteredParties.length === 0) {
              return (
                <div style={{ padding: '60px 20px', textAlign: 'center', gridColumn: '1 / -1', backgroundColor: '#f8fafc', borderRadius: '16px', border: '1px dashed #cbd5e1' }}>
                  <div style={{ fontSize: '48px', marginBottom: '16px' }}>🏸</div>
                  <h3 style={{ color: '#475569', margin: '0 0 8px 0', fontSize: '18px', fontWeight: 'bold' }}>暫無球局，換你來揪吧！</h3>
                  <p style={{ color: '#94a3b8', margin: 0, fontSize: '14px' }}>目前這個分類還沒有人發起揪團，點擊右下角發起第一場吧</p>
                </div>
              );
            }

            return filteredParties.map(party => {"""

content = content.replace(old_map, new_map)

old_end = """              </div>
            );
          })}
        </div>
      </main>"""

new_end = """              </div>
            );
          })()}
        </div>
      </main>"""

content = content.replace(old_end, new_end)

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)
