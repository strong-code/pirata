require 'minitest/autorun'
require 'pirata'

class PirataConfigTest < Minitest::Unit::TestCase

  def setup
    Pirata.configure()
  end

  def test_config_defaults
    assert(!Pirata.config.nil?)
    assert(!Pirata.config[:base_url].nil?)
    assert(Pirata.config[:redirect] == :all)
  end

  def test_config_hash
    opts = {
      :base_url => 'http://test.com',
      :redirect => :safe
    }

    Pirata.configure(opts)

    assert(Pirata.config[:base_url] == 'http://test.com')
    assert(Pirata.config[:redirect] == :safe)
  end

  # Should revert to defaults on non-hash args
  def test_invalid_config
    opts = 'this is invalid'

    Pirata.configure(opts)

    assert(Pirata.config[:redirect] == :all)
  end

end
