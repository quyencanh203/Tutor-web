from db_config import *

class User:
    @staticmethod
    def login():
        session['loggedin'] = False
        if request.method == 'POST':
            email = request.form['email']
            password = request.form['password'].encode('utf-8')

            cur = mysql.connection.cursor()
            cur.execute("SELECT * FROM users WHERE email = %s", (email,))
            user = cur.fetchone()
            cur.close()

            if user and bcrypt.checkpw(password, user[3].encode('utf-8')):  
                session['loggedin'] = True
                session['user_id'] = user[0]  
                session['name'] = user[1]  
                session['role'] = user[5]
                flash('Logged in successfully!', category='success')
                return redirect(url_for('home'))
            else:
                flash('Incorrect email or password', category='danger')
                return render_template('auth/login.html')

        return render_template('auth/login.html')

    @staticmethod
    def logout():
        session['loggedin'] = False 
        session.pop('loggedin', None)
        session.pop('user_id', None)
        session.pop('name', None)
        flash('Logged out successfully!', category='success')
        return redirect(url_for('login'))