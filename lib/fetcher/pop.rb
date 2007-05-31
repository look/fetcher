require File.dirname(__FILE__) + '/../vendor/secure_pop'

module Fetcher
  class Pop < Base

    protected
    
    def assign_options(options={})
      @ssl = options.delete(:ssl)
      super
    end

    def establish_connection
      @connection = Net::POP3.new(@server)
      @connection.enable_ssl(OpenSSL::SSL::VERIFY_NONE) if @ssl
      @connection.start(@username, @password)
    end

    def get_messages
      unless @connection.mails.empty?
        @connection.each_mail do |msg|
          # Process the message
          begin
            @receiver.receive(msg.pop)
          rescue
            # Store the message for inspection if the receiver errors
          end
          # Delete message from server
          msg.delete
        end
      end
    end

    def close_connection
      @connection.finish
    end

  end
end
