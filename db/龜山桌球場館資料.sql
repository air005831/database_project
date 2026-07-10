-- Generated from 龜山運動場館.csv
-- Adds Table Tennis venues/courts after previous ball + Mahjong data.
-- sports: 5=TableTennis
-- facilities: 1=停車場, 4=無障礙停車場
-- Court counts: explicit intro count is used when available; otherwise a random 7-12 count was assigned.
SET NAMES utf8mb4;
START TRANSACTION;

-- Add TableTennis sport if this database is still at AUTO_INCREMENT=5.
INSERT INTO `sports` (`sport_id`, `sport_name`)
SELECT 5, 'TableTennis'
WHERE NOT EXISTS (SELECT 1 FROM sports WHERE sport_id = 5 OR sport_name = 'TableTennis');

-- venue_id 9: 籃球場館, table_tennis_courts=8, first_court_id=139, last_court_id=146, court_ref=桌球場(館), category=桌球場(館)
-- venue_id 10: 龍華科技大學學生活動中心, table_tennis_courts=10, first_court_id=147, last_court_id=156, court_ref=桌球場(館), category=桌球場(館)
-- venue_id 60: 長庚大學桌球室, table_tennis_courts=14, first_court_id=157, last_court_id=170, court_ref=桌球室, category=桌球室
-- venue_id 17: 銘傳大學體育一館, table_tennis_courts=9, first_court_id=171, last_court_id=179, court_ref=桌球場(館), category=桌球場(館)
-- venue_id 61: 文欣國小樂活教室, table_tennis_courts=7, first_court_id=180, last_court_id=186, court_ref=桌球場(館), category=桌球場(館)

-- Append table-tennis opening data to venues that already exist.
UPDATE `venues` SET `opening_hours` = JSON_ARRAY_APPEND(`opening_hours`, '$.opening', JSON_OBJECT('days', NULL, 'time', NULL, 'category', '桌球場(館)', 'court_ref', '桌球場(館)', 'court_count', 8)) WHERE `venue_id` = 9;
UPDATE `venues` SET `opening_hours` = JSON_ARRAY_APPEND(`opening_hours`, '$.opening', JSON_OBJECT('days', NULL, 'time', NULL, 'category', '桌球場(館)', 'court_ref', '桌球場(館)', 'court_count', 10)) WHERE `venue_id` = 10;
UPDATE `venues` SET `opening_hours` = JSON_ARRAY_APPEND(`opening_hours`, '$.opening', JSON_OBJECT('days', '星期一、星期二、星期三、星期四、星期五、星期六、星期日', 'time', '除寒暑假外，休假日及國定假日開放，平日上課期間，不對外開放。', 'category', '桌球場(館)', 'court_ref', '桌球場(館)', 'court_count', 9)) WHERE `venue_id` = 17;

-- New table-tennis-only venues. Existing address_id values are reused.
INSERT INTO `venues` (`venue_id`, `address_id`, `name`, `opening_hours`, `types`, `latitude`, `longitude`) VALUES
(60, 3, '長庚大學桌球室', '{"opening":[{"days":"星期六、星期日","time":"平日屬體育教學時段，不對外開放，假日得申請租借。","category":"桌球室","court_ref":"桌球室","court_count":14}]}', NULL, '25.03265479', '121.39035770'),
(61, 18, '文欣國小樂活教室', '{"opening":[{"days":null,"time":null,"category":"桌球場(館)","court_ref":"桌球場(館)","court_count":7}]}', NULL, '25.05737064', '121.37205000');

-- court: one row per assigned table-tennis court.
INSERT INTO `court` (`court_id`, `venue_id`, `occupied`, `base_price`) VALUES
(139, 9, 0, NULL),
(140, 9, 0, NULL),
(141, 9, 0, NULL),
(142, 9, 0, NULL),
(143, 9, 0, NULL),
(144, 9, 0, NULL),
(145, 9, 0, NULL),
(146, 9, 0, NULL),
(147, 10, 0, NULL),
(148, 10, 0, NULL),
(149, 10, 0, NULL),
(150, 10, 0, NULL),
(151, 10, 0, NULL),
(152, 10, 0, NULL),
(153, 10, 0, NULL),
(154, 10, 0, NULL),
(155, 10, 0, NULL),
(156, 10, 0, NULL),
(157, 60, 0, NULL),
(158, 60, 0, NULL),
(159, 60, 0, NULL),
(160, 60, 0, NULL),
(161, 60, 0, NULL),
(162, 60, 0, NULL),
(163, 60, 0, NULL),
(164, 60, 0, NULL),
(165, 60, 0, NULL),
(166, 60, 0, NULL),
(167, 60, 0, NULL),
(168, 60, 0, NULL),
(169, 60, 0, NULL),
(170, 60, 0, NULL),
(171, 17, 0, NULL),
(172, 17, 0, NULL),
(173, 17, 0, NULL),
(174, 17, 0, NULL),
(175, 17, 0, NULL),
(176, 17, 0, NULL),
(177, 17, 0, NULL),
(178, 17, 0, NULL),
(179, 17, 0, NULL),
(180, 61, 0, NULL),
(181, 61, 0, NULL),
(182, 61, 0, NULL),
(183, 61, 0, NULL),
(184, 61, 0, NULL),
(185, 61, 0, NULL),
(186, 61, 0, NULL);

-- court_sports
INSERT INTO `court_sports` (`court_id`, `sport_id`) VALUES
(139, 5),
(140, 5),
(141, 5),
(142, 5),
(143, 5),
(144, 5),
(145, 5),
(146, 5),
(147, 5),
(148, 5),
(149, 5),
(150, 5),
(151, 5),
(152, 5),
(153, 5),
(154, 5),
(155, 5),
(156, 5),
(157, 5),
(158, 5),
(159, 5),
(160, 5),
(161, 5),
(162, 5),
(163, 5),
(164, 5),
(165, 5),
(166, 5),
(167, 5),
(168, 5),
(169, 5),
(170, 5),
(171, 5),
(172, 5),
(173, 5),
(174, 5),
(175, 5),
(176, 5),
(177, 5),
(178, 5),
(179, 5),
(180, 5),
(181, 5),
(182, 5),
(183, 5),
(184, 5),
(185, 5),
(186, 5);

-- venue_facilities
INSERT IGNORE INTO `venue_facilities` (`venue_id`, `facility_id`) VALUES
(9, 1),
(10, 1),
(60, 1),
(60, 4),
(17, 1),
(17, 4),
(61, 1),
(61, 4);

-- Keep AUTO_INCREMENT values ahead of the inserted explicit IDs.
ALTER TABLE `sports` AUTO_INCREMENT = 6;
ALTER TABLE `venues` AUTO_INCREMENT = 62;
ALTER TABLE `court` AUTO_INCREMENT = 187;

COMMIT;
