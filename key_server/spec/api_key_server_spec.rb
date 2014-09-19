#!/bin/env rspec

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Server Home"  do
	it "Returns Hello World!" do
		get '/'
    	last_response.should be_ok
    	assert last_response.body.include?('Hello World')
	end
end

