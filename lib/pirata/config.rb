module Pirata
  module Config
    
    # This is the base URL to query against. Depending on server/mirror
    # availability, blocked URLs, etc, you may need to change this. A
    # list of available mirrors for ThePirateBay may be found at
    # http://http://proxybay.info/
    #
    # Note that all URLs should yeild the same results. You are advised
    # to pick a mirror that is closest to your application server for best
    # results though.
    
    BASE_URL = "http://thepiratebay.si"
    
  end
end