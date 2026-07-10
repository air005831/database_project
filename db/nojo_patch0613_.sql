-- Patch for nojo_schema_and_data__DATE_.sql
-- 1) Normalize venues.opening_hours to {weekday, weekend, regular_off, special_off}.
-- 2) Drop venues.types.
-- 3) Drop address city/district/latitude/longitude.
-- 4) Remove facility_id=8 ?? and related mappings.

START TRANSACTION;

UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 1;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 2;
UPDATE `venues` SET `opening_hours` = '{"weekday":["08:30","21:30"],"weekend":["08:30","21:30"],"regular_off":["weekday"],"special_off":[]}' WHERE `venue_id` = 3;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 4;
UPDATE `venues` SET `opening_hours` = '{"weekday":["08:30","21:30"],"weekend":["08:30","21:30"],"regular_off":["weekday"],"special_off":[]}' WHERE `venue_id` = 5;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 6;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":["weekday","weekend"],"special_off":[]}' WHERE `venue_id` = 7;
UPDATE `venues` SET `opening_hours` = '{"weekday":["07:30","17:00"],"weekend":["07:30","17:00"],"regular_off":["weekday"],"special_off":[]}' WHERE `venue_id` = 8;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 9;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 10;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":["weekday"],"special_off":[]}' WHERE `venue_id` = 11;
UPDATE `venues` SET `opening_hours` = '{"weekday":["08:30","21:30"],"weekend":["08:30","21:30"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 12;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":["weekday","weekend"],"special_off":[]}' WHERE `venue_id` = 13;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 14;
UPDATE `venues` SET `opening_hours` = '{"weekday":["16:00","18:30"],"weekend":["06:30","18:30"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 15;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":["weekday"],"special_off":[]}' WHERE `venue_id` = 16;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":["weekday"],"special_off":[]}' WHERE `venue_id` = 17;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":["weekday"],"special_off":[]}' WHERE `venue_id` = 18;
UPDATE `venues` SET `opening_hours` = '{"weekday":["08:00","19:00"],"weekend":["08:00","19:00"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 19;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 20;
UPDATE `venues` SET `opening_hours` = '{"weekday":["16:00","18:00"],"weekend":["08:00","18:00"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 21;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 22;
UPDATE `venues` SET `opening_hours` = '{"weekday":["08:30","17:30"],"weekend":["08:30","17:30"],"regular_off":["weekday"],"special_off":[]}' WHERE `venue_id` = 23;
UPDATE `venues` SET `opening_hours` = '{"weekday":["07:30","16:30"],"weekend":["07:30","16:30"],"regular_off":["weekday"],"special_off":[]}' WHERE `venue_id` = 24;
UPDATE `venues` SET `opening_hours` = '{"weekday":["07:30","17:30"],"weekend":["07:30","17:30"],"regular_off":["weekday"],"special_off":[]}' WHERE `venue_id` = 25;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 26;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 27;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 28;
UPDATE `venues` SET `opening_hours` = '{"weekday":["08:00","19:00"],"weekend":["08:00","19:00"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 29;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 30;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 31;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 32;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 33;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 34;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 35;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 36;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 37;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 38;
UPDATE `venues` SET `opening_hours` = '{"weekday":["18:00","21:00"],"weekend":["18:00","21:00"],"regular_off":["weekday"],"special_off":[]}' WHERE `venue_id` = 39;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 40;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 41;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 42;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 43;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 44;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 45;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 46;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 47;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 48;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 49;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 50;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 51;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 52;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 53;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 54;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 55;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 56;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 57;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 58;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 59;
UPDATE `venues` SET `opening_hours` = '{"weekday":["08:00","22:00"],"weekend":["08:00","22:00"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 65;
UPDATE `venues` SET `opening_hours` = '{"weekday":["08:00","22:00"],"weekend":["08:00","22:00"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 66;
UPDATE `venues` SET `opening_hours` = '{"weekday":["08:00","22:00"],"weekend":["08:00","22:00"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 68;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 77;
UPDATE `venues` SET `opening_hours` = '{"weekday":["00:00","23:59"],"weekend":["00:00","23:59"],"regular_off":[],"special_off":[]}' WHERE `venue_id` = 79;

-- Remove duplicated facility: ?? (facility_id=8), keeping ??? (facility_id=2).
DELETE FROM `venue_facilities` WHERE `facility_id` = 8;
DELETE FROM `facilities` WHERE `facility_id` = 8;

-- Drop venue type column. Actual column name in this dump is `types`.
ALTER TABLE `venues` DROP COLUMN `types`;

-- Remove address city/district and latitude/longitude columns.
ALTER TABLE `address`
  DROP COLUMN `city`,
  DROP COLUMN `district`,
  DROP COLUMN `latitude`,
  DROP COLUMN `longitude`;

COMMIT;
