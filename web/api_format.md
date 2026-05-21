# 「不揪ㄛ」揪團平台——前後端 API 規格書

本文件定義「不揪ㄛ」運動揪團平台前端與後端之資料傳輸介面，欄位設計嚴格對齊系統 MySQL 資料表結構（包含 Users, GamesMatches, Match_Participants, favorite_games, favorite_venues, Reports, blacklist），並納入「生日年齡驗證」與「球局/場館收藏」等新進功能。

**文件版本：** V1.0  
**基礎網址 (Base URL)：** `/api`

---

## 一、 使用者認證與個人檔案模組 (Auth & Users)

主要連動 `users`、`user_sport_levels` 與 `blacklist` 資料表。用於處理球友註冊、登入、信用積分核算與運動能力級別之管理。

### 1. 使用者註冊與登入
- **路由路徑：** `POST /api/auth/login`
- **說明：** 使用者首次登入即自動註冊，前端需傳入生日以供後端進行年齡匹配驗證。

| 傳入參數 (JSON Body) | 欄位型態 | 欄位說明 |
| :--- | :--- | :--- |
| name | String | 球友姓名或暱稱 |
| phone | String | 聯絡電話（唯一識別） |
| birthday | Date (YYYY-MM-DD) | 出生年月日（前端用日曆選擇器） |

**後端回傳範例 (Response 200)：**
```json
{
  "token": "eyJhbGciOi...",
  "user_id": 1,
  "role": "user"
}
```

### 2. 取得個人資料與信譽積分
- **路由路徑：** `GET /api/users/profile`
- **說明：** 後端需根據 `birthday` 與當前日期，於資料庫動態計算出 `age` 欄位吐給前端。

**後端回傳範例 (Response 200)：**
```json
{
  "user_id": 1,
  "name": "陳球友",
  "phone": "0912345678",
  "birthday": "2006-06-25",
  "age": 19,
  "credit_point": 100,
  "role": "user"
}
```

### 3. 取得與更新個人的運動能力分級
- **取得能力值：** `GET /api/users/sport-levels`
- **更新能力值：** `PUT /api/users/sport-levels`

**更新時傳入參數 (Body)：**
```json
{
  "sport_id": 1,
  "level": "advanced"
}
```

---

## 二、 球局房間模組 (GamesMatches CRUD)

主要連動 `gamesmatches`、`sports`、`venues` 與 `address` 資料表。為系統核心列表與開房引擎。

### 1. 取得球局列表 (支援分類篩選與特殊排序)
- **路由路徑：** `GET /api/games`
- **前端篩選 Query 參數：** `?sport_id=1&target_level=casual&city=新北市`
- **說明：** 後端必須主動將球場、運動項目、地址進行 JOIN，並連動氣象與環保署 OpenData 計算出 `weather_index`（不適合遊玩指數），直接吐給前端渲染。

| 回傳 JSON 欄位 | 欄位型態 | 欄位說明 |
| :--- | :--- | :--- |
| game_id | Int | 球局活動唯一識別碼 |
| sport_name | String | 運動項目名稱（羽毛球、排球、籃球、麻將） |
| venue_name | String | 球館/場館名稱 |
| split_price | Decimal | 分攤後一人需付金額（總價/上限人數） |
| most_players | Int | 所需總人數 |
| current_players | Int | 目前已加入人數（剩餘名額由前端兩者相減計算） |
| weather_index | Decimal | 不適合遊玩指數 (5*降雨機率 + AQI/50) |
| match_status | Enum | 匹配狀態 ('recruiting', 'full', 'closed') |

> **💡 前端 UI 特別處理邏輯：**
> 1. 若 `sport_name` 為「麻將」，前端應直接隱藏時間篩選，改以極大字體視覺化突顯「缺 1 人」、「缺 2 人」之即時狀態。
> 2. 若 `weather_index` 指數偏高且場地類型為 outdoor，前端卡片需亮起紅色降雨警告標籤。

### 2. 主揪發起球局（開房）
- **路由路徑：** `POST /api/games`

