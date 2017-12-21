class Currency < ActiveRecord::Base

	require 'open-uri'
	def self.get_currency
		begin
			books = Nokogiri::HTML(open("https://www.coingecko.com/en"))
			name = []
			abbreviation = []
			rate = []
			exchange = []

			books.css('.coin-content-name').each do |link|
				name.push link.content
			end

			books.css('.coin-crypto-symbol').each do |link|
				abbreviation.push link.content
			end
			
			books.css('.stat-percent').each do |link|
				rate.push link.content
			end

			books.css('.currency-exchangable').each do |link|
			  	s = link.content.split("\n")[1]
			  	exchange.push s
			end

			(0..name.count-1).each do |i|
				currency = Currency.find_by(:name => name[i])
				currency = Currency.create(:name => name[i]) if currency.nil?

				currency.abbreviation = abbreviation[i]
				currency.value = exchange[i*3]
				currency.rate = rate[i]
				currency.market_exchange = exchange[i*3+2]
				currency.save
			end
		rescue OpenURI::HTTPError => e
			return "Server Error"
		end

		return "OK"
	end

	def self.search_by_abbreviation(abbreviation, type)
		if get_currency == "OK"
			c = Currency.find_by(:abbreviation => abbreviation)

			unless c.nil?
				res = "貨幣: #{c.name}\n價格: #{c.value}\n市場價值: #{c.market_exchange}"
			else
				res = "請輸入正確的貨幣代號，例如：BTC (Bitcoin)!" if type == 'user'
			end
		else
			res = "伺服器目前維護中...\n請稍候再試，謝謝您的支持(oops)" if type == 'user'
		end
		res
	end

	def self.search_by_abbreviation_fb(abbreviation)
		if get_currency == "OK"
			c = Currency.find_by(:abbreviation => abbreviation)

			unless c.nil?
				res = "貨幣: #{c.name}\n價格: #{c.value}\n市場價值: #{c.market_exchange}"
			else
				res = "請輸入正確的貨幣代號，例如：BTC (Bitcoin)!"
		else
			res = "伺服器目前維護中...\n請稍候再試，謝謝您的支持(oops)"
		end
		res
	end

end
