-- Migration only: move venue coordinates to address and remove redundant street prefix.
-- Run this once after your current schema/data has been imported.

ALTER TABLE `address`
  ADD COLUMN `latitude` decimal(10,8) DEFAULT NULL COMMENT '地址緯度' AFTER `street_line`,
  ADD COLUMN `longitude` decimal(11,8) DEFAULT NULL COMMENT '地址經度' AFTER `latitude`;

-- Some venues shared the same address_id but had different coordinates.
-- Split those into separate address rows so no coordinate data is lost.
INSERT INTO `address` (`address_id`, `city`, `district`, `street_line`, `latitude`, `longitude`) VALUES
(48, '桃園市', '龜山區', '文化一路259號', 25.03261162, 121.39042000),
(49, '桃園市', '龜山區', '文化一路259號', 25.03510407, 121.39067210),
(50, '桃園市', '龜山區', '文化一路259號', 25.03245065, 121.39004660),
(51, '桃園市', '龜山區', '文化一路259號', 25.03308754, 121.39214190),
(52, '桃園市', '龜山區', '大同村德明路5號', 24.98413081, 121.34231510),
(53, '桃園市', '龜山區', '大同村德明路5號', 24.98369951, 121.34292390),
(54, '桃園市', '龜山區', '頂興路115巷20號', 24.98879064, 121.33070110),
(55, '桃園市', '龜山區', '大坑路一段850號', 25.04450056, 121.31474780),
(56, '桃園市', '龜山區', '大湖村文三二街80號', 25.05733906, 121.35879990),
(57, '桃園市', '龜山區', '龍壽村龍校街30號', 25.01096053, 121.38805750),
(58, '桃園市', '龜山區', '萬壽路二段933巷14號', 24.99407580, 121.34095520),
(59, '桃園市', '龜山區', '文化一路250號', 25.03047256, 121.38761760);

UPDATE `venues`
SET `address_id` = CASE `venue_id`
  WHEN 5 THEN 48
  WHEN 11 THEN 49
  WHEN 12 THEN 50
  WHEN 13 THEN 51
  WHEN 17 THEN 52
  WHEN 18 THEN 53
  WHEN 22 THEN 54
  WHEN 25 THEN 55
  WHEN 29 THEN 56
  WHEN 30 THEN 57
  WHEN 37 THEN 58
  WHEN 39 THEN 59
  ELSE `address_id`
END
WHERE `venue_id` IN (5, 11, 12, 13, 17, 18, 22, 25, 29, 30, 37, 39);

UPDATE `address` AS a
JOIN `venues` AS v ON v.`address_id` = a.`address_id`
SET
  a.`latitude` = v.`latitude`,
  a.`longitude` = v.`longitude`;

UPDATE `address`
SET `street_line` = CASE
  WHEN `street_line` LIKE '桃園市龜山區%' THEN SUBSTRING(`street_line`, CHAR_LENGTH('桃園市龜山區') + 1)
  ELSE REPLACE(`street_line`, '桃園市龜山區', '')
END;

ALTER TABLE `venues`
  DROP COLUMN `latitude`,
  DROP COLUMN `longitude`;
