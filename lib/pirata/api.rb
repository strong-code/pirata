require 'nokogiri'
require 'open-uri'
require 'torrent'
require 'user'
require 'category'
require 'sort'
require 'config'

module Pirata
  class API
        
    def initialize(base = Pirata::Config::BASE_URL, page = 0, sort_type = Pirata::Sort::RELEVANCE, categories = ["0"])
      @base_url = base
      @page = page.to_s
      @sort_type = sort_type
      @category = categories.join(',')
      @paginated = false
    end
    
    # Perform a search and return an array of Torrent objects
    # Requires a query string.
    def search(query)
      #build URL ex: http://thepiratebay.se/search/cats/0/99/0
      url = @base_url + "/search/#{URI.escape(query)}" + "/#{@page}" + "/#{@sort_type}" + "/#{@category}"
      html = Nokogiri::HTML(open(url))
      parse_search_page(html)
    end
  
    def page(page)
      if page.class != Fixnum || page < 0
        raise "Page must be a valid, positive integer"
      elsif paginated
        @page = page
        return self.search()
      end
    end
    
    # Return the n most recent torrents from a category
    # Searches all categories if none supplied
    def top(category = "all")
      html = Nokogiri::HTML(open(@base_url + '/top/' + URI.escape(category)))
      parse_search_page(html)
    end
    
    # Return an array of the 30 most recent Torrents
    def recent
      html = Nokogiri::HTML(open(@base_url + '/recent'))
      parse_search_page(html)
    end
    
    private #---------------------------------------------
    
    # From a results table, collect and build all Torrents
    # into an array
    def parse_search_page(html)
      results = []
      html.css('#searchResult tr').each do |row|
        title = row.search('.detLink').text
        next if title == ''
        
        begin
          h = {}
          h[:title]       = title
          h[:category]    = row.search('td a')[0].text
          h[:title]       = row.search('.detLink')[0].text
          h[:url]         = @base_url + row.search('.detLink').attribute('href').to_s
          h[:id]          = h[:url].split('/')[4]
          h[:magnet_link] = row.search('td a')[3]['href']
          h[:seeders]     = row.search('td')[2].text.to_i
          h[:leechers]    = row.search('td')[3].text.to_i
          h[:uploader]    = Pirata::User.new(row.search('td a')[5].text, @base_url)
         # h[:paginated]   = row
        rescue
          #puts "not found"
        end
        results << Pirata::Torrent.new(h)
      end
      results
    end
    
  end
end

api = Pirata::API.new('http://thepiratebay.si')
#Pirata::Torrent.find_by_id(10088431)
#api.top
collection = api.search('skyrim')
#p collection.length
#p collection.first
#puts "-----"
#collection = api.search('world of warcraft')
#p collection.length
#p collection.first