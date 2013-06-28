# require File.dirname(__FILE__) + '/../../../../config/boot'
require 'rubygems'
require 'test/unit'
require 'mocha'
require 'fetcher'

class FetcherTest < Test::Unit::TestCase
  
  def setup
    @receiver = mock()
  end
  
  def test_should_set_configuration_instance_variables
    create_fetcher
    assert_equal 'test.host', @fetcher.instance_variable_get(:@server)
    assert_equal 'name', @fetcher.instance_variable_get(:@username)
    assert_equal 'password', @fetcher.instance_variable_get(:@password)
    assert_equal @receiver, @fetcher.instance_variable_get(:@receiver)
  end
  
  def test_should_require_subclass
    create_fetcher
    assert_raise(NotImplementedError) { @fetcher.fetch }
  end
  
  def test_should_require_server
    assert_raise(ArgumentError) { create_fetcher(:server => nil) }
  end
  
  def test_should_require_username
    assert_raise(ArgumentError) { create_fetcher(:username => nil) }
  end
  
  def test_should_require_password
    assert_raise(ArgumentError) { create_fetcher(:password => nil) }
  end
  
  def test_should_require_receiver
    assert_raise(ArgumentError) { create_fetcher(:receiver => nil) }
  end

  def test_should_handle_exception_if_receiver_raises_exception_during_receive
    @imap_fetcher = Fetcher.create(:type => :imap, :server => 'test.host',
                                   :username => 'name',
                                   :password => 'password',
                                   :receiver => @receiver)

    # most of this stubbing/mocking is to prevent the fetcher from 
    # actually connecting to a server.
    @fake_message = stub('fake-message')
    @stub_connection = stub_everything('fake-imap-connection', {
      :uid_search => ['123'], 
      :uid_fetch  => [stub('fake-message-piece', :attr => {"RFC822" => @fake_message})]
    })
    @imap_fetcher.stubs(:establish_connection).returns(true)
    @imap_fetcher.stubs(:connection).returns(@stub_connection)

    # The meat of this test
    exception = RuntimeError.new("Explosion")
    @receiver.expects(:receive).with(@fake_message).raises(exception)
    
    # we should handle the exception
    @imap_fetcher.expects(:handle_exception).with(exception)

    # but also ensure we handle the bogus message as well
    @imap_fetcher.expects(:handle_bogus_message).with(@fake_message)
    @imap_fetcher.fetch
  end
  
  def create_fetcher(options={})
    @fetcher = Fetcher::Base.new({:server => 'test.host', :username => 'name', :password => 'password', :receiver => @receiver}.merge(options))
  end
  
end

class FactoryFetcherTest < Test::Unit::TestCase
  
  def setup
    @receiver = mock()
    @pop_fetcher = Fetcher.create(:type => :pop, :server => 'test.host',
                               :username => 'name',
                               :password => 'password',
                               :receiver => @receiver)
    
  @imap_fetcher = Fetcher.create(:type => :imap, :server => 'test.host',
                              :username => 'name',
                              :password => 'password',
                              :receiver => @receiver)
  end
  
  def test_should_be_sublcass
    assert_equal Fetcher::Pop, @pop_fetcher.class
    assert_equal Fetcher::Imap, @imap_fetcher.class
  end
  
  def test_should_require_type
    assert_raise(ArgumentError) { Fetcher.create({}) }
  end
  
end

# Write tests for sub-classes
