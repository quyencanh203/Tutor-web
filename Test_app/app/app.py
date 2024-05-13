from flask import Flask, render_template, request, redirect, url_for, session, flash, jsonify
from flask_mysqldb import MySQL
import bcrypt
from datetime import datetime
import MySQLdb.cursors
import os
app = Flask(__name__)

# Required
app.config["MYSQL_HOST"] = "localhost"
app.config["MYSQL_PORT"] = 3306 
app.config["MYSQL_USER"] = "root"
app.config["MYSQL_PASSWORD"] = "quan342004q"
app.config["MYSQL_DB"] = "dataq"

app.config["SECRET_KEY"] = 'secret_key'

mysql = MySQL(app)

@app.route('/home')
def home():
    # check loggedin 
    if not session.get('loggedin'):
        return redirect(url_for('login'))
    return render_template('common/index.html')

# class 
@app.route('/Class')
def Class():
   # Truy vấn cơ sở dữ liệu để lấy danh sách các lớp học mới
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute("SELECT * FROM classes WHERE status = 'Chưa có gia sư'")  # Lấy danh sách các lớp học chưa có gia sư
    new_classes = cursor.fetchall()
    cursor.close()

    # Hiển thị thông tin của lớp học mới lên trang của gia sư
    return render_template('tutor/class.html', new_classes=new_classes)

@app.route('/', methods=['GET', 'POST'])
def login():
    session['loggedin'] = False
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password'].encode('utf-8')
        
        # Tạo một connection cursor
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM users WHERE email = %s", (email,))
        user = cur.fetchone()
        cur.close()

        if user and bcrypt.checkpw(password, user[3].encode('utf-8')):  
            # Kiểm tra mật khẩu và vai trò của người dùng
            session['loggedin'] = True
            session['user_id'] = user[0]
            session['name'] = user[1]
            session['role'] = user[5]
            flash('Logged in successfully!', category='success')

            if session['role'] == 'admin':  
                # Nếu người dùng là admin, chuyển hướng đến trang admin.html
                return redirect(url_for('admin'))

            return redirect(url_for('home'))  # Chuyển hướng đến trang home cho các người dùng khác
        else:
            flash('Incorrect email or password', category='danger')
            return render_template('auth/login.html')

    return render_template('auth/login.html')


@app.route('/admin', methods=['GET', 'POST'])
def admin():
    if session['role'] == 'admin':
        if request.method == 'POST':
            # Lấy tutor_id và số tiền từ biểu mẫu gửi đi
            tutor_id = request.form['tutor_id']
            amount = request.form['amount']

            # Xác nhận rằng tutor_id và amount là dữ liệu hợp lệ
            try:
                tutor_id = int(tutor_id)
                amount = int(amount)
            except ValueError:
                flash('Dữ liệu không hợp lệ.', category='danger')
                return redirect(url_for('admin'))

            # Kiểm tra xem tutor_id có tồn tại trong cơ sở dữ liệu không
            cur = mysql.connection.cursor()
            cur.execute("SELECT tutor_id FROM tutor WHERE tutor_id = %s", (tutor_id,))
            tutor = cur.fetchone()
            cur.close()

            if not tutor:
                flash('Gia sư không tồn tại.', category='danger')
                return redirect(url_for('admin'))

            # Cập nhật số tiền trong tài khoản của gia sư
            cur = mysql.connection.cursor()
            cur.execute("UPDATE tutor SET balance = balance + %s WHERE tutor_id = %s", (amount, tutor_id))
            mysql.connection.commit()
            cur.close()

            flash('Cộng tiền thành công.', category='success')
            return redirect(url_for('admin'))

        else:
            # Truy vấn cơ sở dữ liệu để lấy thông tin của tất cả các gia sư từ bảng tutor và thông tin của họ từ bảng users
            cur = mysql.connection.cursor()
            cur.execute("""
                        SELECT u.name, u.email, t.tutor_id, t.phone_tutor, t.date_of_birth_tutor, t.education, t.balance,
                        GROUP_CONCAT(p.img_payment) AS img_payments
                        FROM users u
                        INNER JOIN tutor t ON u.user_id = t.user_id
                        LEFT JOIN payment p ON t.tutor_id = p.tutor_id
                        GROUP BY t.tutor_id
                        """)
            tutors_info = cur.fetchall()
            
            for i in tutors_info:
                print(type(i[7]))
                break
            cur.close()

            # Truyền thông tin của các gia sư vào template admin.html
            return render_template('admin.html', tutors_info=tutors_info)
    else:
        flash('You do not have permission to access this page.', category='danger')
        return redirect(url_for('login'))
    
    
