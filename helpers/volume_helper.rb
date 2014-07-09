module Common
  module VolumeHelper

  def createVolume(driver, name, description, size)
    wait = Selenium::WebDriver::Wait.new(:timeout => 180)
    
    # click create volume button
    wait.until { driver.find_element(:css, "i.fa.fa-floppy-o").displayed? }
    driver.find_element(:css, "i.fa.fa-floppy-o").click
    wait.until { driver.find_element(:xpath, "//button[normalize-space(text())=\"Create Volume\"]").displayed? }    
    driver.find_element(:xpath, "//*[@id=\"side-action\"]").click
    wait.until { driver.find_element(:xpath, "/html/body/div[3]/div/div").displayed? }
    
    # enter details and create
    driver.find_element(:id, "displayName").clear
    driver.find_element(:id, "displayName").send_keys(name)
    driver.find_element(:id, "displayDescription").clear
    driver.find_element(:id, "displayDescription").send_keys(description)
    driver.find_element(:id, "volumeSize").clear
    driver.find_element(:id, "volumeSize").send_keys(size)
    driver.find_element(:xpath, "//div[3]/button[2]").click
    
    # wait until the volume is no longer in creating status
    assert !120.times{ break if !(driver.find_element(:xpath, "//tr/td[normalize-space(text())=\"#{ name }\"]/..//td[4]").text =~ /creating/) rescue false; sleep 2 }
  end

  def attachVolume(driver, vol_name, instance_name)
    wait = Selenium::WebDriver::Wait.new(:timeout => 60)
   
    # click attach option of volume
    wait.until { driver.find_element(:css, "i.fa.fa-floppy-o").displayed? }
    driver.find_element(:css, "i.fa.fa-floppy-o").click    
    wait.until { driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/table[1]/tbody/tr/td[normalize-space(text())=\"#{ vol_name }\"]/..//td[7]/div/button").displayed? }
    driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/table[1]/tbody/tr/td[normalize-space(text())=\"#{ vol_name }\"]/..//td[7]/div/button").click
    
    # select instance to attach to 
    wait.until { driver.find_element(:xpath, "//*[@id=\"attachVolume\"]/div/select").displayed? }
    driver.find_element(:xpath, "//*[@id=\"attachVolume\"]/div/select").click
    driver.find_element(:xpath, "//form[@id='attachVolume']/div/select/option[normalize-space(text())=\"#{ instance_name }\"]").click
    driver.find_element(:xpath, "//div[3]/button[2]").click
    
    # wait until the volume is no longer in attaching status
    wait.until { !(driver.find_element(:xpath, "//*[@id=\"attachVolume\"]/div/select").displayed?) }
    assert !120.times{ break if (driver.find_element(:xpath, "//*[@id=\"dv-main-content\"]/table[1]/tbody/tr/td[normalize-space(text())=\"#{ vol_name }\"]/..//td[4]").text =~ /in-use/) rescue false; sleep 2 }
  end
  
  end
end