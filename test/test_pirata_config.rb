require 'minitest/autorun'
require 'pirata'

class PirataConfigTest < Minitest::Unit::TestCase

  def setup
    Pirata.configure({
      :base_url => 'https://pirateproxy.tv/',
      :redirect => :all
    })
  end

  def test_config_defaults
    assert(!Pirata.config.nil?)
    assert(!Pirata.config[:base_url].nil?)
    assert_equal(:all, Pirata.config[:redirect])
  end

  def test_config_hash
    opts = {
      :base_url => 'http://test.com',
      :redirect => :safe
    }

    Pirata.configure(opts)

    assert_equal('http://test.com', Pirata.config[:base_url])
    assert_equal(:safe, Pirata.config[:redirect])
  end

  # Should revert to defaults on non-hash args
  def test_invalid_config
    opts = 'this is invalid'

    Pirata.configure(opts)

    assert_equal(:all, Pirata.config[:redirect])
  end

  # Shoudl revert to defaults on no arg call
  def test_nil_config
    Pirata.configure()

    assert(!Pirata.config[:base_url].nil?)
    assert_equal(:all, Pirata.config[:redirect])
  end

end
