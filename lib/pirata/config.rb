module Pirata
  module Config

    # This is the base URL to query against. Depending on server/mirror
    # availability, blocked URLs, etc, you may need to change this. A
    # list of available mirrors for ThePirateBay may be found at
    # https://proxybay.la/
    #
    # Note that all URLs should yeild the same results. You are advised
    # to pick a mirror that is closest to your application server for best
    # results though.

    BASE_URL = "https://ahoy.re"

    # This is the rule used when following HTTPS <-> HTTP redirects.
    # It accepts :all and :safe
    # :safe will allow HTTP -> HTTPS redirections
    # :all will allow both HTTP -> HTTPS redirections as well as HTTPS -> HTTP

    REDIRECT = :all

  end
end
