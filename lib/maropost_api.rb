require "maropost_api/version"
require "maropost_api/campaigns"
require "httparty"

module MaropostApi
  include HTTParty
  format :json
  base_uri 'https://api.maropost.com'
  
  class Error < StandardError; end
  
  def self.get_result(result)
    begin
      result.parsed_response if result.code == 200
    rescue
      raise 404
    end
  end
end
