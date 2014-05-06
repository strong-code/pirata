require 'nokogiri'
require 'open-uri'
require 'time'

module Pirata
  class Torrent
    
    def initialize(params)
      params.each do |k,v| 
        instance_variable_set("@#{k}", v)
        self.class.send(:attr_reader, k)
      end
    end
      
    def self.find_by_id(id)
      raise "Invalid torrent ID format. Must be an integer" if id.class != Fixnum
      html = Nokogiri::HTML(open(Pirata::Config::BASE_URL + "/torrent" + "/#{URI.escape(id.to_s)}"))
      parse_torrent_page(html)
    end
    
    private #-------------------------------------------------
    
    def self.parse_torrent_page(html)
      if html.css("#err").text.include?("404")
        raise "No torrent for supplied ID found"
      else        
        row = html.css('#detailsframe').first
        h = {
          :title     => row.search('#title')[0].text.strip,
          :files     => row.search('dd a')[1].text.to_i,
          :size      => row.search('dd')[2].child.text,
          :date      => Time.parse(row.search('dd')[3].child.text),
          :uploader  => row.search('dd')[4].text.strip,
          :seeders   => row.search('dd')[5].text.to_i,
          :leechers  => row.search('dd')[6].text.to_i,
          :comments  => row.search('dd')[7].text.to_i,
          :hash      => row.search('dl').text.split.last.strip
        }
      end
      p Torrent.new(h)
    end
        
  end
end