'''
@app.route('/add_balance', methods=['POST'])
def add_balance():
    if request.method == 'POST':
        tutor_id = request.form['tutor_id']
        amount = int(request.form['amount'])
        
        try:
            # Kết nối đến cơ sở dữ liệu
            cursor = mysql.connection.cursor()
            
            # Truy vấn để lấy số dư hiện tại của gia sư
            cursor.execute("SELECT balance FROM tutor WHERE tutor_id = %s", (tutor_id,))
            current_balance = cursor.fetchone()[5]
            
            # Cộng số tiền mới vào số dư hiện tại
            new_balance = current_balance + amount
            
            # Cập nhật số dư mới vào cơ sở dữ liệu
            cursor.execute("UPDATE tutor SET balance = %s WHERE tutor_id = %s", (new_balance, tutor_id))
            
            # Commit thay đổi và đóng kết nối
            mysql.connection.commit()
            cursor.close()
            
            flash('Số tiền đã được cộng vào tài khoản của gia sư', 'success')
            return redirect(url_for('admin'))  # Chuyển hướng về trang admin
        except Exception as e:
            flash('Đã xảy ra lỗi: ' + str(e), 'error')
            return redirect(url_for('admin'))  # Chuyển hướng về trang admin
'''

@app.route('/registerS', methods=['GET', 'POST'])
def registerS():
    if request.method == 'POST':
        name = request.form['name']
        email = request.form['email']
        sex = request.form['sex']
        role = request.form['role']
        password = request.form['password'].encode('utf-8')
        hashed_password = bcrypt.hashpw(password, bcrypt.gensalt()).decode('utf-8')
        phone_student = request.form['phone_student']
        date_of_birth_student = request.form['date_of_birth_student']
        
        get_root_path = app.root_path + "\\static"
        # thêm thư mục vào student
        user_folder = os.path.join(get_root_path, 'images_user', 'students', email, 'avt')
        os.makedirs(user_folder, exist_ok=True)
        # Create cursor
        cur = mysql.connection.cursor()
        try:
            # Execute SQL query to insert user data
            cur.execute("INSERT INTO users (name, email, password, sex, role) VALUES (%s, %s, %s, %s, %s)", (name, email, hashed_password, sex, role))
            
            # Get the ID of the inserted user
            user_id = cur.lastrowid


            # Execute SQL query to insert student data
            cur.execute("INSERT INTO student (user_id, phone_student, date_of_birth_student) VALUES (%s, %s, %s)", (user_id,phone_student, date_of_birth_student))
            
            # Commit the transaction
            mysql.connection.commit()

            # Close the cursor
            cur.close()

            flash('Registered successfully! You can now login.', 'success')
            return redirect(url_for('login'))

        except Exception as e:
            flash('An error occurred while registering. Please try again.', 'danger')
            print(e)
            cur.close()
            return redirect(url_for('registerS'))

    return render_template('auth/registerS.html')

@app.route('/registerT', methods=['GET', 'POST'])
def registerT():
    if request.method == 'POST':
        name = request.form['name']
        email = request.form['email']
        sex = request.form['sex']
        password = request.form['password'].encode('utf-8')
        hashed_password = bcrypt.hashpw(password, bcrypt.gensalt()).decode('utf-8')
        phone_tutor = request.form['phone_tutor']
        date_of_birth_tutor = request.form['date_of_birth_tutor']
        education = request.form['education']
        
        get_root_path = app.root_path + "\\static"
        # thêm thư mục vào tutor
        avt_folder = os.path.join(get_root_path, 'images_user', 'tutors', email, 'avt')
        payment_folder = os.path.join(get_root_path, 'images_user', 'tutors', email, 'payment')

        # Tạo thư mục avt và payment
        os.makedirs(avt_folder, exist_ok=True)
        os.makedirs(payment_folder, exist_ok=True)
        # Create cursor
        cur = mysql.connection.cursor()

        try:
            # Execute SQL query to insert user data
            cur.execute("INSERT INTO users (name, email, password, sex, role) VALUES (%s, %s, %s, %s, 'tutor')", (name, email, hashed_password, sex))
            
            # Get the ID of the inserted user
            user_id = cur.lastrowid

            # Execute SQL query to insert tutor data
            cur.execute("INSERT INTO tutor (user_id, phone_tutor, date_of_birth_tutor, education) VALUES (%s, %s, %s, %s)", (user_id, phone_tutor, date_of_birth_tutor, education))
            
            # Commit the transaction
            mysql.connection.commit()

            # Close the cursor
            cur.close()

            flash('Registered successfully! You can now login.', 'success')
            return redirect(url_for('login'))

        except Exception as e:
            flash('An error occurred while registering. Please try again.', 'danger')
            print(e)
            cur.close()
            return redirect(url_for('registerT'))

    return render_template('auth/registerT.html')


