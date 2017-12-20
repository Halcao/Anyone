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

 Date: 12/21/2017 01:20:18 AM
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `log`
-- ----------------------------
DROP TABLE IF EXISTS `log`;
CREATE TABLE `log` (
  `log_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id` int(10) NOT NULL,
  `action` varchar(10) DEFAULT NULL,
  `time` datetime DEFAULT NULL,
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB AUTO_INCREMENT=200 DEFAULT CHARSET=utf8;

SET FOREIGN_KEY_CHECKS = 1;
