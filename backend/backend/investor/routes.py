from flask import render_template, request, Blueprint, jsonify
from backend import db
from backend.models import Business, FlashFundIPO, Investor, VirtualWallet
investor = Blueprint('investor', __name__)
from flask_cors import CORS
CORS(investor)

@investor.route("/")
def investor_home():
	return "This is the main module of business"

@investor.route("/register", methods=['POST'])
def register():
	data = request.json
	name = data['name']
	aadhar = data['aadhar']
	address = data['address']
	pan = data['pan']
	email = data['email']
	password = data['password']

	b = Investor.query.filter_by(email=email).first()
	if(b != None):
		return jsonify({
			'error': 'investor already exists',
		}), 400
	
	b = Investor(
		name=name,
		email=email,
		password=password,
		aadhar=aadhar,
		pan=pan,
		address=address,
	)
	db.session.add(b)
	db.session.commit()

	b = Investor.query.filter_by(email=email).first()

	#Create VirtualWallet
	vw = VirtualWallet(
		business_id=None,
		investor_id=b.id,
	)
	db.session.add(vw)
	db.session.commit()

	print('Virtual Wallet Created for Investor!')


	return jsonify({
		'status': 'OK',
		'message': 'investor created!',
	}), 200
	
@investor.route("/login", methods=['POST'])
def login():
	data = request.json
	if(data == None or data == ''):
		return jsonify({
			'error':'Invalid Request Body',
		}), 400
	b = Investor.query.filter_by(email=data['email'], password=data['password']).first()
	if(b == None):
		return jsonify({
			'success': False,
			'message': 'Investor Not Found'
		})
	return jsonify({
		'success': True,
		'id': b.id
	})

@investor.route("/roadshows")
def roadshows():
	roadshows = FlashFundIPO.query.filter_by(
		status='roadshow',
	).all()

	def get_company_name_by_bid(id):
		b = Business.query.filter_by(id=id).first()
		return b.company_name
		
	jsonbody = {
		'roadshows': [{
			'company_name': get_company_name_by_bid(x.business_id),
			'status': x.status,
			'proposed_valuation': x.valuation,
			'public_valuation': x.getAverageValuation(),
			'loan_amount': x.loan_amount,
		} for x in roadshows]
	}
	return jsonify(jsonbody), 200

	# data = request.json
	# if(data == None or data == ''):
	# 	return jsonify({
	# 		'error':'Invalid Request Body',
	# 	}), 400
	# b = Investor.query.filter_by(email=data['email'], password=data['password']).first()
	# if(b == None):
	# 	return jsonify({
	# 		'success': False,
	# 		'message': 'Investor Not Found'
	# 	})
	# return jsonify({
	# 	'success': True,
	# 	'id': b.id
	# })