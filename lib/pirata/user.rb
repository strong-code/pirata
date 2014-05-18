require 'config'

module Pirata
  class User
    
    attr_reader :profile_url, :username
    
    def initialize(username)
      @username = username
      @profile_url = "#{Pirata::Config::BASE_URL}/user/#{@username}" 
    end
    
    def to_s
      @username  
    end
     
  end
end
