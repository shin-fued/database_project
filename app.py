import flet as ft
import psycopg2
from datetime import datetime

from flask import Flask, url_for, render_template, request, flash, redirect
from sqlalchemy import text
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import create_engine, func
from sqlalchemy.orm import Session

conn = psycopg2.connect(database="pharmacy_db_loob",
                                        user="pharmacy_db_loob_user",
                                        host='dpg-ct22pcm8ii6s73fk6lo0-a.oregon-postgres.render.com',
                                        password="gFTd7aJRHHb8PYJ6FqcqDOomdSwkQbjv",
                                        port=5432)
cur = conn.cursor()

app = Flask(__name__)
app.secret_key = "12345"


@app.route('/')
def index():
    return render_template('index.html')

@app.route('/shift/', methods=('GET', 'POST'))
def shift():
    if request.method == 'POST':
        id = request.form['id']
        name = request.form['name']
        cur.execute("SELECT employee_name FROM employee WHERE id = {0}".format(id))
        if not id:
            flash('ID is required!')
            return redirect(url_for('shift'))
        if cur.fetchone()[0]==name:
            flash('You\'re not an employee')
            return redirect(url_for('shift'))
        else:
            t = datetime.now().hour
            day = datetime.now().date().isoformat()
            shift = 2
            if 8 <= t <=14:
                shift = 1
            cur.execute("INSERT INTO shift (date, employee_id, shift_number) values (%s, %s, %s) ON CONFLICT DO NOTHING", (day, id, shift))
            conn.commit()
            return redirect(url_for('transactions'))

    return render_template('shift.html')


@app.route('/transactions/')
def transactions():
    return render_template('transactions.html')

@app.route('/user/<username>')
def profile(username):
    return f'{username}\'s profile'

with app.test_request_context():
    print(url_for('index'))
    print(url_for('shift'))
    print(url_for('transactions', next='/'))

if __name__ == '__main__':
    app.run(debug=True)

