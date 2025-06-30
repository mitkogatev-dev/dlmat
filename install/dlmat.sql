-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jun 30, 2025 at 07:30 AM
-- Server version: 10.11.9-MariaDB
-- PHP Version: 8.3.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dlmat`
--

-- --------------------------------------------------------

--
-- Table structure for table `devices`
--

CREATE TABLE `devices` (
  `device_id` int(11) NOT NULL,
  `device_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `i2i`
--

CREATE TABLE `i2i` (
  `int_a` int(11) NOT NULL,
  `int_b` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `interfaces`
--

CREATE TABLE `interfaces` (
  `interface_id` int(11) NOT NULL,
  `device_id` int(11) NOT NULL,
  `interface_number` int(11) NOT NULL,
  `interface_name` varchar(255) NOT NULL,
  `interface_type` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `interface_types`
--

CREATE TABLE `interface_types` (
  `interface_type_id` int(11) NOT NULL,
  `interface_type_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `interface_types`
--

INSERT INTO `interface_types` (`interface_type_id`, `interface_type_name`) VALUES
(1, 'Physical'),
(2, 'Wireless'),
(3, 'Virtual');

-- --------------------------------------------------------

--
-- Table structure for table `virtual_members`
--

CREATE TABLE `virtual_members` (
  `virtual_id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `devices`
--
ALTER TABLE `devices`
  ADD PRIMARY KEY (`device_id`);

--
-- Indexes for table `i2i`
--
ALTER TABLE `i2i`
  ADD KEY `int_a` (`int_a`),
  ADD KEY `int_b` (`int_b`);

--
-- Indexes for table `interfaces`
--
ALTER TABLE `interfaces`
  ADD PRIMARY KEY (`interface_id`),
  ADD KEY `device_id` (`device_id`);

--
-- Indexes for table `interface_types`
--
ALTER TABLE `interface_types`
  ADD PRIMARY KEY (`interface_type_id`);

--
-- Indexes for table `virtual_members`
--
ALTER TABLE `virtual_members`
  ADD KEY `virtual_id` (`virtual_id`),
  ADD KEY `member_id` (`member_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `devices`
--
ALTER TABLE `devices`
  MODIFY `device_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `interfaces`
--
ALTER TABLE `interfaces`
  MODIFY `interface_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `interface_types`
--
ALTER TABLE `interface_types`
  MODIFY `interface_type_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `i2i`
--
ALTER TABLE `i2i`
  ADD CONSTRAINT `i2i_ibfk_1` FOREIGN KEY (`int_a`) REFERENCES `interfaces` (`interface_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `i2i_ibfk_2` FOREIGN KEY (`int_b`) REFERENCES `interfaces` (`interface_id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `interfaces`
--
ALTER TABLE `interfaces`
  ADD CONSTRAINT `interfaces_ibfk_1` FOREIGN KEY (`device_id`) REFERENCES `devices` (`device_id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `virtual_members`
--
ALTER TABLE `virtual_members`
  ADD CONSTRAINT `virtual_members_ibfk_1` FOREIGN KEY (`virtual_id`) REFERENCES `interfaces` (`interface_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `virtual_members_ibfk_2` FOREIGN KEY (`member_id`) REFERENCES `interfaces` (`interface_id`) ON DELETE CASCADE ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
