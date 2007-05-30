module Fetcher
  class Base

    def initialize(options={})
      %w(server username password receiver).each do |opt|
        instance_eval("@#{opt} = options[:#{opt}]")
      end
    end

    def fetch
      establish_connection
      get_messages
      close_connection
    end

    protected

    def establish_connection
      raise NotImplementedError, "This method should be overridden by subclass"
    end
    
    def get_messages
      raise NotImplementedError, "This method should be overridden by subclass"
    end
    
    def close_connection
      raise NotImplementedError, "This method should be overridden by subclass"
    end

  end
end
