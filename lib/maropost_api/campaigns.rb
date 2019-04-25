module MaropostApi
  class Campaigns
    
    def initialize(account, api_key = ENV["API_KEY"])
      @account = account
      MaropostApi.instance_variable_set(:@api_key, api_key)
      @resource_path = "/accounts/#{@account}"
    end
    
    def get(page)
      full_path = @resource_path << '/campaigns.json'
      query_params = MaropostApi.set_query_params({page: page})
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    def get_campaign(campaign_id)
      full_path = @resource_path << "/campaigns/#{campaign_id}.json"
      query_params = MaropostApi.set_query_params()
      
      MaropostApi.get_result(full_path, query_params)
    end
  end
end