require 'selenium-webdriver'
require 'date'
require 'net/smtp'
require 'dotenv'

def test_rate_my_agent
  driver = Selenium::WebDriver.for :firefox

  begin
    driver.get 'https://www.rate-my-agent.com/'
    agent_name = 'Megan Scott'

    home_page_content = driver.find_element(:tag_name, 'h2').text
    raise 'Homepage content mismatch' unless home_page_content.include?('Hire the')

    get_matched_button = driver.find_element(:link_text, 'Get Matched Now')
    get_matched_button.click

    current_url = driver.current_url
    raise 'Incorrect page navigation' unless current_url.include?('quiz?cta=take-quiz-home')

    driver.navigate.back

    search_box = driver.find_element(:name, 'term')
    driver.execute_script("document.getElementById('term').value='#{agent_name}'")
    search_box.submit

    sleep 2

    agent_page_content = driver.find_element(:tag_name, 'h1').text
    raise 'Agent not found in search results' unless agent_page_content.include?("Agents matching \"#{agent_name}\"")

    puts 'All checks passed successfully!'
  rescue StandardError => e
    log_error(e)
    to_email = 'alerts@rate-my-agent.com'
    subject = 'Error Alert'
    body = e.message
    send_email_notification(to_email, subject, body)
    puts "Error: #{e.message}"
  ensure
    sleep 2
    driver.quit
  end
end

def log_error(error)
  File.open('error_log.txt', 'a') do |file|
    file.puts "#{DateTime.now.strftime('%Y-%m-%d %H:%M:%S')} - #{error.message}"
  end
end

def send_email_notification(to_email, subject, body)
  Dotenv.load
  smtp_server = 'smtp.gmail.com'
  smtp_port = 587
  sender_email =  ENV['GMAIL_EMAIL_ADDRESS']  # Replace with your Gmail email address
  sender_password = ENV['GMAIL_PASSWORD']  # Replace with your Gmail password

  # Create the message
    message = <<MESSAGE_END
    From: #{sender_email}
    To: #{to_email}
    Subject: #{subject}
    #{body}
MESSAGE_END

  # Send the email
  Net::SMTP.start(smtp_server, smtp_port, 'localhost', sender_email, sender_password, :plain) do |smtp|
    smtp.send_message(message, sender_email, to_email)
  end

  puts 'Email sent successfully!'
rescue StandardError => e
  puts "Error sending email: #{e.message}"
end

test_rate_my_agent
