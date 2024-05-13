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
  `balance` int
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
