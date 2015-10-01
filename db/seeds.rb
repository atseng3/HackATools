# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'csv'
# file=File.open("input_file", "r:ISO-8859-1")
csv_text = File.open('./db/sample_result.csv', "r:ISO-8859-1")
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row| 
	# @product = Product.new()
	# @product.name = row[0]
	# @product.website = row[1]
	# @product.description = row[2]
	# @product.save!
	Product.create!(row.to_hash)
end
# CSV.foreach("./db/sample_result.csv") do |row|
	# @product = Product.new()
	# @product.name = row[0]
	# @product.website = row[1]
	# @product.description = row[2]
	# @product.save!
# end