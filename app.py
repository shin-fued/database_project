import flet as ft
import psycopg2
from datetime import datetime

from flask import Flask, url_for, render_template, request, flash, redirect
from sqlalchemy import text
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import create_engine

app = Flask(__name__)

conn = psycopg2.connect(database="postgres",
                                        user="root",
                                        host='localhost',
                                        password="dbpass",
                                        port=5432)
cur = conn.cursor()


@app.route('/')
def index():
    return render_template('index.html')

@app.route('/shift/', methods=('GET', 'POST'))
def shift():
    if request.method == 'POST':
        id = request.form['id']

        if not id:
            flash('ID is required!')
        else:
            t = datetime.now().hour
            day = datetime.now().date().isoformat()
            shift = 2
            if 8 <= t <=14:
                shift = 1
                cur.execute("INSERT INTO shift (date, employee_id, shift_number) values (%s, %s, %s)", (day, id, shift))
                conn.commit()
            return redirect(url_for('index'))

    return render_template('shift.html')


@app.route('/login')
def login():
    return 'login'

@app.route('/user/<username>')
def profile(username):
    return f'{username}\'s profile'

with app.test_request_context():
    print(url_for('index'))
    print(url_for('login'))
    print(url_for('login', next='/'))
    print(url_for('profile', username='John Doe'))

if __name__ == '__main__':
    app.run(debug=True)

