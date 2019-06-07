module MaropostApi
  
  ##
  # Contains methods that get various Campaign Reports based on provided parameters.
  # The method names themselves reveal the type of reports they are getting.
  class Campaigns
    ##
    # Creates a new instance of Reports class.
    # @param account [Integer] is authentic user account id (Integer) provided by maropost.com
    # @param api_key [String] is the auth token (String) that is validated on the server to authenticate the user
    def initialize(account = ENV["ACCOUNT"], api_key = ENV["API_KEY"])
      MaropostApi.instance_variable_set(:@api_key, api_key)
      MaropostApi.instance_variable_set(:@account, account)
    end
    
    ##
    # gets all the campaigns grouped by 
    # @param page (Integer) number that determines which page of the result to retrieve
    def get(page)
      full_path = full_resource_path('')
      query_params = MaropostApi.set_query_params({page: page})
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    ##
    # gets a campaign determined by the provided
    # @param campaign_id [Integer] Unique identifier of campaigns
    def get_campaign(campaign_id)
      full_path = full_resource_path("/#{campaign_id}")
      query_params = MaropostApi.set_query_params()

      MaropostApi.get_result(full_path, query_params)
    end
    
    ##
    # gets bounce reports for the provided
    # @param campaign_id [Integer] Unique id of campaign
    # @param page [Integer] number that decides which page of result to get
    def get_bounce_reports(campaign_id, page)
      full_path = full_resource_path("/#{campaign_id}/bounce_report")
      query_params = MaropostApi.set_query_params({page:page})
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    ##
    # gets click reports for the provided
    # @param campaign_id [Integer] Unique id of campaign
    # @param page [Integer] number that decides which page of result to get
    # @param unique [Boolean] decides whether to retrive unique reports or not
    def get_click_reports(campaign_id, page, unique = nil)
      full_path = full_resource_path("/#{campaign_id}/click_report")
      query_params = MaropostApi.set_query_params({page: page})
      query_params[:query][:unique] = unique unless unique.nil?
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    ##
    # gets complaint reports for the provided
    # @param campaign_id [Integer] Unique id of campaign
    # param page [Integer] number that decides which page of result to get
    def get_complaint_reports(campaign_id, page)
      full_path = full_resource_path("/#{campaign_id}/complaint_report")
      query_params = MaropostApi.set_query_params({page: page})
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    ##
    # gets delivered reports for the provided
    # @param campaign_id [Integer] Unique id of campaign
    # param page [Integer] number that decides which page of result to get
    def get_delivered_reports(campaign_id, page)
      full_path = full_resource_path("/#{campaign_id}/delivered_report")
      query_params = MaropostApi.set_query_params({page: page})
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    ##
    # gets hard bounce reports for the provided
    # @param campaign_id [Integer] Unique id of campaign
    # param page [Integer] number that decides which page of result to get
    def get_hard_bounce_reports(campaign_id, page)
      full_path = full_resource_path("/#{campaign_id}/hard_bounce_report")
      query_params = MaropostApi.set_query_params({page: page})
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    ##
    # gets soft bounce reports for the provided
    # @param campaign_id [Integer] Unique id of campaign
    # param page [Integer] number that decides which page of result to get
    def get_soft_bounce_reports(campaign_id, page)
      full_path = full_resource_path("/#{campaign_id}/soft_bounce_report")
      query_params = MaropostApi.set_query_params({page: page})
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    ##
    # gets open reports for the provided
    # @param campaign_id [Integer] Unique id of campaign
    # param page [Integer] number that decides which page of result to get
    # @param unique [Boolean] decides whether to retrive unique reports or not
    def get_open_reports(campaign_id, page, unique = nil)
      full_path = full_resource_path("/#{campaign_id}/open_report")
      query_params = MaropostApi.set_query_params({page: page})
      query_params[:query][:unique] = unique unless unique.nil?
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    ##
    # gets unsubscribe reports for the provided
    # @param campaign_id [Integer] Unique id of campaign
    # param page [Integer] number that decides which page of result to get
    def get_unsubscribe_reports(campaign_id, page)
      full_path = full_resource_path("/#{campaign_id}/unsubscribe_report")
      query_params = MaropostApi.set_query_params({page: page})
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    ##
    # gets link reports for the provided
    # @param campaign_id [Integer] Unique id of campaign
    # param page [Integer] number that decides which page of result to get
    def get_link_reports(campaign_id, page, unique = nil)
      full_path = full_resource_path("/#{campaign_id}/link_report")
      query_params = MaropostApi.set_query_params({page: page})
      query_params[:query][:unique] = unique unless unique.nil?
      
      MaropostApi.get_result(full_path, query_params)
    end
    
      private
      
      def full_resource_path(specifics = '')
        account = MaropostApi.instance_variable_get(:@account)
        "/accounts/#{account}/campaigns" << specifics
      end
  end
  
end