/*
 Navicat Premium Data Transfer

 Source Server         : anyone
 Source Server Type    : MySQL
 Source Server Version : 50717
 Source Host           : 107.170.252.172
 Source Database       : anyone

 Target Server Type    : MySQL
 Target Server Version : 50717
 File Encoding         : utf-8

 Date: 12/21/2017 01:20:33 AM
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `status`
-- ----------------------------
DROP TABLE IF EXISTS `status`;
CREATE TABLE `status` (
  `id` int(10) NOT NULL,
  `is_present` tinyint(1) NOT NULL,
  `ip` varchar(40) DEFAULT NULL,
  `update_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

SET FOREIGN_KEY_CHECKS = 1;
