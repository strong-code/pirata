require 'nokogiri'
require 'open-uri'
require 'torrent'
require 'user'
require 'category'
require 'sort'

module Pirata
  class API
    
    attr_reader :base_url
    
    def initialize(base_url)
      @base_url = base_url
    end
    
    def search(query, page = 0, sort_type = Pirata::Sort::RELEVANCE, category = 0)
      #build URL ex: http://thepiratebay.se/search/cats/0/99/0
      url = @base_url + "/search/#{URI.escape(query)}" + "/#{page}" + "/#{sort_type}" + "/#{category}"
      html = Nokogiri::HTML(open(url))
      collect_results(html)
    end
    
    # Return the n most recent torrents from a category
    # Searches all categories if none supplied
    def top(category = "all")
      html = Nokogiri::HTML(open(@base_url + '/top/' + URI.escape(category)))
      collect_results(html)
    end
    
    def recent
      html = Nokogiri::HTML(open(@base_url + '/recent'))
      collect_results(html)
    end
    
    private #---------------------------------------------
    
    # From a results table, collect and build all Torrents
    # into an array
    def collect_results(html)
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
collection = api.search('skyrim')
p collection.length
p collection.first
puts "-----"
collection = api.search('world of warcraft')
p collection.length
p collection.first