from db_config import *
from User import *
from Utils import *

class Student(User, Utils):
    @staticmethod
    def post():
        cur = mysql.connection.cursor()
        user_id = session['user_id']

        cur.execute("SELECT * FROM student WHERE user_id = %s", (user_id,))
        student = cur.fetchone()
        cur.close()

        if request.method == 'POST':
            student_id = student[0]
            class_student = request.form['class_student']
            subject = request.form['subject']
            address = request.form['address']
            booking_date = datetime.now()
            price = request.form['price']
            description = request.form['description']

            cursor = mysql.connection.cursor()
            cursor.execute('INSERT INTO classes (student_id, class_student, subject, address, status, description, booking_date, price) VALUES (%s, %s, %s ,%s, %s, %s, %s, %s)', (student_id, class_student, subject, address, 'Chưa có gia sư', description,booking_date, price))
            mysql.connection.commit()
            cursor.close()

        return render_template('student/post.html')
    @staticmethod
    def my_post():
        # Kiểm tra xem người dùng đã đăng nhập chưa
        if 'loggedin' not in session:
            flash('Bạn cần đăng nhập để xem các lớp học của mình.', 'danger')
            return redirect(url_for('login'))
        
        # Lấy user_id từ session
        user_id = session['user_id']

        try:
            # Thực hiện truy vấn từ bảng student để lấy student_id
            cursor = mysql.connection.cursor()
            cursor.execute("SELECT student_id FROM student WHERE user_id = %s", (user_id,))
            student_data = cursor.fetchone()
            if student_data:
                student_id = student_data[0]  # Lấy student_id từ kết quả truy vấn
                # Thực hiện truy vấn từ bảng classes để lấy danh sách các lớp học của học viên
                cursor.execute("SELECT * FROM classes WHERE student_id = %s", (student_id,))
                student_classes = cursor.fetchall()
                cursor.close()
                print(student_classes[0][0])
                # Trả về template để hiển thị danh sách các lớp học của học viên
                return render_template('student/my_post.html', student_classes=student_classes)
            else:
                flash('Không tìm thấy thông tin học viên.', 'danger')
                return redirect(url_for('home'))
        except Exception as e:
            flash('Đã xảy ra lỗi khi tải danh sách các lớp học của bạn.', 'danger')
            print(e)  # In ra lỗi để debug
            return redirect(url_for('home'))
    @staticmethod
    def list_tutor(class_id):
        # Truy vấn cơ sở dữ liệu để lấy danh sách các tutor_id từ bảng requirement
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("SELECT tutor_id FROM requirement WHERE class_id = %s", (class_id,))
        tutor_ids = cursor.fetchall()
        # Khởi tạo danh sách chứa thông tin của các gia sư
        tutors_info = []

        # Lặp qua từng tutor_id để lấy thông tin từ bảng users và bảng tutor
        for tutor_id in tutor_ids:
            cursor.execute("SELECT t.tutor_id, u.user_id, u.name, u.sex, t.phone_tutor, t.education FROM users u INNER JOIN tutor t ON u.user_id = t.user_id WHERE t.tutor_id = %s", (tutor_id['tutor_id'],))
            tutor_info = cursor.fetchone()
            tutors_info.append(tutor_info)
            print(tutor_info)
        cursor.close()

        # Trả về dữ liệu cho template để hiển thị
        return render_template('student/list_tutor.html', tutors_info=tutors_info, class_id=class_id)
    
    @staticmethod
    def select_tutor(class_id, tutor_id):
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        try:
            # Cập nhật thông tin vào bảng classes
            cursor.execute("UPDATE classes SET tutor_id = %s, status = 'Đã có gia sư' WHERE class_id = %s", (tutor_id, class_id))
            mysql.connection.commit()
            flash('Bạn đã chọn gia sư thành công!', 'success')
        except Exception as e:
            print("Error:", e)
            mysql.connection.rollback()
            flash('Đã xảy ra lỗi, không thể chọn gia sư!', 'error')
        finally:
            cursor.close()
        return redirect(url_for('list_tutor', class_id=class_id))


