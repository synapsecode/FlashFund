from flask import render_template, request, Blueprint, jsonify
from backend import db
from backend.models import Business, VirtualWallet
business = Blueprint('business', __name__)
from flask_cors import CORS
CORS(business)

@business.route("/")
def business_home():
	return "This is the main module of business"

@business.route("/register", methods=['POST'])
def register():
	data = request.json
	company_name = data['company_name']
	legalstructure = data['legalstructure']
	company_address = data['company_address']
	dateoffounding = data['dateoffounding']
	email = data['email']
	password = data['password']
	funding_state = data['funding_state']

	b = Business.query.filter_by(email=email).first()
	if(b != None):
		return jsonify({
			'error': 'business already exists',
		}), 400
	
	b = Business(
		company_name=company_name,
		email=email,
		password=password,
		legalstructure=legalstructure,
		fundingdate=dateoffounding,
		address=company_address,
		fundingstage=funding_state,
	)
	
	db.session.add(b)
	db.session.commit()

	b = Business.query.filter_by(email=email).first()

	#Create VirtualWallet
	vw = VirtualWallet(
		business_id=b.id,
		investor_id=None,
	)
	db.session.add(vw)
	db.session.commit()

	print('Virtual Wallet Created for Business!')

	return jsonify({
		'status': 'OK',
		'message': 'business created!',
	}), 200
	
@business.route("/login", methods=['POST'])
def login():
	data = request.json
	if(data == None or data == ''):
		return jsonify({
			'error':'Invalid Request Body',
		}), 400
	b = Business.query.filter_by(email=data['email'], password=data['password']).first()
	if(b == None):
		return jsonify({
			'success': False,
			'message': 'Business Not Found'
		})
	return jsonify({
		'success': True,
		'id': b.id
	})