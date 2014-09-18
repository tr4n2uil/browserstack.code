#!/bin/env ruby

require 'rubygems'
require 'selenium-webdriver'

# Input capabilities
caps = Selenium::WebDriver::Remote::Capabilities.new
caps["browser"] = "IE"
caps["browser_version"] = "7.0"
caps["os"] = "Windows"
caps["os_version"] = "XP"
caps["browserstack.debug"] = "true"
caps["name"] = "Testing Selenium 2 with Ruby on BrowserStack"

driver = Selenium::WebDriver.for(:remote,
  :url => "http://vibhajrajan1:isx1GLKoDPyxvJwMZBso@hub.browserstack.com/wd/hub",
  :desired_capabilities => caps)
driver.navigate.to "http://www.google.com/ncr"
element = driver.find_element(:name, 'q')
element.send_keys "BrowserStack"
element.submit
puts driver.title
driver.quit
