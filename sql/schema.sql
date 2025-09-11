DROP DATABASE IF EXISTS dondothat;
CREATE DATABASE dondothat;
USE dondothat;

CREATE TABLE `user` (
                        `user_id` BIGINT NOT NULL AUTO_INCREMENT,
                        `name` VARCHAR(255) NOT NULL,
                        `nickname` VARCHAR(255) NOT NULL,
                        `email` VARCHAR(255) NOT NULL,
                        `age` INT NOT NULL,
                        `password` VARCHAR(255),
                        `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                        `email_verified` BOOLEAN NOT NULL DEFAULT FALSE,
                        `asset_connected` BOOLEAN NOT NULL DEFAULT FALSE,
                        `saving_connected` BOOLEAN NOT NULL DEFAULT FALSE,
                        `role` VARCHAR(255) NOT NULL,
                        `job` VARCHAR(255) NOT NULL,
                        `social_id` VARCHAR(255),
                        `tier_id` BIGINT NULL,  -- tier 추가
                        PRIMARY KEY (`user_id`)
);

CREATE TABLE `category` (
                            `category_id` BIGINT NOT NULL AUTO_INCREMENT,
                            `name` VARCHAR(255) NOT NULL,
                            PRIMARY KEY (`category_id`)
);

-- Tier 테이블
CREATE TABLE `tier` (
                        `tier_id` BIGINT NOT NULL AUTO_INCREMENT,
                        `name` VARCHAR(30) NOT NULL,
                        PRIMARY KEY (`tier_id`)
);

CREATE TABLE `user_challenge` (
                                  `user_challenge_id` BIGINT NOT NULL AUTO_INCREMENT,
                                  `user_id` BIGINT NOT NULL,
                                  `challenge_id` BIGINT NOT NULL,
                                  `status` ENUM('ongoing', 'completed', 'failed','closed') NOT NULL,
                                  `period` BIGINT NOT NULL,
                                  `progress` BIGINT NOT NULL,
                                  `start_date` TIMESTAMP NOT NULL,
                                  `end_date` TIMESTAMP NOT NULL,
                                  `saving` BIGINT NOT NULL,
                                  PRIMARY KEY (`user_challenge_id`)
);

CREATE TABLE `challenge` (
                             `challenge_id` BIGINT NOT NULL AUTO_INCREMENT,
                             `category_id` BIGINT NOT NULL,
                             `title` VARCHAR(255) NOT NULL,
                             `summary` VARCHAR(255) NOT NULL,
                             `description` VARCHAR(255) NOT NULL,
                             PRIMARY KEY (`challenge_id`)
);

CREATE TABLE `user_asset` (
                              `asset_id` BIGINT NOT NULL AUTO_INCREMENT,
                              `user_id` BIGINT NOT NULL,
                              `asset_name` VARCHAR(255) NOT NULL,
                              `balance` BIGINT NOT NULL,
                              `bank_name` VARCHAR(255) NOT NULL,
                              `created_at` TIMESTAMP NOT NULL,
                              `bank_account` TEXT NOT NULL,
                              `bank_id` TEXT NOT NULL,
                              `bank_pw` TEXT NOT NULL,
                              `connected_id` TEXT NULL,
                              `status` ENUM('main', 'sub') NOT NULL,
                              PRIMARY KEY (`asset_id`)
);

CREATE TABLE `expenditure` (
                               `expenditure_id` BIGINT NOT NULL AUTO_INCREMENT,
                               `user_id` BIGINT NOT NULL,
                               `asset_id` BIGINT NOT NULL,
                               `category_id` BIGINT NOT NULL,
                               `amount` BIGINT NOT NULL,
                               `description` VARCHAR(255) NOT NULL,
                               `expenditure_date` DATETIME NOT NULL,
                               `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                               `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                               `user_modified` BOOLEAN NOT NULL DEFAULT FALSE,
                               `codef_transaction_id` VARCHAR(255),
                               `deleted_at` TIMESTAMP NULL,
                               PRIMARY KEY (`expenditure_id`)
);

CREATE TABLE `chat_message` (
                                `message_id` BIGINT NOT NULL AUTO_INCREMENT,
                                `user_id` BIGINT NOT NULL,
                                `challenge_id` BIGINT NOT NULL,
                                `message` VARCHAR(255) NOT NULL,
                                `sent_at` TIMESTAMP NOT NULL,
                                `message_type` VARCHAR(20) DEFAULT 'MESSAGE' NOT NULL,
                                PRIMARY KEY (`message_id`)
);

CREATE TABLE access_token (
                              `token_id` BIGINT NOT NULL AUTO_INCREMENT,
                              `access_token` TEXT NOT NULL,
                              `expires_at` TIMESTAMP NOT NULL,
                              `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                              `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                              PRIMARY KEY (`token_id`)
);

-- 1. 적금 상품 기본 정보 테이블 (baseList 데이터)
CREATE TABLE `saving_base` (
                               `saving_base_id` BIGINT NOT NULL AUTO_INCREMENT,
                               `dcls_month` VARCHAR(6) NOT NULL,
                               `fin_co_no` VARCHAR(255) NOT NULL,
                               `fin_prdt_cd` VARCHAR(255) NOT NULL,
                               `kor_co_nm` VARCHAR(255) NOT NULL,
                               `fin_prdt_nm` VARCHAR(255) NOT NULL,
                               `join_way` VARCHAR(255) NOT NULL,
                               `mtrt_int` TEXT NOT NULL,
                               `spcl_cnd` TEXT NOT NULL,
                               `join_deny` VARCHAR(255) NOT NULL,
                               `join_member` VARCHAR(255) NOT NULL,
                               `etc_note` TEXT NOT NULL,
                               `max_limit` INT,
                               `dcls_strt_day` VARCHAR(8),
                               `dcls_end_day` VARCHAR(8),
                               `fin_co_subm_day` VARCHAR(12) NOT NULL,
                               `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                               `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                               PRIMARY KEY (`saving_base_id`),
                               UNIQUE KEY `uk_saving_base` (`fin_co_no`, `fin_prdt_cd`, `dcls_month`)
);

-- 2. 적금 상품 옵션 정보 테이블 (optionList 데이터)
CREATE TABLE `saving_option` (
                                 `saving_option_id` BIGINT NOT NULL AUTO_INCREMENT,
                                 `saving_base_id` BIGINT NOT NULL,
                                 `dcls_month` VARCHAR(6) NOT NULL,
                                 `fin_co_no` VARCHAR(255) NOT NULL,
                                 `fin_prdt_cd` VARCHAR(255) NOT NULL,
                                 `intr_rate_type` VARCHAR(1) NOT NULL,
                                 `intr_rate_type_nm` VARCHAR(2) NOT NULL,
                                 `rsrv_type` VARCHAR(1) NOT NULL,
                                 `rsrv_type_nm` VARCHAR(20) NOT NULL,
                                 `save_trm` VARCHAR(3) NOT NULL,
                                 `intr_rate` DECIMAL(5,2),
                                 `intr_rate2` DECIMAL(5,2),
                                 `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                 `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                 PRIMARY KEY (`saving_option_id`),
                                 UNIQUE KEY `uk_saving_option` (`fin_co_no`, `fin_prdt_cd`, `save_trm`, `rsrv_type`, `dcls_month`)
);

ALTER TABLE `user` ADD CONSTRAINT `fk_user_tier`
    FOREIGN KEY (`tier_id`) REFERENCES `tier`(`tier_id`) ON DELETE SET NULL;

ALTER TABLE `user_challenge` ADD CONSTRAINT `fk_user_challenge_user`
    FOREIGN KEY (`user_id`) REFERENCES `user`(`user_id`) ON DELETE CASCADE;

ALTER TABLE `user_challenge` ADD CONSTRAINT `fk_user_challenge_challenge`
    FOREIGN KEY (`challenge_id`) REFERENCES `challenge`(`challenge_id`) ON DELETE CASCADE;

ALTER TABLE `chat_message` ADD CONSTRAINT `fk_chat_message_user`
    FOREIGN KEY (`user_id`) REFERENCES `user`(`user_id`) ON DELETE CASCADE;

ALTER TABLE `chat_message` ADD CONSTRAINT `fk_chat_message_challenge`
    FOREIGN KEY (`challenge_id`) REFERENCES `challenge`(`challenge_id`) ON DELETE CASCADE;

ALTER TABLE `user_asset` ADD CONSTRAINT `fk_user_asset_user`
    FOREIGN KEY (`user_id`) REFERENCES `user`(`user_id`) ON DELETE CASCADE;

ALTER TABLE `expenditure` ADD CONSTRAINT `fk_expenditure_user`
    FOREIGN KEY (`user_id`) REFERENCES `user`(`user_id`) ON DELETE CASCADE;

ALTER TABLE `expenditure` ADD CONSTRAINT `fk_expenditure_asset`
    FOREIGN KEY (`asset_id`) REFERENCES `user_asset`(`asset_id`) ON DELETE CASCADE;

ALTER TABLE `expenditure` ADD CONSTRAINT `fk_expenditure_category`
    FOREIGN KEY (`category_id`) REFERENCES `category`(`category_id`) ON DELETE CASCADE;

ALTER TABLE `challenge` ADD CONSTRAINT `fk_challenge_category`
    FOREIGN KEY (`category_id`) REFERENCES `category`(`category_id`) ON DELETE CASCADE;

ALTER TABLE `saving_option` ADD CONSTRAINT `fk_option_to_base`
    FOREIGN KEY (`saving_base_id`) REFERENCES `saving_base`(`saving_base_id`)
        ON DELETE RESTRICT -- 부모(base) 데이터 삭제 시 자식(option)이 있으면 삭제를 막음 (안전장치)
        ON UPDATE CASCADE; -- 부모(base) 데이터의 id가 바뀌면 자식(option)의 id도 함께 변경