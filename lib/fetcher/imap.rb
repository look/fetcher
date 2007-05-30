require File.dirname(__FILE__) + '/../vendor/plain_imap'

module Fetcher
  class Imap < Base
    
    def initialize(options={})
      @authentication = options.delete(:authentication) || 'PLAIN'
      super(options)
    end

    protected

    def establish_connection
      @connection = Net::IMAP.new(@server)
      @connection.authenticate(@authentication, @username, @password)
    end

    def get_messages
      @connection.select('INBOX')
      @connection.search(['ALL']).each do |message_id|
        msg = @connection.fetch(message_id,'RFC822')[0].attr['RFC822']
        # process the email message
        begin
          @receiver.receive(msg)
        rescue
          # Store the message for inspection if the receiver errors
          @connection.append('bogus', msg)
        end
        # Mark message as deleted 
        @connection.store(message_id, "+FLAGS", [:Deleted])
      end
    end

    def close_connection
      # expunge messages and log out.
      @connection.expunge
      @connection.logout
      @connection.disconnect
    end

  end
end
