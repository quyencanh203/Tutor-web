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
                if session['role'] == 'admin':  
                # Nếu người dùng là admin, chuyển hướng đến trang admin.html
                    return redirect(url_for('admin'))
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
        session.clear()
        flash('Logged out successfully!', category='success')

        # return redirect(url_for('login'))
        return render_template('backgroup_app.html')

        
    
    # @staticmethod
    # def admin():
    #     if session['role'] == 'admin':
    #         if request.method == 'POST':
    #             # Lấy tutor_id và số tiền từ biểu mẫu gửi đi
    #             tutor_id = request.form['tutor_id']
    #             amount = request.form['amount']

    #             # Xác nhận rằng tutor_id và amount là dữ liệu hợp lệ
    #             try:
    #                 tutor_id = int(tutor_id)
    #                 amount = int(amount)
    #             except ValueError:
    #                 flash('Dữ liệu không hợp lệ.', category='danger')
    #                 return redirect(url_for('admin'))

    #             # Kiểm tra xem tutor_id có tồn tại trong cơ sở dữ liệu không
    #             cur = mysql.connection.cursor()
    #             cur.execute("SELECT tutor_id FROM tutor WHERE tutor_id = %s", (tutor_id,))
    #             tutor = cur.fetchone()
    #             cur.close()

    #             if not tutor:
    #                 flash('Gia sư không tồn tại.', category='danger')
    #                 return redirect(url_for('admin'))

    #             # Cập nhật số tiền trong tài khoản của gia sư
    #             cur = mysql.connection.cursor()
    #             cur.execute("UPDATE tutor SET balance = balance + %s WHERE tutor_id = %s", (amount, tutor_id))
    #             mysql.connection.commit()
    #             cur.close()

    #             flash('Cộng tiền thành công.', category='success')
    #             return redirect(url_for('admin'))

    #         else:
    #             # Truy vấn cơ sở dữ liệu để lấy thông tin của tất cả các gia sư từ bảng tutor và thông tin của họ từ bảng users
    #             cur = mysql.connection.cursor()
    #             cur.execute("""
    #                         SELECT u.name, u.email, t.tutor_id, t.phone_tutor, t.date_of_birth_tutor, t.education, t.balance,
    #                         GROUP_CONCAT(p.img_payment) AS img_payments
    #                         FROM users u
    #                         INNER JOIN tutor t ON u.user_id = t.user_id
    #                         LEFT JOIN payment p ON t.tutor_id = p.tutor_id
    #                         GROUP BY t.tutor_id
    #                         """)
    #             tutors_info = cur.fetchall()
                
    #             for i in tutors_info:
    #                 print(type(i[7]))
    #                 break
    #             cur.close()

    #             # Truyền thông tin của các gia sư vào template admin.html
    #             return render_template('admin.html', tutors_info=tutors_info)
    #     else:
    #         flash('You do not have permission to access this page.', category='danger')
    #         return redirect(url_for('login'))