**前端傳送範例 (Body)：**
```json
{
  "sport_id": 1,
  "court_id": 5,
  "least_players": 4,
  "most_players": 6,
  "target_level": "casual",
  "booking_date": "2026-05-25",
  "time_slot": "14:00-16:00",
  "total_price": 600.00,
  "deposit_required": 1,
  "cancel_deadline": "2026-05-24T14:00:00Z"
}
```

---

## 三、 球友參與與房間互動模組 (Match Participants)

主要連動 `match_participants` 與 `gamesmatches` 資料表。控制房間內人員異動、取消截止期限及到場確認。

### 1. 球友加入球局（我要加一）
- **路由路徑：** `POST /api/games/{game_id}/join`
- **後端檢驗安全機制：** 後端會校驗使用者目前是否被列入黑名單（`blacklist`）、信用積分是否足夠，以及其能力值（`level`）是否達到房間要求的 `target_level`。

### 2. 球友退出球局
- **路由路徑：** `DELETE /api/games/{game_id}/leave`
- **說明：** 前端點擊退出。若當前時間已超過 `cancel_deadline` 且該球局 `deposit_required=1`，後端將執行扣除訂金流程或跳出不可免費取消警告。

### 3. 免費場地：主揪到場站位確認
- **路由路徑：** `PATCH /api/games/{game_id}/confirm-presence`
- **前端傳送 (Body)：** `{ "is_confirmed": 1 }`
- **說明：** 企劃書規定免費場地需於 30 分鐘前到場站位按下確認，否則系統將對隊伍成員發送未成團通知。

---

## 四、 關注與收藏模組

連動全新建立之 `favorite_games` 與 `favorite_venues` 關聯表。用於實現球友收藏愛心功能。

### 1. 收藏與取消收藏「球局」
- **新增收藏：** `POST /api/favorites/games` → 傳入 Body: `{"game_id": 101}`
- **移除收藏：** `DELETE /api/favorites/games/101`
- **取得收藏球局列表：** `GET /api/favorites/games`

### 2. 收藏與取消收藏「場館球館」
- **新增收藏：** `POST /api/favorites/venues` → 傳入 Body: `{"venue_id": 5}`
- **移除收藏：** `DELETE /api/favorites/venues/5`
- **取得收藏場館列表：** `GET /api/favorites/venues`

---

## 五、 檢舉與管理員後台模組 (Reports & Penalty)

主要連動 `reports`、`penalty_rules` 與 `blacklist` 資料表。維護平台揪團之信譽積分秩序。

### 1. 使用者發起賽後檢舉
- **路由路徑：** `POST /api/reports`

**前端傳送範例 (Body)：**
```json
{
  "game_id": 101,
  "offender_id": 3,
  "reason": "no_show" 
}
```
*\*註：reason 可選值包含放鳥 'no_show'、未付錢 'not_paid'、惡劣行為 'bad_behavior'。*

### 2. 管理員審核檢舉案 (限 Admin 權限)
- **路由路徑：** `PATCH /api/admin/reports/{report_id}/review`
- **前端傳送 (Body)：** `{ "status": "deducted", "admin_note": "審核通過，放鳥扣分" }`
- **說明：** 審核狀態改為 `deducted` 後，後端依 `penalty_rules` 自動扣減該 user 的 `credit_point`。當低於特定積分，後端應自動寫入 `blacklist`（黑名單表）強制封鎖其開房與加一權限。

---

## 六、 球館與場地基礎資訊模組 (Venues & Courts)

主要連動 `venues`、`court`、`sports`、`court_sports`。提供主揪發起活動時，連動選擇球館與場地。

### 1. 取得特定球館內之場地/桌次狀態
- **路由路徑：** `GET /api/venues/{venue_id}/courts`

**後端回傳範例 (Response 200)：**
```json
[
  { "court_id": 1, "court_name": "A 羽球場", "occupied": 0 },
  { "court_id": 2, "court_name": "B 羽球場", "occupied": 1 }
]
```
