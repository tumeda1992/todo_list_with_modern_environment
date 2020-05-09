class ScrapingController < ApplicationController
  def index
    browser = ::Selenium::WebDriver.for :remote,  url: "http://selenium-hub:4444/wd/hub", desired_capabilities: :chrome
    browser.get("https://google.com/")
    title = browser.find_element(:tag_name, "title")
    render json: {content: title}
  end
end
