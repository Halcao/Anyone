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

 Date: 12/21/2017 01:20:40 AM
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `user`
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `mac` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `default_name` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `master_id` int(10) unsigned DEFAULT NULL,
  `insert_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `master_id` (`master_id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
