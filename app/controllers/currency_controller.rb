class CurrencyController < ApplicationController
	def search_by_abbreviation
		abbreviation = params[:abbreviation]
		api_response = Response::CurrencyResponse.new
		Currency.get_currency

		currency = Currency.find_by(:abbreviation => abbreviation)
		unless currency.nil?
			api_response.info = currency
		else
			api_response.setErrMsg("currency not found")
		end

		render json: api_response
	end

	require 'line/bot'
	def client
	  @client ||= Line::Bot::Client.new { |config|
	    config.channel_secret = ENV["LINE_CHANNEL_SECRET"] || "aa1a582b6359f43848c64cf151ed919c"
	    config.channel_token = ENV["LINE_CHANNEL_TOKEN"] || "1V2Lncj9KNTWZICN6sUfV1gAarKPs0z/ES5SR0hsF+V64c9T/xkkQEEGG3zfo0ACS34G1avwvaDfrTHtN0vz/P1C8Ahu4SN3avIcLXHdyow5X8RfPY1qXOYP+Ui1yGcmhRByHijxkV0P5RBI3gA1jQdB04t89/1O/w1cDnyilFU="
	  }
	end

	# post '/webhook' do
	def webhook
	  client
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
	    end
	  }

	  "OK"
	end
end
