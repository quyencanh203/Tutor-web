from db_config import *
from User import *


class Admin(User):
    @staticmethod
    def admin():
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM users")
        users = cur.fetchall()
        cur.close()
        
        if 'role' in session and session['role'] == 'admin':
            if request.method == 'POST':
                if 'tutor_id' in request.form and 'amount' in request.form:
                    # Xử lý cộng tiền cho gia sư
                    tutor_id = request.form['tutor_id']
                    amount = request.form['amount']
                    try:
                        tutor_id = int(tutor_id)
                        amount = int(amount)
                    except ValueError:
                        flash('Dữ liệu không hợp lệ.', category='danger')
                        return redirect(url_for('admin'))

                    cur = mysql.connection.cursor()
                    cur.execute("SELECT tutor_id FROM tutor WHERE tutor_id = %s", (tutor_id,))
                    tutor = cur.fetchone()
                    cur.close()

                    if not tutor:
                        flash('Gia sư không tồn tại.', category='danger')
                        return redirect(url_for('admin'))

                    cur = mysql.connection.cursor()
                    cur.execute("UPDATE tutor SET balance = balance + %s WHERE tutor_id = %s", (amount, tutor_id))
                    mysql.connection.commit()
                    cur.close()

                    flash('Cộng tiền thành công.', category='success')
                    return redirect(url_for('admin'))

                elif 'user_id' in request.form:
                    # Xử lý xóa tài khoản
                    user_id = request.form['user_id']
                    try:
                        user_id = int(user_id)
                    except ValueError:
                        flash('Dữ liệu không hợp lệ.', category='danger')
                        return redirect(url_for('admin'))

                    cur = mysql.connection.cursor()

                    # Xóa các bản ghi liên quan trong bảng `tutor`
                    cur.execute("DELETE FROM tutor WHERE user_id = %s", (user_id,))
                    # Xóa các bản ghi liên quan trong bảng `student`
                    cur.execute("DELETE FROM student WHERE user_id = %s", (user_id,))
                    # Xóa tài khoản người dùng từ bảng `users`
                    cur.execute("DELETE FROM users WHERE user_id = %s", (user_id,))
                    mysql.connection.commit()
                    cur.close()
                    flash('Xóa tài khoản thành công.', category='danger')
                    return redirect(url_for('admin'))

            else:
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
                cur.close()

                return render_template('admin.html', tutors_info=tutors_info, users=users)
        else:
            flash('You do not have permission to access this page.', category='danger')
            return redirect(url_for('login'))

    # @staticmethod
    # def admin():
            
    #     if session['role'] == 'admin':
    #         # ----------
    #         cur = mysql.connection.cursor()
    #         cur.execute("SELECT * FROM users")
    #         users = cur.fetchall()  # Sử dụng fetchall() để lấy tất cả các dòng
    #         cur.close()
    #         print("____users_____")
    #         print(users)
    #         # -----------
    #         if request.method == ['GET', 'POST']:
                
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
    #             cur.execute(
    #                 "SELECT tutor_id FROM tutor WHERE tutor_id = %s", (tutor_id,))
    #             tutor = cur.fetchone()
    #             cur.close()
                
    #             if not tutor:
    #                 flash('Gia sư không tồn tại.', category='danger')
    #                 return redirect(url_for('admin'))

    #             # Cập nhật số tiền trong tài khoản của gia sư
    #             cur = mysql.connection.cursor()
    #             cur.execute(
    #                 "UPDATE tutor SET balance = balance + %s WHERE tutor_id = %s", (amount, tutor_id))
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
    #             return render_template('admin.html', tutors_info=tutors_info, users=users)
    #     else:
    #         flash('You do not have permission to access this page.',
    #               category='danger')
    #         return redirect(url_for('login'))

    # @staticmethod
    # def drop_user():
    #     if request.method == 'POST':
    #         user_id = request.form['user_id']
    #         cur = mysql.connection.cursor()
    #         try:
    #             # Execute the SQL query to delete the user
    #             cur.execute('DELETE FROM users WHERE user_id = %s', (user_id,))
    #             mysql.connection.commit()
    #             flash('User deleted successfully', 'success')
    #         except Exception as e:
    #             mysql.connection.rollback()
    #             flash(f'Error deleting user: {str(e)}', 'danger')
    #         finally:
    #             cur.close()
    #         return redirect(url_for('admin'))  # Redirect to the index page or any other page



