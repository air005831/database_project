# 不揪喔——揪團平台

「不揪喔」是一個以運動與麻將揪團為核心的平台專案，目標是協助使用者快速找到附近場地、即時媒合缺人的球局或牌局，並結合天氣、空氣品質、場地預約與費用分攤資訊，降低臨時揪團失敗的機率。

本系統目前支援活動包含**籃球、排球、羽毛球與麻將**。

---

## 📄 專案核心技術文檔目錄

我們對專案的結構進行了整理，並撰寫了完整的最新技術文檔：

1. 🗄️ **[資料庫設計文件 (Database Design)](doc/database_design.md)**
   * 提供最新 20 張資料表的 Mermaid ERD 關聯圖。
   * 詳細列明每個欄位的資料型態、主外鍵、索引設計與外鍵級聯（Cascade）聯動機制。
2. 🔌 **[前後端 API 規格書 V1.5 (API Specification)](doc/api_specification.md)**
   * 定義 `/api` 下的所有 RESTful API 端點（使用者個人檔案、球局開房、候補加一、檢舉扣分與系統公告）。
   * 提供詳細的參數說明與成功/錯誤 JSON 回傳格式。
3. 🛠️ **[開發與執行指南 (Development & Run Guide)](doc/development_guide.md)**
   * 詳述後端 Django 與前端 Vite 本地環境建置步驟。
   * 提供資料庫遷移、SQL 備份匯入及單元與整合測試執行指令。
4. 📊 **[整體專案報告 (Project Report)](doc/project_report.md)**
   * 綜述專案的解決痛點與前後端全景技術架構。
   * 詳細剖析系統內部實際運行的 6 大核心演算法與業務機制（如拉取式信用分恢復、單表時間戳候補遞補、快速配對評分與生命週期定時流局監控）。

---

## 📂 專案目錄結構

整理後的最整潔專案結構如下：

```text
database_project/
├── backend/                # 後端服務目錄 (Django Web Framework)
│   ├── api_v1/             # API 核心模組 (Views, Models, Serializers)
│   ├── core/               # Django 專案核心設定目錄
│   └── env/                # Python 虛擬環境 (Virtual Environment)
├── frontend/               # 前端網頁目錄 (Vite + React + Vanilla CSS)
│   ├── src/                # 前端原始碼 (Components, Pages, API Client)
│   └── public/             # 靜態資源
├── db/                     # 資料庫 SQL 備份檔案
│   ├── nojo_db_backup.sql  # MySQL 資料表結構與場地資料備份
│   └── nojo_django_db_backup.sql # Django 格式備份
├── doc/                    # 專案技術與架構文檔目錄
│   ├── database_design.md  # 資料庫設計文件
│   ├── api_specification.md# API 規格書 (V1.5)
│   ├── development_guide.md# 開發與執行指南
│   └── project_report.md   # 整體專案報告
├── scratch/                # 臨時或開發輔助草稿目錄
├── start_dev.ps1 / .bat    # 開發環境一鍵啟動腳本 (Windows)
├── start_tunnel.ps1 / .bat # 網路穿透服務啟動腳本 (測試用)
└── README.md               # 專案說明文件 (本檔案)
```

---

## 🚀 快速啟動開發環境

1. 請確保本地已安裝 **Node.js** (v18+) 及 **Python** (3.10+)。
2. 在 Windows 系統下，雙擊根目錄下的 `start_dev.bat` 或在 PowerShell 中執行 `.\start_dev.ps1`。
3. 腳本將在新視窗中分別啟動：
   * **前端網頁** (Vite): `http://localhost:5173/`
   * **後端 API 與管理後台** (Django): `http://127.0.0.1:8000/`
4. 如需更詳細的配置（如資料庫匯入、遷移及測試指令），請參閱 **[開發與執行指南](doc/development_guide.md)**。