@app.route('/logout')
def logout():
    session['loggedin'] = False 
    session.pop('loggedin', None)
    session.pop('id', None)
    session.pop('name', None)
    flash('Logged out successfully!', category = 'success')
    return redirect(url_for('login'))


# profile 
@app.route('/home/profile')
def profile():
    # Kết nối đến cơ sở dữ liệu
    cur = mysql.connection.cursor()
    
    user_id = session['user_id']
    
    # Truy vấn dữ liệu từ bảng người dùng
    cur.execute("SELECT * FROM users WHERE user_id = %s", (user_id,))
    user = cur.fetchone()

    if session['role'] == 'tutor':
        # Truy vấn dữ liệu từ bảng tutor
        cur.execute("SELECT * FROM tutor WHERE user_id = %s", (user_id,))
        tutor = cur.fetchone()
    
        # Đóng kết nối
        cur.close()
        
        # Trả về trang profile và truyền dữ liệu người dùng
        return render_template('common/profile.html', user=user, tutor = tutor)
    elif session['role'] == 'student':
        # Truy vấn dữ liệu từ bảng tutor
        cur.execute("SELECT * FROM student WHERE user_id = %s", (user_id,))
        student = cur.fetchone()
    
        # Đóng kết nối
        cur.close()
        print('student infor : ')
        print(student)
        print('user infor')
        print(user)

        # Trả về trang profile và truyền dữ liệu người dùng
        return render_template('common/profile.html', user=user, student = student)

@app.route("/profile/payment", methods=["GET", "POST"])
def payment():
    if request.method == "POST":
        # Lấy dữ liệu từ form
        amount = request.form["amount"]
        description = request.form["description"]
        proof = request.files["proof"]

        # Kiểm tra xem người dùng đã đăng nhập với vai trò tutor chưa
        if 'user_id' in session:
            user_id = session['user_id']
            cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cur.execute("SELECT tutor_id, email FROM users JOIN tutor ON users.user_id = tutor.user_id WHERE users.user_id = %s", (user_id,))
            tutor = cur.fetchone()
            
            if tutor:
                tutor_email = tutor['email']
                tutor_id = tutor['tutor_id']
                print(tutor_email)
                print(tutor_id)
                print(app.root_path)
                tutor_payment_dir = os.path.join(app.root_path, 'static/images_user/tutors/' + tutor_email + '/payment')
                if not os.path.exists(tutor_payment_dir):
                    os.makedirs(tutor_payment_dir)
                proof_path = os.path.join(tutor_payment_dir, proof.filename)
                print(proof_path)
                proof.save(proof_path)

                # Thêm thông tin thanh toán vào bảng payment
                cur.execute("INSERT INTO payment (tutor_id, amount_paid, date_payment, img_payment) VALUES (%s, %s, %s, %s)",
                            (tutor_id, amount, datetime.now().date(), '..\static/images_user/tutors/' + tutor_email + '/payment/'+proof.filename))
                mysql.connection.commit()
                flash("Thanh toán thành công!")
                return redirect(url_for("home"))  # Chuyển hướng sau khi thanh toán
            else:
                flash("Bạn không có quyền thực hiện thanh toán!")
                return redirect(url_for("home"))  # Chuyển hướng về trang chủ nếu người dùng không phải là tutor

    # Nếu là GET request hoặc nếu có lỗi xảy ra trong POST request, render template payment.html
    return render_template("tutor/payment.html")

