
CREATE TABLE `AM_API_THROTTLE_POLICY` (
  `POLICY_ID` INTEGER,
  `NAME` VARCHAR(255),
  `DISPLAY_NAME` VARCHAR(255),
  `DESCRIPTION` VARCHAR(1024),
  PRIMARY KEY (`POLICY_ID`),
  UNIQUE (`NAME`)
);

CREATE TABLE AM_POLICY_APPLICATION (
  `POLICY_ID` INT(11) NOT NULL AUTO_INCREMENT,
  `NAME` VARCHAR(512) NOT NULL,
  `DISPLAY_NAME` VARCHAR(512) NULL DEFAULT NULL,
  `DESCRIPTION` VARCHAR(1024) NULL DEFAULT NULL,
  `QUOTA_TYPE` VARCHAR(25) NOT NULL,
  `QUOTA` INT(11) NOT NULL,
  `QUOTA_UNIT` VARCHAR(10) NULL DEFAULT NULL,
  `UNIT_TIME` INT(11) NOT NULL,
  `TIME_UNIT` VARCHAR(25) NOT NULL,
  `IS_DEPLOYED` TINYINT(1) NOT NULL DEFAULT 0,
  `CUSTOM_ATTRIBUTES` BLOB DEFAULT NULL,
  `UUID` VARCHAR(256),
  PRIMARY KEY (POLICY_ID),
  UNIQUE INDEX APP_NAME (NAME),
  UNIQUE (UUID)
);
CREATE TABLE `AM_API` (
  `API_ID` INTEGER AUTO_INCREMENT,
  `PROVIDER` VARCHAR(255),
  `NAME` VARCHAR(255),
  `CONTEXT` VARCHAR(255),
  `VERSION` VARCHAR(30),
  `IS_DEFAULT_VERSION` BOOLEAN,
  `DESCRIPTION` VARCHAR(1024),
  `VISIBILITY` VARCHAR(30),
  `IS_RESPONSE_CACHED` BOOLEAN,
  `CACHE_TIMEOUT` INTEGER,
  `UUID` VARCHAR(255),
  `TECHNICAL_OWNER` VARCHAR(255),
  `TECHNICAL_EMAIL` VARCHAR(255),
  `BUSINESS_OWNER` VARCHAR(255),
  `BUSINESS_EMAIL` VARCHAR(255),
  `LIFECYCLE_INSTANCE_ID` VARCHAR(255),
  `CURRENT_LC_STATUS` VARCHAR(255),
  `CORS_ENABLED` BOOLEAN,
  `CORS_ALLOW_ORIGINS` VARCHAR(512),
  `CORS_ALLOW_CREDENTIALS` BOOLEAN,
  `CORS_ALLOW_HEADERS` VARCHAR(512),
  `CORS_ALLOW_METHODS` VARCHAR(255),
  `CREATED_BY` VARCHAR(100),
  `CREATED_TIME` TIMESTAMP,
  `LAST_UPDATED_TIME` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`API_ID`),
  UNIQUE (`PROVIDER`,`NAME`,`VERSION`),
  UNIQUE (`CONTEXT`)
);

