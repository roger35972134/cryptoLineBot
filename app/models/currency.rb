class Currency < ActiveRecord::Base

	require 'open-uri'
	def self.get_currency
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
	end

	def self.search_by_abbreviation(abbreviation)
		get_currency

		c = Currency.find_by(:abbreviation => abbreviation)

		unless c.nil?
			res = "currency: #{c.name}
					value: #{c.value}
					market_exchange: #{c.market_exchange}"
		else
			res = "Currency not found !"
		end
		res
	end
end
