from flask import render_template, request, Blueprint
from flask.json import jsonify

from backend.models import VirtualWallet
main = Blueprint('main', __name__)

@main.route("/")
def main_home():
	return "This is the main module of backend"

@main.route('/wallet_deposit/<wtype>/<id>/<amount>', methods=['POST'])
def wallet_deposit(wtype, id, amount):
	wallet = None
	if(wtype == 'business'):
		wallet = VirtualWallet.query.filter_by(business_id=id).first()
	else:
		wallet = VirtualWallet.query.filter_by(investor_id=id).first()
	if(wallet == None):
		return jsonify({
			'message': 'Wallet not found'
		}), 400
	wallet.deposit(int(str(amount)))
	return jsonify({
		'message': 'OK',
		'balance': wallet.balance,
	}), 200

@main.route('/wallet_withdraw/<wtype>/<id>/<amount>', methods=['POST'])
def wallet_withdraw(wtype, id, amount):
	wallet = None
	if(wtype == 'business'):
		wallet = VirtualWallet.query.filter_by(business_id=id).first()
	else:
		wallet = VirtualWallet.query.filter_by(investor_id=id).first()
	if(wallet == None):
		return jsonify({
			'message': 'Wallet not found'
		}), 400
	success = wallet.withdraw(int(str(amount)))
	if(not success):
		return jsonify({
			'message': 'Insufficient Balance'
		}), 400
	return jsonify({
		'message': 'OK',
		'balance': wallet.balance,
	}), 200