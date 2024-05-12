from flask import render_template, request, Blueprint
business = Blueprint('business', __name__)
from flask_cors import CORS
CORS(business)

@business.route("/")
def business_home():
	return "This is the main module of business"
