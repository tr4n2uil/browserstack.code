#!/bin/env ruby

require 'sinatra'
require './api_key'


get '/' do
  "Hello World!"
end

get '/generate/:value/' do
	api = ApiKey.new(params[:value])
	if api.generate?
		"Successfully Generated"
	else
		status 404
		"Already Generated"
	end
end

get '/random/' do
	api = ApiKey.random
	if api
		"API Key :" + api.value
	else
		status 404
		"No Key Found. Please Try Later"
	end
end

get '/unblock/:value/' do
	api = ApiKey.new(params[:value])
	if api.unblock
		"Key Unblocked"
	else
		status 404
		"Key Could Not Be Unblocked"
	end
end

get '/delete/:value/' do
	api = ApiKey.new(params[:value])
	if api.delete
		"Key Deleted. Purged"
	else
		status 404
		"Key Could Not Be Deleted"
	end
end

get '/ping/:value/' do
	api = ApiKey.new(params[:value])
	if api.ping
		"Key Pinged"
	else
		status 404
		"Key Could Not Be Pinged"
	end
end



