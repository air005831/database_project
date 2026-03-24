-- phpMyAdmin SQL Dump
-- version 4.6.6
-- https://www.phpmyadmin.net/
--
-- 主機: localhost
-- 產生時間： 2026-03-24 10:54:37
-- 伺服器版本: 5.7.17-log
-- PHP 版本： 5.6.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 資料庫： `university`
--

-- --------------------------------------------------------

--
-- 資料表結構 `course`
--

CREATE TABLE `course` (
  `CourseNo` char(6) NOT NULL,
  `CrsDesc` varchar(250) NOT NULL,
  `CrsUnits` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `enrollment`
--

CREATE TABLE `enrollment` (
  `OfferNo` int(11) NOT NULL,
  `StdSSN` char(11) NOT NULL,
  `EnrGrade` decimal(3,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `faculty`
--

CREATE TABLE `faculty` (
  `FacSSN` char(11) NOT NULL,
  `FacFirstName` varchar(50) NOT NULL,
  `FacLastName` varchar(50) NOT NULL,
  `FacCity` varchar(50) NOT NULL,
  `FacState` char(2) NOT NULL,
  `FacZipCode` char(10) NOT NULL,
  `FacHireDate` date DEFAULT NULL,
  `FacDept` char(6) DEFAULT NULL,
  `FacRank` char(4) DEFAULT NULL,
  `FacSalary` decimal(10,2) DEFAULT NULL,
  `FacSupervisor` char(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `offering`
--

CREATE TABLE `offering` (
  `OfferNo` int(11) NOT NULL,
  `CourseNo` char(6) NOT NULL,
  `OffLocation` varchar(50) DEFAULT NULL,
  `OffDays` char(6) DEFAULT NULL,
  `OffTerm` char(6) NOT NULL,
  `OffYear` int(11) NOT NULL,
  `FacSSN` char(11) DEFAULT NULL,
  `OffTime` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `student`
--

CREATE TABLE `student` (
  `StdSSN` char(11) NOT NULL,
  `StdFirstName` varchar(50) NOT NULL,
  `StdLastName` varchar(50) NOT NULL,
  `StdCity` varchar(50) NOT NULL,
  `StdState` char(2) NOT NULL,
  `StdZip` char(10) NOT NULL,
  `StdMajor` char(6) DEFAULT NULL,
  `StdClass` char(2) DEFAULT NULL,
  `StdGPA` decimal(3,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 已匯出資料表的索引
--

--
-- 資料表索引 `course`
--
ALTER TABLE `course`
  ADD PRIMARY KEY (`CourseNo`),
  ADD UNIQUE KEY `CrsDesc` (`CrsDesc`);

--
-- 資料表索引 `enrollment`
--
ALTER TABLE `enrollment`
  ADD PRIMARY KEY (`OfferNo`,`StdSSN`),
  ADD KEY `StdSSN` (`StdSSN`);

--
-- 資料表索引 `faculty`
--
ALTER TABLE `faculty`
  ADD PRIMARY KEY (`FacSSN`),
  ADD KEY `FacSupervisor` (`FacSupervisor`);

--
-- 資料表索引 `offering`
--
ALTER TABLE `offering`
  ADD PRIMARY KEY (`OfferNo`),
  ADD KEY `CourseNo` (`CourseNo`),
  ADD KEY `FacSSN` (`FacSSN`);

--
-- 資料表索引 `student`
--
ALTER TABLE `student`
  ADD PRIMARY KEY (`StdSSN`);

--
-- 已匯出資料表的限制(Constraint)
--

--
-- 資料表的 Constraints `enrollment`
--
ALTER TABLE `enrollment`
  ADD CONSTRAINT `enrollment_ibfk_1` FOREIGN KEY (`OfferNo`) REFERENCES `offering` (`OfferNo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `enrollment_ibfk_2` FOREIGN KEY (`StdSSN`) REFERENCES `student` (`StdSSN`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 資料表的 Constraints `faculty`
--
ALTER TABLE `faculty`
  ADD CONSTRAINT `faculty_ibfk_1` FOREIGN KEY (`FacSupervisor`) REFERENCES `faculty` (`FacSSN`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- 資料表的 Constraints `offering`
--
ALTER TABLE `offering`
  ADD CONSTRAINT `offering_ibfk_1` FOREIGN KEY (`CourseNo`) REFERENCES `course` (`CourseNo`),
  ADD CONSTRAINT `offering_ibfk_2` FOREIGN KEY (`FacSSN`) REFERENCES `faculty` (`FacSSN`) ON DELETE SET NULL ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
