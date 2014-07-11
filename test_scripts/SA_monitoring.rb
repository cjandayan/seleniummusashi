current_directory = File.expand_path(File.dirname(__FILE__))
require current_directory + "/../test_helper"

class Monitoring < MiniTest::Test

  include Common::AuthenticationHelper
  include Common::MonitoringHelper

  def setup
    @test_data = Data.config.test_data
    @config = Data.config.setup
    
    @driver = Selenium::WebDriver.for @config["test_browser"].to_sym
    @driver.get(@config["envi"] + "/")
  end

  def teardown
    @driver.quit
  end
  
  def test_update_monitoring_threshold
   
    login(@driver, @test_data["user_admin"] + 0.to_s, @test_data["user_password"])

    warning = 30
    error = 35
    increase = 5
    range = 10 

    range.times do 

      warning += increase
      error += increase

      update_settings(@driver, warning, error)
    end
    
    logout(@driver)

  end
end