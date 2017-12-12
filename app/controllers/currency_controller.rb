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
end
