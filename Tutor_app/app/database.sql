use dataq;
CREATE TABLE users (
  user_id int PRIMARY KEY AUTO_INCREMENT,
  name varchar(255),
  email varchar(100),
  password varchar(255),
  sex enum('male','female'),
  role enum('student','tutor','admin'), 
   avatar varchar(255)
);


CREATE TABLE tutor (
  tutor_id int PRIMARY KEY AUTO_INCREMENT,
  user_id int,
  phone_tutor varchar(11),
  date_of_birth_tutor date,
  education text,
  balance int DEFAULT 0
);

CREATE TABLE student (
  student_id int PRIMARY KEY AUTO_INCREMENT,
  user_id int,
  phone_student varchar(11),
  date_of_birth_student date
);

CREATE TABLE classes (
  class_id int PRIMARY KEY AUTO_INCREMENT,
  student_id int,
  tutor_id int,
  class_student int,
  subject varchar(255),
  address varchar(255),
  session_of_per_week int,
  status enum('Chưa có gia sư','Đã có gia sư'),
  description text,
  booking_date date,
  price int
);

CREATE TABLE requirement (
  requirement_id int PRIMARY KEY AUTO_INCREMENT,
  tutor_id int,
  class_id int
);

CREATE TABLE payment (
  payment_id int PRIMARY KEY AUTO_INCREMENT,
  tutor_id int,
  amount_paid int,
  date_payment date,
  img_payment varchar(255)
);

ALTER TABLE student ADD FOREIGN KEY (user_id) REFERENCES users (user_id);

ALTER TABLE tutor ADD FOREIGN KEY (user_id) REFERENCES users (user_id);

ALTER TABLE classes ADD FOREIGN KEY (student_id) REFERENCES student (student_id);

ALTER TABLE classes ADD FOREIGN KEY (tutor_id) REFERENCES tutor (tutor_id);

ALTER TABLE requirement ADD FOREIGN KEY (tutor_id) REFERENCES tutor (tutor_id);

ALTER TABLE requirement ADD FOREIGN KEY (class_id) REFERENCES classes (class_id);

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

insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (15, 1, 'Tin', 'Ninh Thuận', 2, 'Chưa có gia sư', 'CTU', '2024-01-30', 180000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (20, 9, 'Tiếng Anh', 'Sóc Trăng', 4, 'Chưa có gia sư', 'BA', '2024-01-20', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (9, 8, 'Sinh', 'Bắc Kạn', 1, 'Chưa có gia sư', 'CTU', '2024-04-12', 150000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (16, 9, 'Văn', 'Sơn La', 4, 'Chưa có gia sư', 'MIT', '2024-05-02', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (1, 5, 'Sinh', 'Bắc Giang', 4, 'Chưa có gia sư', 'NEU', '2023-10-10', 300000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (13, 9, 'Tiếng Anh', 'Lạng Sơn', 2, 'Chưa có gia sư', 'HUST', '2023-07-24', 350000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (3, 10, 'Hóa', 'Cần Thơ', 3, 'Chưa có gia sư', 'HUST', '2024-04-23', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (14, 6, 'Tin', 'Hải Phòng', 4, 'Chưa có gia sư', 'TMU', '2023-12-06', 150000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (25, 7, 'Lý', 'Bình Định', 4, 'Chưa có gia sư', 'CTU', '2023-10-12', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (30, 6, 'Văn', 'Lạng Sơn', 1, 'Chưa có gia sư', 'HUST', '2023-08-27', 250000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (8, 1, 'Hóa', 'Hồ Chí Minh', 2, 'Chưa có gia sư', 'HCMUS', '2023-12-07', 150000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (27, 4, 'Lý', 'Cần Thơ', 3, 'Chưa có gia sư', 'UTC', '2024-05-15', 180000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (20, 8, 'Tin', 'Lào Cai', 4, 'Chưa có gia sư', 'UTC', '2023-09-12', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (15, 5, 'Địa Lý', 'Hải Phòng', 1, 'Chưa có gia sư', 'HUST', '2024-01-19', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (12, 8, 'Sinh', 'Thanh Hóa', 2, 'Chưa có gia sư', 'UET', '2023-10-21', 300000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (7, 11, 'Tin', 'Đà Nẵng', 4, 'Chưa có gia sư', 'BA', '2024-04-05', 350000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (25, 10, 'Sinh', 'Cần Thơ', 2, 'Chưa có gia sư', 'FTU', '2023-11-13', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (15, 6, 'Sinh', 'Hồ Chí Minh', 4, 'Chưa có gia sư', 'MIT', '2023-07-14', 180000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (13, 9, 'Công Dân', 'Hòa Bình', 1, 'Chưa có gia sư', 'BA', '2023-07-07', 350000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (22, 9, 'Tin', 'Dĩ An', 4, 'Chưa có gia sư', 'TMU', '2023-09-08', 400000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (13, 4, 'Tiếng Anh', 'Ninh Thuận', 4, 'Chưa có gia sư', 'PTIT', '2023-08-16', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (6, 11, 'Lý', 'Hậu Giang', 1, 'Chưa có gia sư', 'UTC', '2023-12-12', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (15, 10, 'Sinh', 'Gia Lai', 4, 'Chưa có gia sư', 'CTU', '2024-04-29', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (24, 8, 'Tin', 'Hải Phòng', 3, 'Chưa có gia sư', 'TMU', '2023-12-31', 200000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (10, 5, 'Tiếng Anh', 'Tuyên Quang', 1, 'Chưa có gia sư', 'HUST', '2023-07-24', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (2, 8, 'Hóa', 'Bắc Giang', 4, 'Chưa có gia sư', 'UET', '2023-11-06', 350000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (15, 5, 'Công Dân', 'Sóc Trăng', 3, 'Chưa có gia sư', 'PTIT', '2023-07-29', 200000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (28, 1, 'Tin', 'Cao Bằng', 1, 'Chưa có gia sư', 'MIT', '2024-01-29', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (23, 5, 'Văn', 'Đồng Nai', 3, 'Chưa có gia sư', 'HCMUS', '2023-09-04', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (17, 5, 'Sinh', 'Hải Phòng', 3, 'Chưa có gia sư', 'NEU', '2024-05-11', 180000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (13, 5, 'Văn', 'Quảng Nam', 2, 'Chưa có gia sư', 'TMU', '2023-12-28', 250000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (26, 4, 'Tin', 'Dĩ An', 2, 'Chưa có gia sư', 'PTIT', '2023-07-30', 350000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (20, 6, 'Địa Lý', 'Đồng Tháp', 3, 'Chưa có gia sư', 'UTC', '2024-01-18', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (6, 9, 'Tin', 'Đà Nẵng', 1, 'Chưa có gia sư', 'FTU', '2023-09-21', 250000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (11, 11, 'Tiếng Anh', 'Khánh Hòa', 4, 'Chưa có gia sư', 'NEU', '2023-06-10', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (27, 11, 'Lý', 'Sóc Trăng', 4, 'Chưa có gia sư', 'UTC', '2024-02-20', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (19, 5, 'Văn', 'Thanh Hóa', 3, 'Chưa có gia sư', 'MIT', '2023-06-11', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (13, 4, 'Hóa', 'Đồng Tháp', 4, 'Chưa có gia sư', 'UET', '2023-08-24', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (12, 10, 'Địa Lý', 'Lạng Sơn', 3, 'Chưa có gia sư', 'UET', '2024-02-08', 200000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (24, 3, 'Địa Lý', 'Ninh Thuận', 1, 'Chưa có gia sư', 'UET', '2024-05-18', 180000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (5, 3, 'Tin', 'Quảng Nam', 2, 'Chưa có gia sư', 'NEU', '2023-12-15', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (14, 4, 'Tiếng Anh', 'Quảng Bình', 3, 'Chưa có gia sư', 'UET', '2024-03-11', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (13, 2, 'Địa Lý', 'Hải Dương', 2, 'Chưa có gia sư', 'UET', '2024-02-04', 250000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (25, 1, 'Hóa', 'Tuyên Quang', 4, 'Chưa có gia sư', 'TMU', '2024-03-06', 300000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (19, 11, 'Lý', 'Lạng Sơn', 1, 'Chưa có gia sư', 'BA', '2024-01-08', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (3, 11, 'Toán', 'Dĩ An', 4, 'Chưa có gia sư', 'CTU', '2023-05-24', 200000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (22, 7, 'Lý', 'Cần Thơ', 3, 'Chưa có gia sư', 'UTC', '2023-07-15', 350000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (24, 11, 'Hóa', 'Hải Phòng', 3, 'Chưa có gia sư', 'HCMUS', '2024-03-07', 400000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (20, 2, 'Hóa', 'Quảng Nam', 2, 'Chưa có gia sư', 'MIT', '2023-09-07', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (24, 11, 'Lý', 'Lạng Sơn', 1, 'Chưa có gia sư', 'UTC', '2023-06-06', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (29, 12, 'Tiếng Anh', 'Quảng Ninh', 2, 'Chưa có gia sư', 'BA', '2023-09-29', 400000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (12, 2, 'Toán', 'Hải Phòng', 2, 'Chưa có gia sư', 'UET', '2024-02-27', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (6, 9, 'Công Dân', 'Hồ Chí Minh', 1, 'Chưa có gia sư', 'BA', '2024-02-14', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (20, 10, 'Sinh', 'Nghệ An', 2, 'Chưa có gia sư', 'HUST', '2024-02-08', 200000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (16, 1, 'Địa Lý', 'Cao Bằng', 1, 'Chưa có gia sư', 'HUST', '2024-03-13', 150000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (30, 12, 'Văn', 'Lạng Sơn', 3, 'Chưa có gia sư', 'NEU', '2023-09-04', 400000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (17, 9, 'Tin', 'Gia Lai', 4, 'Chưa có gia sư', 'UTC', '2023-07-17', 180000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (5, 11, 'Toán', 'Bình Định', 4, 'Chưa có gia sư', 'MIT', '2023-06-24', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (26, 10, 'Tiếng Anh', 'Lâm Đồng', 1, 'Chưa có gia sư', 'MIT', '2023-07-19', 350000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (2, 11, 'Tin', 'Thừa Thiên Huế', 2, 'Chưa có gia sư', 'NEU', '2023-09-21', 180000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (4, 2, 'Sinh', 'Thái Nguyên', 3, 'Chưa có gia sư', 'UET', '2024-01-04', 250000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (27, 3, 'Tiếng Anh', 'Ninh Thuận', 4, 'Chưa có gia sư', 'CTU', '2023-08-21', 180000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (3, 11, 'Hóa', 'Cần Thơ', 2, 'Chưa có gia sư', 'MIT', '2024-05-04', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (20, 6, 'Tiếng Anh', 'Lạng Sơn', 4, 'Chưa có gia sư', 'PTIT', '2023-06-05', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (3, 9, 'Toán', 'Hòa Bình', 4, 'Chưa có gia sư', 'NEU', '2023-06-18', 300000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (14, 10, 'Công Dân', 'Lạng Sơn', 1, 'Chưa có gia sư', 'PTIT', '2023-05-31', 180000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (1, 1, 'Tiếng Anh', 'Sóc Trăng', 1, 'Chưa có gia sư', 'MIT', '2023-10-02', 400000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (1, 10, 'Lịch Sử', 'Hải Phòng', 1, 'Chưa có gia sư', 'CTU', '2023-09-13', 180000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (28, 6, 'Lý', 'Sóc Trăng', 3, 'Chưa có gia sư', 'BA', '2024-01-01', 350000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (5, 6, 'Hóa', 'Thừa Thiên Huế', 4, 'Chưa có gia sư', 'UET', '2023-11-12', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (1, 3, 'Địa Lý', 'Thanh Hóa', 2, 'Chưa có gia sư', 'HUST', '2023-12-12', 300000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (20, 10, 'Tiếng Anh', 'Đắk Lắk', 2, 'Chưa có gia sư', 'MIT', '2023-12-20', 180000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (27, 7, 'Tin', 'Bắc Giang', 3, 'Chưa có gia sư', 'UET', '2023-06-05', 400000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (11, 2, 'Sinh', 'Thừa Thiên Huế', 3, 'Chưa có gia sư', 'HCMUS', '2023-12-19', 250000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (19, 6, 'Toán', 'Đồng Tháp', 3, 'Chưa có gia sư', 'MIT', '2024-05-10', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (22, 6, 'Tiếng Anh', 'Hà Nội', 3, 'Chưa có gia sư', 'UET', '2023-05-20', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (7, 6, 'Địa Lý', 'Sơn La', 4, 'Chưa có gia sư', 'PTIT', '2024-01-22', 150000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (4, 3, 'Sinh', 'Đồng Tháp', 1, 'Chưa có gia sư', 'BA', '2023-07-17', 300000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (22, 5, 'Công Dân', 'Quảng Nam', 4, 'Chưa có gia sư', 'HUST', '2024-03-19', 250000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (29, 10, 'Địa Lý', 'Quảng Bình', 4, 'Chưa có gia sư', 'UET', '2023-06-10', 150000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (16, 12, 'Lý', 'Bình Định', 4, 'Chưa có gia sư', 'HCMUS', '2023-09-18', 250000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (5, 12, 'Địa Lý', 'Nghệ An', 3, 'Chưa có gia sư', 'MIT', '2023-06-14', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (11, 6, 'Công Dân', 'Lào Cai', 2, 'Chưa có gia sư', 'CTU', '2023-10-14', 400000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (18, 4, 'Tin', 'Bình Định', 4, 'Chưa có gia sư', 'UET', '2023-12-21', 400000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (15, 11, 'Hóa', 'Hà Giang', 3, 'Chưa có gia sư', 'FTU', '2023-10-31', 200000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (23, 5, 'Công Dân', 'Quảng Nam', 2, 'Chưa có gia sư', 'HCMUS', '2023-09-14', 350000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (30, 12, 'Tin', 'Phú Thọ', 2, 'Chưa có gia sư', 'TMU', '2023-11-15', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (19, 2, 'Tin', 'Gia Lai', 4, 'Chưa có gia sư', 'BA', '2024-03-11', 300000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (11, 4, 'Hóa', 'Đồng Tháp', 1, 'Chưa có gia sư', 'UET', '2024-04-15', 250000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (15, 11, 'Toán', 'Lào Cai', 4, 'Chưa có gia sư', 'HUST', '2023-10-20', 100000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (29, 1, 'Công Dân', 'Thừa Thiên Huế', 4, 'Chưa có gia sư', 'NEU', '2023-10-04', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (30, 4, 'Tin', 'Lâm Đồng', 2, 'Chưa có gia sư', 'CTU', '2024-03-08', 150000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (11, 5, 'Toán', 'Cần Thơ', 1, 'Chưa có gia sư', 'TMU', '2023-05-30', 180000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (24, 11, 'Toán', 'Bình Định', 2, 'Chưa có gia sư', 'UTC', '2024-03-19', 150000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (22, 8, 'Lý', 'Cần Thơ', 4, 'Chưa có gia sư', 'BA', '2023-07-03', 180000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (19, 3, 'Công Dân', 'Kiên Giang', 1, 'Chưa có gia sư', 'CTU', '2023-12-26', 400000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (13, 12, 'Tin', 'Sóc Trăng', 4, 'Chưa có gia sư', 'HUST', '2024-01-23', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (26, 3, 'Công Dân', 'Lạng Sơn', 2, 'Chưa có gia sư', 'UET', '2024-05-01', 120000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (27, 2, 'Văn', 'Lâm Đồng', 2, 'Chưa có gia sư', 'MIT', '2024-04-29', 300000);
insert into classes (student_id, class_student, subject, address, session_of_per_week, status, description, booking_date, price) values (15, 6, 'Hóa', 'Ninh Thuận', 3, 'Chưa có gia sư', 'HUST', '2024-04-25', 150000);

