require 'nokogiri'
require 'open-uri'
require 'torrent'
require 'user'
require 'category'
require 'sort'
require 'config'

module Pirata
  class Search
    
    attr_accessor :results, :pages
    attr_reader :category, :sort_type, :query
        
    def initialize(query, sort_type = Pirata::Sort::RELEVANCE, categories = ["0"])
      @sort_type = sort_type
      @category = categories.join(',')
      @pages = 0
      @query = query
      @results = search()
    end
    
    # Perform a search and return an array of Torrent objects
    def search(page = 0)
      #build URL ex: http://thepiratebay.se/search/cats/0/99/0
      url = Pirata::Config::BASE_URL + "/search/#{URI.escape(@query)}" + "/#{page.to_s}" + "/#{@sort_type}" + "/#{@category}"
      html = Nokogiri::HTML(open(url))
      Pirata::Search::parse_search_page(html, self)
    end
    
    # Return the n page results of a search, assuming it is multipage
  def search_page(page)
      raise "Search must be multipage to search pages" if !multipage?
      raise "Page must be a valid, positive integer" if page.class != Fixnum || page < 0
      raise "Invalid page range" if page > @pages
        
      self.search(page)
    end
    
    # Return the n most recent torrents from a category
    # Searches all categories if none supplied
    def self.top(category = "all")
      html = Nokogiri::HTML(open(Pirata::Config::BASE_URL + '/top/' + URI.escape(category)))
      Pirata::Search::parse_search_page(html)
    end
    
    # Return an array of the 30 most recent Torrents
    def self.recent
      html = Nokogiri::HTML(open(Pirata::Config::BASE_URL + '/recent'))
      Pirata::Search::parse_search_page(html)
    end
      
    def multipage?
      @pages > 0
    end
      
    private #---------------------------------------------
    
    # From a results table, collect and build all Torrents
    # into an array
    def self.parse_search_page(html, search_object = nil)
      results = []
      
      begin 
        search_object.pages = html.css('#content div a')[-2].text.to_i
      rescue
      end  
      
      html.css('#searchResult tr').each do |row|
        title = row.search('.detLink').text
        next if title == ''
        h = {}
        
        begin
          h[:title]       = title
          h[:category]    = row.search('td a')[0].text
          h[:url]         = Pirata::Config::BASE_URL + row.search('.detLink').attribute('href').to_s
          h[:id]          = h[:url].split('/')[4].to_i
          h[:magnet]      = row.search('td a')[3]['href']
          h[:seeders]     = row.search('td')[2].text.to_i
          h[:leechers]    = row.search('td')[3].text.to_i
          h[:uploader]    = Pirata::User.new(row.search('td a')[5].text)
        rescue
          #puts "not found"
        end
        results << Pirata::Torrent.new(h)
      end
      results
    end
    
  end
end