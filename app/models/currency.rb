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

	require 'line/bot'
	def self.client
	  @client ||= Line::Bot::Client.new { |config|
	    config.channel_secret = ENV["LINE_CHANNEL_SECRET"] || "aa1a582b6359f43848c64cf151ed919c"
	    config.channel_token = ENV["LINE_CHANNEL_TOKEN"] || "1V2Lncj9KNTWZICN6sUfV1gAarKPs0z/ES5SR0hsF+V64c9T/xkkQEEGG3zfo0ACS34G1avwvaDfrTHtN0vz/P1C8Ahu4SN3avIcLXHdyow5X8RfPY1qXOYP+Ui1yGcmhRByHijxkV0P5RBI3gA1jQdB04t89/1O/w1cDnyilFU="
	  }
	end

	post '/webhook' do
	  body = request.body.read
	  puts body

	  signature = request.env['HTTP_X_LINE_SIGNATURE']
	  unless client.validate_signature(body, signature)
	    error 400 do 'Bad Request' end
	  end

	  events = client.parse_events_from(body)
	  events.each { |event|
	    case event
	    when Line::Bot::Event::Message
	      case event.type
	      when Line::Bot::Event::MessageType::Text
	        message = {
	          type: 'text',
	          text: event.message['text']
	        }
	        client.reply_message(event['replyToken'], message)
	    end
	  }

	  "OK"
	end
end
