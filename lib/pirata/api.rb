require 'nokogiri'
require 'open-uri'

module Pirata
  class API
    
    def initialize(base_url)
      @base_url = base_url
    end
    
    # Returns a Collection object containing the results
    # of the search according to supplied parameters.
    def search()
      #
    end
    
    # Return the n most recent torrents from a category
    # Searches all categories if none supplied
    def top(category = "all", n = "100")
      html = Nokogiri::HTML(open(@base_url + '/top/' + URI.escape(category)))
      
      p html.xpath("//table//tr")
    end
    
    # Return the n most recent torrents from all categories
    def recent(n = 0)
      #
    end
    
    private #---------------------------------------------
    
    # Build a URL from the supplied arguments
    def build_url
      #
    end
    
  end
end