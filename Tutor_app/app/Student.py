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

