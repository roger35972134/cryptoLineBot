class CurrencyController < ApplicationController

	require 'line/bot'
	def client
	  @client ||= Line::Bot::Client.new { |config|
	    config.channel_secret = ENV["LINE_CHANNEL_SECRET"] || "a320a370df8bc56c649032b84dd756f1"
	    config.channel_token = ENV["LINE_CHANNEL_TOKEN"] || "47eqwdQSxHRe0jDnYW3QHyDv3wmoxf39ebarCeqehS8uKZAAZqzhXxEfRD561cDd9Fee9nFMjYwa3VnI0p+QezsOWmT2qmM1OHAHirjvC3qIt2ZUtnpeOsa5BewBPLYq5p0hL5t8q0EcsZVxBxToDwdB04t89/1O/w1cDnyilFU="
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
	     		query = event.message['text']
	     		res = Currency.search_by_abbreviation(query)
		        message = {
		          type: 'text',
		          text: res
		        }
		        client.reply_message(event['replyToken'], message)
	    	end
	    end
	  }

	  "OK"
	end
end
