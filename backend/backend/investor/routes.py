from flask import render_template, request, Blueprint
investor = Blueprint('investor', __name__)

@investor.route("/")
def investor_home():
	return "This is the investor module of investor"
