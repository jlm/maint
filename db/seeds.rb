# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create!(email: "jmessenger@advaoptical.com", password: "ponytail", password_confirmation: "ponytail", admin: true, debugger: true)
Minst.create([
	{ code: "P" , name: "Published" },
	{ code: "A" , name: "Approved" },
	{ code: "B" , name: "Ready for Ballot" },
	{ code: "CB", name: "Complete then Ballot" },
	{ code: "CE", name: "Complete then Errata" },
	{ code: "E" , name: "Errata" },
	{ code: "F" , name: "Failed" },
	{ code: "I" , name: "Incomplete" },
	{ code: "J" , name: "Rejected" },
	{ code: "R" , name: "Received" },
	{ code: "S" , name: "Errata Sheet Published" },
	{ code: "T" , name: "Technical experts review" },
	{ code: "V" , name: "Balloting" },
	{ code: "W" , name: "Withdrawn" }
	])
