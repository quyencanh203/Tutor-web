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
    
    @staticmethod
    def detail(class_id):
        # Kết nối đến cơ sở dữ liệu
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute("SELECT * FROM classes WHERE class_id = %s", (class_id,)) 
        
    
        # Thực hiện truy vấn SQL để lấy thông tin lớp học từ cơ sở dữ liệu
       
        class_info = cursor.fetchone()
        cursor.close()
        # Trả về trang detail.html với thông tin lớp học được truy vấn từ cơ sở dữ liệu
        return render_template('tutor/detail.html', class_info=class_info)