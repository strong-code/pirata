require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'
require 'time'
require 'pirata/config'

module Pirata
  class Torrent

    attr_reader :title

    def initialize(params_hash)
      @params = params_hash
      @title = params_hash[:title]
    end

    # def title
    #   @params[:title]
    # end

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
      unless @params[:magnet]
        update_params
      end
      @params[:magnet]
    end

    def seeders
      unless @params[:seeders]
        update_params
      end
      @params[:seeders]
    end

    def leechers
      unless @params[:leechers]
        update_params
      end
      @params[:leechers]
    end

    def uploader
      unless @params[:uploader]
        update_params
      end
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
      url = Pirata::Config::BASE_URL + "/torrent" + "/#{URI.escape(id.to_s)}"
      html = Nokogiri::HTML(open(url, :allow_redirections => Pirata::Config::REDIRECT))
      results_hash = parse_torrent_page(html)
      Pirata::Torrent.new(results_hash)
    end

    def update_params
      html = Nokogiri::HTML(open(@params[:url], :allow_redirections => Pirata::Config::REDIRECT))
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
