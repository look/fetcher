module Fetcher
  class Base
    
    def initialize(options={})
      %w(server username password receiver).each do |opt|
        raise ArgumentError, "#{opt} is required" unless options[opt.to_sym]
        instance_eval("@#{opt} = options[:#{opt}]")
      end
    end
    
    # Run the fetching process
    def fetch
      establish_connection
      get_messages
      close_connection
    end
    
    protected
    
    # Stub. Should be overridden by subclass.
    def establish_connection #:nodoc:
      raise NotImplementedError, "This method should be overridden by subclass"
    end
    
    # Stub. Should be overridden by subclass.
    def get_messages #:nodoc:
      raise NotImplementedError, "This method should be overridden by subclass"
    end
    
    # Stub. Should be overridden by subclass.
    def close_connection #:nodoc:
      raise NotImplementedError, "This method should be overridden by subclass"
    end
    
    # Send message to receiver object
    def process_message(message)
      @receiver.receive(message)
    end
    
    # Stub. Should be overridden by subclass.
    def handle_bogus_message(message) #:nodoc:
      raise NotImplementedError, "This method should be overridden by subclass"
    end
  end
end
