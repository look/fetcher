require File.dirname(__FILE__) + '/../../../../config/boot'
require 'test/unit'
require 'mocha'
require 'fetcher'

class FetcherTest < Test::Unit::TestCase
  
  def setup
    @receiver = mock()
    @fetcher = Fetcher::Base.new(:server => 'test.host',
                                 :username => 'name',
                                 :password => 'password',
                                 :receiver => @receiver)
  end
  
  def test_should_set_configuration_instance_variables
    assert_equal 'test.host', @fetcher.instance_variable_get(:@server)
    assert_equal 'name', @fetcher.instance_variable_get(:@username)
    assert_equal 'password', @fetcher.instance_variable_get(:@password)
    assert_equal @receiver, @fetcher.instance_variable_get(:@receiver)
  end
  
  def test_should_fetch_message
    assert @fetcher.fetch
  end
end
