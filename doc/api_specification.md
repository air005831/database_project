# 「不揪ㄛ」揪團平台——前後端 API 規格書 (V1.5)

本文件定義「不揪ㄛ」運動與麻將揪團平台前端與後端之資料傳輸介面。本版本（V1.5）為目前後端實際運作之規格，包含拉取式信譽積分自動恢復、逾期取消扣分、報名候補順位轉正、檢舉自動扣分防重複等核心業務規則。

* **基礎網址 (Base URL)：** `/api`
* **認證方式：** `Authorization: Token {your_token}` (登入後取得，部分公開 API 不需認證)

---

## 一、 使用者認證與個人檔案 (Auth & Users)

### 1. 使用者註冊 (Register)
* **路徑：** `POST /api/auth/register`
* **權限：** 公開 (不需 Token)
* **請求格式：** `JSON`
* **參數：**

| 參數名 | 必填 | 格式 | 說明 |
| :--- | :--- | :--- | :--- |
| `name` | 是 | String | 使用者暱稱 |
| `email` | 是 | String | 電子信箱，做為登入帳號 (唯一) |
| `password` | 是 | String | 登入密碼 |

* **成功回傳 (201 Created)：**
```json
{
  "id": 12,
  "name": "王小明",
  "email": "xiaoming@example.com"
}
```

---

### 2. 使用者登入 (Login)
* **路徑：** `POST /api/auth/login`
* **權限：** 公開 (不需 Token)
* **請求格式：** `JSON`
* **參數：**

| 參數名 | 必填 | 格式 | 說明 |
| :--- | :--- | :--- | :--- |
| `email` | 是 | String | 電子信箱 |
| `password` | 是 | String | 密碼 |

* **成功回傳 (200 OK)：**
```json
{
  "token": "a1b2c3d4e5f6g7h8i9j0",
  "user_id": 12,
  "role": "user",
  "name": "王小明"
}
```
* **特殊邏輯 (403 Forbidden)：**
  若使用者信譽分數已降至 40 分或以下，或被列入黑名單，登入時會被拒絕並回傳：
```json
{
  "detail": "您的帳號已被列入黑名單或信譽分數已低於或等於 40 分，無法進行此操作。"
}
```

---

### 3. 取得個人資料與信譽分數 (Profile)
* **路徑：** `GET /api/users/profile`
* **權限：** 需 Token 認證
* **成功回傳 (200 OK)：**
```json
{
  "user_id": 12,
  "email": "xiaoming@example.com",
  "name": "王小明",
  "phone": "0912345678",
  "birthday": "1998-05-20",
  "age": 28,
  "credit_point": 95,
  "role": "user",
  "gender": "男",
  "avatar_url": "https://example.com/avatars/12.jpg",
  "bio": "熱愛排球的攻擊手！",
  "line_id": "xiaoming_line",
  "instagram": "xiaoming_ig",
  "levels": {
    "排球": "A",
    "籃球": "B"
  }
}
```
* **拉取式信譽恢復邏輯**：每次呼叫此 API 或經過 `IsNotBanned` 權限檢查時，後端會自動計算自 `last_credit_update` 起所流逝的時間。每過 2 天 (172,800 秒) 會自動恢復 1 分，最高恢復至 100 分。

---

### 4. 更新個人資料 (Update Profile)
* **路徑：** `PUT /api/users/profile` 或 `PATCH /api/users/profile`
* **權限：** 需 Token 認證
* **參數 (JSON Body)：**

| 參數名 | 必填 | 格式 | 說明 |
| :--- | :--- | :--- | :--- |
| `name` | 否 | String | 暱稱修改 |
| `phone` | 否 | String | 手機號碼 (必須符合 `09xxxxxxxx` 格式且不可重複) |
| `bio` | 否 | String | 個人簡介 |
| `line_id` | 否 | String | LINE ID |
| `instagram` | 否 | String | Instagram 帳號 |
| `avatar_url` | 否 | String | 頭像連結 |
| `gender` | 否 | String | 性別 (僅能首次完善時填寫，後續不可修改) |
| `birthday` | 否 | String | 生日 (格式 `YYYY-MM-DD`，僅能首次填寫，不可修改) |
| `levels` | 否 | Object | 各運動項目的等級對照，格式：`{"排球": "A", "籃球": "B"}` |