# post website
@app.route('/home/post',methods=['GET', 'POST'])
def post():
    # ket no database
    cur = mysql.connection.cursor()

    # lay user_id nguoi dang dang nhap 
    user_id = session['user_id']
    
    # Truy vấn dữ liệu từ bảng người dùng
    cur.execute("SELECT * FROM student WHERE user_id = %s", (user_id,))

    # luu thong tin vao user 
    student = cur.fetchone()
    print(student)
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
# Route để hiển thị thông tin chi tiết của một lớp học
@app.route('/home/post/detail/<int:class_id>', methods=['GET', 'POST'])
def detail(class_id):
    # Kết nối đến cơ sở dữ liệu
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute("SELECT * FROM classes WHERE class_id = %s", (class_id,)) 
    

    # Thực hiện truy vấn SQL để lấy thông tin lớp học từ cơ sở dữ liệu
   
    class_info = cursor.fetchone()
    cursor.close()
    # Trả về trang detail.html với thông tin lớp học được truy vấn từ cơ sở dữ liệu
    return render_template('tutor/detail.html', class_info=class_info)
'''
@app.route('/home/post/detail/<int:class_id>/register', methods=['POST'])
def register_class(class_id):
    # Kiểm tra xem người dùng đã đăng nhập chưa
    if not session.get('loggedin'):
        flash('Bạn phải đăng nhập để đăng kí nhận lớp.', 'danger')
        return redirect(url_for('login'))
    
    # Lấy user_id từ session
    user_id = session.get('user_id')

    # Thực hiện truy vấn SQL để lấy tutor_id từ bảng tutor
    try:
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("SELECT tutor_id FROM tutor WHERE user_id = %s", (user_id,))
        tutor = cursor.fetchone()
        if tutor:
            tutor_id = tutor['tutor_id']
        else:
            flash('Bạn phải là gia sư mới có thể đăng kí nhận lớp.', 'danger')
            return redirect(url_for('Class'))
        
        # Thêm thông tin vào bảng requirement
        cursor.execute("INSERT INTO requirement (tutor_id, class_id) VALUES (%s, %s)", (tutor_id, class_id))
        mysql.connection.commit()
        cursor.close()
        flash('Đăng kí nhận lớp thành công!', 'success')
    except Exception as e:
        flash('Đã xảy ra lỗi khi đăng kí nhận lớp. Vui lòng thử lại.', 'danger')
        print(e)  # In ra lỗi để debug
    
    return redirect(url_for('Class'))
'''
@app.route('/home/post/detail/<int:class_id>/register', methods=['POST'])
def register_class(class_id):
    # Kiểm tra xem người dùng đã đăng nhập chưa
    if not session.get('loggedin'):
        flash('Bạn phải đăng nhập để đăng kí nhận lớp.', 'danger')
        return redirect(url_for('login'))
    
    # Lấy user_id từ session
    user_id = session.get('user_id')

    # Thực hiện truy vấn SQL để lấy tutor_id và giá tiền một buổi từ bảng tutor và class
    try:
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("SELECT tutor_id FROM tutor WHERE user_id = %s", (user_id,))
        tutor = cursor.fetchone()
        if tutor:
            tutor_id = tutor['tutor_id']
        else:
            flash('Bạn phải là gia sư mới có thể đăng kí nhận lớp.', 'danger')
            return redirect(url_for('Class'))

        # Lấy thông tin về giá tiền một buổi từ bảng class
        cursor.execute("SELECT price FROM classes WHERE class_id = %s", (class_id,))
        class_info = cursor.fetchone()
        if class_info:
            price_per_session = class_info['price']
        else:
            flash('Không tìm thấy thông tin lớp học.', 'danger')
            return redirect(url_for('Class'))

        # Tính toán số tiền cần để đăng ký nhận lớp
        required_balance = 0.3 * price_per_session * 10

        # Kiểm tra số dư trong tài khoản của gia sư
        cursor.execute("SELECT balance FROM tutor WHERE tutor_id = %s", (tutor_id,))
        tutor_balance = cursor.fetchone()['balance']

        if tutor_balance < required_balance:
            flash('Bạn chưa đủ tiền trong tài khoản để đăng kí nhận lớp.', 'danger')
            return redirect(url_for('payment'))  # Chuyển hướng về trang nạp thẻ

        # Thêm thông tin vào bảng requirement
        cursor.execute("INSERT INTO requirement (tutor_id, class_id) VALUES (%s, %s)", (tutor_id, class_id))
        mysql.connection.commit()
        cursor.close()
        flash('Đăng kí nhận lớp thành công!', 'success')
    except Exception as e:
        flash('Đã xảy ra lỗi khi đăng kí nhận lớp. Vui lòng thử lại.', 'danger')
        print(e)  # In ra lỗi để debug
    
    return redirect(url_for('Class'))


