
from flask import Flask, render_template, request, redirect, url_for, session, flash
from flask_mysqldb import MySQL
import bcrypt

app = Flask(__name__)

# Required
app.config["MYSQL_HOST"] = "localhost"
app.config["MYSQL_PORT"] = 3307 
app.config["MYSQL_USER"] = "root"
app.config["MYSQL_PASSWORD"] = ""
<<<<<<< HEAD
app.config["MYSQL_DB"] = "mydata"
app.config["SECRET_KEY"] = 'secret_key'
=======
app.config["MYSQL_DB"] = "users_system"
app.config["SECRET_KEY"] = 'secret_key'
# # Extra configs, optional:
# app.config["MYSQL_CURSORCLASS"] = "DictCursor"
# app.config["MYSQL_CUSTOM_OPTIONS"] = {"ssl": {"ca": "/path/to/ca-file"}}  # https://mysqlclient.readthedocs.io/user_guide.html#functions-and-attributes
>>>>>>> main

mysql = MySQL(app)

@app.route('/')
def home():
<<<<<<< HEAD
    # check loggedin 
    if not session.get('loggedin'):
        return redirect(url_for('login'))
=======
>>>>>>> main
    return render_template('index.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password'].encode('utf-8')
<<<<<<< HEAD
        # creating a connection cursor 
=======

>>>>>>> main
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM users WHERE email = %s", (email,))
        user = cur.fetchone()
        cur.close()

        if user and bcrypt.checkpw(password, user[3].encode('utf-8')):  # Truy cập mật khẩu thông qua chỉ số
<<<<<<< HEAD
           # set session variable
=======
>>>>>>> main
           session['loggedin'] = True
           session['id'] = user[0]  # Truy cập id thông qua chỉ số
           session['name'] = user[1]  # Truy cập tên thông qua chỉ số
           flash('Logged in successfully!', 'success')
           return redirect(url_for('home'))
        else:
<<<<<<< HEAD
            flash('Incorrect email or password', category = 'danger')
=======
            flash('Incorrect email or password', 'danger')
>>>>>>> main
            return render_template('login.html')

    return render_template('login.html')

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        name = request.form['name']
        email = request.form['email']
        password = request.form['password'].encode('utf-8')
        hashed_password = bcrypt.hashpw(password, bcrypt.gensalt()).decode('utf-8')

        cur = mysql.connection.cursor()
<<<<<<< HEAD
        
        cur.execute("INSERT INTO users (name, email, password) VALUES (%s, %s, %s)", (name, email, hashed_password))
        # saving the actions performed on the DB 
        mysql.connection.commit()
        # closing the cursor
        cur.close()

        flash('Registered successfully! You can now login.', category = 'success')
=======
        cur.execute("INSERT INTO users (name, email, password) VALUES (%s, %s, %s)", (name, email, hashed_password))
        mysql.connection.commit()
        cur.close()

        flash('Registered successfully! You can now login.', 'success')
>>>>>>> main
        return redirect(url_for('login'))

    return render_template('register.html')

@app.route('/logout')
def logout():
<<<<<<< HEAD
    session['loggedin'] = False 
    session.pop('loggedin', None)
    session.pop('id', None)
    session.pop('name', None)
    flash('Logged out successfully!', category = 'success')
=======
    session.pop('loggedin', None)
    session.pop('id', None)
    session.pop('name', None)
    flash('Logged out successfully!', 'success')
>>>>>>> main
    return redirect(url_for('login'))

if __name__ == '__main__':
    app.run('0.0.0.0', '5000', debug=True)