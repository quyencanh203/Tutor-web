use dataq;
CREATE TABLE `users` (
  `user_id` int PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(255),
  `email` varchar(100),
  `password` varchar(255),
  `sex` enum('male','female'),
  `role` enum('student','tutor','admin'), 
   `avatar` varchar(255)
);

CREATE TABLE `tutor` (
  `tutor_id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int,
  `phone_tutor` varchar(11),
  `date_of_birth_tutor` date,
  `education` text,
  `balance` int DEFAULT 0
);

CREATE TABLE `student` (
  `student_id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int,
  `phone_student` varchar(11),
  `date_of_birth_student` date
);

CREATE TABLE `classes` (
  `class_id` int PRIMARY KEY AUTO_INCREMENT,
  `student_id` int,
  `tutor_id` int,
  `class_student` int,
  `subject` varchar(255),
  `address` varchar(255),
  `session_of_per_week` int,
  `status` enum('Chưa có gia sư','Đã có gia sư'),
  `description` text,
  `booking_date` date,
  `price` int
);

CREATE TABLE `requirement` (
  `requirement_id` int PRIMARY KEY AUTO_INCREMENT,
  `tutor_id` int,
  `class_id` int
);

CREATE TABLE `payment` (
  `payment_id` int PRIMARY KEY AUTO_INCREMENT,
  `tutor_id` int,
  `amount_paid` int,
  `date_payment` date,
  `img_payment` varchar(255)
);

ALTER TABLE `student` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

ALTER TABLE `tutor` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

