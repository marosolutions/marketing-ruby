require "maropost_api/version"
require "maropost_api/campaigns"
require "httparty"

module MaropostApi
  include HTTParty
  format :json
  base_uri 'https://api.maropost.com'
  
  attr_accessor :api_key
  
  class Error < StandardError; end
  
  def self.get_result(path, options)
    begin
      result = get(path, options)
      result.parsed_response if result.code == 200
    rescue
      raise 404
    end
  end
  
  def self.set_query_params(query_params = {})
    return nil if query_params.class != Hash
    @query_params ||= {
      query: {auth_token: @api_key}
    }
    additional_params = { query: query_params }
    
    @query_params.merge(additional_params) do |key, qp_val, ap_val|
      qp_val.merge ap_val
    end
  end
  
end
