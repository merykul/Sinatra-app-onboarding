# frozen_string_literal: true
module LoggerHelper

  def user_creds_log(username, password)
    log_message = "------------------------------------------------------ User creds: #{username}, #{password} ------------------------------------------------------"
    puts log_message
  end

  def last_request_log
    end_line_log
    puts "Last request path: #{last_request.path_info}"
    end_line_log
  end

  def last_request_method
    end_line_log
    puts "Last request method #{last_request.env['REQUEST_METHOD']}"
    end_line_log
  end

  def last_response_status
    end_line_log
    puts "last response status code #{last_response.status}"
    end_line_log
  end

  def last_response_log
    p last_response_start_log_line
    p last_response
    p end_line_log
  end

  def last_response_body_log
    p last_response_start_log_line
    p last_response.body
    p end_line_log
  end

  def log_new_record_info(first_name, second_name, city, dob)
    log_message = "------------------------------------------------------ New record: #{first_name}, #{second_name}, #{city}, #{dob}!! ------------------------------------------------------"
    puts log_message
  end

  private

  def last_response_start_log_line
    log_message = '------------------------------------------------------ Last response ------------------------------------------------------------'
    puts log_message
  end

  def end_line_log
    log_message = '-----------------------------------------------------------------------------------------------------------------------------------------------'
    puts log_message
  end
end
