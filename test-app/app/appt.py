from db_config import *
from User import *
from Student import *
from Tutor import *
from Utils import *

@app.route('/', methods=['GET', 'POST'])
def login():
    return User.login()

@app.route('/logout')
def logout():
    if session['role'] == 'student':
        return Student.logout()
    else:
        return Tutor.logout()

@app.route('/registerT', methods=['GET', 'POST'])
def registerT():
    return Utils.registerT()

@app.route('/registerS', methods=['GET', 'POST'])
def registerS():
    return Utils.registerS()

@app.route('/home/profile')
def profile():
    return Utils.profile()

@app.route('/home/post', methods=['GET', 'POST'])
def post():
    return Student.post()

@app.route('/home/profile/update_profile', methods=['GET', 'POST'])
def update_profile():
    return Utils.update_profile()

@app.route('/Class')
def Class():
    return Tutor.Class()

@app.route('/home')
def home():
    if not session.get('loggedin'):
        return redirect(url_for('login'))
    return render_template('common/index.html')

# Route để hiển thị thông tin chi tiết của một lớp học
@app.route('/home/post/detail/<int:class_id>', methods=['GET', 'POST'])
def detail(class_id):
    return Tutor.detail(class_id=class_id)

if __name__ == '__main__':
    app.run('0.0.0.0', '5000', debug=True)
