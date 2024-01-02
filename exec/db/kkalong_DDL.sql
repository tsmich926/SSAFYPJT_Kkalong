CREATE SCHEMA `kkalong` ;
use kkalong;
DROP TABLE IF EXISTS `member`;

CREATE TABLE `member` (
	`member_seq`	int	NOT NULL AUTO_INCREMENT PRIMARY KEY	COMMENT '인덱스',
	`member_nickname`	varchar(20)	NOT NULL	COMMENT '닉네임',
	`member_id`	varchar(20)	NOT NULL	COMMENT '아이디',
	`member_pw`	varchar(100)	NOT NULL	COMMENT '비밀번호',
	`member_mail`	varchar(40)	NOT NULL	COMMENT '이메일',
	`member_phone`	varchar(11)	NULL	COMMENT '전화번호',
	`member_gender`	char(1)	NULL	COMMENT '성별(M-남자, F - 여자)',
	`member_birth_year`	smallint	NULL	COMMENT '생년',
	`member_reg_date`	datetime	NOT NULL	DEFAULT now()	COMMENT '회원가입 일시',
	`is_member_deleted`	boolean	NOT NULL	DEFAULT false	COMMENT '회원 탈퇴 여부',
	`member_withdrawn_date`	datetime	NULL	COMMENT '탈퇴일'
);

DROP TABLE IF EXISTS `assess`;

CREATE TABLE `assess` (
	`fashion_seq`	int	NOT NULL	COMMENT '코디 인덱스',
	`member_seq`	int	NOT NULL	COMMENT '좋아요를 누른 회원 인덱스',
	`is_like`	boolean	NOT NULL	COMMENT '좋아요/싫어요 (1- 좋아요, 0 - 싫어요)',
	`assess_reg_date`	datetime	NOT NULL	DEFAULT now()	COMMENT '좋아요 싫어요 누른 날짜'
);

DROP TABLE IF EXISTS `cloth`;

CREATE TABLE `cloth` (
	`cloth_seq`	int	NOT NULL AUTO_INCREMENT PRIMARY KEY	COMMENT '인덱스',
	`cloth_name`	varchar(40)	NOT NULL	COMMENT '옷 이름',
	`cloth_img_name`	varchar(75)	NOT NULL	COMMENT '옷 원본 사진 파일 이름(cloth_소유자아이디_올린시간_무작위난수6자리)',
	`cloth_img_no_bg`	boolean	NOT NULL	DEFAULT false	COMMENT '옷 누끼 사진 배경 없는 파일 존재 여부',
	`cloth_img_yes_bg`	boolean	NOT NULL	DEFAULT false	COMMENT '옷 누끼 사진 배경있는 파일 존재여부',
	`cloth_img_masking`	boolean	NOT NULL	DEFAULT false	COMMENT '옷 마스킹 사진 파일 존재여부',
	`is_private`	tinyint	NOT NULL	DEFAULT false	COMMENT '공개 여부',
	`cloth_reg_date`	datetime	NOT NULL	DEFAULT now()	COMMENT '생성날짜',
	`is_cloth_deleted`	boolean	NOT NULL	DEFAULT false	COMMENT '삭제여부',
	`cloth_del_date`	datetime	NULL	COMMENT '삭제일시',
	`section_seq`	int	COMMENT '옷장 상세정보 인덱스',
	`sort_seq`	int	NOT NULL	COMMENT '옷 종류 인덱스',
	`member_seq`	int	NOT NULL	COMMENT '소유자 인덱스'
);
use kkalong;
DROP TABLE IF EXISTS `tag`;

CREATE TABLE `tag` (
	`tag_seq`	int	NOT NULL AUTO_INCREMENT PRIMARY KEY	COMMENT '인덱스',
	`tag`	varchar(40)	NOT NULL	COMMENT '태그명'
);

DROP TABLE IF EXISTS `closet`;

CREATE TABLE `closet` (
	`closet_seq`	int	NOT NULL AUTO_INCREMENT PRIMARY KEY	COMMENT '인덱스',
	`closet_name`	varchar(40)	NOT NULL	COMMENT '옷장 이름',
	`closet_img_name`	varchar(70)	NOT NULL	COMMENT '옷장 사진 파일 이름(closet_소유자아이디_올린시간_무작위난수6자리)',
	`closet_reg_date`	datetime	NOT NULL	DEFAULT now()	COMMENT '생성 날짜',
	`is_closet_deleted`	boolean	NOT NULL	DEFAULT false	COMMENT '삭제여부',
	`closet_del_date`	datetime	NULL	COMMENT '삭제일시',
	`member_seq`	int	NOT NULL	COMMENT '소유한 회원 인덱스'
);

