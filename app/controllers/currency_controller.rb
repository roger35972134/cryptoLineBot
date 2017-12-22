class CurrencyController < ApplicationController

	require 'line/bot'
	require "facebook/messenger"
	include Facebook::Messenger

	def client
	  	@client ||= Line::Bot::Client.new { |config|
	    	config.channel_secret = ENV["LINE_CHANNEL_SECRET_1"]
	    	config.channel_token = ENV["LINE_CHANNEL_TOKEN_1"]
	  	}
	end

	def client2
		@client2 ||= Line::Bot::Client.new { |config|
	    	config.channel_secret = ENV["LINE_CHANNEL_SECRET_2"]
	    	config.channel_token = ENV["LINE_CHANNEL_TOKEN_2"] 
	  	}
	end

	def client3
		@client3 ||= Line::Bot::Client.new { |config|
	    	config.channel_secret = ENV["LINE_CHANNEL_SECRET_3"]
	    	config.channel_token = ENV["LINE_CHANNEL_TOKEN_3"] 
	  	}
	end

	def fb_client
		
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
	     		type = event["source"]['type']
	     		res = Currency.search_by_abbreviation(query, type)
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

	def webhook2
	  client2
	  body = request.body.read
	  puts body

	  signature = request.env['HTTP_X_LINE_SIGNATURE']
	  unless client2.validate_signature(body, signature)
	    error 400 do 'Bad Request' end
	  end

	  events = client2.parse_events_from(body)
	  events.each { |event|
	    case event
	    when Line::Bot::Event::Message
	      	case event.type
	     	when Line::Bot::Event::MessageType::Text
	     		query = event.message['text']
	     		logger.info event.to_s
	     		type = event["source"]['type']
	     		res = Currency.search_by_abbreviation(query, type)
		        message = {
		          type: 'text',
		          text: res
		        }
		        client2.reply_message(event['replyToken'], message)
	    	end
	    end
	  }

	  "OK"
	end

	def webhook3
	  client3
	  body = request.body.read
	  puts body

	  signature = request.env['HTTP_X_LINE_SIGNATURE']
	  unless client3.validate_signature(body, signature)
	    error 400 do 'Bad Request' end
	  end

	  events = client3.parse_events_from(body)
	  events.each { |event|
	    case event
	    when Line::Bot::Event::Message
	      	case event.type
	     	when Line::Bot::Event::MessageType::Text
	     		query = event.message['text']
	     		logger.info event.to_s
	     		type = event["source"]['type']
	     		res = Currency.search_by_abbreviation(query, type)
		        message = {
		          type: 'text',
		          text: res
		        }
		        client3.reply_message(event['replyToken'], message)
	    	end
	    end
	  }

	  "OK"
	end

	#--------------------------------------------------------------

	 # def webhook_facebook
	 # 	Facebook::Messenger::Subscriptions.subscribe(access_token: ENV["FB_ACCESS_TOKEN"])
	 # 	body = JSON.parse(request.body.read)
	 # 	entries = body['entry']
	 # 	if body['object'] == 'page'
	 # 	  entries.each do |entry|
	 # 	    entry['messaging'].each do |message|
	 # 	      reveive_message = message.dig('message','text').to_s
	 # 	      senderID = message.dig('sender','id')

	 # 	      messageData = self.text_format(senderID, reveive_message)
	 # 	      res = HTTParty.post(uri, body: massageData.to_json, headers: { 'Content-Type' => 'application/json' })
	 # 	    end
	 # 	  end
	 # 	end
	 # 	#render plain: 'OK', status: 200
	 #end
end
