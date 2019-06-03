module MaropostApi

  ##
  # It contains methods that get reports based on provided parameters.
  # The method names themselves reveal the type of reports they are getting.
  class Reports
    
    def initialize(account = ENV["ACCOUNT"], api_key = ENV["API_KEY"])
      MaropostApi.instance_variable_set(:@api_key, api_key)
      MaropostApi.instance_variable_set(:@account, account)
    end
    
    def get(page)
      full_path = full_resource_path
      query_params = MaropostApi.set_query_params({'page' => page})
      
      MaropostApi.get_result(full_path, query_params)
    end
  
    def get_report(id)
      full_path = full_resource_path "/#{id}"
      query_params = MaropostApi.set_query_params
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    def get_opens(page:, fields: [], from: nil, to: nil, unique: nil, email: nil, uid: nil, per: nil)
      full_path = full_resource_path "/opens"
      params = {}
      method(__method__).parameters.each{|p| params[p[1]] = eval(p[1].to_s)}
      params.reject!{|k,v| v.nil? or (v.respond_to? :empty? and v.empty?) }

      query_params = MaropostApi.set_query_params(params)
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    def get_clicks(page:, fields: [], from: nil, to: nil, unique: nil, email: nil, uid: nil, per: nil)
      full_path = full_resource_path "/clicks"
      params = {}
      method(__method__).parameters.each{|p| params[p[1]] = eval(p[1].to_s)}
      params.reject!{|k,v| v.nil? or (v.respond_to? :empty? and v.empty?) }

      query_params = MaropostApi.set_query_params(params)
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    def get_bounces(page:, fields: [], from: nil, to: nil, unique: nil, email: nil, uid: nil, per: nil, type: nil)
      full_path = full_resource_path "/bounces"
      params = {}
      method(__method__).parameters.each{|p| params[p[1]] = eval(p[1].to_s)}
      params.reject!{|k,v| v.nil? or (v.respond_to? :empty? and v.empty?) }

      query_params = MaropostApi.set_query_params(params)
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    def get_unsubscribes(page:, fields: [], from: nil, to: nil, unique: nil, email: nil, uid: nil, per: nil)
      full_path = full_resource_path "/unsubscribes"
      params = {}
      method(__method__).parameters.each{|p| params[p[1]] = eval(p[1].to_s)}
      params.reject!{|k,v| v.nil? or (v.respond_to? :empty? and v.empty?) }

      query_params = MaropostApi.set_query_params(params)
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    def get_complaints(page:, fields: [], from: nil, to: nil, unique: nil, email: nil, uid: nil, per: nil)
      full_path = full_resource_path "/unsubscribes"
      params = {}
      method(__method__).parameters.each{|p| params[p[1]] = eval(p[1].to_s)}
      params.reject!{|k,v| v.nil? or (v.respond_to? :empty? and v.empty?) }

      query_params = MaropostApi.set_query_params(params)
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    def get_ab_reports(name:, page:, from: nil, to: nil, per: nil)
      full_path = full_resource_path('', "ab_reports")
      params = {}
      method(__method__).parameters.each{|p| params[p[1]] = eval(p[1].to_s)}
      params.reject!{|k,v| v.nil? or (v.respond_to? :empty? and v.empty?) }

      query_params = MaropostApi.set_query_params(params)
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    def get_journeys(page)
      full_path = full_resource_path '/journeys'
      query_params = MaropostApi.set_query_params({:page => page})
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    
      private
    
      def full_resource_path(specifics = '', root_resource = 'reports')
        account = MaropostApi.instance_variable_get(:@account)
        "/accounts/#{account}/#{root_resource}" << specifics
      end
  end
end