DROP TABLE IF EXISTS `follow`;

CREATE TABLE `follow` (
	`is_follow_deleted`	boolean	NOT NULL	COMMENT '삭제여부',
	`follow_del_date`	datetime	NULL	COMMENT '삭제일시',
	`reg_date`	datetime	NOT NULL	DEFAULT now()	COMMENT '기록일시',
	`following_member_seq`	int	NOT NULL	COMMENT '구독하는  회원 인덱스',
	`follower_member_seq`	int	NOT NULL	COMMENT '구독자 회원 인덱스'
);

DROP TABLE IF EXISTS `section`;

CREATE TABLE `section` (
	`section_seq`	int	NOT NULL AUTO_INCREMENT PRIMARY KEY	COMMENT '인덱스',
	`section_name`	varchar(40)	NOT NULL	COMMENT '상세구역 이름',
	`is_section_deleted`	boolean	NOT NULL	DEFAULT false	COMMENT '삭제여부',
	`section_del_date`	datetime	NULL	COMMENT '삭제일시',
	`closet_seq`	int	NOT NULL	COMMENT '옷장 인덱스',
	`sort_seq`	int	NOT NULL	COMMENT '옷장 상세 종류 인덱스'
);

DROP TABLE IF EXISTS `fashion`;

CREATE TABLE `fashion` (
	`fashion_seq`	int	NOT NULL AUTO_INCREMENT PRIMARY KEY	COMMENT '인덱스',
	`fashion_name`	varchar(40)	NOT NULL	COMMENT '코디이름',
	`fashion_img_name`	varchar(70)	NOT NULL	COMMENT '파일 이름 (fashion_소유자아이디_올린시간_무작위6자리난수.)',
	`is_ai`	tinyint	NOT NULL	COMMENT '(1- ai사진, 0- 실제사진)',
	`fashion_reg_date`	datetime	NOT NULL	DEFAULT now()	COMMENT '저장한 날짜',
	`is_fashion_deleted`	boolean	NOT NULL	DEFAULT false	COMMENT '삭제여부',
	`fashion_del_date`	datetime	NULL	COMMENT '삭제 일시',
	`member_seq`	int	NOT NULL	COMMENT '소유회원 인덱스'
);

DROP TABLE IF EXISTS `sort`;

CREATE TABLE `sort` (
	`sort_seq`	int	NOT NULL AUTO_INCREMENT PRIMARY KEY	COMMENT '인덱스',
	`sort`	varchar(20)	NOT NULL	COMMENT '종류',
	`sort_group_seq`	int	NOT NULL	COMMENT '그룹 인덱스'
);

DROP TABLE IF EXISTS `tag_relation`;

CREATE TABLE `tag_relation` (
	`is_tag_relation_delete`	boolean	NOT NULL	DEFAULT false	COMMENT '삭제여부',
	`tag_relation_del_date`	datetime	NULL	COMMENT '삭제일시',
	`cloth_seq`	int	NOT NULL	COMMENT '옷 인덱스',
	`tag_seq`	int	NOT NULL	COMMENT '인덱스'
);

DROP TABLE IF EXISTS `photo`;

