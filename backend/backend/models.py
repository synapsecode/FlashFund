#Database Layer
from datetime import datetime
from flask import current_app
from backend import db
from sqlalchemy import PickleType
from sqlalchemy.ext.mutable import MutableList

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

class FlashFundIPO(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	business_id = db.Column(db.Integer)
	# prospectus_url = db.Column(db.String)
	valuation = db.Column(db.Integer)

	# proposed_valuations = db.Column(MutableList.as_mutable(PickleType),default=[])

	proposed_valuation_count = db.Column(db.Integer, default=0)
	proposed_valuation_sum = db.Column(db.Integer, default=0)


	status = db.Column(db.String)

	loan_amount = db.Column(db.Integer)
	shares_left = db.Column(db.Integer)

	def __init__(self, business_id, prospectus_url, valuation, loan_amount):
		self.business_id = business_id
		# self.prospectus_url = prospectus_url,
		self.valuation = valuation
		self.status = 'roadshow'
		self.loan_amount = loan_amount
		self.shares_left = 1_000_000 #CONSTANT VALUE

	def __repr__(self):
		return f"FlashFundIPO({self.business_id}, {self.valuation}, {self.status})"
	

	def add_proposed_valuation(self, valuation):
		# self.proposed_valuations = [*self.proposed_valuations, valuation]
		self.proposed_valuation_count += valuation
		self.proposed_valuation_count += 1
		print(f'add_proposed_valuation: added {valuation}')
		db.session.commit()

	def getAverageValuation(self):
		if(self.proposed_valuation_count == 0): 
			return self.valuation
		return (self.proposed_valuation_count/self.proposed_valuation_count)
 
	def update_status(self, status):
		self.status = status
		print(f'Updated Status of {self.business_id} to {status}')
		db.session.commit()

	def purchase_share(self, units):
		if(units > self.shares_left):
			print('No More Microstocks Left')
			return False
			
		# Add the funds to the Business Wallet
		wv = VirtualWallet.query.filter_by(business_id=self.business_id).first()
		if(wv == None):
			print('No Associated Business Wallet')
			return False
		
		#Reduce the number of shares left
		self.shares_left = self.shares_left - units
		
		#find the total amount to transfer (units * shareprice)
		shareprice = self.loan_amount/1_000_000
		print(f'Using Shareprice {shareprice} Rupees')

		transferamount = units * shareprice
		print(f'Transferring Amount Rs.{transferamount} to Business({self.business_id})')
	
		# Transfer funds to the VirtualWallet
		wv.deposit(transferamount)

		print('====MicroShare Purchase Complete=====')
		return True

class InvestorFlashFundAssociation(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	investor_id = db.Column(db.Integer)
	flashfund_id = db.Column(db.Integer)
	units = db.Column(db.Integer)

	def __init__(self, investor, flashfund, units):
		self.investor_id = investor.id
		self.flashfund_id = flashfund.id
		self.units = units

	def __repr__(self):
		print(f'InvestorFlashFundAssociation({self.investor_id}, {self.flashfund_id}, {self.units})')