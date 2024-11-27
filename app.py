import flet as ft
import psycopg2

conn = psycopg2.connect(database = "postgres",
                        user = "root",
                        host= 'localhost',
                        password = "dbpass",
                        port = 5432)
cur = conn.cursor()

from flask import Flask, url_for, render_template, request

app = Flask(__name__)


@app.route('/')
def index():
    return render_template('index.html')

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

