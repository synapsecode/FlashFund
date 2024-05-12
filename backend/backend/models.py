#Database Layer
from datetime import datetime
from flask import current_app
from backend import db

class TestModel(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	test_name = db.Column(db.String)


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