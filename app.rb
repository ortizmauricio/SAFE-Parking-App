require 'spreadsheet'

Spreadsheet.client_encoding = 'UTF-8'
receipt = Spreadsheet.open 'receipt1.xls'
sheet1 = receipt.worksheet 0

puts"#{sheet1[12, 0]}"

#Changes name
sheet1[12, 0] = "CRIS"

#Changes date
sheet1[4, 3] = Time.now.strftime("%m/%d/%Y")
sheet1[21, 2] = "DATE: #{Time.now.strftime("%m/%d/%Y")}"

#Changes total
sheet1[20, 3] = 70
puts"#{sheet1[12, 0]}"
puts"#{sheet1[3, 20]}"

sheet1.each do |row|
	puts"#{row}"
end

receipt.write 'file.xls'
