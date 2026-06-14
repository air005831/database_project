# 「不揪ㄛ」揪團平台——開發與執行指南 (Development & Run Guide)

本指南詳細說明「不揪ㄛ」專案的本地開發環境建立、伺服器啟動、資料庫遷移與匯入、以及自動化測試的執行步驟。

---

## 一、 開發環境準備

### 1. 後端 (Django)
* **Python 版本**：建議 Python 3.10+
* **依賴安裝**：後端使用 `requirements.txt` 管理 Python 套件。
* **虛擬環境**：專案已包含 `backend/env` 虛擬環境資料夾。

### 2. 前端 (Vite + React)
* **Node.js**：建議 Node.js v18+ 及 npm v9+

---

## 二、 後端伺服器建置與啟動 (Backend)

1. **進入後端目錄**：
   ```powershell
   cd backend
   ```

2. **啟用虛擬環境**：
   * **Windows (PowerShell)**：
     ```powershell
     .\env\Scripts\Activate.ps1
     ```
   * **Windows (CMD)**：
     ```cmd
     .\env\Scripts\activate.bat
     ```
   * **macOS / Linux**：
     ```bash
     source env/bin/activate
     ```

3. **安裝依賴套件**（如已安裝可跳過）：
   ```bash
   pip install -r requirements.txt
   ```

4. **資料庫遷移與初始化 (Migrations)**：
   本專案支援 Django ORM 自動遷移。請在啟用虛擬環境下執行：
   ```bash
   python manage.py makemigrations
   ```
   ```bash
   python manage.py migrate
   ```

5. **啟動 Django 本地伺服器**：
   ```bash
   python manage.py runserver
   ```
   * 啟動後，後端 API 服務將運行在 `http://127.0.0.1:8000/`。
   * 管理員後台可存取 `http://127.0.0.1:8000/admin/`。

---

## 三、 資料庫備份與匯入說明 (MySQL / MariaDB)

本專案支援將資料儲存至本地 SQLite (預設開發偵錯用) 或 MySQL/MariaDB。

若要手動匯入我們提供的最新資料庫結構與測試資料：
1. **結構與測試資料備份檔** 位於 `db/` 目錄：
   - `db/nojo_db_backup.sql`（主要 MySQL/MariaDB 資料庫結構與基本場地資料備份）
   - `db/nojo_django_db_backup.sql`（Django 格式備份）

2. **MySQL 匯入指令**：
   在 MySQL/MariaDB 命令列中建立一個名為 `nojo` 的資料庫，並執行以下指令進行匯入：
   ```bash
   mysql -u {YOUR_USERNAME} -p nojo < db/nojo_db_backup.sql
   ```

---

## 四、 前端伺服器建置與啟動 (Frontend)

1. **進入前端目錄**：
   ```bash
   cd frontend
   ```

2. **安裝 Node.js 依賴套件**：
   ```bash
   npm install
   ```

3. **啟動 Vite 開發伺服器**：
   ```bash
   npm run dev
   ```
   * 啟動後，前端網頁服務將運行在 `http://localhost:5173/`。
   * 網頁會自動偵測並呼叫本地後端 API 端點 (`/api`)。

---

## 五、 一鍵啟動腳本 (One-Click Startup)

為簡化啟動流程，我們在專案根目錄提供了自動啟動腳本（會在新視窗中分別啟動前後端伺服器）：

* **PowerShell 啟動**：
  在專案根目錄下直接執行：
  ```powershell
  .\start_dev.ps1
  ```
* **Windows CMD/批次檔啟動**：
  連擊或在終端機中運行：
  ```cmd
  start_dev.bat
  ```

---

## 六、 執行自動化測試 (Testing)

我們撰寫了完整的測試案例，用以驗證認證、創房、候補與信譽扣分等機制是否正常運作。

1. **執行 Django 單元測試**：
   進入 `backend` 目錄並啟用虛擬環境，執行：
   ```bash
   python manage.py test
   ```
2. **執行整合 API 自動測試腳本**：
   我們在 `backend/autotest/` 目錄下準備了專屬的 API 自動化測試腳本：
   * 執行第一階段 API 測試：
     ```bash
     python autotest/api_test_1st_stage.py
     ```
   * 執行佈告欄 API 測試：
     ```bash
     python autotest/api_test_bulletins.py
     ```
