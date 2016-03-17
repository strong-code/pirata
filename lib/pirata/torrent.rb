require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'
require 'time'

module Pirata
  class Torrent

    attr_reader :title, :category, :url, :id, :magnet

    def initialize(params_hash)
      @params     = params_hash
      @title      = @params[:title]
      @category   = @params[:category]
      @url        = @params[:url]
      @id         = @params[:id]
      @magnet     = @params[:magnet]

      build_getters()
    end

    # Return a Torrent object from a corresponding ID
    def self.find_by_id(id)
      raise "Invalid torrent ID format. Must be an integer" if id.class != Fixnum

      url  = Pirata.config[:base_url] + "/torrent" + "/#{URI.escape(id.to_s)}"
      html = self.parse_html(url)
      results_hash = parse_torrent_page(html)

      Pirata::Torrent.new(results_hash)
    end

    def update_params!
      html = Pirata::Torrent.parse_html(url)
      
      updated_params = Pirata::Torrent.parse_torrent_page(html)
      @params.merge!(updated_params)
    end

    private #-------------------------------------------------

    # Parse HTML body of a supplied URL
    class << self
      def parse_html(url)
        response = open(url, :allow_redirections => Pirata.config[:redirect])
        Nokogiri::HTML(response)
      end
    end

    # Initialize getters for +1 request variables, fetching them if we need them
    def build_getters
      [:seeders, :leechers, :uploader, :files, :size, :date, :comments, :hash].each do |m|
        self.class.send(:define_method, m) {
          update_params! unless @params[m]
          @params[m]
        }
      end
    end

    def self.parse_torrent_page(html)
      if html.css("#err").text.include?("404")
        raise "No torrent for supplied ID found"
      else
        row = html.css('#detailsframe').first
        h = {
          :title     => row.search('#title')[0].text.strip,
          :files     => row.at_css('dt:contains("Files:")').next_element().text.to_i,
          :size      => row.at_css('dt:contains("Size:")').next_element().child.text,
          :date      => Time.parse(row.at_css('dt:contains("Uploaded:")').next_element().text),
          :uploader  => Pirata::User.new(row.at_css('dt:contains("By:")').next_element().text.strip),
          :seeders   => row.at_css('dt:contains("Seeders:")').next_element().text.to_i,
          :leechers  => row.at_css('dt:contains("Leechers:")').next_element().text.to_i,
          :comments  => row.at_css('dt:contains("Comments")').next_element().text.to_i,
          :hash      => row.search('dl').text.split.last.strip,
          :magnet    => row.search('.download a')[0]['href']
        }
        return h
      end
      nil
    end

  end
end
