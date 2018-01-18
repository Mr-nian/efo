-- MySQL Script generated by MySQL Workbench
-- Thu Jan 18 13:31:41 2018
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema efo
-- -----------------------------------------------------
-- 线上文件管理系统
DROP SCHEMA IF EXISTS `efo` ;

-- -----------------------------------------------------
-- Schema efo
--
-- 线上文件管理系统
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `efo` DEFAULT CHARACTER SET utf8 ;
USE `efo` ;

-- -----------------------------------------------------
-- Table `efo`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `efo`.`user` ;

CREATE TABLE IF NOT EXISTS `efo`.`user` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '用户编号',
  `username` VARCHAR(16) NOT NULL DEFAULT '' COMMENT '用户名',
  `real_name` VARCHAR(45) NULL DEFAULT '' COMMENT '真实姓名',
  `email` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '邮箱地址',
  `password` VARCHAR(128) NOT NULL DEFAULT '' COMMENT '登录密码',
  `permission` INT NOT NULL DEFAULT 1 COMMENT '0（禁止登录），1（正常，普通用户），2（正常，管理员），3（正常，超级管理员）',
  `create_time` DATETIME NOT NULL DEFAULT current_timestamp COMMENT '注册时间',
  `last_login_time` DATETIME NOT NULL DEFAULT current_timestamp COMMENT '最后一次登录时间',
  `is_downloadable` INT NOT NULL DEFAULT 1 COMMENT '（全局权限）用户是否可以下载，0不可以，1可以',
  `is_uploadable` INT NOT NULL DEFAULT 1 COMMENT '（全局权限）用户是否可以上传，0不可以，1可以',
  `is_visible` INT NOT NULL DEFAULT 1 COMMENT '（全局权限）用户是否可以查看文件，0不可以，1可以',
  `is_deletable` INT NOT NULL DEFAULT 0 COMMENT '（全局权限）用户可以删除文件，0不可以，1可以',
  `is_updatable` INT NOT NULL DEFAULT 0 COMMENT '（全局权限）用户是否可以更新文件，0不可以，1可以',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC),
  UNIQUE INDEX `password_UNIQUE` (`password` ASC),
  UNIQUE INDEX `create_time_UNIQUE` (`create_time` ASC),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC))
ENGINE = InnoDB
COMMENT = '用户表';


-- -----------------------------------------------------
-- Table `efo`.`category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `efo`.`category` ;

CREATE TABLE IF NOT EXISTS `efo`.`category` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL DEFAULT '',
  `create_time` DATETIME NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC),
  UNIQUE INDEX `cat_id_UNIQUE` (`id` ASC))
ENGINE = InnoDB
COMMENT = '文件分类';


-- -----------------------------------------------------
-- Table `efo`.`file`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `efo`.`file` ;

CREATE TABLE IF NOT EXISTS `efo`.`file` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` VARCHAR(256) NULL DEFAULT '' COMMENT '文件名',
  `suffix` VARCHAR(16) NOT NULL DEFAULT '' COMMENT '文件后缀\n',
  `local_url` VARCHAR(1024) NOT NULL DEFAULT '' COMMENT '本地路径',
  `visit_url` VARCHAR(1024) NOT NULL DEFAULT '' COMMENT '客户端访问路径',
  `size` BIGINT NOT NULL DEFAULT 0 COMMENT '文件大小，单位bit',
  `create_time` DATETIME NOT NULL DEFAULT current_timestamp COMMENT '创建时间',
  `description` VARCHAR(1024) NULL DEFAULT '' COMMENT '文件描述',
  `check_times` INT NOT NULL DEFAULT 0 COMMENT '查看次数',
  `download_times` INT NOT NULL DEFAULT 0 COMMENT '下载次数',
  `tag` VARCHAR(45) NULL DEFAULT '' COMMENT '文件标签',
  `user_id` INT NOT NULL,
  `category_id` INT NOT NULL,
  `is_downloadable` INT NOT NULL DEFAULT 1 COMMENT '（全局权限）文件是否可以下载，0不可以，1可以',
  `is_uploadable` INT NOT NULL DEFAULT 1 COMMENT '（全局权限）文件夹是否允许上传（需要判断文件是否是文件夹），0不可以，1可以',
  `is_visible` INT NOT NULL DEFAULT 1 COMMENT '（全局权限）文件是否可见，0不可以，1可以',
  `is_deletable` INT NOT NULL DEFAULT 1 COMMENT '（全局权限）文件是否可以删除，0不可以，1可以',
  `is_updatable` INT NOT NULL DEFAULT 1 COMMENT '（全局权限）文件是否可以更新，0不可以，1可以',
  `last_modify_time` DATETIME NOT NULL DEFAULT current_timestamp COMMENT '最近一次修改时间',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `file_id_UNIQUE` (`id` ASC),
  INDEX `fk_file_user_idx` (`user_id` ASC),
  INDEX `fk_file_category1_idx` (`category_id` ASC),
  UNIQUE INDEX `local_url_UNIQUE` (`local_url` ASC),
  UNIQUE INDEX `visit_url_UNIQUE` (`visit_url` ASC),
  CONSTRAINT `fk_file_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `efo`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_file_category1`
    FOREIGN KEY (`category_id`)
    REFERENCES `efo`.`category` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '文件列表';


-- -----------------------------------------------------
-- Table `efo`.`download`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `efo`.`download` ;

CREATE TABLE IF NOT EXISTS `efo`.`download` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '编号',
  `create_time` DATETIME NOT NULL DEFAULT current_timestamp COMMENT '下载时间',
  `user_id` INT NOT NULL,
  `file_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_download_user1_idx` (`user_id` ASC),
  INDEX `fk_download_file1_idx` (`file_id` ASC),
  CONSTRAINT `fk_download_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `efo`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_download_file1`
    FOREIGN KEY (`file_id`)
    REFERENCES `efo`.`file` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '下载历史表';


-- -----------------------------------------------------
-- Table `efo`.`auth`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `efo`.`auth` ;

CREATE TABLE IF NOT EXISTS `efo`.`auth` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `is_uploadable` INT NOT NULL DEFAULT 1 COMMENT '是否可以上传（需要判断对应的文件是否是文件夹），0不可以，1可以',
  `is_deletable` INT NOT NULL DEFAULT 1 COMMENT '是否可以删除，0不可以，1可以',
  `is_updatable` INT NOT NULL DEFAULT 1 COMMENT '是否可以更新，0不可以，1可以',
  `user_id` INT NOT NULL,
  `file_id` BIGINT NOT NULL,
  `is_visible` INT NOT NULL DEFAULT 1 COMMENT '是否可以查看，0不可以，1可以',
  `is_downloadable` INT NOT NULL DEFAULT 1 COMMENT '用户是否可以下载，0不可以，1可以',
  `create_time` DATETIME NOT NULL DEFAULT current_timestamp COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_auth_user1_idx` (`user_id` ASC),
  INDEX `fk_auth_file1_idx` (`file_id` ASC),
  CONSTRAINT `fk_auth_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `efo`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_auth_file1`
    FOREIGN KEY (`file_id`)
    REFERENCES `efo`.`file` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '用户对应指定文件的权限表，覆盖用户表的权限';


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

insert into user(username,real_name,email,password,permission,is_deletable,is_updatable) values("system","系统","system@local.host",sha2("123456",256),3,1,1);