* **成功回傳 (200 OK)：** 更新後的個人資料。

---

### 5. 取得與更新個人的運動能力分級
* **取得能力分級：** `GET /api/users/sport-levels`
  - **成功回傳 (200 OK)：** `[{"sport": "排球", "level": "A", "updated_at": "..."}]`
* **更新單項能力：** `PUT /api/users/sport-levels`
  - **請求參數 (JSON Body)：** `{"sport_id": 1, "level": "A"}`
  - **成功回傳 (200 OK)：** `{"detail": "Sport level updated successfully."}`

---

### 6. 管理員更新使用者信譽 (Admin Only)
* **路徑：** `PATCH /api/users/{id}/reputation`
* **權限：** 僅限 Admin 權限
* **參數 (JSON Body)：**
```json
{
  "credit_point": 100
}
```
* **成功回傳 (200 OK)：** 使用者最新資料。

---

## 二、 運動與場地模組 (Sports & Venues)

### 1. 取得運動項目清單
* **路徑：** `GET /api/sports`
* **權限：** 公開
* **成功回傳 (200 OK)：**
```json
[
  {
    "id": 1,
    "name": "basketball",
    "chinese_name": "籃球"
  },
  {
    "id": 2,
    "name": "volleyball",
    "chinese_name": "排球"
  }
]
```

---

### 2. 取得場館列表
* **路徑：** `GET /api/venues`
* **權限：** 需 Token 認證
* **Query 篩選參數：** `city` (縣市), `district` (行政區)
* **成功回傳 (200 OK)：**
```json
[
  {
    "id": 5,
    "name": "板橋國民運動中心",
    "address": "新北市板橋區智樂路6號",
    "opening_hours": {"monday": "06:00-22:00", "tuesday": "06:00-22:00"},
    "facilities": ["停車場", "淋浴間", "冷氣"]
  }
]
```

---

### 3. 取得場館之縣市與行政區結構 (Regions)
* **路徑：** `GET /api/venues/regions`
* **權限：** 需 Token 認證
* **說明：** 回傳現存有場地登記的所有縣市與行政區，便於前端下拉選單進行連動與重置。
* **成功回傳 (200 OK)：**
```json
{
  "新北市": ["板橋區", "新莊區", "三重區"],
  "台北市": ["大安區", "信義區"]
}
```

---

### 4. 管理員場地管理 (Admin Only)
* **新增場地：** `POST /api/venues`
* **刪除場地：** `DELETE /api/venues/{id}`
  - **特殊限制**：若有「招募中、滿員、進行中」的球局正在使用此場地，後端會阻擋刪除並回傳 `409 Conflict`。
* **緊急關閉場地：** `POST /api/venues/{id}/emergency-close`
  - **說明**：用於暴雨或天災時關閉場地。將自動解散受影響之尚未開始的球局，並發送緊急通知給所有參與者。

---

## 三、 球局房間模組 (Games/Matches)

### 1. 取得與篩選球局列表
* **路徑：** `GET /api/games`
* **權限：** 需 Token 認證
* **Query 參數：** `sport_id` (運動項目), `target_level` (目標程度), `city` (縣市), `region` (行政區), `date` (活動日期 `YYYY-MM-DD`)
* **成功回傳 (200 OK)：**
```json
[
  {
    "id": 152,
    "game_name": "歡樂羽球團",
    "creator": {
      "id": 8,
      "name": "王主揪"
    },
    "sport": {
      "id": 3,
      "chinese_name": "羽球"
    },
    "court": {
      "id": 2,
      "venue_name": "板橋運動中心"
    },
    "least_players": 4,
    "most_players": 6,
    "current_players_count": 5,
    "target_level": "業餘",
    "booking_date": "2026-06-25",
    "time_slot": "14:00-16:00",
    "total_price": "600.00",
    "split_price": 100,
    "deposit_required": false,
    "cancel_deadline": "2026-06-24T14:00:00Z",
    "match_status": "recruiting",
    "booking_status": "未確認",
    "gender_limit": "不限",
    "weather": 2.2,
    "air_index": 45
  }
]
```

