require "maropost_api/version"
require 'uri'
require "maropost_api/campaigns"
require "maropost_api/contacts"
require "maropost_api/journeys"
require "maropost_api/products_and_revenue"
require "maropost_api/custom_types/operation_result"
require "maropost_api/ab_test_campaigns"
require "maropost_api/reports"
require "maropost_api/relational_tables"
require "maropost_api/transactional_campaigns"
require "httparty"

##
# This package provides programmatic access to several Maropost services. It consists of eight services within the MaropostApi
# namespace. Each service consists of one or more functions that perform an operation against your Maropost account. These methods
# return a result object indicating success/failure, any Exceptions thrown, and the resulting data. The detailed documentation of the
# api can be found in http://api.maropost.com/api
#
module MaropostApi
  include HTTParty
  # debug_output $stdout
  include URI
  format :json
  base_uri 'https://api.maropost.com'
  
  attr_accessor :api_key
  attr_accessor :account
  
  class Error < StandardError; end
  
  def self.get_result(path, options)
    full_path = path << ".#{format.to_s}"
    result = get(full_path, options)
    
    OperationResult.new(result)
  end
  
  def self.post_result(path, form_body)
    raise ArgumentError "path and form_body cannot be nil" if path.nil? || form_body.nil?
    full_path = path << ".#{format.to_s}"
    # set auth_token manually due to 400 error when sent via parameters
    full_path = full_path << "?auth_token=#{@api_key}"
    result = post(full_path, :body => form_body.to_json, :headers => {"Content-Type" => 'application/json'})
    
    OperationResult.new(result)
  end
  
  def self.put_result(path, form_body = {}, query_params = {})
    raise ArgumentError "path and form_body cannot be nil" if path.nil? || form_body.nil?
    full_path = path << ".#{format.to_s}"
    query_params = set_query_params if query_params.empty?
    result = put(full_path, :body => form_body.to_json, :headers => {"Content-Type" => 'application/json', 'Accept' => 'application/json'}, :query => query_params[:query])
    
    OperationResult.new(result)
  end
  
  def self.delete_result(path, query_params, body={})
    raise ArgumentError "path and query_params cannot be nil" if path.nil? || query_params.nil?
    full_path = path << ".#{format.to_s}"
    result = delete(full_path, :headers => {"Content-Type" => 'application/json'}, :query => query_params[:query], :body => body.to_json)
    
    OperationResult.new(result)
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
