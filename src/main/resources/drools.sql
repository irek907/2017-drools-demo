/*
Navicat MySQL Data Transfer

Source Server         : 本地连接
Source Server Version : 50527
Source Host           : localhost:3306
Source Database       : drools

Target Server Type    : MYSQL
Target Server Version : 50527
File Encoding         : 65001

Date: 2017-05-03 17:33:27
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `tb_rule`
-- ----------------------------
DROP TABLE IF EXISTS `tb_rule`;
CREATE TABLE `tb_rule` (
  `r_name` varchar(32) NOT NULL DEFAULT '',
  `r_content` blob,
  PRIMARY KEY (`r_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tb_rule
-- ----------------------------
INSERT INTO `tb_rule` VALUES ('my_rule', 0x7061636B61676520636F6D2E6665692E64726F6F6C730A696D706F727420636F6D2E6D79686578696E2E7765622E4D657373616765323B0A72756C65202272756C6531220A097768656E0A4D657373616765322820737461747573203D3D20312C206D794D657373616765203A206D73672029097468656E0A090953797374656D2E6F75742E7072696E746C6E2820312B223A222B6D794D65737361676520293B0A0A200A0A656E640A0A0A72756C65202272756C6532220A097768656E0A4D657373616765322820737461747573203D3D20322C206D794D657373616765203A206D73672029097468656E0A090953797374656D2E6F75742E7072696E746C6E2820322B223A222B6D794D65737361676520293B0A0A200A0A656E640A0A72756C65202272756C6533220A097768656E0A4D657373616765322820737461747573203D3D20332C206D794D657373616765203A206D73672029097468656E0A090953797374656D2E6F75742E7072696E746C6E2820332B223A222B6D794D65737361676520293B0A0A200A0A656E64);