---

### 2. 主揪建立球局 (開房)
* **路徑：** `POST /api/games`
* **權限：** 需 Token 認證 (信譽分數低於或等於 60 分者被限制無法創房)
* **參數 (JSON Body)：**

| 參數名 | 必填 | 格式 | 說明 |
| :--- | :--- | :--- | :--- |
| `game_name` | 否 | String | 房間名稱 (預設為 '未命名球局') |
| `sport_id` | 是 | Integer | 運動項目 ID |
| `venue_id` | 是 | Integer | 場地 ID |
| `court_id` | 否 | Integer | 實體桌/場地 ID (未傳則自動帶入該場館第一個場地) |
| `most_players` | 是 | Integer | 上限人數 |
| `least_players` | 否 | Integer | 最少成團人數 (預設 1) |
| `target_level` | 是 | String | 限制程度 ('休閒', '業餘', '高手') |
| `booking_date` | 是 | String | 日期 (`YYYY-MM-DD`) |
| `time_slot` | 是 | String | 時段 (格式 `HH:MM-HH:MM`) |
| `total_price` | 是 | Decimal | 場地總價 (最高限制 10,000 元) |
| `deposit_required`| 否 | Boolean | 是否收取訂金 |
| `cancel_deadline`| 是 | String | 免費取消截止時間 (ISO 格式) |
| `gender_limit` | 否 | String | 性別限制 ('不限', '限男', '限女'，預設 '不限') |
| `game_note` | 否 | String | 球局備註 |

* **成功回傳 (210 Created)：** 產生的球局完整資料。

---

### 3. 加入球局 / 排隊候補 (Join / Waitlist)
* **路徑：** `POST /api/games/{id}/join`
* **權限：** 需 Token 認證
* **參數 (JSON Body)：**

| 參數名 | 必填 | 格式 | 說明 |
| :--- | :--- | :--- | :--- |
| `force` | 否 | Boolean | 是否強制加入。當程度不符時，預設會阻擋。傳入 `true` 可忽略警告加入。 |

* **成功回傳之兩種狀態：**
  1. **成功正取 (200 OK)：**
     ```json
     {
       "status": "joined",
       "message": "成功加入球局。"
     }
     ```
  2. **自動進入候補 (200 OK)：**
     ```json
     {
       "status": "waitlist",
       "position": 2,
       "message": "球局已滿，已自動為您排入候補名單，目前順位為第 2 位。"
     }
     ```

* **級聯加入與防呆機制**：
  - **滿員限制**：當該球局的總報名人數 (包含正取與候補) 已達到上限的 1.3 倍 (即 `most_players * 1.3`)，將拒絕加入並回傳 `400 Bad Request`。
  - **性別限制**：若球局限制 `限男` 或 `限女` 且與使用者性別不符，直接拒絕。
  - **黑名單限制**：若使用者被列入黑名單或信用分 $\le$ 40 分，直接拒絕。
  - **程度防呆**：當使用者設定的運動等級與球局限制不同（例如：高手局，使用者為 C 級），若未傳送 `force: true`，後端會阻擋並回傳 `LEVEL_MISMATCH` 錯誤代碼：
    ```json
    {
      "error_code": "LEVEL_MISMATCH",
      "detail": "您的球技等級低於此球局的目標程度，請多加留意。是否確定要加入？"
    }
    ```

---

### 4. 退出與取消報名 (Leave / Cancel)

