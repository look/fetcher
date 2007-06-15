require File.dirname(__FILE__) + '/../vendor/plain_imap'

module Fetcher
  class Imap < Base
    
    protected
    
    # Additional Options:
    # * <tt>:authentication</tt> - authentication type to use, defaults to PLAIN
    def initialize(options={})
      @authentication = options.delete(:authentication) || 'PLAIN'
      super(options)
    end
    
    # Open connection and login to server
    def establish_connection
      @connection = Net::IMAP.new(@server)
      @connection.authenticate(@authentication, @username, @password)
    end
    
    # Retrieve messages from server
    def get_messages
      @connection.select('INBOX')
      @connection.search(['ALL']).each do |message_id|
        msg = @connection.fetch(message_id,'RFC822')[0].attr['RFC822']
        begin
          process_message(msg)
        rescue
          handle_bogus_message(msg)
        end
        # Mark message as deleted 
        @connection.store(message_id, "+FLAGS", [:Deleted])
      end
    end
    
    # Store the message for inspection if the receiver errors
    def handle_bogus_message(message)
      @connection.append('bogus', message)
    end
    
    # Delete messages and log out
    def close_connection
      @connection.expunge
      @connection.logout
      @connection.disconnect
    end
    
  end
end
