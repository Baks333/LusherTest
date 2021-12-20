DROP SCHEMA IF EXISTS `lusherdb`;
CREATE SCHEMA IF NOT EXISTS `lusherdb` ;

DROP USER IF EXISTS `lusher`@`%`;
CREATE USER `lusher`@`%` IDENTIFIED WITH `mysql_native_password` BY 'lusher123';

GRANT USAGE ON `lusherdb`.* TO `lusher`@`%`;
GRANT CREATE, REFERENCES, ALTER ON `lusherdb`.* TO `lusher`@`%`;
GRANT SELECT, INSERT, UPDATE, DELETE ON `lusherdb`.* TO `lusher`@`%`;
