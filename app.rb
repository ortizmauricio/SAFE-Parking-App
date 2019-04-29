require 'spreadsheet'

Spreadsheet.client_encoding = 'UTF-8'
receipt = Spreadsheet.open 'receipt1.xls'
sheet1 = receipt.worksheet 0

puts"#{sheet1[12, 0]}"
sheet1[12, 0] = "MAURICIO ORTIZ"
puts"#{sheet1[12, 0]}"

sheet1.each do |row|
	puts"#{row}"
end

receipt.write 'file.xls'
