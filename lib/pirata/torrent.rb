require 'nokogiri'
require 'open-uri'
require 'time'
require 'config'

module Pirata
  class Torrent

    def initialize(params_hash)
      @params = params_hash
    end
    
    def title
      @params[:title]
    end
    
    def category
      @params[:category]
    end
    
    def title
      @params[:title]
    end
    
    def url
      @params[:url]
    end
    
    def id
      @params[:id]
    end
    
    def magnet
      @params[:magnet]
    end
    
    def seeders
      @params[:seeders]
    end
    
    def leechers
      @params[:leechers]
    end
    
    def uploader
      @params[:uploader]
    end
    
    def files
      unless @params[:files]
        update_params
      end
      @params[:files]
    end
    
    def size
      unless @params[:size]
        update_params
      end
      @params[:size]
    end
    
    def date
      unless @params[:date]
        update_params
      end
      @params[:date]
    end
    
    def comments
      unless @params[:comments]
        update_params
      end
      @params[:comments]
    end
    
    def hash
      unless @params[:hash]
        update_params
      end
      @params[:hash]
    end
           
    # Return a Torrent object from a corresponding ID
    def self.find_by_id(id)
      raise "Invalid torrent ID format. Must be an integer" if id.class != Fixnum
      html = Nokogiri::HTML(open(Pirata::Config::BASE_URL + "/torrent" + "/#{URI.escape(id.to_s)}"))
      results_hash = parse_torrent_page(html)
      Pirata::Torrent.new(results_hash)
    end
    
    def update_params
      html = Nokogiri::HTML(open(@params[:url]))
      updated_params = Pirata::Torrent.parse_torrent_page(html)
      @params.merge!(updated_params)
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
          :date      => Time.parse(row.search('.col2 dd')[0].text),
          :uploader  => row.search('dd')[4].text.strip,
          :seeders   => row.search('dd')[5].text.to_i,
          :leechers  => row.search('dd')[6].text.to_i,
          :comments  => row.search('dd')[7].text.to_i,
          :hash      => row.search('dl').text.split.last.strip
        }
        return h
      end
      nil
    end
        
  end
end