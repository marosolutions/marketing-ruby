module MaropostApi

  ##
  # Contains methods that get reports based on provided parameters.
  # The method names themselves reveal the type of reports they are getting.
  class Reports
    ##
    # Creates a new instance of Reports class.
    # Takes +account+ and +api_key+ as parameters where 
    # @param account [Integer] is authentic user account id (Integer) provided by maropost.com
    # @param api_key [String] is the auth token (String) that is validated on the server to authenticate the user
    def initialize(account = ENV["ACCOUNT"], api_key = ENV["API_KEY"])
      MaropostApi.instance_variable_set(:@api_key, api_key)
      MaropostApi.instance_variable_set(:@account, account)
    end
    
    ##
    # gets all the reports grouped by +page+ (Integer)
    def get(page)
      full_path = full_resource_path
      query_params = MaropostApi.set_query_params({'page' => page})
      
      MaropostApi.get_result(full_path, query_params)
    end
  
    ##
    # gets a report defined by its unique +id+ (Integer)
    def get_report(id)
      full_path = full_resource_path "/#{id}"
      query_params = MaropostApi.set_query_params
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    ##
    # gets all open reports described by 
    # @param page [Integer] Integer that tells the service what page of report to retrieve
    # @param fields [Array] that contains the name of the fields of the contact to retrieve
    # @param from [Date] formatted string to add a constriant to our result
    # @param to [Date] Part of date range of +from+. Determines the result retrieved is in between this range of date
    # @param unique [Boolean] that indicates whether to get unique reports or not
    # @param email [String] email to be equated while querying for reports
    # @param uid [String] carrying unique identifier for the report.
    # @param per [Integer] determining how many records to get for each page
    def get_opens(page:, fields: [], from: nil, to: nil, unique: nil, email: nil, uid: nil, per: nil)
      full_path = full_resource_path "/opens"
      params = {}
      method(__method__).parameters.each{|p| params[p[1]] = eval(p[1].to_s)}
      params.reject!{|k,v| v.nil? or (v.respond_to? :empty? and v.empty?) }

      query_params = MaropostApi.set_query_params(params)
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    ##
    # gets all click reports described by 
    # @param page [Integer] that tells the service what page of report to retrieve
    # @param fields [Array] that contains the name of the fields of the contact to retrieve
    # @param from [Date] formatted string to add a constriant to our result
    # @param to [Part] of date range of +from+. Determines the result retrieved is in between this range of date
    # @param unique [Boolean] that indicates whether to get unique reports or not
    # @param email [String] email to be equated while querying for reports
    # @param uid [String] carrying unique identifier for the report.
    # @param per [Integer] determining how many records to get for each page
    def get_clicks(page:, fields: [], from: nil, to: nil, unique: nil, email: nil, uid: nil, per: nil)
      full_path = full_resource_path "/clicks"
      params = {}
      method(__method__).parameters.each{|p| params[p[1]] = eval(p[1].to_s)}
      params.reject!{|k,v| v.nil? or (v.respond_to? :empty? and v.empty?) }

      query_params = MaropostApi.set_query_params(params)
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    ##
    # gets all bounce reports described by 
    # @param page [Integer] that tells the service what page of report to retrieve
    # @param fields [Array] that contains the name of the fields of the contact to retrieve
    # @param from [Date] formatted string to add a constriant to our result
    # @param to [Part] of date range of +from+. Determines the result retrieved is in between this range of date
    # @param unique [Boolean] that indicates whether to get unique reports or not
    # @param email [String] email to be equated while querying for reports
    # @param uid [String] carrying unique identifier for the report.
    # @param per [Integer] determining how many records to get for each page
    # @param type [String] Set of values determining "soft" or "hard" bounces
    def get_bounces(page:, fields: [], from: nil, to: nil, unique: nil, email: nil, uid: nil, per: nil, type: nil)
      full_path = full_resource_path "/bounces"
      params = {}
      method(__method__).parameters.each{|p| params[p[1]] = eval(p[1].to_s)}
      params.reject!{|k,v| v.nil? or (v.respond_to? :empty? and v.empty?) }

      query_params = MaropostApi.set_query_params(params)
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    ##
    # gets all unsubscribe reports described by 
    # @param page: [Integer] that tells the service what page of report to retrieve
    # @param fields: [Array] that contains the name of the fields of the contact to retrieve
    # @param from: [Date] formatted string to add a constriant to our result
    # @param to: [Date] part of date range of +from+. Determines the result retrieved is in between this range of date
    # @param unique: [Boolean] that indicates whether to get unique reports or not
    # @param email: [String] email to be equated while querying for reports
    # @param uid: [String] carrying unique identifier for the report.
    # @param per: [Integer] determining how many records to get for each page
    def get_unsubscribes(page:, fields: [], from: nil, to: nil, unique: nil, email: nil, uid: nil, per: nil)
      full_path = full_resource_path "/unsubscribes"
      params = {}
      method(__method__).parameters.each{|p| params[p[1]] = eval(p[1].to_s)}
      params.reject!{|k,v| v.nil? or (v.respond_to? :empty? and v.empty?) }

      query_params = MaropostApi.set_query_params(params)
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    ##
    # gets all complaint reports described by 
    # @param page [Integer] that tells the service what page of report to retrieve
    # @param fields [Array] that contains the name of the fields of the contact to retrieve
    # @param from [Date] formatted string to add a constriant to our result
    # @param to [Date] part of date range of +from+. Determines the result retrieved is in between this range of date
    # @param unique [Boolean] that indicates whether to get unique reports or not
    # @param email [String] email to be equated while querying for reports
    # @param uid [String] carrying unique identifier for the report.
    # @param per [Integer] determining how many records to get for each page
    def get_complaints(page:, fields: [], from: nil, to: nil, unique: nil, email: nil, uid: nil, per: nil)
      full_path = full_resource_path "/unsubscribes"
      params = {}
      method(__method__).parameters.each{|p| params[p[1]] = eval(p[1].to_s)}
      params.reject!{|k,v| v.nil? or (v.respond_to? :empty? and v.empty?) }

      query_params = MaropostApi.set_query_params(params)
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    ##
    # gets all ab reports described by 
    # @param page [Integer] that tells the service what page of report to retrieve
    # @param fields [Array] that contains the name of the fields of the contact to retrieve
    # @param from [Date] formatted string to add a constriant to our result
    # @param to [Date] part of date range of +from+. Determines the result retrieved is in between this range of date
    # @param per [Integer] determining how many records to get for each page
    def get_ab_reports(name:, page:, from: nil, to: nil, per: nil)
      full_path = full_resource_path('', "ab_reports")
      params = {}
      method(__method__).parameters.each{|p| params[p[1]] = eval(p[1].to_s)}
      params.reject!{|k,v| v.nil? or (v.respond_to? :empty? and v.empty?) }

      query_params = MaropostApi.set_query_params(params)
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    ## 
    # gets all journey reports for the provided +page+
    # @param page [Integer]
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