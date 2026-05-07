from flask import Blueprint, request, jsonify
from db import get_db_connection
auth_bp = Blueprint('auth', __name__)
#VULNERABLE LOGIN (SQL Injection)
@auth_bp.route('/login', methods=['POST'])
def login():
    data = request.json
    username = data.get("username")
    password = data.get("password")
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    #INTENTIONALLY VULNERABLE QUERY
    query = f"SELECT * FROM users WHERE username = '{username}' AND password = '{password}'"
    print("Executing Query:", query)
    cursor.execute(query)
    user = cursor.fetchone()
    if user:
        return jsonify({
            "message": "Login successful",
            "user_id": user["id"],
            "username": user["username"],
            "role": user["role"]
        })
    else:
        return jsonify({
            "message": "Invalid credentials"
        }), 401
@auth_bp.route('/register', methods=['POST'])
def register():
    data = request.json
    username = data.get("username")
    password = data.get("password")
    email = data.get("email")
    conn = get_db_connection()
    cursor = conn.cursor()
    #VULNERABLE (no validation, raw SQL)
    query = f"""
    INSERT INTO users (username, password, email, role)
    VALUES ('{username}', '{password}', '{email}', 'user')
    """
    cursor.execute(query)
    conn.commit()
    return jsonify({"message": "User registered"})
