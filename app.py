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
        cur.execute(f"SELECT employee_name FROM employee WHERE id = {id} limit 1")
        print(cur.fetchone())
        if not id:
            flash('ID is required!')
            return redirect(url_for('shift'))
        if cur.fetchone() is None or cur.fetchone()[0] == name:
            flash('You\'re not an employee')
            return redirect(url_for('shift'))
        else:
            t = datetime.now().hour
            day = datetime.now().date().isoformat()
            shift = 2
            if 8 <= t <= 14:
                shift = 1
            cur.execute(
                "INSERT INTO shift (date, employee_id, shift_number) values (%s, %s, %s) ON CONFLICT DO NOTHING",
                (day, id, shift))
            conn.commit()
            return redirect(url_for('transactions'))

    return render_template('shift.html')


@app.route('/transactions/', methods=['POST'])
def transactions():
    return render_template('transactions.html')


@app.route('/expired_drugs/<int:branch_id>', methods=['GET'])
def expired_drugs(branch_id):
    """
    Fetch and display all expired drugs for a specific branch.
    """
    try:
        # Call the SQL function to get expired drugs
        cur.execute("SELECT * FROM expired(%s)", (branch_id,))
        expired_drugs = cur.fetchall()

        # Render results in a template
        return render_template('expired_drugs.html', expired_drugs=expired_drugs, branch_id=branch_id)
    except Exception as e:
        flash(f"Error retrieving expired drugs: {e}", "error")
        return redirect(url_for('index'))


@app.route('/api/search_drug', methods=['GET'])
def search_drug():
    query = request.args.get('query')
    cur.execute("SELECT id, drug_name FROM drugs WHERE drug_name ILIKE %s OR id::text = %s LIMIT 1",
                (f"%{query}%", query))
    drug = cur.fetchone()
    if drug:
        return {'id': drug[0], 'name': drug[1]}
    return {}


# somehow the process transaction in front end doesnt work properly
@app.route('/api/process_transaction', methods=['POST'])
def process_transaction():
    data = request.get_json()
    cart = data.get('cart', [])
    try:
        for item in cart:
            cur.execute("SELECT make_purchase(%s, %s, %s, %s, %s)",
                        ('Customer Name', item['drug_id'], 1, 1, item['quantity']))  # Replace with actual parameters
        conn.commit()
        return {'success': True}
    except Exception as e:
        conn.rollback()
        return {'success': False, 'error': str(e)}


@app.route('/cashier')
def cashier():
    return render_template('cashier.html')


# http://127.0.0.1:5000/add_stock?branch_id=1
@app.route('/add_stock', methods=['GET', 'POST'])
def add_stock():
    branch_id = request.args.get('branch_id')
    if not branch_id:
        flash('Branch ID is required!', 'danger')
        return redirect(url_for('index'))

    if request.method == 'POST':

        drug_id = request.form['drug_id']
        drug_name = request.form['drug_name']
        amount = request.form['amount']
        expiration_date = request.form['expiration_date']

        try:
            cur.execute("SELECT add_stock(%s, %s, %s, %s, %s)",
                        (drug_id, drug_name, branch_id, amount, expiration_date))
            result = cur.fetchone()[0]  # Fetch the result of the function

            conn.commit()

            flash(result, 'success')
        except Exception as e:
            conn.rollback()
            flash(f'Error: {str(e)}', 'danger')

        return redirect(url_for('add_stock', branch_id=branch_id))

    return render_template('add_stock.html', branch_id=branch_id)


@app.route('/login', methods=['GET', 'POST'])
def login():
    return render_template('login.html')


# Homepage Route
@app.route('/home/<int:branch_id>')
def home(branch_id):
    # if 'employee_id' not in session:
    #     return redirect(url_for('login'))
    #    cur.execute("SELECT s.drug_id, d.drug_name, d.brand_name, s.amount, s.expiration_date FROM stock as s right JOIN drugs as d ON s.drug_id = d.id where s.branch_id=%s", (branch_id,))
    cur.execute(" SELECT s.drug_id , d.drug_name, amount, expiration_date FROM stock as s inner join drugs as d on s.drug_id = d.id where branch_id = %s ORDER BY expiration_date", (branch_id,))
    stock = cur.fetchall()
    return render_template('home.html', stock=stock, branch_id = branch_id)


# Sign Out Route
@app.route('/signout', methods=['POST'])
def signout():
    # session.pop('employee_id', None)
    # session.pop('branch_id', None)
    return redirect(url_for('login'))


# Purchase Route


# @app.route('/home/<int:branch_id>')
# def home(branch_id):
#     cur.execute("SELECT drug_name, amount, expiration_date FROM stock WHERE branch_id = %s;", (branch_id,))
#     stock = cur.fetchall()
#
#     return render_template('home.html', branch_id=branch_id, stock=stock)


@app.route('/user/<username>')
def profile(username):
    return f'{username}\'s profile'


with app.test_request_context():
    print(url_for('index'))
    print(url_for('shift'))
    print(url_for('transactions', next='/'))

if __name__ == '__main__':
    app.run(debug=True)
