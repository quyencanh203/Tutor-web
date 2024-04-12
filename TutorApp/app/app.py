from flask import Flask, render_template, request, redirect, url_for, session, flash
from flask_mysqldb import MySQL
import bcrypt
from datetime import datetime

app = Flask(__name__)

# Required
app.config["MYSQL_HOST"] = "localhost"
app.config["MYSQL_PORT"] = 3306 
app.config["MYSQL_USER"] = "root"
app.config["MYSQL_PASSWORD"] = ""
app.config["MYSQL_DB"] = "db_tutor"

app.config["SECRET_KEY"] = 'secret_key'

mysql = MySQL(app)

@app.route('/home')
def home():
    # check loggedin 
    if not session.get('loggedin'):
        return redirect(url_for('login'))
    return render_template('index.html')

# class 
@app.route('/Class')
def Class():
    return render_template('class.html')

@app.route('/', methods=['GET', 'POST'])
def login():
    session['loggedin'] = False
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password'].encode('utf-8')

        # creating a connection cursor 
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM users WHERE email = %s", (email,))
        user = cur.fetchone()
        cur.close()

        if user and bcrypt.checkpw(password, user[3].encode('utf-8')):  # Truy cập mật khẩu thông qua chỉ số

           # set session variable
           session['loggedin'] = True
           session['user_id'] = user[0]  # Truy cập id thông qua chỉ số
           session['name'] = user[1]  # Truy cập tên thông qua chỉ số
           session['role'] = user[5]
           flash('Logged in successfully!', category = 'success')
           return redirect(url_for('home'))
        else:
            flash('Incorrect email or password', category = 'danger')
            return render_template('login.html')

    return render_template('login.html')

@app.route('/registerS', methods=['GET', 'POST'])
@app.route('/registerS', methods=['GET', 'POST'])
def registerS():
    if request.method == 'POST':
        name = request.form['name']
        email = request.form['email']
        sex = request.form['sex']
        role = request.form['role']
        password = request.form['password'].encode('utf-8')
        hashed_password = bcrypt.hashpw(password, bcrypt.gensalt()).decode('utf-8')

        # Create cursor
        cur = mysql.connection.cursor()

        try:
            # Execute SQL query to insert user data
            cur.execute("INSERT INTO users (name, email, password, sex, role) VALUES (%s, %s, %s, %s, %s)", (name, email, hashed_password, sex, role))
            
            # Get the ID of the inserted user
            user_id = cur.lastrowid

            # Execute SQL query to insert student data
            cur.execute("INSERT INTO student (user_id) VALUES (%s)", (user_id,))
            
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

    return render_template('registerS.html')


@app.route('/logout')
def logout():
    session['loggedin'] = False 
    session.pop('loggedin', None)
    session.pop('id', None)
    session.pop('name', None)
    flash('Logged out successfully!', category = 'success')
    return redirect(url_for('login'))

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

    return render_template('registerT.html')

@app.route('/home/profile')
def profile():
    # # Kết nối đến cơ sở dữ liệu
    # cur = mysql.connection.cursor()

    # # Truy vấn dữ liệu từ bảng người dùng
    # cur.execute("SELECT * FROM users WHERE id = 1")  # Giả sử id của người dùng là 1
    # user = cur.fetchone()

    # # Đóng kết nối
    # cur.close()
    # cur.close()

    # Trả về trang profile và truyền dữ liệu người dùng
    return render_template('profile.html')


# post website
@app.route('/home/post',methods=['GET', 'POST'])
def post():
    if request.method == 'POST':
        class_student = request.form['class_student']
        subject = request.form['subject']
        address = request.form['address']
        booking_date = datetime.now()
        price = request.form['price']
        description = request.form['description']
        cursor = mysql.connection.cursor()
        cursor.execute('INSERT INTO classes (class_student, subject, address, status, description, booking_date, price) VALUES (%s, %s ,%s, %s, %s, %s, %s)', (class_student, subject, address, 'Chưa có gia sư', description,booking_date, price))
        mysql.connection.commit()
        cursor.close()
    return render_template('post.html')
# dang code 
@app.route('/home/profile/update_profile', methods=['GET', 'POST'])
def update_profile():
    # if request.method == 'POST':

    #     pass
    # # Kết nối đến cơ sở dữ liệu
    # cur = mysql.connection.cursor()

    # cur.execute("SELECT * FROM users WHERE id = 1")

    return render_template('update_profile.html')

if __name__ == '__main__':
    app.run('0.0.0.0', '5000', debug=True)