CREATE TABLE `photo` (
	`photo_seq`	int	NOT NULL AUTO_INCREMENT PRIMARY KEY	COMMENT '인덱스',
	`photo_img_name`	varchar(75)	NOT NULL	COMMENT '사용자 누끼 사진 파일 이름 (photo_소유자아이디_올린시간_무작위6자리난수)',
	`photo_img_masking`	boolean	NOT NULL	DEFAULT false	COMMENT '사용자 마스킹 사진 파일 존재여부',
	`photo_img_openpose`	boolean	NOT NULL	DEFAULT false	COMMENT '사용자 오픈포즈 사진 파일 존재여부',
	`photo_json_openpose`	boolean	NOT NULL	DEFAULT false	COMMENT '사용자 오픈포즈 JSON 파일 존재여부',
	`photo_reg_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '저장날짜',
    `is_photo_deleted` boolean NOT NULL DEFAULT false COMMENT '사진 삭제 여부',
	`photo_del_date`	datetime	NULL	COMMENT '삭제일시',
	`member_seq`	int	NOT NULL	COMMENT '사진 소유자 인덱스'
);

DROP TABLE IF EXISTS `sort_group`;

CREATE TABLE `sort_group` (
	`sort_group_seq`	int	NOT NULL AUTO_INCREMENT PRIMARY KEY	COMMENT '인덱스',
	`group_name`	varchar(20)	NOT NULL	COMMENT '그룹 이름'
);

DROP TABLE IF EXISTS `chat_room`;

CREATE TABLE `chat_room` (
	`seq`	int	NOT NULL AUTO_INCREMENT PRIMARY KEY	COMMENT '인덱스',
	`chat_room_latest_log`	varchar(100)	NULL	COMMENT '마지막 채팅 내용',
	`chat_room_latest_date`	datetime	NULL	COMMENT '마지막 채팅 보낸 일시',
	`member_fir_seq`	int	NOT NULL	COMMENT '채팅 요청한 사용자 인덱스',
	`member_sec_seq`	int	NOT NULL	COMMENT '채팅 요청 받은 사용자 인덱스'
);

ALTER TABLE `assess` ADD CONSTRAINT `FK_fashion_TO_assess_1` FOREIGN KEY (
	`fashion_seq`
)
REFERENCES `fashion` (
	`fashion_seq`
);

ALTER TABLE `assess` ADD CONSTRAINT `FK_member_TO_assess_1` FOREIGN KEY (
	`member_seq`
)
REFERENCES `member` (
	`member_seq`
);

ALTER TABLE `cloth` ADD CONSTRAINT `FK_section_TO_cloth_1` FOREIGN KEY (
	`section_seq`
)
REFERENCES `section` (
	`section_seq`
);

ALTER TABLE `cloth` ADD CONSTRAINT `FK_sort_TO_cloth_1` FOREIGN KEY (
	`sort_seq`
)
REFERENCES `sort` (
	`sort_seq`
);

ALTER TABLE `cloth` ADD CONSTRAINT `FK_member_TO_cloth_1` FOREIGN KEY (
	`member_seq`
)
REFERENCES `member` (
	`member_seq`
);

ALTER TABLE `closet` ADD CONSTRAINT `FK_member_TO_closet_1` FOREIGN KEY (
	`member_seq`
)
REFERENCES `member` (
	`member_seq`
);

ALTER TABLE `follow` ADD CONSTRAINT `FK_member_TO_follow_1` FOREIGN KEY (
	`following_member_seq`
)
REFERENCES `member` (
	`member_seq`
);

ALTER TABLE `follow` ADD CONSTRAINT `FK_member_TO_follow_2` FOREIGN KEY (
	`follower_member_seq`
)
REFERENCES `member` (
	`member_seq`
);

ALTER TABLE `section` ADD CONSTRAINT `FK_closet_TO_section_1` FOREIGN KEY (
	`closet_seq`
)
REFERENCES `closet` (
	`closet_seq`
);

ALTER TABLE `section` ADD CONSTRAINT `FK_sort_TO_section_1` FOREIGN KEY (
	`sort_seq`
)
REFERENCES `sort` (
	`sort_seq`
);

ALTER TABLE `fashion` ADD CONSTRAINT `FK_member_TO_fashion_1` FOREIGN KEY (
	`member_seq`
)
REFERENCES `member` (
	`member_seq`
);

ALTER TABLE `sort` ADD CONSTRAINT `FK_sort_group_TO_sort_1` FOREIGN KEY (
	`sort_group_seq`
)
REFERENCES `sort_group` (
	`sort_group_seq`
);

ALTER TABLE `tag_relation` ADD CONSTRAINT `FK_cloth_TO_tag_relation_1` FOREIGN KEY (
	`cloth_seq`
)
REFERENCES `cloth` (
	`cloth_seq`
);

ALTER TABLE `tag_relation` ADD CONSTRAINT `FK_tag_TO_tag_relation_1` FOREIGN KEY (
	`tag_seq`
)
REFERENCES `tag` (
	`tag_seq`
);

ALTER TABLE `photo` ADD CONSTRAINT `FK_member_TO_photo_1` FOREIGN KEY (
	`member_seq`
)
REFERENCES `member` (
	`member_seq`
);

ALTER TABLE `chat_room` ADD CONSTRAINT `FK_member_TO_chat_room_1` FOREIGN KEY (
	`member_fir_seq`
)
REFERENCES `member` (
	`member_seq`
);

ALTER TABLE `chat_room` ADD CONSTRAINT `FK_member_TO_chat_room_2` FOREIGN KEY (
	`member_sec_seq`
)
REFERENCES `member` (
	`member_seq`
);