#### A. 主動退出 (正取/候補皆適用)：`DELETE /api/games/{id}/leave`
* **說明**：球友自行退出。若是逾期取消且設定了需收訂金，會返回警告。
* **單表自動轉正機制**：如果退出的使用者是正取成員（加入時間排序在前 `most_players` 之內），且目前有候補球友（總人數 $>$ `most_players`），系統會**自動將第一順位（第 `most_players + 1` 位）的候補球友升為正取**，並對其發送成團轉正推播通知。
* **成功回傳 (200 OK)：**
```json
{
  "detail": "Successfully left the match."
}
```

#### B. 退房與取消加一 (帶扣除信譽分數邏輯)：`DELETE /api/games/{id}/cancel`
* **說明**：等同退出，但後端會強力檢驗是否符合「逾期取消」條件。
* **扣分判定**：
  1. 目前時間已超過 `cancel_deadline` (取消截止時間) ；**或者**
  2. 距離球局開始時間已不足 **24 小時**。
  - 若符合以上任一條件，退出時後端會**自動扣除該使用者信譽分數 10 分**！
* **成功回傳 (200 OK)：**
```json
{
  "detail": "成功取消報名並退出球局。",
  "warning": "已超過免費取消期限（活動前 24 小時），已扣除信譽分數 10 分！ 您的信譽分數已處於 40 至 60 分的警示區間，限制發起新球局。",
  "credit_point": 55
}
```

---

### 5. 主揪確認與回報場地狀態 (Venue Status)
* **路徑：** `PATCH /api/games/{id}/venue-status`
* **權限：** 需 Token 認證 (僅限該球局之主揪或 Admin)
* **參數 (JSON Body)：**

| 參數名 | 必填 | 格式 | 說明 |
| :--- | :--- | :--- | :--- |
| `status` | 是 | String | 狀態值，可為 `'confirmed'` (已佔到/已預約), `'failed'` (未佔到/未預約), 或 `'pending'` (未確認) |

* **成功確認回傳 (200 OK)：** 回傳最新球局資料。
* **場地未借到 (Failed) 的自動流程**：若主揪回報狀態為 `failed` (未佔到/未預約)，該球局會被後端**自動物理刪除(解散)**，並向所有已報名球友發送「【活動取消】場地未借到」之推播通知。

---

### 6. 主揪佈告欄公告 (Announcements)
* **取得歷史公告：** `GET /api/games/{id}/announcements`
  - **成功回傳 (200 OK)：** `[{"id": 1, "title": "重要公告", "content": "大家帶紅色衣服", "time": "09:30 AM", "date": "2026-06-15"}]`
* **發布新公告：** `POST /api/games/{id}/announcements`
  - **權限：** 僅限主揪
  - **參數 (JSON Body)：** `{"title": "公告", "content": "時間提前10分鐘"}`
  - **成功回傳 (210 Created)：** 產生的公告對象。並會自動對全體參戰成員推送通知。

---

### 7. 快速配對推薦 (Quick Match)
* **路徑：** `POST /api/games/quick-match`
* **權限：** 需 Token 認證
* **參數 (JSON Body)：**

| 參數名 | 必填 | 格式 | 說明 |
| :--- | :--- | :--- | :--- |
| `sport_id` | 是 | Integer | 運動項目 ID |
| `target_level` | 是 | String | 期望的能力限制級別 ('休閒', '業餘', '高手') |
| `age_preference`| 否 | String | 年齡偏好，可為 `'same_generation'` (同年代) 或 `'any'` (不限) |

* **成功回傳 (200 OK)：**
```json
{
  "matched_type": "exact",
  "matches": [
    {
      "game_id": 152,
      "sport_name": "羽球",
      "venue_name": "板橋運動中心",
      "match_score": 95,
      "reason": "能力要求完全符合, 同年代球友"
    }
  ]
}
```

---

## 四、 收藏、檢舉與通知 (Social & Reports)

