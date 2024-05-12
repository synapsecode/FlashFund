#Database Layer
from datetime import datetime
from flask import current_app
from backend import db

class Investor(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	name = db.Column(db.String)
	email = db.Column(db.String)
	password = db.Column(db.String)
	aadhar = db.Column(db.String)
	pan = db.Column(db.String)
	address = db.Column(db.String)

	def __init__(self, name, email, password, aadhar, pan, address):
		self.name = name
		self.email = email
		self.password = password
		self.aadhar = aadhar
		self.pan = pan
		self.address = address

	def __repr__(self):
		return f"Investor({self.name}, {self.email})"
	
class Business(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	company_name = db.Column(db.String)
	email = db.Column(db.String)
	password = db.Column(db.String)
	legalstructure = db.Column(db.String)
	fundingdate = db.Column(db.String)
	fundingstage = db.Column(db.String)
	address = db.Column(db.String)

	def __init__(self, company_name, email, password, legalstructure, fundingdate, address, fundingstage):
		self.company_name = company_name
		self.email = email
		self.password = password
		self.legalstructure = legalstructure
		self.fundingdate = fundingdate
		self.address = address
		self.fundingstage = fundingstage

	def __repr__(self):
		return f"Business({self.name}, {self.email})"
	
class VirtualWallet(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	business_id = db.Column(db.Integer)
	investor_id = db.Column(db.Integer)
	balance = db.Column(db.Float)

	def __init__(self, investor_id, business_id):
		self.balance = 0
		self.investor_id = investor_id
		self.business_id = business_id

	def __repr__(self):
		return f"VirtualWallet({self.investor_id}, {self.business_id}, {self.balance})"
	
	def deposit(self, amount):
		self.balance = self.balance + amount
		print(f"deposited {amount} into VirtualWallet")
		db.session.commit()

	def withdraw(self, amount):
		if(amount > self.balance):
			print('Cannot Withdraw more than balance')
			return False
		self.balance = self.balance - amount
		print(f"Withdrew {amount} from VirtualWallet")
		db.session.commit()
		return True

