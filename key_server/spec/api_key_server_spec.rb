#!/bin/env rspec

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
key = Time.now.getutc.to_i.to_s
apikey = nil

describe "Server Home"  do
	it "Returns Hello World!" do
		get '/'
    	last_response.should be_ok
    	assert last_response.body.include?('Hello World')
	end
end

describe "Key Server" do
	it "Generates New Key into KeyServer" do
		get "/generate/#{key}/"
		last_response.should be_ok
		assert last_response.body.include?('Successfully Generated')
	end

	it "Does Not Add Duplicate Key into KeyServer" do
		get "/generate/#{key}/"
		assert_equal 404, last_response.status
		assert last_response.body.include?('Already Generated')
	end

	it "Get Random Key from KeyServer" do
		get "/random/"
		puts last_response.body
		apikey = last_response.body.split(':')[1]
		puts apikey
		last_response.should be_ok
		assert last_response.body.include?('API Key')
	end	

	it "Ping Key on KeyServer" do
		get "/ping/#{apikey}/"
		puts last_response.body
		last_response.should be_ok
		assert last_response.body.include?('Key Pinged')
	end	

	it "Unblocks Key into KeyServer" do
		get "/unblock/#{apikey}/"
		puts last_response.body
		last_response.should be_ok
		assert last_response.body.include?('Key Unblocked')
	end

	it "Deletes Key into KeyServer" do
		get "/delete/#{key}/"
		puts last_response.body
		last_response.should be_ok
		assert last_response.body.include?('Key Deleted')
	end

	it "Purges Key from KeyServer" do
		get "/generate/#{key}/"
		puts last_response.body
		assert_equal 404, last_response.status
		assert last_response.body.include?('Already Generated')
	end
end


