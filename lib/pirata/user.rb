module Pirata
  class User

    attr_reader :profile_url, :username

    def initialize(username)
      @username = username
      @profile_url = "#{Pirata.config[:base_url]}/user/#{@username}"
    end

    def to_s
      @username
    end

  end
end
