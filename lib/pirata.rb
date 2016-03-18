require 'pirata/search'
require 'pirata/torrent'
require 'pirata/category'
require 'yaml'

module Pirata
  @config = {
    :base_url => 'https://pirateproxy.tv/',
    :redirect => :all
  }

  def self.valid_key?(key)
    @config.keys.include?(key.to_sym)
  end

  def self.configure(opts = nil)
    return if opts.nil?

    if opts.class == Hash
      opts.each do |k, v|
        @config[k.to_sym] = v if self.valid_key?(k)
      end
    end
  end

  def self.config
    @config
  end

end
