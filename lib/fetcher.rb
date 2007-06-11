module Fetcher
  # Use factory-style initialization or insantiate directly from a subclass
  # 
  # Example:
  # 
  # Fetcher.new(:pop) is equivalent to
  # Fetcher::Pop.new()
  def self.new(klass, options={})
    module_eval "#{klass.to_s.capitalize}.new(options)"
  end
end

require 'fetcher/base'
require 'fetcher/pop'
require 'fetcher/imap'