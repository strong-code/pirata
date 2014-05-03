module Pirata
  class User
    
    attr_reader :profile_url, :username
    
    def initialize(username, base_url)
      @username = username
      @base_url = base_url
      @profile_url = "#{@base_url}/user/#{@username}" 
    end
     
  end
end