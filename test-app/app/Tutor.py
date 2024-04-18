from db_config import *
from User import *
from Utils import *

class Tutor(User, Utils):
    @staticmethod
    def Class():
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("SELECT * FROM classes WHERE status = 'Chưa có gia sư'")
        new_classes = cursor.fetchall()
        cursor.close()
        return render_template('tutor/class.html', new_classes=new_classes)