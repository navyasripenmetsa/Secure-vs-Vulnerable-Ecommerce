from flask import Flask
from flask_cors import CORS
from routes.auth import auth_bp
from routes.search import search_bp
from routes.dashboard import dashboard_bp
from routes.review import review_bp
from routes.admin import admin_bp
from routes.profile import profile_bp
from routes.orders import orders_bp
app = Flask(__name__)
CORS(app)
app.register_blueprint(auth_bp)
app.register_blueprint(search_bp)
app.register_blueprint(dashboard_bp)
app.register_blueprint(review_bp)
app.register_blueprint(admin_bp)
app.register_blueprint(profile_bp)
app.register_blueprint(orders_bp)
@app.route('/')
def home():
    return "Backend Running!"
if __name__ == '__main__':
    app.run(debug=True)
