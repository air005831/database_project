-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- 主機： 127.0.0.1
-- 產生時間： 2026-06-12 16:19:27
-- 伺服器版本： 10.4.32-MariaDB
-- PHP 版本： 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 資料庫： `nojo`
--

-- --------------------------------------------------------

--
-- 資料表結構 `address`
--

CREATE TABLE `address` (
  `address_id` int(11) NOT NULL,
  `zipcode` varchar(5) DEFAULT NULL,
  `city` varchar(50) NOT NULL,
  `district` varchar(50) NOT NULL,
  `street_line` varchar(255) NOT NULL,
  `latitude` decimal(10,8) DEFAULT NULL COMMENT '地址緯度',
  `longitude` decimal(11,8) DEFAULT NULL COMMENT '地址經度'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 傾印資料表的資料 `address`
--

INSERT INTO `address` (`address_id`, `zipcode`, `city`, `district`, `street_line`, `latitude`, `longitude`) VALUES
(1, '333', '桃園市', '龜山區', '中興路100巷20號', 24.98786195, 121.33263230),
(2, '333', '桃園市', '龜山區', '南美村南上路99號', 25.04861101, 121.29699110),
(3, '333', '桃園市', '龜山區', '文化一路259號', 25.03260190, 121.39029120),
(4, '333', '桃園市', '龜山區', '萬壽路一段168號', 25.01933398, 121.40470060),
(5, '333', '桃園市', '龜山區', '大同路23號', 24.99538368, 121.34144600),
(6, '333', '桃園市', '龜山區', '文化一路250號', 25.03456513, 121.38351920),
(7, '333', '桃園市', '龜山區', '自由街40號', 25.02016278, 121.40298660),
(8, '333', '桃園市', '龜山區', '自強東路269號', 24.99727985, 121.34530310),
(9, '333', '桃園市', '龜山區', '萬壽路一段300號', 25.01967182, 121.40094280),
(10, '333', '桃園市', '龜山區', '萬壽路二段933巷14號', 24.99416332, 121.33979920),
(11, '333', '桃園市', '龜山區', '新路村永和街12號', 24.99544203, 121.33510530),
(12, '333', '桃園市', '龜山區', '大同村德明路5號', 24.98803293, 121.34169280),
(13, '333', '桃園市', '龜山區', '大湖村文三二街80號', 25.05799995, 121.35893400),
(14, '333', '桃園市', '龜山區', '頂興路115巷20號', 24.98922338, 121.33029880),
(15, '333', '桃園市', '龜山區', '福源街59號', 24.98818996, 121.35750170),
(16, '333', '桃園市', '龜山區', '龍壽村龍校街30號', 25.01079768, 121.38767930),
(17, '333', '桃園市', '龜山區', '大坑路一段850號', 25.04453478, 121.31490390),
(18, '333', '桃園市', '龜山區', '文昌五街95號', 25.05765990, 121.37202340),
(19, '333', '桃園市', '龜山區', '楓樹村光峰路277號', 25.00599696, 121.34314050),
(20, '333', '桃園市', '龜山區', '文化里文化二路168號', 25.05128392, 121.37063380),
(21, '333', '桃園市', '龜山區', '文七二街72號旁', 25.05247456, 121.36032880),
(22, '333', '桃園市', '龜山區', '自強北路38號', 24.99939477, 121.34353280),
(23, '333', '桃園市', '龜山區', '同心二路', 24.99526213, 121.32973020),
(24, '333', '桃園市', '龜山區', '自強南路81巷', 24.99148430, 121.34006740),
(25, '333', '桃園市', '龜山區', '文化七路116號後方', 25.04982597, 121.36486710),
(26, '333', '桃園市', '龜山區', '大崗里20鄰大湖一路175號', 25.05185014, 121.35856430),
(27, '333', '桃園市', '龜山區', '長庚里長庚醫護新村425號', 25.06166397, 121.38710260),
(28, '333', '桃園市', '龜山區', '大崗村樹人路56號', 25.04716275, 121.35351060),
(29, '333', '桃園市', '龜山區', '文化一路261號', 25.03065727, 121.38989210),
(30, '333', '桃園市', '龜山區', '宏德新村2號', 24.97991670, 121.33137170),
(31, '333', '桃園市', '龜山區', '宏慶街34巷48-1號', 25.01898641, 121.41026080),
(32, '333', '桃園市', '龜山區', '復興北路與文昌五街交叉口', 25.05681417, 121.37156760),
(33, '333', '桃園市', '龜山區', '光峰路及光榮路口', 25.00638588, 121.34135490),
(34, '333', '桃園市', '龜山區', '文化三路246號', 25.05458321, 121.36710950),
(35, '333', '桃園市', '龜山區', '文化七路與興華五街交叉口', 25.05142085, 121.36558060),
(36, '333', '桃園市', '龜山區', '文安街與文光街交叉口', 25.05523486, 121.38071360),
(37, '333', '桃園市', '龜山區', '萬壽路一段383號後方', 25.01638657, 121.40242880),
(38, '333', '桃園市', '龜山區', '假日花市', 24.99606922, 121.32514360),
(39, '333', '桃園市', '龜山區', '自強西路66號', 24.99733819, 121.33889260),
(40, '333', '桃園市', '龜山區', '文化里文化三路395號', 25.06010000, 121.36540000),
(41, '333', '桃園市', '龜山區', '大同里德明路133號', NULL, NULL),
(42, '333', '桃園市', '龜山區', '文化里復興一路212巷32號', 25.05920000, 121.36810000),
(43, '333', '桃園市', '龜山區', '文青里樂善一路7號', 25.03450000, 121.39120000),
(44, '333', '桃園市', '龜山區', '迴龍里萬壽路一段155號', NULL, NULL),
(45, '333', '桃園市', '龜山區', '大華里文化三路552號1樓', NULL, NULL),
(46, '333', '桃園市', '龜山區', '新興里自強南路281號', 24.99610000, 121.34120000),
(47, '333', '桃園市', '龜山區', '大同里德明路87號', NULL, NULL),
(48, '220', '新北市', '板橋區', '雙十路二段100號', 25.02640000, 121.46740000),
(53, NULL, '桃園市', '你好', '', 24.96055050, 121.29930860),
(54, '320', '桃園市', '中壢區', '中大路300號', 24.96830000, 121.19250000),
(55, '220', '新北市', '板橋區', '未指定路段', NULL, NULL),
(56, '333', '桃園市', '龜山區', '復興二路100號', NULL, NULL);

-- --------------------------------------------------------

--
-- 資料表結構 `announcements`
--

CREATE TABLE `announcements` (
  `announcement_id` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `content` text NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `photo` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- 資料表結構 `blacklist`
--

CREATE TABLE `blacklist` (
  `blacklist_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `added_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `removed_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- 資料表結構 `court`
--

CREATE TABLE `court` (
  `court_id` int(11) NOT NULL,
  `venue_id` int(11) NOT NULL,
  `occupied` tinyint(1) NOT NULL DEFAULT 0,
  `base_price` int(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 傾印資料表的資料 `court`
--

INSERT INTO `court` (`court_id`, `venue_id`, `occupied`, `base_price`) VALUES
(1, 1, 0, NULL),
(2, 2, 0, NULL),
(3, 3, 0, NULL),
(4, 3, 0, NULL),
(5, 3, 0, NULL),
(6, 4, 0, NULL),
(7, 4, 0, NULL),
(8, 5, 0, NULL),
(9, 6, 0, NULL),
(10, 7, 0, NULL),
(11, 8, 0, NULL),
(12, 8, 0, NULL),
(13, 8, 0, NULL),
(14, 9, 0, NULL),
(15, 10, 0, NULL),
(16, 10, 0, NULL),
(17, 10, 0, NULL),
(18, 11, 0, NULL),
(19, 12, 0, NULL),
(20, 12, 0, NULL),
(21, 13, 0, NULL),
(22, 14, 0, NULL),
(23, 15, 0, NULL),
(24, 16, 0, NULL),
(25, 16, 0, NULL),
(26, 17, 0, NULL),
(27, 17, 0, NULL),
(28, 17, 0, NULL),
(29, 18, 0, NULL),
(30, 18, 0, NULL),
(31, 19, 0, NULL),
(32, 20, 0, NULL),
(33, 21, 0, NULL),
(34, 22, 0, NULL),
(35, 23, 0, NULL),
(36, 24, 0, NULL),
(37, 25, 0, NULL),
(38, 26, 0, NULL),
(39, 27, 0, NULL),
(40, 28, 0, NULL),
(41, 29, 0, NULL),
(42, 30, 0, NULL),
(43, 31, 0, NULL),
(44, 32, 0, NULL),
(45, 33, 0, NULL),
(46, 34, 0, NULL),
(47, 35, 0, NULL),
(48, 36, 0, NULL),
(49, 37, 0, NULL),
(50, 38, 0, NULL),
(51, 39, 0, NULL),
(52, 40, 0, NULL),
(53, 41, 0, NULL),
(54, 41, 0, NULL),
(55, 42, 0, NULL),
(56, 43, 0, NULL),
(57, 44, 0, NULL),
(58, 45, 0, NULL),
(59, 46, 0, NULL),
(60, 47, 0, NULL),
(61, 48, 0, NULL),
(62, 49, 0, NULL),
(63, 50, 0, NULL),
(64, 51, 0, NULL),
(65, 52, 0, NULL),
(66, 52, 0, NULL),
(67, 52, 0, NULL),
(68, 52, 0, NULL),
(69, 52, 0, NULL),
(70, 52, 0, NULL),
(71, 52, 0, NULL),
(72, 52, 0, NULL),
(73, 52, 0, NULL),
(74, 52, 0, NULL),
(75, 52, 0, NULL),
(76, 52, 0, NULL),
(77, 52, 0, NULL),
(78, 53, 0, NULL),
(79, 53, 0, NULL),
(80, 53, 0, NULL),
(81, 53, 0, NULL),
(82, 53, 0, NULL),
(83, 53, 0, NULL),
(84, 53, 0, NULL),
(85, 53, 0, NULL),
(86, 53, 0, NULL),
(87, 53, 0, NULL),
(88, 54, 0, NULL),
(89, 54, 0, NULL),
(90, 54, 0, NULL),
(91, 54, 0, NULL),
(92, 54, 0, NULL),
(93, 54, 0, NULL),
(94, 54, 0, NULL),
(95, 54, 0, NULL),
(96, 54, 0, NULL),
(97, 54, 0, NULL),
(98, 55, 0, NULL),
(99, 55, 0, NULL),
(100, 55, 0, NULL),
(101, 55, 0, NULL),
(102, 55, 0, NULL),
(103, 55, 0, NULL),
(104, 56, 0, NULL),
(105, 56, 0, NULL),
(106, 56, 0, NULL),
(107, 56, 0, NULL),
(108, 56, 0, NULL),
(109, 56, 0, NULL),
(110, 56, 0, NULL),
(111, 56, 0, NULL),
(112, 57, 0, NULL),
(113, 57, 0, NULL),
(114, 57, 0, NULL),
(115, 57, 0, NULL),
(116, 57, 0, NULL),
(117, 57, 0, NULL),
(118, 57, 0, NULL),
(119, 58, 0, NULL),
(120, 58, 0, NULL),
(121, 58, 0, NULL),
(122, 58, 0, NULL),
(123, 58, 0, NULL),
(124, 58, 0, NULL),
(125, 58, 0, NULL),
(126, 58, 0, NULL),
(127, 58, 0, NULL),
(128, 59, 0, NULL),
(129, 59, 0, NULL),
(130, 59, 0, NULL),
(131, 59, 0, NULL),
(132, 59, 0, NULL),
(133, 59, 0, NULL),
(134, 59, 0, NULL),
(135, 59, 0, NULL),
(136, 59, 0, NULL),
(137, 59, 0, NULL),
(138, 59, 0, NULL),
(139, 65, 0, 0),
(140, 65, 0, 0),
(141, 65, 0, 0),
(142, 66, 0, 0),
(143, 66, 0, 0),
(144, 66, 0, 0),
(150, 68, 0, 0),
(151, 68, 0, 0),
(152, 68, 0, 0),
(181, 77, 0, 0),
(182, 77, 0, 0),
(183, 77, 0, 0),
(184, 77, 0, 0),
(185, 77, 0, 0),
(187, 12, 0, 0),
(188, 12, 0, 0),
(189, 12, 0, 0),
(190, 68, 0, 300),
(191, 1, 0, 0),
(192, 79, 0, 0),
(193, 79, 0, 0),
(194, 79, 0, 0);

-- --------------------------------------------------------

--
-- 資料表結構 `court_conflicts`
--

CREATE TABLE `court_conflicts` (
  `conflict_id` int(11) NOT NULL,
  `court_id_1` int(11) NOT NULL,
  `court_id_2` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- 資料表結構 `court_sports`
--

CREATE TABLE `court_sports` (
  `id` int(11) NOT NULL,
  `court_id` int(11) NOT NULL,
  `sport_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 傾印資料表的資料 `court_sports`
--

INSERT INTO `court_sports` (`id`, `court_id`, `sport_id`) VALUES
(1, 1, 1),
(140, 1, 2),
(2, 2, 1),
(3, 3, 2),
(4, 4, 3),
(5, 5, 1),
(6, 6, 2),
(7, 7, 1),
(8, 8, 2),
(9, 9, 2),
(10, 10, 1),
(11, 10, 3),
(12, 11, 1),
(13, 12, 2),
(14, 13, 3),
(15, 14, 1),
(16, 15, 2),
(17, 16, 1),
(18, 17, 1),
(19, 18, 3),
(20, 19, 1),
(21, 20, 3),
(22, 21, 1),
(23, 22, 1),
(24, 23, 1),
(25, 24, 1),
(26, 25, 3),
(27, 26, 1),
(28, 27, 2),
(29, 28, 3),
(30, 29, 3),
(31, 30, 1),
(32, 31, 1),
(33, 32, 1),
(34, 33, 1),
(35, 34, 1),
(36, 35, 1),
(37, 36, 1),
(38, 37, 2),
(39, 38, 1),
(40, 39, 1),
(41, 40, 1),
(42, 41, 1),
(43, 42, 2),
(44, 43, 1),
(45, 44, 1),
(46, 45, 1),
(47, 46, 1),
(48, 47, 1),
(49, 48, 2),
(50, 49, 1),
(51, 50, 1),
(52, 51, 2),
(53, 52, 1),
(54, 53, 2),
(55, 54, 3),
(56, 55, 1),
(57, 56, 1),
(58, 57, 1),
(59, 58, 1),
(60, 59, 1),
(61, 60, 1),
(62, 61, 1),
(63, 62, 1),
(64, 63, 2),
(65, 64, 1),
(66, 65, 5),
(67, 66, 5),
(68, 67, 5),
(69, 68, 5),
(70, 69, 5),
(71, 70, 5),
(72, 71, 5),
(73, 72, 5),
(74, 73, 5),
(75, 74, 5),
(76, 75, 5),
(77, 76, 5),
(78, 77, 5),
(79, 78, 5),
(80, 79, 5),
(81, 80, 5),
(82, 81, 5),
(83, 82, 5),
(84, 83, 5),
(85, 84, 5),
(86, 85, 5),
(87, 86, 5),
(88, 87, 5),
(89, 88, 5),
(90, 89, 5),
(91, 90, 5),
(92, 91, 5),
(93, 92, 5),
(94, 93, 5),
(95, 94, 5),
(96, 95, 5),
(97, 96, 5),
(98, 97, 5),
(99, 98, 5),
(100, 99, 5),
(101, 100, 5),
(102, 101, 5),
(103, 102, 5),
(104, 103, 5),
(105, 104, 5),
(106, 105, 5),
(107, 106, 5),
(108, 107, 5),
(109, 108, 5),
(110, 109, 5),
(111, 110, 5),
(112, 111, 5),
(113, 112, 5),
(114, 113, 5),
(115, 114, 5),
(116, 115, 5),
(117, 116, 5),
(118, 117, 5),
(119, 118, 5),
(120, 119, 5),
(121, 120, 5),
(122, 121, 5),
(123, 122, 5),
(124, 123, 5),
(125, 124, 5),
(126, 125, 5),
(127, 126, 5),
(128, 127, 5),
(129, 128, 5),
(130, 129, 5),
(131, 130, 5),
(132, 131, 5),
(133, 132, 5),
(134, 133, 5),
(135, 134, 5),
(136, 135, 5),
(137, 136, 5),
(138, 137, 5),
(139, 138, 5),
(170, 139, 1),
(171, 140, 1),
(172, 141, 1),
(173, 142, 1),
(174, 143, 1),
(175, 144, 1),
(184, 150, 1),
(185, 151, 1),
(186, 152, 1),
(259, 181, 1),
(260, 182, 1),
(261, 183, 1),
(262, 184, 1),
(263, 185, 1),
(267, 187, 1),
(268, 188, 1),
(269, 189, 1),
(270, 190, 1),
(271, 191, 1),
(281, 192, 1),
(282, 193, 1),
(283, 194, 4);

-- --------------------------------------------------------

--
-- 資料表結構 `facilities`
--

CREATE TABLE `facilities` (
  `facility_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 傾印資料表的資料 `facilities`
--

INSERT INTO `facilities` (`facility_id`, `name`) VALUES
(1, '停車場'),
(5, '免費車位'),
(8, '冷氣'),
(2, '冷氣機'),
(3, '廁所'),
(4, '無障礙停車場'),
(6, '熱水淋浴間'),
(7, '自動販賣機');

-- --------------------------------------------------------

--
-- 資料表結構 `feedbacks`
--

CREATE TABLE `feedbacks` (
  `feedback_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `type` varchar(50) NOT NULL,
  `content` text NOT NULL,
  `is_handled` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime(6) NOT NULL,
  `admin_reply` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- 資料表結構 `feedback_types`
--

CREATE TABLE `feedback_types` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- 資料表結構 `gamesmatches`
--

CREATE TABLE `gamesmatches` (
  `game_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `court_id` int(20) NOT NULL,
  `sport_id` int(11) NOT NULL,
  `least_players` int(11) NOT NULL,
  `most_players` int(11) NOT NULL,
  `target_level` enum('休閒','業餘','高手') DEFAULT NULL,
  `weather` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`weather`)),
  `air_index` int(11) DEFAULT NULL,
  `match_status` enum('recruiting','full','closed','started','failed_to_start') NOT NULL DEFAULT 'recruiting',
  `booking_date` date NOT NULL COMMENT '紀錄球局預約的日期',
  `time_slot` varchar(50) NOT NULL COMMENT '紀錄球局進行的時間區間，例如 18:00-20:00',
  `total_price` decimal(10,2) DEFAULT NULL,
  `deposit_required` tinyint(1) NOT NULL DEFAULT 0,
  `cancel_deadline` timestamp NULL DEFAULT NULL,
  `booking_status` enum('已佔到/已預約','未佔到/未預約','未確認') NOT NULL DEFAULT '未確認',
  `gender_limit` enum('不限','限男','限女') NOT NULL DEFAULT '不限',
  `game_note` text DEFAULT NULL COMMENT '佔場位置或衣服說明備註',
  `game_name` varchar(100) NOT NULL COMMENT '比賽名稱',
  `venue_note` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- 資料表結構 `game_bulletins`
--

CREATE TABLE `game_bulletins` (
  `bulletin_id` int(11) NOT NULL,
  `game_id` int(11) NOT NULL,
  `title` varchar(200) NOT NULL DEFAULT '公告',
  `content` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- 資料表結構 `keep`
--

CREATE TABLE `keep` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `game_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- 資料表結構 `match_participants`
--

CREATE TABLE `match_participants` (
  `list_id` int(11) NOT NULL,
  `game_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `joined_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- 資料表結構 `notification`
--

CREATE TABLE `notification` (
  `notification_id` int(11) NOT NULL,
  `game_id` int(11) DEFAULT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_read` tinyint(1) DEFAULT 0,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- 資料表結構 `penalty_rules`
--

CREATE TABLE `penalty_rules` (
  `rule_id` int(11) NOT NULL,
  `reason` varchar(50) NOT NULL,
  `points_deducted` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- 資料表結構 `reports`
--

CREATE TABLE `reports` (
  `report_id` int(11) NOT NULL,
  `game_id` int(11) NOT NULL,
  `reporter_id` int(11) NOT NULL,
  `offender_id` int(11) NOT NULL,
  `rule_id` int(11) DEFAULT NULL,
  `admin_note` text DEFAULT NULL,
  `reviewed_at` timestamp NULL DEFAULT NULL,
  `reviewed_by` int(11) DEFAULT NULL,
  `status` enum('pending','deducted','rejected') NOT NULL DEFAULT 'pending',
  `detail` text DEFAULT NULL COMMENT '檢舉詳細內容說明'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- 資料表結構 `sports`
--

CREATE TABLE `sports` (
  `sport_id` int(11) NOT NULL,
  `sport_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 傾印資料表的資料 `sports`
--

INSERT INTO `sports` (`sport_id`, `sport_name`) VALUES
(3, '排球'),
(4, '桌球'),
(1, '籃球'),
(2, '羽球'),
(5, '麻將');

-- --------------------------------------------------------

--
-- 資料表結構 `taiwan_regions`
--

CREATE TABLE `taiwan_regions` (
  `zipcode` varchar(5) NOT NULL,
  `city` varchar(50) NOT NULL,
  `district` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 傾印資料表的資料 `taiwan_regions`
--

INSERT INTO `taiwan_regions` (`zipcode`, `city`, `district`) VALUES
('400', '台中市', '中區'),
('420', '台中市', '丰原區'),
('404', '台中市', '北區'),
('406', '台中市', '北屯區'),
('402', '台中市', '南區'),
('408', '台中市', '南屯區'),
('421', '台中市', '后里區'),
('424', '台中市', '和平區'),
('438', '台中市', '外埔區'),
('439', '台中市', '大安區'),
('437', '台中市', '大甲區'),
('432', '台中市', '大肚區'),
('412', '台中市', '大里區'),
('428', '台中市', '大雅區'),
('411', '台中市', '太平區'),
('426', '台中市', '新社區'),
('423', '台中市', '東勢區'),
('401', '台中市', '東區'),
('435', '台中市', '梧棲區'),
('434', '台中市', '沙鹿區'),
('436', '台中市', '清水區'),
('427', '台中市', '潭子區'),
('414', '台中市', '烏日區'),
('422', '台中市', '石岡區'),
('429', '台中市', '神岡區'),
('403', '台中市', '西區'),
('407', '台中市', '西屯區'),
('413', '台中市', '霧峰區'),
('433', '台中市', '龍井區'),
('104', '台北市', '中山區'),
('100', '台北市', '中正區'),
('110', '台北市', '信義區'),
('114', '台北市', '內湖區'),
('112', '台北市', '北投區'),
('115', '台北市', '南港區'),
('111', '台北市', '士林區'),
('103', '台北市', '大同區'),
('106', '台北市', '大安區'),
('116', '台北市', '文山區'),
('105', '台北市', '松山區'),
('108', '台北市', '萬華區'),
('237', '新北市', '三峽區'),
('252', '新北市', '三芝區'),
('241', '新北市', '三重區'),
('235', '新北市', '中和區'),
('244', '新北市', '五股區'),
('248', '新北市', '八里區'),
('236', '新北市', '土城區'),
('232', '新北市', '坪林區'),
('226', '新北市', '平溪區'),
('231', '新北市', '新店區'),
('242', '新北市', '新莊區'),
('220', '新北市', '板橋區'),
('249', '新北市', '林口區'),
('238', '新北市', '樹林區'),
('234', '新北市', '永和區'),
('221', '新北市', '汐止區'),
('243', '新北市', '泰山區'),
('251', '新北市', '淡水區'),
('222', '新北市', '深坑區'),
('233', '新北市', '烏來區'),
('224', '新北市', '瑞芳區'),
('223', '新北市', '石碇區'),
('253', '新北市', '石門區'),
('207', '新北市', '萬里區'),
('247', '新北市', '蘆洲區'),
('228', '新北市', '貢寮區'),
('208', '新北市', '金山區'),
('227', '新北市', '雙溪區'),
('239', '新北市', '鶯歌區'),
('320', '桃園市', '中壢區'),
('334', '桃園市', '八德區'),
('337', '桃園市', '大園區'),
('335', '桃園市', '大溪區'),
('324', '桃園市', '平鎮區'),
('336', '桃園市', '復興區'),
('327', '桃園市', '新屋區'),
('330', '桃園市', '桃園區'),
('326', '桃園市', '楊梅區'),
('338', '桃園市', '蘆竹區'),
('328', '桃園市', '觀音區'),
('325', '桃園市', '龍潭區'),
('333', '桃園市', '龜山區');

-- --------------------------------------------------------

--
-- 資料表結構 `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `role` enum('user','admin') NOT NULL DEFAULT 'user',
  `name` varchar(100) NOT NULL,
  `credit_point` int(11) NOT NULL DEFAULT 100,
  `phone` varchar(20) DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `gender` enum('男','女','其他','不願透漏') NOT NULL,
  `avatar_url` varchar(255) DEFAULT NULL COMMENT '頭貼網址',
  `bio` text DEFAULT NULL COMMENT '個人簡介',
  `password` varchar(255) NOT NULL,
  `line_id` varchar(50) DEFAULT NULL COMMENT 'LINE ID',
  `instagram` varchar(50) DEFAULT NULL COMMENT 'Instagram 帳號',
  `email` varchar(255) DEFAULT NULL COMMENT '電子郵件',
  `last_credit_update` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- 資料表結構 `user_sport_levels`
--

CREATE TABLE `user_sport_levels` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `sport_id` int(11) NOT NULL,
  `level` enum('C','B','A','S') NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- 資料表結構 `venues`
--

CREATE TABLE `venues` (
  `venue_id` int(11) NOT NULL,
  `address_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `opening_hours` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`opening_hours`)),
  `types` enum('indoor','outdoor','semi-outdoor') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 傾印資料表的資料 `venues`
--

INSERT INTO `venues` (`venue_id`, `address_id`, `name`, `opening_hours`, `types`) VALUES
(1, 1, '幸福國中籃球場', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null}]}', NULL),
(2, 2, '南美國小田徑場', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null}]}', NULL),
(3, 3, '長庚大學體育館', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"08:30\",\"end\":\"21:30\",\"is_closed\":true,\"note\":\"平日8：30～21：30為學生體育課程及運動訓練使用時間，不對外開放，假日可申請租用。\"},{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"08:30\",\"end\":\"21:30\",\"is_closed\":true,\"note\":\"平日8：30～21：30為學生體育課程及運動訓練時間，不對外開放，假日可申請租用。\"},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"08:30\",\"end\":\"21:30\",\"is_closed\":false,\"note\":\"平日8：30～21：30為學生體育課程及運動訓練使用時間，不對外開放，假日可申請租用。\"},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"08:30\",\"end\":\"21:30\",\"is_closed\":false,\"note\":\"平日8：30～21：30為學生體育課程及運動訓練時間，不對外開放，假日可申請租用。\"}]}', NULL),
(4, 4, '迴龍國中小體育館', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null}]}', NULL),
(5, 3, '長庚大學羽球室', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"08:30\",\"end\":\"21:30\",\"is_closed\":true,\"note\":\"平日8：30～21：30為體育教學及課餘活動使用時段，故不對外開放。\"},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"08:30\",\"end\":\"21:30\",\"is_closed\":false,\"note\":null}]}', NULL),
(6, 5, '壽山高中活動中心', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null}]}', NULL),
(7, 6, '體育大學綜合體育館', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":true,\"note\":\"週一至週五為全日及週六上午為教學使用，故不對外開放， 辦理大型活動除外，春節及休館時間配合活動調整。\"},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":true,\"note\":\"週一至週五為全日及週六上午為教學使用，故不對外開放， 辦理大型活動除外，春節及休館時間配合活動調整。\"}]}', NULL),
(8, 7, '光啟高中田徑場', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"07:30\",\"end\":\"17:00\",\"is_closed\":true,\"note\":\"平日07:30-1700.18:30-22:30為學生上課時間，故不對外開放。\"},{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"07:30\",\"end\":\"17:00\",\"is_closed\":true,\"note\":\"平日07:30-17:00.18:30-22:30為學生上課時間，故不對外開放。\"},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"07:30\",\"end\":\"17:00\",\"is_closed\":false,\"note\":\"平日07:30-1700.18:30-22:30為學生上課時間，故不對外開放。\"},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"07:30\",\"end\":\"17:00\",\"is_closed\":false,\"note\":\"平日07:30-17:00.18:30-22:30為學生上課時間，故不對外開放。\"}]}', NULL),
(9, 8, '籃球場館', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null}]}', NULL),
(10, 9, '龍華科技大學學生活動中心', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null}]}', NULL),
(11, 3, '長庚大學排球場', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":true,\"note\":\"平日為體育教學及學生活動時段，不對外開放，假日可申請租借。\"},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":\"平日為體育教學及學生活動時段，不對外開放，假日可申請租借。\"}]}', NULL),
(12, 3, '長庚大學薄膜球場', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"08:30\",\"end\":\"21:30\",\"is_closed\":false,\"note\":\"平日8：30～21：30為體育教學及活動時段，本校師生免費使用，假日則申請租借。\"},{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"08:30\",\"end\":\"21:30\",\"is_closed\":false,\"note\":\"平日8：30～21：30為體育教學及活動時段，本校師生免費使用，假日則申請租借用。\"},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"08:30\",\"end\":\"21:30\",\"is_closed\":false,\"note\":\"平日8：30～21：30為體育教學及活動時段，本校師生免費使用，假日則申請租借。\"},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"08:30\",\"end\":\"21:30\",\"is_closed\":false,\"note\":\"平日8：30～21：30為體育教學及活動時段，本校師生免費使用，假日則申請租借用。\"}]}', NULL),
(13, 3, '長庚大學籃球場', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":true,\"note\":\"平日為本校師生體育教學及課餘活動時間，不對外開放，假日得申請租借。\"},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":true,\"note\":\"平日為本校師生體育教學及課餘活動時間，不對外開放，假日得申請租借。\"}]}', NULL),
(14, 10, '龜山國小中正堂', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null}]}', NULL),
(15, 11, '新路國小籃球場', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"16:00\",\"end\":\"18:30\",\"is_closed\":false,\"note\":\"開放時間說明： 平日16:00~18:30 假日06:30~18:30\"},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"06:30\",\"end\":\"18:30\",\"is_closed\":false,\"note\":\"開放時間說明： 平日16:00~18:30 假日06:30~18:30\"}]}', NULL),
(16, 12, '銘傳大學體育二館', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":true,\"note\":\"除寒暑假外，休假日及國定假日開放，平日上課期間，不對外開放。\"},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":\"除寒暑假外，休假日及國定假日開放，平日上課期間，不對外開放。\"},{\"day_type\":\"specific_date\",\"specific_date\":null,\"start\":null,\"end\":null,\"is_closed\":false,\"note\":\"除寒暑假外，休假日及國定假日開放，平日上課期間，不對外開放。\"}]}', NULL),
(17, 12, '銘傳大學體育一館', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":true,\"note\":\"除寒暑假外，休假日及國定假日開放，平日上課期間，不對外開放。\"},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":\"除寒暑假外，休假日及國定假日開放，平日上課期間，不對外開放。\"},{\"day_type\":\"specific_date\",\"specific_date\":null,\"start\":null,\"end\":null,\"is_closed\":false,\"note\":\"除寒暑假外，休假日及國定假日開放，平日上課期間，不對外開放。\"}]}', NULL),
(18, 12, '銘傳大學室外籃球場', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":true,\"note\":\"除寒暑假外，休假日及國定假日開放，平日上課期間，不對外開放。\"},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":\"除寒暑假外，休假日及國定假日開放，平日上課期間，不對外開放。\"},{\"day_type\":\"specific_date\",\"specific_date\":null,\"start\":null,\"end\":null,\"is_closed\":false,\"note\":\"除寒暑假外，休假日及國定假日開放，平日上課期間，不對外開放。\"}]}', NULL),
(19, 13, '大湖國小籃球場(新)', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":null,\"end\":null,\"is_closed\":false,\"note\":\"例假日開放時間:8:00~19:00\"},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"08:00\",\"end\":\"19:00\",\"is_closed\":false,\"note\":\"例假日開放時間:8:00~19:00\"}]}', NULL),
(20, 14, '幸福國小學生活動中心', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":\"以學校活動為優先\"},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":\"以學校活動為優先\"}]}', NULL),
(21, 15, '福源國小籃球場', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"16:00\",\"end\":\"18:00\",\"is_closed\":false,\"note\":\"開放時間週一到週五16:00-18:00，週六週日8:00-18:00。\"},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"08:00\",\"end\":\"18:00\",\"is_closed\":false,\"note\":\"開放時間週一到週五16:00-18:00，週六週日8:00-18:00。\"}]}', NULL),
(22, 14, '幸福國小操場', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":\"上課無法開放\"},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":\"上課無法開放\"}]}', NULL),
(23, 16, '龍壽國小田徑場', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"08:30\",\"end\":\"17:30\",\"is_closed\":true,\"note\":\"除寒暑假外，平日08:30~17:30為學生上課時間，故不對外開放。\"},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"08:30\",\"end\":\"17:30\",\"is_closed\":false,\"note\":\"除寒暑假外，平日08:30~17:30為學生上課時間，故不對外開放。\"}]}', NULL),
(24, 17, '大坑國小田徑場', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"07:30\",\"end\":\"16:30\",\"is_closed\":true,\"note\":\"除寒暑假外，平日07:30~16:30為學生上課時間，故不對外開放。\"},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"07:30\",\"end\":\"16:30\",\"is_closed\":false,\"note\":\"除寒暑假外，平日07:30~16:30為學生上課時間，故不對外開放。\"}]}', NULL),
(25, 17, '大坑國小活動中心', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"07:30\",\"end\":\"17:30\",\"is_closed\":true,\"note\":\"除寒暑假外，平日07:30~17:30為學生上課時間，故不對外開放。\"},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"07:30\",\"end\":\"17:30\",\"is_closed\":false,\"note\":\"除寒暑假外，平日07:30~17:30為學生上課時間，故不對外開放。\"}]}', NULL),
(26, 18, '文欣國小田徑場附設籃球場', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null}]}', NULL),
(27, 19, '楓樹國小籃球場', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null}]}', NULL),
(28, 20, '大崗國中田徑場、籃球場', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":\"如遇整修或天然災害時不對外開放\"},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":\"如遇整修或天然災害時不對外開放\"}]}', NULL),
(29, 13, '大湖國小籃球場', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"08:00\",\"end\":\"19:00\",\"is_closed\":false,\"note\":\"例假日為8:00~19:00，平日則放學後才開放。\"},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"08:00\",\"end\":\"19:00\",\"is_closed\":false,\"note\":\"例假日為8:00~19:00，平日則放學後才開放。\"}]}', NULL),
(30, 16, '龍壽國小活動中心', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null}]}', NULL),
(31, 21, '華美公園', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null}]}', NULL),
(32, 22, '中正公園籃球場 ', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null}]}', NULL),
(33, 23, '南崁溪河濱公園籃球場 ', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null}]}', NULL),
(34, 24, '第三運動公園', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null}]}', NULL),
(35, 25, '第二運動公園', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null}]}', NULL),
(36, 26, '大崗國小活動中心', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null}]}', NULL),
(37, 10, '籃球場(半場)', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null}]}', NULL),
(38, 27, '長庚國小活動中心', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null}]}', NULL),
(39, 6, '體育大學羽球場(館)', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"18:00\",\"end\":\"21:00\",\"is_closed\":true,\"note\":\"週一至週五平日時段為校內專長及教學使用，故不對外開放，夜間18:00至21:00，辦理活動除外。\"},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"18:00\",\"end\":\"21:00\",\"is_closed\":false,\"note\":null}]}', NULL),
(40, 28, '中央警察大學體育館', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null}]}', NULL),
(41, 29, '長庚科技大學體育館', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null}]}', NULL),
(42, 30, '宏德高商進修學校籃球場', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null}]}', NULL),
(43, 31, '迴龍活動中心前籃球場', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null}]}', NULL),
(44, 32, '文化公園', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null}]}', NULL),
(45, 33, '楓樹籃球場', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null}]}', NULL),
(46, 34, '大坪頂公園', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null}]}', NULL),
(47, 35, '廣六公園', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null}]}', NULL),
(48, 36, '樂善公園', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null}]}', NULL),
(49, 37, '迴龍加油站後', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null}]}', NULL),
(50, 38, '桃園市成功橋下運動暨休憩空間', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null}]}', NULL),
(51, 39, '龜山國中籃球場', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":null}]}', NULL),
(52, 40, '大三元麻將24hr棋牌會館-林口龜山店', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":\"全年24小時\"},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":\"全年24小時\"}]}', 'indoor'),
(53, 41, '我家相公-24H桌遊體驗館(龜山銘傳)', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":\"全年24小時\"},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":\"全年24小時\"}]}', 'indoor'),
(54, 42, '三加一自助麻將', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":\"全年24小時\"},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":\"全年24小時\"}]}', 'indoor'),
(55, 43, '雀特GPT 24H包廂式自助桌遊店', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":\"全年24小時\"},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":\"全年24小時\"}]}', 'indoor'),
(56, 44, '輔又贏棋牌館 龍華店', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":\"全年24小時\"},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":\"全年24小時\"}]}', 'indoor'),
(57, 45, '藝博棋牌社', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":\"全年24小時\"},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":\"全年24小時\"}]}', 'indoor'),
(58, 46, '東瀛WIN自助桌遊24H【棋牌|包廂|GAME】', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":\"全年24小時\"},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":\"全年24小時\"}]}', 'indoor'),
(59, 47, '銘傳棋牌會館', '{\"rules\":[{\"day_type\":\"weekday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":\"全年24小時\"},{\"day_type\":\"holiday\",\"specific_date\":null,\"start\":\"00:00\",\"end\":\"23:59\",\"is_closed\":false,\"note\":\"全年24小時\"}]}', 'indoor'),
(65, 48, '板橋體育館二館-測試', '{\"weekdays\": \"08:00-22:00\", \"weekends\": \"08:00-22:00\"}', 'indoor'),
(66, 48, '板橋體育館二館-測試', '{\"weekdays\": \"08:00-22:00\", \"weekends\": \"08:00-22:00\"}', 'indoor'),
(68, 48, '板橋體育館二館-測試', '{\"weekdays\": \"08:00-22:00\", \"weekends\": \"08:00-22:00\"}', 'indoor'),
(77, 54, 'Test Venue with Courts', NULL, 'indoor'),
(79, 56, '龜山運動中心', NULL, 'indoor');

-- --------------------------------------------------------

--
-- 資料表結構 `venue_facilities`
--

CREATE TABLE `venue_facilities` (
  `id` int(11) NOT NULL,
  `venue_id` int(11) NOT NULL,
  `facility_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- 傾印資料表的資料 `venue_facilities`
--

INSERT INTO `venue_facilities` (`id`, `venue_id`, `facility_id`) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 1),
(4, 3, 4),
(5, 4, 1),
(6, 5, 1),
(7, 5, 4),
(8, 6, 1),
(9, 7, 1),
(10, 8, 1),
(11, 9, 1),
(12, 10, 1),
(13, 11, 1),
(14, 11, 4),
(15, 12, 1),
(16, 12, 4),
(17, 13, 1),
(18, 13, 4),
(19, 14, 1),
(20, 15, 1),
(21, 15, 4),
(22, 16, 1),
(23, 17, 1),
(24, 17, 4),
(25, 18, 1),
(26, 19, 1),
(27, 20, 1),
(28, 21, 1),
(29, 21, 4),
(30, 23, 1),
(31, 26, 1),
(32, 26, 4),
(33, 27, 1),
(34, 27, 4),
(35, 28, 1),
(36, 28, 4),
(37, 29, 1),
(38, 30, 1),
(39, 36, 1),
(40, 36, 4),
(41, 39, 1),
(42, 41, 1),
(43, 41, 4),
(44, 50, 1),
(45, 51, 1),
(46, 51, 4),
(47, 52, 1),
(48, 52, 2),
(49, 52, 3),
(50, 53, 2),
(51, 53, 3),
(52, 55, 2),
(53, 55, 3),
(54, 56, 2),
(55, 56, 3),
(56, 57, 2),
(57, 57, 3),
(58, 58, 2),
(59, 58, 3),
(95, 77, 1),
(94, 77, 8),
(97, 79, 1),
(99, 79, 2),
(100, 79, 3),
(98, 79, 4);

--
-- 已傾印資料表的索引
--

--
-- 資料表索引 `address`
--
ALTER TABLE `address`
  ADD PRIMARY KEY (`address_id`);

--
-- 資料表索引 `announcements`
--
ALTER TABLE `announcements`
  ADD PRIMARY KEY (`announcement_id`);

--
-- 資料表索引 `blacklist`
--
ALTER TABLE `blacklist`
  ADD PRIMARY KEY (`blacklist_id`),
  ADD KEY `user_id` (`user_id`);

--
-- 資料表索引 `court`
--
ALTER TABLE `court`
  ADD PRIMARY KEY (`court_id`),
  ADD KEY `venue_id` (`venue_id`);

--
-- 資料表索引 `court_conflicts`
--
ALTER TABLE `court_conflicts`
  ADD PRIMARY KEY (`conflict_id`),
  ADD UNIQUE KEY `court_id_1` (`court_id_1`,`court_id_2`),
  ADD KEY `court_id_2` (`court_id_2`);

--
-- 資料表索引 `court_sports`
--
ALTER TABLE `court_sports`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `court_id_sport_id` (`court_id`,`sport_id`),
  ADD KEY `sport_id` (`sport_id`);

--
-- 資料表索引 `facilities`
--
ALTER TABLE `facilities`
  ADD PRIMARY KEY (`facility_id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- 資料表索引 `feedbacks`
--
ALTER TABLE `feedbacks`
  ADD PRIMARY KEY (`feedback_id`),
  ADD KEY `feedbacks_user_id_fk` (`user_id`);

--
-- 資料表索引 `feedback_types`
--
ALTER TABLE `feedback_types`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- 資料表索引 `gamesmatches`
--
ALTER TABLE `gamesmatches`
  ADD PRIMARY KEY (`game_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `sport_id` (`sport_id`),
  ADD KEY `court_id` (`court_id`);

--
-- 資料表索引 `game_bulletins`
--
ALTER TABLE `game_bulletins`
  ADD PRIMARY KEY (`bulletin_id`),
  ADD KEY `game_id` (`game_id`);

--
-- 資料表索引 `keep`
--
ALTER TABLE `keep`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id_game_id` (`user_id`,`game_id`),
  ADD KEY `game_id` (`game_id`);

--
-- 資料表索引 `match_participants`
--
ALTER TABLE `match_participants`
  ADD PRIMARY KEY (`list_id`),
  ADD UNIQUE KEY `game_id` (`game_id`,`user_id`),
  ADD KEY `user_id` (`user_id`);

--
-- 資料表索引 `notification`
--
ALTER TABLE `notification`
  ADD PRIMARY KEY (`notification_id`),
  ADD KEY `fk_notification_game` (`game_id`),
  ADD KEY `user_id` (`user_id`);

--
-- 資料表索引 `penalty_rules`
--
ALTER TABLE `penalty_rules`
  ADD PRIMARY KEY (`rule_id`),
  ADD UNIQUE KEY `reason` (`reason`);

--
-- 資料表索引 `reports`
--
ALTER TABLE `reports`
  ADD PRIMARY KEY (`report_id`),
  ADD UNIQUE KEY `game_id` (`game_id`,`reporter_id`,`offender_id`),
  ADD KEY `reporter_id` (`reporter_id`),
  ADD KEY `offender_id` (`offender_id`),
  ADD KEY `rule_id` (`rule_id`),
  ADD KEY `reviewed_by` (`reviewed_by`);

--
-- 資料表索引 `sports`
--
ALTER TABLE `sports`
  ADD PRIMARY KEY (`sport_id`),
  ADD UNIQUE KEY `sport_name` (`sport_name`);

--
-- 資料表索引 `taiwan_regions`
--
ALTER TABLE `taiwan_regions`
  ADD PRIMARY KEY (`zipcode`),
  ADD UNIQUE KEY `idx_city_district` (`city`,`district`);

--
-- 資料表索引 `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `phone` (`phone`);

--
-- 資料表索引 `user_sport_levels`
--
ALTER TABLE `user_sport_levels`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id_sport_id` (`user_id`,`sport_id`),
  ADD KEY `sport_id` (`sport_id`);

--
-- 資料表索引 `venues`
--
ALTER TABLE `venues`
  ADD PRIMARY KEY (`venue_id`),
  ADD KEY `address_id` (`address_id`);

--
-- 資料表索引 `venue_facilities`
--
ALTER TABLE `venue_facilities`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `venue_id_facility_id` (`venue_id`,`facility_id`),
  ADD KEY `facility_id` (`facility_id`);

--
-- 在傾印的資料表使用自動遞增(AUTO_INCREMENT)
--

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `address`
--
ALTER TABLE `address`
  MODIFY `address_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=58;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `announcements`
--
ALTER TABLE `announcements`
  MODIFY `announcement_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `blacklist`
--
ALTER TABLE `blacklist`
  MODIFY `blacklist_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `court`
--
ALTER TABLE `court`
  MODIFY `court_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=199;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `court_conflicts`
--
ALTER TABLE `court_conflicts`
  MODIFY `conflict_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `court_sports`
--
ALTER TABLE `court_sports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=288;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `facilities`
--
ALTER TABLE `facilities`
  MODIFY `facility_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `feedbacks`
--
ALTER TABLE `feedbacks`
  MODIFY `feedback_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `feedback_types`
--
ALTER TABLE `feedback_types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `gamesmatches`
--
ALTER TABLE `gamesmatches`
  MODIFY `game_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `game_bulletins`
--
ALTER TABLE `game_bulletins`
  MODIFY `bulletin_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `keep`
--
ALTER TABLE `keep`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `match_participants`
--
ALTER TABLE `match_participants`
  MODIFY `list_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `notification`
--
ALTER TABLE `notification`
  MODIFY `notification_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `penalty_rules`
--
ALTER TABLE `penalty_rules`
  MODIFY `rule_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `reports`
--
ALTER TABLE `reports`
  MODIFY `report_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `sports`
--
ALTER TABLE `sports`
  MODIFY `sport_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `user_sport_levels`
--
ALTER TABLE `user_sport_levels`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `venues`
--
ALTER TABLE `venues`
  MODIFY `venue_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=81;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `venue_facilities`
--
ALTER TABLE `venue_facilities`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=105;

--
-- 已傾印資料表的限制式
--

--
-- 資料表的限制式 `blacklist`
--
ALTER TABLE `blacklist`
  ADD CONSTRAINT `blacklist_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 資料表的限制式 `court`
--
ALTER TABLE `court`
  ADD CONSTRAINT `court_ibfk_1` FOREIGN KEY (`venue_id`) REFERENCES `venues` (`venue_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 資料表的限制式 `court_conflicts`
--
ALTER TABLE `court_conflicts`
  ADD CONSTRAINT `court_conflicts_ibfk_1` FOREIGN KEY (`court_id_1`) REFERENCES `court` (`court_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `court_conflicts_ibfk_2` FOREIGN KEY (`court_id_2`) REFERENCES `court` (`court_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 資料表的限制式 `court_sports`
--
ALTER TABLE `court_sports`
  ADD CONSTRAINT `court_sports_ibfk_1` FOREIGN KEY (`court_id`) REFERENCES `court` (`court_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `court_sports_ibfk_2` FOREIGN KEY (`sport_id`) REFERENCES `sports` (`sport_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 資料表的限制式 `feedbacks`
--
ALTER TABLE `feedbacks`
  ADD CONSTRAINT `feedbacks_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- 資料表的限制式 `gamesmatches`
--
ALTER TABLE `gamesmatches`
  ADD CONSTRAINT `gamesmatches_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `gamesmatches_ibfk_3` FOREIGN KEY (`sport_id`) REFERENCES `sports` (`sport_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `gamesmatches_ibfk_4` FOREIGN KEY (`court_id`) REFERENCES `court` (`court_id`);

--
-- 資料表的限制式 `game_bulletins`
--
ALTER TABLE `game_bulletins`
  ADD CONSTRAINT `game_bulletins_ibfk_1` FOREIGN KEY (`game_id`) REFERENCES `gamesmatches` (`game_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 資料表的限制式 `keep`
--
ALTER TABLE `keep`
  ADD CONSTRAINT `keep_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `keep_ibfk_2` FOREIGN KEY (`game_id`) REFERENCES `gamesmatches` (`game_id`);

--
-- 資料表的限制式 `match_participants`
--
ALTER TABLE `match_participants`
  ADD CONSTRAINT `match_participants_ibfk_1` FOREIGN KEY (`game_id`) REFERENCES `gamesmatches` (`game_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `match_participants_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 資料表的限制式 `notification`
--
ALTER TABLE `notification`
  ADD CONSTRAINT `fk_notification_game` FOREIGN KEY (`game_id`) REFERENCES `gamesmatches` (`game_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `notification_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- 資料表的限制式 `reports`
--
ALTER TABLE `reports`
  ADD CONSTRAINT `reports_ibfk_1` FOREIGN KEY (`game_id`) REFERENCES `gamesmatches` (`game_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `reports_ibfk_2` FOREIGN KEY (`reporter_id`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `reports_ibfk_3` FOREIGN KEY (`offender_id`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `reports_ibfk_4` FOREIGN KEY (`rule_id`) REFERENCES `penalty_rules` (`rule_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `reports_ibfk_5` FOREIGN KEY (`reviewed_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- 資料表的限制式 `user_sport_levels`
--
ALTER TABLE `user_sport_levels`
  ADD CONSTRAINT `user_sport_levels_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `user_sport_levels_ibfk_2` FOREIGN KEY (`sport_id`) REFERENCES `sports` (`sport_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 資料表的限制式 `venues`
--
ALTER TABLE `venues`
  ADD CONSTRAINT `venues_ibfk_1` FOREIGN KEY (`address_id`) REFERENCES `address` (`address_id`) ON UPDATE CASCADE;

--
-- 資料表的限制式 `venue_facilities`
--
ALTER TABLE `venue_facilities`
  ADD CONSTRAINT `venue_facilities_ibfk_1` FOREIGN KEY (`venue_id`) REFERENCES `venues` (`venue_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `venue_facilities_ibfk_2` FOREIGN KEY (`facility_id`) REFERENCES `facilities` (`facility_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