# dang code 
@app.route('/home/profile/update_profile', methods=['GET', 'POST'])
def update_profile():
    cur = mysql.connection.cursor()
    user_id = session['user_id']

    if request.method == 'POST':
        # Nhận thông tin từ form
        name = request.form['name']
        email = request.form['email']
        phone = request.form['phone']
        date_of_birth = request.form['date_of_birth']
        # Cập nhật thông tin người dùng
        cur.execute("""
            UPDATE users 
            SET name = %s, email = %s
            WHERE user_id = %s
        """, (name, email,  user_id))
        
        if session['role'] == 'student':
            cur.execute("""
                UPDATE student
                SET phone_student = %s, date_of_birth_student = %s
                WHERE  user_id = %s
            """, (phone, date_of_birth,  user_id))

        if session['role'] == 'tutor':
            cur.execute("""
                UPDATE tutor
                SET phone_tutor = %s, date_of_birth_tutor = %s
                WHERE  user_id = %s
            """, (phone, date_of_birth,  user_id))
        
        # Lưu thay đổi
        mysql.connection.commit()

        # Đóng kết nối
        cur.close()

        # Chuyển hướng về trang profile sau khi cập nhật
        return redirect(url_for('profile'))

    elif request.method == 'GET':
        # Truy vấn thông tin người dùng hiện tại
        cur.execute("SELECT * FROM users WHERE user_id = %s", (user_id,))
        user = cur.fetchone()

        # Đóng kết nối
        cur.close()

        return render_template('common/update_profile.html', user=user)


@app.route('/my_post', methods=['GET'])
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



@app.route('/list_tutor/<int:class_id>')
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

@app.route('/select_tutor/<int:class_id>/<int:tutor_id>', methods=['POST'])
def select_tutor(class_id, tutor_id):
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    try:
        # Truy vấn giá tiền một buổi học từ cơ sở dữ liệu
        cursor.execute("SELECT price FROM classes WHERE class_id = %s", (class_id,))
        price_info = cursor.fetchone()
        if price_info:
            price_per_session = price_info['price']
            # Tính toán số tiền cần trừ từ tài khoản của gia sư
            amount_to_deduct = 0.3 * price_per_session * 10
            # Cập nhật số tiền trong tài khoản của gia sư
            cursor.execute("UPDATE tutor SET balance = balance - %s WHERE tutor_id = %s", (amount_to_deduct, tutor_id))
            mysql.connection.commit()
            # Cập nhật thông tin vào bảng classes
            cursor.execute("UPDATE classes SET tutor_id = %s, status = 'Đã có gia sư' WHERE class_id = %s", (tutor_id, class_id))
            mysql.connection.commit()
            flash('Bạn đã chọn gia sư thành công!', 'success')
        else:
            flash('Không tìm thấy thông tin về giá tiền của lớp học.', 'error')
    except Exception as e:
        print("Error:", e)
        mysql.connection.rollback()
        flash('Đã xảy ra lỗi, không thể chọn gia sư!', 'error')
    finally:
        cursor.close()
    return redirect(url_for('list_tutor', class_id=class_id))



'''
@app.route('/select_tutor/<int:class_id>/<int:tutor_id>', methods=['POST'])
def select_tutor(class_id, tutor_id):
    if request.method == 'POST':
        # Cập nhật bảng classes với tutor_id được chọn
        cursor = mysql.connection.cursor()
        cursor.execute("UPDATE classes SET tutor_id = %s WHERE class_id = %s", (tutor_id, class_id))
        mysql.connection.commit()
        cursor.close()
        flash('Gia sư đã được chọn thành công', 'success')
        return redirect(url_for('view_class', class_id=class_id))
    else:
        flash('Lỗi trong quá trình chọn gia sư', 'error')
        return redirect(url_for('list_tutor', class_id=class_id))

'''

if __name__ == '__main__':
    app.run('0.0.0.0', '5000', debug=True)