CREATE TABLE `AM_API_VISIBLE_ROLES` (
  `API_ID` INTEGER,
  `ROLE` VARCHAR(255),
  PRIMARY KEY (`API_ID`, `ROLE`),
  FOREIGN KEY (`API_ID`) REFERENCES `AM_API`(`API_ID`) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE `AM_API_TAG_MAPPING` (
  `API_ID` INTEGER,
  `TAG_ID` INTEGER,
  PRIMARY KEY (`API_ID`, `TAG_ID`),
  FOREIGN KEY (`API_ID`) REFERENCES `AM_API`(`API_ID`) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE `AM_TAGS` (
  `TAG_ID` INTEGER AUTO_INCREMENT,
  `TAG_NAME` VARCHAR(255),
  PRIMARY KEY (`TAG_ID`)
);

CREATE TABLE `AM_API_SUBSCRIPTION_POLICY_MAPPING` (
  `API_ID` INTEGER,
  `POLICY_ID` INTEGER,
  PRIMARY KEY (`API_ID`, `POLICY_ID`),
  FOREIGN KEY (`API_ID`) REFERENCES `AM_API`(`API_ID`) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE `AM_API_ENDPOINTS` (
  `API_ID` INTEGER,
  `ENVIRONMENT_CATEGORY` VARCHAR(30),
  `ENDPOINT_TYPE` VARCHAR(30),
  `IS_ENDPOINT_SECURED` BOOLEAN,
  `TPS` INTEGER,
  `AUTH_DIGEST` VARCHAR(30),
  `USERNAME` VARCHAR(255),
  `PASSWORD` VARCHAR(255),
  PRIMARY KEY (`API_ID`),
  FOREIGN KEY (`API_ID`) REFERENCES `AM_API`(`API_ID`) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE `AM_API_SCOPES` (
  `API_ID` INTEGER,
  `SCOPE_ID` INTEGER,
  PRIMARY KEY (`API_ID`, `SCOPE_ID`),
  FOREIGN KEY (`API_ID`) REFERENCES `AM_API`(`API_ID`) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE `AM_API_URL_MAPPING` (
  `API_ID` INTEGER,
  `HTTP_METHOD` VARCHAR(30),
  `URL_PATTERN` VARCHAR(255),
  `AUTH_SCHEME` VARCHAR(30),
  `API_POLICY_ID` INTEGER,
  PRIMARY KEY (`API_ID`, `HTTP_METHOD`, `URL_PATTERN`),
  FOREIGN KEY (`API_ID`) REFERENCES `AM_API`(`API_ID`) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (`API_POLICY_ID`) REFERENCES `AM_API_THROTTLE_POLICY`(`POLICY_ID`)
);

CREATE TABLE AM_POLICY_APPLICATION (
  `POLICY_ID` INT(11) NOT NULL AUTO_INCREMENT,
  `NAME` VARCHAR(512) NOT NULL,
  `DISPLAY_NAME` VARCHAR(512) NULL DEFAULT NULL,
  `DESCRIPTION` VARCHAR(1024) NULL DEFAULT NULL,
  `QUOTA_TYPE` VARCHAR(25) NOT NULL,
  `QUOTA` INT(11) NOT NULL,
  `QUOTA_UNIT` VARCHAR(10) NULL DEFAULT NULL,
  `UNIT_TIME` INT(11) NOT NULL,
  `TIME_UNIT` VARCHAR(25) NOT NULL,
  `IS_DEPLOYED` TINYINT(1) NOT NULL DEFAULT 0,
  `CUSTOM_ATTRIBUTES` BLOB DEFAULT NULL,
  `UUID` VARCHAR(256),
  PRIMARY KEY (POLICY_ID),
  UNIQUE INDEX APP_NAME (NAME),
  UNIQUE (UUID)
);

#This is for tests only (until the tier dao is implemented)
INSERT INTO AM_POLICY_APPLICATION (NAME, DISPLAY_NAME, DESCRIPTION, QUOTA_TYPE, QUOTA, QUOTA_UNIT, UNIT_TIME,
                                   TIME_UNIT, IS_DEPLOYED, UUID) VALUES ('gold', 'Gold', 'Gold Tier', 'x', 10, 'REQ',
                                                                         1, 's', 1, 'xxxxx');
INSERT INTO AM_POLICY_APPLICATION (NAME, DISPLAY_NAME, DESCRIPTION, QUOTA_TYPE, QUOTA, QUOTA_UNIT, UNIT_TIME,
                                   TIME_UNIT, IS_DEPLOYED, UUID) VALUES ('silver', 'Silver', 'Silver Tier', 'y', 50, 'REQ',
                                                                         1, 's', 1, 'yyyyy');

CREATE TABLE `AM_APPLICATION` (
  `APPLICATION_ID` INTEGER AUTO_INCREMENT,
  `NAME` VARCHAR(255),
  `APPLICATION_POLICY_ID` INTEGER,
  `CALLBACK_URL` VARCHAR(512),
  `DESCRIPTION` VARCHAR(1024),
  `APPLICATION_STATUS` VARCHAR(255),
  `GROUP_ID` VARCHAR(255),
  `CREATED_BY` VARCHAR(100),
  `CREATED_TIME` TIMESTAMP,
  `UPDATED_BY` VARCHAR(100),
  `LAST_UPDATED_TIME` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `UUID` VARCHAR(255),
  PRIMARY KEY (`APPLICATION_ID`),
  UNIQUE (NAME),
  FOREIGN KEY (`APPLICATION_POLICY_ID`) REFERENCES `AM_POLICY_APPLICATION`(`POLICY_ID`) ON UPDATE CASCADE
);

CREATE TABLE `AM_POLICY_SUBSCRIPTION` (
  `POLICY_ID` INTEGER,
  `NAME` VARCHAR(255),
  `DISPLAY_NAME` VARCHAR(512),
  `DESCRIPTION` VARCHAR(1024),
  `QUOTA_TYPE` VARCHAR(30),
  `QUOTA` INTEGER,
  `QUOTA_UNIT` VARCHAR(30),
  `UNIT_TIME` INTEGER,
  `TIME_UNIT` VARCHAR(30),
  `RATE_LIMIT_COUNT` INTEGER,
  `RATE_LIMIT_TIME_UNIT` VARCHAR(30),
  `IS_DEPLOYED` BOOL,
  `CUSTOM_ATTRIBUTES` BLOB,
  `STOP_ON_QUOTA_REACH` BOOL,
  `BILLING_PLAN` VARCHAR(30),
  `UUID` VARCHAR(255),
  PRIMARY KEY (`POLICY_ID`)
);

CREATE TABLE `AM_APP_KEY_MAPPING` (
  `APPLICATION_ID` INTEGER,
  `CONSUMER_KEY` VARCHAR(255),
  `KEY_TYPE` VARCHAR(255),
  `STATE` VARCHAR(30),
  `CREATE_MODE` VARCHAR(30),
  PRIMARY KEY (`APPLICATION_ID`, `KEY_TYPE`)
);

CREATE TABLE `AM_API_TRANSPORTS` (
  `API_ID` INTEGER,
  `TRANSPORT` VARCHAR(30),
  PRIMARY KEY (`API_ID`, `TRANSPORT`),
  FOREIGN KEY (`API_ID`) REFERENCES `AM_API`(`API_ID`) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE `AM_API_ENVIRONMENTS` (
  `API_ID`         INTEGER,
  `ENV_NAME`       VARCHAR(255),
  `HTTP_URL`       VARCHAR(255),
  `HTTPS_URL`      VARCHAR(255),
  `APPEND_CONTEXT` BOOLEAN,
  PRIMARY KEY (`API_ID`, `ENV_NAME`),
  FOREIGN KEY (`API_ID`) REFERENCES `AM_API` (`API_ID`)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

CREATE TABLE `AM_RESOURCE_TYPES` (
  `RESOURCE_TYPE_ID` INTEGER AUTO_INCREMENT,
  `RESOURCE_TYPE_NAME` VARCHAR(255),
  PRIMARY KEY (`RESOURCE_TYPE_ID`)
);

CREATE TABLE `AM_API_RESOURCES` (
  `RESOURCE_ID` INTEGER AUTO_INCREMENT,
  `API_ID` INTEGER,
  `RESOURCE_TYPE_ID` INTEGER,
  `DATA_TYPE` VARCHAR(255),
  `RESOURCE_TEXT_VALUE` VARCHAR(1024),
  `RESOURCE_BINARY_VALUE` BLOB,
  PRIMARY KEY (`RESOURCE_ID`),
  FOREIGN KEY (`API_ID`) REFERENCES `AM_API`(`API_ID`) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (`RESOURCE_TYPE_ID`) REFERENCES `AM_RESOURCE_TYPES`(`RESOURCE_TYPE_ID`)
);

INSERT INTO AM_API_THROTTLE_POLICY (`POLICY_ID`, `NAME`, `DISPLAY_NAME`, `DESCRIPTION`) VALUES ('1', 'Unlimited', 'Unlimited', 'Unlimited');
INSERT INTO AM_API_THROTTLE_POLICY (`POLICY_ID`, `NAME`, `DISPLAY_NAME`, `DESCRIPTION`) VALUES ('2', 'Gold', 'Gold', 'Gold');
INSERT INTO AM_API_THROTTLE_POLICY (`POLICY_ID`, `NAME`, `DISPLAY_NAME`, `DESCRIPTION`) VALUES ('3', 'Bronze', 'Bronze', 'Bronze');
INSERT INTO AM_API_THROTTLE_POLICY (`POLICY_ID`, `NAME`, `DISPLAY_NAME`, `DESCRIPTION`) VALUES ('4', 'Silver', 'Silver', 'Silver');
INSERT INTO AM_POLICY_SUBSCRIPTION (`POLICY_ID`, `NAME`, `DISPLAY_NAME`, `DESCRIPTION`) VALUES ('1', 'Unlimited', 'Unlimited', 'Unlimited');
INSERT INTO AM_POLICY_SUBSCRIPTION (`POLICY_ID`, `NAME`, `DISPLAY_NAME`, `DESCRIPTION`) VALUES ('2', 'Gold', 'Gold', 'Gold');
INSERT INTO AM_POLICY_SUBSCRIPTION (`POLICY_ID`, `NAME`, `DISPLAY_NAME`, `DESCRIPTION`) VALUES ('3', 'Silver', 'Silver', 'Silver');
INSERT INTO AM_POLICY_SUBSCRIPTION (`POLICY_ID`, `NAME`, `DISPLAY_NAME`, `DESCRIPTION`) VALUES ('4', 'Bronze', 'Bronze', 'Bronze');
Commit;