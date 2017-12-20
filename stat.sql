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

 Date: 12/21/2017 01:20:27 AM
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `stat`
-- ----------------------------
DROP TABLE IF EXISTS `stat`;
CREATE TABLE `stat` (
  `id` int(10) DEFAULT NULL,
  `week_time` int(11) DEFAULT NULL,
  `total_time` int(11) DEFAULT NULL,
  `update_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

SET FOREIGN_KEY_CHECKS = 1;
