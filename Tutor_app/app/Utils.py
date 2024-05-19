from db_config import *
import os
class Utils:
    @staticmethod
    def profile():
        cur = mysql.connection.cursor()

        user_id = session['user_id']

        cur.execute("SELECT * FROM users WHERE user_id = %s", (user_id,))
        user = cur.fetchone()

        if session['role'] == 'tutor':
            cur.execute("SELECT * FROM tutor WHERE user_id = %s", (user_id,))
            tutor = cur.fetchone()
            cur.close()
            Utils.get_image(user_id=user_id)
            return render_template('common/profile.html', user=user, tutor=tutor)
        elif session['role'] == 'student':
            cur.execute("SELECT * FROM student WHERE user_id = %s", (user_id,))
            student = cur.fetchone()
            cur.close()
            Utils.get_image(user_id=user_id)
            return render_template('common/profile.html', user=user, student=student)

    @staticmethod
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

            cur = mysql.connection.cursor()

            try:
                cur.execute("INSERT INTO users (name, email, password, sex, role) VALUES (%s, %s, %s, %s, 'tutor')", (name, email, hashed_password, sex))
                user_id = cur.lastrowid
                cur.execute("INSERT INTO tutor (user_id, phone_tutor, date_of_birth_tutor, education) VALUES (%s, %s, %s, %s)", (user_id, phone_tutor, date_of_birth_tutor, education))
                mysql.connection.commit()
                cur.close()

                flash('Registered successfully! You can now login.', 'success')
                return redirect(url_for('login'))

            except Exception as e:
                flash('An error occurred while registering. Please try again.', 'danger')
                print(e)
                cur.close()
                return redirect(url_for('registerT'))

        return render_template('auth/registerT.html')

    @staticmethod
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

    @staticmethod
    def update_profile():
        cur = mysql.connection.cursor()
        user_id = session['user_id']

        if request.method == 'POST':
            name = request.form['name']
            email = request.form['email']
            phone = request.form['phone']
            date_of_birth = request.form['date_of_birth']

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

            mysql.connection.commit()
            cur.close()

            return redirect(url_for('profile'))

        elif request.method == 'GET':
            cur.execute("SELECT * FROM users WHERE user_id = %s", (user_id,))
            user = cur.fetchone()
            cur.close()

            return render_template('common/update_profile.html', user=user)

    @staticmethod
    def Bing_Map() :
        return render_template('map.html')

    @staticmethod
    def backgroup_app():
        return render_template('backgroup_app.html')
    
    @staticmethod
    def get_image(user_id):
        if request.method == 'POST':
            user_id = user_id
            avatar = request.form['avatar']
            cur = mysql.connection.cursor()
            cur.execute('UPDATE users SET avatar = %s WHERE user_id = %s',(avatar, user_id))
            mysql.connection.commit()
            cur.close()
            flash('bạn đã link ảnh giao diện thành công.', category='success')
            return redirect(url_for('profile'))
            # return render_template('common/profile.html')
    
    @staticmethod
    def top_tutor():
        return 0