### 1. 收藏球局 (Favorites)
* **取得我的收藏：** `GET /api/favorites/games` (回傳球局清單)
* **新增收藏：** `POST /api/favorites/games` - 參數 `{"game_id": 152}`
* **取消收藏：** `DELETE /api/favorites/games/{game_id}`

---

### 2. 提交檢舉與自動扣分 (Reports)
* **路徑：** `POST /api/reports`
* **權限：** 需 Token 認證
* **參數 (JSON Body)：**

| 參數名 | 必填 | 格式 | 說明 |
| :--- | :--- | :--- | :--- |
| `game_id` | 是 | Integer | 發生問題的球局 ID |
| `reported_user_id`| 是 | Integer | 被檢舉的使用者 ID |
| `reason` | 是 | String | 違規原因 (參見對照表) |
| `detail` | 否 | String | 詳細描述 |

* **系統自動扣分與處罰機制**：
  - 檢舉提交後，系統會自動在被檢舉人身上扣除對應的分數 (預設扣 10 分)。
  - **自動扣分對照表 (DEDUCTION_MAP)**：
    * `未出現` (放鳥)：主揪扣 30 分，一般成員扣 20 分。
    * `沒預約場地` / `未出現` (主揪)：扣 30 分。
    * `沒交錢` / `直銷`：扣 15 分。
    * `球品不好` / `態度不佳` / `等級不符` / `語言攻擊`：扣 10 分。
    * `騷擾與人身攻擊`：扣 30 分。
    * `肢體暴力`：扣 60 分。
  - **停權狀態聯動**：扣分後，若被檢舉人信用分降至 60 分或以下，會推送警告通知並限制其創房；若降至 40 分或以下，會直接寫入 `blacklist` (黑名單) 進行永久停權。
  - **防重複檢舉**：同一名使用者對同一個球局的同一對象，僅能檢舉一次。重複提交將返回 `409 Conflict`。
* **成功回傳 (200 OK)：**
```json
{
  "detail": "您對「王大華」的檢舉（原因：未出現）已成功提交，系統已自動對其扣除 20 分。"
}
```

---

### 3. 個人通知系統 (Notifications)
* **取得通知列表：** `GET /api/notifications` (回傳個人所有通知，支援 WebSocket / SSE 即時更新)
* **標記單筆通知為已讀：** `PATCH /api/notifications/{id}/read`

---

## 五、 氣象、數據與回饋 (Utility & Admin)

### 1. 即時天氣與空氣品質 (Weather & AQI)
* **路徑：** `GET /api/weather/aqi`
* **Query 參數：** `city`, `district`
* **成功回傳 (200 OK)：**
```json
{
  "location": "新北市板橋區",
  "temperature": 28,
  "condition": "晴天",
  "aqi": 35,
  "rain_probability": "10%"
}
```

---

### 2. 使用者系統回饋 (Feedback)
* **提交回饋：** `POST /api/feedback`
  - 參數：`{"type": "建議", "content": "希望場地篩選能更迅速"}`
* **管理員回覆與結案 (Admin Only)：** `PUT /api/admin/feedbacks/{id}/handle`
  - 參數：`{"admin_reply": "感謝回報，我們已優化篩選響應時間。"}`
  - 成功提交後，會自動對該回饋之使用者推送通知：「您的回饋已有管理員回覆！」並將狀態變更為 `is_handled = true`。

---

## 六、 信譽分數等級與處罰基準 (Credit Levels)

| 信用積分區間 | 系統權限與狀態 |
| :--- | :--- |
| **100 分** | 初始分數。 |
| **81 - 99 分** | 狀態良好，可自由使用所有功能。 |
| **61 - 80 分** | 警告區間。**限制發起（創建）新球局房間之功能**，只能加入他人球局。 |
| **41 - 60 分** | 嚴重警告區間。**限制加入任何球局** (僅能查看)。 |
| **<= 40 分** | **永久停權**。帳號被寫入黑名單，無法登入或呼叫任何 API 動作。 |
