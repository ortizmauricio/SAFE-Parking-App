require 'spreadsheet'
require 'sinatra'
require 'convert_api'


get "/receipt" do
	if params["fName"] && params["lName"] && params["total"]
		Spreadsheet.client_encoding = 'UTF-8'
		receipt = Spreadsheet.open 'receipt1.xls'
		sheet1 = receipt.worksheet 0

		#Changes name
		sheet1[12, 0] = "#{params["fName"]} #{params["lName"]}"
		sheet1[24, 2] = "#{params["fName"]} #{params["lName"]}"

		#Changes date
		sheet1[4, 3] = Time.now.strftime("%m/%d/%Y")
		sheet1[21, 2] = "DATE: #{Time.now.strftime("%m/%d/%Y")}"

		#Changes total
		sheet1[20, 3] = params["total"].to_i

		receipt.write 'file.xls'

		ConvertApi.configure do |config|
		  config.api_secret = 'RU3BdMgKqrjtUoR8'
		end

		result = ConvertApi.convert('pdf', File: 'file.xls')

		# save to file
		result.file.save('file.pdf')
	end

	return "hi"
end