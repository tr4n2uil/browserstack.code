#!/bin/env ruby

require 'rubygems'
require 'selenium-webdriver'
require 'test/unit'

class SampleTest < Test::Unit::TestCase
  def setup
    url = "http://vibhajrajan1:isx1GLKoDPyxvJwMZBso@hub.browserstack.com/wd/hub"
    @driver = Selenium::WebDriver.for(:remote, :url => url)
  end

  def test_post
    @driver.navigate.to "http://www.google.com"
    element = @driver.find_element(:name, 'q')
    element.send_keys "BrowserStack"
    element.submit
    assert_equal(@driver.title, "BrowserStack - Google Search")
  end

  def teardown
    @driver.quit
  end
end
