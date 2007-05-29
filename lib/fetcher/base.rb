module Fetcher
  class Base

    def initialize(options={})
      %w(server username password receiver).each do |opt|
        instance_eval("@#{opt} = options[:#{opt}]")
      end
    end

    def fetch
      establish_connection
      get_message
      close_connection
    end

    protected

    def establish_connection; true; end
    def get_message; true; end
    def close_connection; true; end

  end
end
