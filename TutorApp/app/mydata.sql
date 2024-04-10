CREATE TABLE users (
  user_id int(255) PRIMARY KEY AUTO_INCREMENT,
  name varchar(255),
  email varchar(100),
  password varchar(255),
  sex enum('male','female'),
  role enum('student','tutor')
);

CREATE TABLE tutor (
  tutor_id int(255) PRIMARY KEY AUTO_INCREMENT,
  user_id int(255),
  phone_tutor varchar(11),
  year_of_birth_tutor int(11),
  education text,
  FOREIGN KEY (user_id) REFERENCES users (user_id)
);

CREATE TABLE student (
  student_id int(255) PRIMARY KEY AUTO_INCREMENT,
  user_id int(255),
  phone_student varchar(11),
  address varchar(255),
  year_of_birth_student int(11),
  FOREIGN KEY (user_id) REFERENCES users (user_id)
);

CREATE TABLE booking (
  booking_id int(255) PRIMARY KEY AUTO_INCREMENT,
  student_id int(255),
  tutor_id int(255),
  subject varchar(255),
  class_student int(13),
  booking_date date,
  status_booking enum('Confirm','Pending'),
  price int(255),
  describe_request text,
  FOREIGN KEY (student_id) REFERENCES student (student_id),
  FOREIGN KEY (tutor_id) REFERENCES tutor (tutor_id)
);