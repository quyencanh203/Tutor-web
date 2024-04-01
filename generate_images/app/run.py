
from flask import Flask, render_template
from flask_sqlalchemy import SQLAlchemy
from flask_login import UserMixin

app = Flask(__name__)
db = SQLAlchemy(app)
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///project.db"
app.config['SECRET_KEY'] = 'thisisasecretkey'

@app.route('/')
def home():
   return render_template('index.html')

@app.route('/login')
def login():
   return render_template('login.html')

@app.route('/register')
def register():
   return render_template('register.html')

if __name__ == '__main__':
   app.run('0.0.0.0', '5000', debug = True)

   