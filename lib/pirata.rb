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

  def self.configure(config)
    if config.class == Hash
      self.configure_from_hash(config)
      return
    elsif
      File.exist?(config)
      self.configure_from_file(config)
      return
    else
      raise 'Must pass configuration as a hash or path to YAML file.'
    end
  end

  def self.configure_from_hash(opts = {})
    opts.each do |k, v|
      @config[k.to_sym] = v if self.valid_key?(k)
    end
  end

  def self.configure_from_file(path)
    config = YAML::load(IO.read(path))
  end

  def self.config
    @config
  end

end
