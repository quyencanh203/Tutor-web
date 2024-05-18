from flask import Flask, render_template, request, redirect, url_for, session, flash
from flask_mysqldb import MySQL
import bcrypt
from datetime import datetime
import MySQLdb.cursors
from flask_socketio import SocketIO
from flask_socketio import emit

app = Flask(__name__)

# Required
app.config["MYSQL_HOST"] = "localhost"
app.config["MYSQL_PORT"] = 3306 
app.config["MYSQL_USER"] = "root" 
app.config["MYSQL_PASSWORD"] = "220303"  
app.config["MYSQL_DB"] = "dataq" 
app.config["SECRET_KEY"] = 'secret_key'

mysql = MySQL(app)
socketio = SocketIO(app)