ALTER TABLE `classes` ADD FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`);

ALTER TABLE `classes` ADD FOREIGN KEY (`tutor_id`) REFERENCES `tutor` (`tutor_id`);

ALTER TABLE `requirement` ADD FOREIGN KEY (`tutor_id`) REFERENCES `tutor` (`tutor_id`);

ALTER TABLE `requirement` ADD FOREIGN KEY (`class_id`) REFERENCES `classes` (`class_id`);

ALTER TABLE `payment` ADD FOREIGN KEY (`tutor_id`) REFERENCES `tutor` (`tutor_id`);

-- tài khoản admin mặc định
INSERT INTO users (name, email, password, sex, role)
VALUES ('Admin', 'admin_tutor@gmail.com', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'male', 'admin');

-- 
ALTER TABLE requirement
ADD status ENUM('Đã được nhận', 'Đang chờ duyệt', 'Không được nhận') DEFAULT 'Đang chờ duyệt';

-- Tạo dữ liệu
DELIMITER //

CREATE TRIGGER after_user_insert
AFTER INSERT ON users
FOR EACH ROW
BEGIN
    IF NEW.role = 'tutor' THEN
        INSERT INTO tutor (user_id, phone_tutor, date_of_birth_tutor, education, balance)
        VALUES (NEW.user_id, '0123', '2000-01-01', 'YES', 0);
    ELSEIF NEW.role = 'student' THEN
        INSERT INTO student (user_id, phone_student, date_of_birth_student)
        VALUES (NEW.user_id, '0123', '2000-01-01');
    END IF;
END//

DELIMITER ;

insert into users ( name, email, password, sex, role) values ( 'Peter MacKettrick', 'pmackettrick0@newyorker.com', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'male', 'tutor');
insert into users ( name, email, password, sex, role) values ( 'Anni Caret', 'acaret1@washington.edu', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'male', 'student');
insert into users ( name, email, password, sex, role) values ( 'Laird Gouth', 'lgouth2@mit.edu', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'female', 'tutor');
insert into users ( name, email, password, sex, role) values ( 'Nikolas Janous', 'njanous3@mlb.com', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'female', 'tutor');
insert into users ( name, email, password, sex, role) values ( 'Luce Caberas', 'lcaberas4@businessweek.com', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'male', 'student');
insert into users ( name, email, password, sex, role) values ('Marla Pettendrich', 'mpettendrich5@nps.gov', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'female', 'student');
insert into users ( name, email, password, sex, role) values ( 'Susi Hymor', 'shymor6@toplist.cz', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'male', 'tutor');
insert into users ( name, email, password, sex, role) values ('Colline Gaitung', 'cgaitung7@dagondesign.com', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'male', 'student');
insert into users ( name, email, password, sex, role) values ( 'Ty Lerway', 'tlerway8@reverbnation.com', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'male', 'student');
insert into users ( name, email, password, sex, role) values ( 'Minnaminnie Herrieven', 'mherrieven9@indiatimes.com', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'male', 'student');
insert into users ( name, email, password, sex, role) values ( 'Charil Bicksteth', 'cbickstetha@jimdo.com', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'male', 'student');
insert into users ( name, email, password, sex, role) values ( 'Kris Patman', 'kpatmanb@mail.ru', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'female', 'student');
insert into users ( name, email, password, sex, role) values ( 'Halsey Hannis', 'hhannisc@hp.com', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'male', 'student');
insert into users ( name, email, password, sex, role) values ( 'Ruby Goracci', 'rgoraccid@plala.or.jp', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'male', 'tutor');
insert into users ( name, email, password, sex, role) values ( 'Joellyn Remington', 'jremingtone@sakura.ne.jp', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'male', 'student');
insert into users ( name, email, password, sex, role) values ( 'Davina Maccrea', 'dmaccreaf@indiatimes.com', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'female', 'student');
insert into users ( name, email, password, sex, role) values ( 'Aggy Sindell', 'asindellg@home.pl', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'male', 'tutor');
insert into users ( name, email, password, sex, role) values ( 'Shelby Laight', 'slaighth@zimbio.com', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'female', 'student');
insert into users ( name, email, password, sex, role) values ( 'Joelie Zisneros', 'jzisnerosi@discuz.net', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'female', 'student');
insert into users ( name, email, password, sex, role) values ( 'Roda Zealy', 'rzealyj@stumbleupon.com', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'male', 'tutor');
insert into users ( name, email, password, sex, role) values ( 'Devi Maroney', 'dmaroneyk@examiner.com', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'male', 'student');
insert into users ( name, email, password, sex, role) values ( 'Kiel Mardlin', 'kmardlinl@ovh.net', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'male', 'tutor');
insert into users ( name, email, password, sex, role) values ( 'Dita Gibbett', 'dgibbettm@imageshack.us', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'female', 'student');
insert into users ( name, email, password, sex, role) values ( 'Stanleigh Trevains', 'strevainsn@amazon.com', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'female', 'student');
insert into users ( name, email, password, sex, role) values ( 'Lorant Farlam', 'lfarlamo@vkontakte.ru', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'female', 'tutor');
insert into users ( name, email, password, sex, role) values ( 'Zachery Myner', 'zmynerp@dedecms.com', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'male', 'student');
insert into users ( name, email, password, sex, role) values ( 'Che Aisbett', 'caisbettq@amazon.com', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'female', 'student');
insert into users ( name, email, password, sex, role) values ( 'Brigham McAllaster', 'bmcallasterr@tinyurl.com', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'female', 'tutor');
insert into users ( name, email, password, sex, role) values ( 'Caddric Portlock', 'cportlocks@nationalgeographic.com', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'male', 'student');
insert into users ( name, email, password, sex, role) values ( 'Erich Kalaher', 'ekalahert@cisco.com', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'female', 'tutor');
insert into users ( name, email, password, sex, role) values ( 'Web Denman', 'wdenmanu@cpanel.net', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'male', 'student');
insert into users ( name, email, password, sex, role) values ( 'Lyn Janaszewski', 'ljanaszewskiv@php.net', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'female', 'tutor');
insert into users ( name, email, password, sex, role) values ( 'Charlean Bamfield', 'cbamfieldw@purevolume.com', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'male', 'student');
insert into users ( name, email, password, sex, role) values ( 'Penni Bauman', 'pbaumanx@marriott.com', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'female', 'student');
insert into users ( name, email, password, sex, role) values ( 'Vi Prudence', 'vprudencey@seesaa.net', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'female', 'tutor');
insert into users ( name, email, password, sex, role) values ( 'Viva Jovovic', 'vjovovicz@ftc.gov', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'female', 'student');
insert into users ( name, email, password, sex, role) values ( 'Loralee Coade', 'lcoade10@google.nl', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'male', 'student');
insert into users ( name, email, password, sex, role) values ( 'Arlina Kitchenside', 'akitchenside11@canalblog.com', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'male', 'student');
insert into users ( name, email, password, sex, role) values ( 'Pietro Karsh', 'pkarsh12@google.com.au', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'male', 'student');
insert into users ( name, email, password, sex, role) values ( 'Carson Manilo', 'cmanilo13@mapy.cz', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'male', 'tutor');
insert into users ( name, email, password, sex, role) values ( 'Celka Friett', 'cfriett14@google.de', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'male', 'tutor');
insert into users ( name, email, password, sex, role) values ( 'Christiano Gerge', 'cgerge15@google.co.uk', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'male', 'student');
insert into users ( name, email, password, sex, role) values ( 'Sebastiano Riddlesden', 'sriddlesden16@state.gov', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'male', 'tutor');
insert into users ( name, email, password, sex, role) values ('Dody Bagnold', 'dbagnold17@multiply.com', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'female', 'tutor');
insert into users ( name, email, password, sex, role) values ( 'Dewain Corbridge', 'dcorbridge18@tripadvisor.com', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'female', 'student');
insert into users ( name, email, password, sex, role) values ( 'Rozalie Shimwell', 'rshimwell19@cbslocal.com', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'female', 'tutor');
insert into users ( name, email, password, sex, role) values ( 'Adorne Villaret', 'avillaret1a@hibu.com', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'male', 'student');
insert into users ( name, email, password, sex, role) values ( 'Bernarr Shower', 'bshower1b@a8.net', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'male', 'tutor');
insert into users ( name, email, password, sex, role) values ( 'Alvis Lanfear', 'alanfear1c@smugmug.com', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'female', 'tutor');
insert into users ( name, email, password, sex, role) values ( 'Alexine Moden', 'amoden1d@unesco.org', '$2b$12$cLBTjAy4hHWUyHIel1sTzeBQZ2PfP5XXj6c5J7zBHzrpdnTkP0Aem', 'male', 'student');

insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (12, 9, 'Hóa', 'Bắc Ninh', 4, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (8, 12, 'Tiếng Anh', 'Hà Nội', 2, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 350000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (23, 7, 'Tiếng Anh', 'Khánh Hòa', 3, 'Chưa có gia sư', 'Gia sư có kinh nghiệm', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (24, 2, 'Lý', 'Nghệ An', 4, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 350000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (33, 6, 'Tin', 'Đà Nẵng', 1, 'Chưa có gia sư', 'Gia sư có kinh nghiệm', 350000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (10, 3, 'Công Dân', 'Khánh Hòa', 3, 'Chưa có gia sư', 'Gia sư có kinh nghiệm', 300000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (28, 1, 'Văn', 'Hòa Bình', 4, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 150000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (15, 5, 'Văn', 'Thanh Hóa', 2, 'Chưa có gia sư', 'Gia sư có kinh nghiệm', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (29, 3, 'Văn', 'Quảng Bình', 4, 'Chưa có gia sư', 'Gia sư có kinh nghiệm', 350000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (30, 7, 'Địa', 'Bắc Giang', 1, 'Chưa có gia sư', 'Gia sư có kinh nghiệm', 250000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (7, 2, 'Tin', 'Bắc Giang', 4, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 250000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (36, 4, 'Toán', 'Hòa Bình', 2, 'Chưa có gia sư', 'Gia sư có kinh nghiệm', 250000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (21, 8, 'Toán', 'Hà Tĩnh', 3, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (19, 2, 'Văn', 'Nghệ An', 4, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 300000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (31, 11, 'Lý', 'Hà Nội', 2, 'Chưa có gia sư', 'Gia sư nam đẹp trai', 300000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (7, 10, 'Địa', 'Đà Nẵng', 4, 'Chưa có gia sư', 'Gia sư nam đẹp trai', 150000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (17, 8, 'Lý', 'Hòa Bình', 3, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 200000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (13, 1, 'Công Dân', 'Ninh Bình', 2, 'Chưa có gia sư', 'Gia sư có kinh nghiệm', 300000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (24, 12, 'Lý', 'Quảng Bình', 2, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (14, 6, 'Lý', 'Hòa Bình', 4, 'Chưa có gia sư', 'Gia sư nam đẹp trai', 300000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (7, 11, 'Lý', 'Khánh Hòa', 4, 'Chưa có gia sư', 'Gia sư nam đẹp trai', 200000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (13, 3, 'Hóa', 'Lào Cai', 3, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 250000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (15, 1, 'Sinh', 'Hà Nội', 4, 'Chưa có gia sư', 'Gia sư nam đẹp trai', 150000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (23, 11, 'Toán', 'Hà Tĩnh', 2, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (11, 1, 'Địa', 'Quảng Bình', 1, 'Chưa có gia sư', 'Gia sư nam đẹp trai', 300000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (10, 3, 'Tin', 'Lào Cai', 2, 'Chưa có gia sư', 'Gia sư có kinh nghiệm', 200000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (11, 6, 'Tiếng Anh', 'Hà Tĩnh', 3, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 300000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (18, 11, 'Toán', 'TPHCM', 2, 'Chưa có gia sư', 'Gia sư có kinh nghiệm', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (18, 8, 'Tin', 'Nghệ An', 4, 'Chưa có gia sư', 'Gia sư có kinh nghiệm', 250000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (11, 6, 'Địa', 'Hòa Bình', 3, 'Chưa có gia sư', 'Gia sư có kinh nghiệm', 250000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (24, 2, 'Địa', 'Lào Cai', 2, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 350000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (29, 2, 'Hóa', 'Bắc Ninh', 4, 'Chưa có gia sư', 'Gia sư có kinh nghiệm', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (35, 10, 'Công Dân', 'Nha Trang', 4, 'Chưa có gia sư', 'Gia sư nam đẹp trai', 200000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (22, 2, 'Sinh', 'Đà Nẵng', 4, 'Chưa có gia sư', 'Gia sư nam đẹp trai', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (33, 7, 'Lý', 'Hà Nội', 2, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (34, 3, 'Công Dân', 'TPHCM', 3, 'Chưa có gia sư', 'Gia sư nam đẹp trai', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (36, 10, 'Sinh', 'Quảng Bình', 2, 'Chưa có gia sư', 'Gia sư nam đẹp trai', 250000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (32, 10, 'Lý', 'Quảng Trị', 3, 'Chưa có gia sư', 'Gia sư có kinh nghiệm', 300000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (28, 10, 'Hóa', 'Ninh Bình', 1, 'Chưa có gia sư', 'Gia sư nam đẹp trai', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (30, 1, 'Tiếng Anh', 'Bắc Ninh', 2, 'Chưa có gia sư', 'Gia sư nam đẹp trai', 150000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (13, 7, 'Tiếng Anh', 'Hà Nội', 1, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 200000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (33, 4, 'Sinh', 'Lào Cai', 4, 'Chưa có gia sư', 'Gia sư nam đẹp trai', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (23, 8, 'Tin', 'Bắc Ninh', 1, 'Chưa có gia sư', 'Gia sư có kinh nghiệm', 150000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (33, 7, 'Công Dân', 'Quảng Bình', 4, 'Chưa có gia sư', 'Gia sư nam đẹp trai', 150000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (12, 9, 'Sinh', 'Hà Tĩnh', 2, 'Chưa có gia sư', 'Gia sư nam đẹp trai', 200000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (33, 11, 'Sinh', 'Nghệ An', 4, 'Chưa có gia sư', 'Gia sư có kinh nghiệm', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (23, 4, 'Hóa', 'Nha Trang', 2, 'Chưa có gia sư', 'Gia sư nam đẹp trai', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (31, 3, 'Địa', 'Ninh Bình', 3, 'Chưa có gia sư', 'Gia sư nam đẹp trai', 350000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (12, 1, 'Văn', 'Đà Nẵng', 3, 'Chưa có gia sư', 'Gia sư nam đẹp trai', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (22, 10, 'Lý', 'Hà Nội', 3, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (23, 2, 'Sử', 'TPHCM', 3, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (8, 5, 'Sinh', 'Lào Cai', 2, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (23, 2, 'Tiếng Anh', 'Quảng Trị', 3, 'Chưa có gia sư', 'Gia sư có kinh nghiệm', 150000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (22, 9, 'Tin', 'Lào Cai', 4, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 150000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (33, 11, 'Công Dân', 'TPHCM', 4, 'Chưa có gia sư', 'Gia sư có kinh nghiệm', 200000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (7, 9, 'Hóa', 'Nghệ An', 2, 'Chưa có gia sư', 'Gia sư có kinh nghiệm', 200000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (16, 11, 'Tin', 'Quảng Bình', 3, 'Chưa có gia sư', 'Gia sư nam đẹp trai', 350000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (18, 8, 'Hóa', 'Nha Trang', 1, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 200000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (9, 10, 'Toán', 'Lào Cai', 2, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 200000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (33, 2, 'Lý', 'TPHCM', 1, 'Chưa có gia sư', 'Gia sư nam đẹp trai', 200000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (28, 10, 'Toán', 'Nha Trang', 1, 'Chưa có gia sư', 'Gia sư có kinh nghiệm', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (23, 4, 'Địa', 'Bắc Giang', 1, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 350000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (12, 10, 'Lý', 'Nha Trang', 3, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 250000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (33, 8, 'Sử', 'Nghệ An', 3, 'Chưa có gia sư', 'Gia sư có kinh nghiệm', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (23, 12, 'Sinh', 'Nha Trang', 4, 'Chưa có gia sư', 'Gia sư có kinh nghiệm', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (31, 2, 'Địa', 'Hà Nội', 1, 'Chưa có gia sư', 'Gia sư có kinh nghiệm', 350000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (26, 4, 'Toán', 'Nghệ An', 1, 'Chưa có gia sư', 'Gia sư nam đẹp trai', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (33, 7, 'Sinh', 'Đà Nẵng', 4, 'Chưa có gia sư', 'Gia sư nam đẹp trai', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (10, 9, 'Tin', 'Lào Cai', 1, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 350000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (23, 5, 'Lý', 'Hà Tĩnh', 1, 'Chưa có gia sư', 'Gia sư nam đẹp trai', 150000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (35, 4, 'Sử', 'Nghệ An', 2, 'Chưa có gia sư', 'Gia sư nam đẹp trai', 200000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (27, 1, 'Lý', 'Hà Tĩnh', 1, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (24, 2, 'Địa', 'Quảng Trị', 3, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 250000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (31, 1, 'Toán', 'Nghệ An', 2, 'Chưa có gia sư', 'Gia sư nam đẹp trai', 250000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (31, 8, 'Sinh', 'Quảng Bình', 1, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (10, 3, 'Sử', 'Bắc Giang', 2, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 300000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (16, 12, 'Hóa', 'Bắc Ninh', 3, 'Chưa có gia sư', 'Gia sư nam đẹp trai', 250000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (19, 8, 'Lý', 'Đà Nẵng', 3, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 300000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (20, 8, 'Địa', 'Khánh Hòa', 4, 'Chưa có gia sư', 'Gia sư có kinh nghiệm', 150000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (27, 6, 'Hóa', 'Bắc Giang', 1, 'Chưa có gia sư', 'Gia sư nam đẹp trai', 150000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (36, 12, 'Địa', 'Hà Tĩnh', 4, 'Chưa có gia sư', 'Gia sư nam đẹp trai', 350000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (22, 10, 'Công Dân', 'TPHCM', 4, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 200000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (8, 7, 'Văn', 'Hà Tĩnh', 4, 'Chưa có gia sư', 'Gia sư có kinh nghiệm', 200000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (23, 12, 'Hóa', 'Bắc Ninh', 3, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 250000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (16, 4, 'Văn', 'Đà Nẵng', 1, 'Chưa có gia sư', 'Gia sư có kinh nghiệm', 350000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (22, 11, 'Công Dân', 'Bắc Giang', 1, 'Chưa có gia sư', 'Gia sư có kinh nghiệm', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (20, 2, 'Sinh', 'Bắc Giang', 1, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 200000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (18, 1, 'Địa', 'Hà Tĩnh', 4, 'Chưa có gia sư', 'Gia sư nam đẹp trai', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (14, 6, 'Lý', 'Quảng Bình', 2, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 150000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (7, 3, 'Công Dân', 'Nghệ An', 1, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (23, 2, 'Lý', 'Hà Nội', 4, 'Chưa có gia sư', 'Gia sư nữ xinh xắn', 150000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (12, 12, 'Toán', 'Ninh Bình', 4, 'Chưa có gia sư', 'Gia sư có kinh nghiệm', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (36, 8, 'Văn', 'Nha Trang', 4, 'Chưa có gia sư', 'Gia sư có kinh nghiệm', 250000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (26, 2, 'Toán', 'TPHCM', 3, 'Chưa có gia sư', 'Gia sư có kinh nghiệm', 350000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (34, 10, 'Toán', 'Ninh Bình', 4, 'Chưa có gia sư', 'Gia sư có kinh nghiệm', 350000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (23, 6, 'Tin', 'Khánh Hòa', 2, 'Chưa có gia sư', 'Gia sư nam đẹp trai', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (31, 4, 'Công Dân', 'Hà Nội', 4, 'Chưa có gia sư', 'Gia sư nam đẹp trai', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (13, 12, 'Sinh', 'Khánh Hòa', 2, 'Chưa có gia sư', 'Gia sư có kinh nghiệm', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (12, 10, 'Tin', 'Khánh Hòa', 3, 'Chưa có gia sư', 'Gia sư nam đẹp trai', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, price) values (8, 4, 'Văn', 'Hòa Bình', 2, 'Chưa có gia sư', 'Gia sư nam đẹp trai', 300000);
