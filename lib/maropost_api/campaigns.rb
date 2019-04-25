module MaropostApi
  class Campaigns
    
    def initialize(account, api_key = ENV["API_KEY"])
      @account = account
      @api_key = api_key
      @resource_path = "/accounts/#{@account}"
    end
    
    def get(page)
      full_path = @resource_path << '/campaigns.json'
      response = MaropostApi.get(full_path, {
        query: {
          auth_token: @api_key,
          page: page
        }
      })
      
      MaropostApi.get_result(response)
    end
    
    def getCampaign(campaign_id)
      full_path = @resource_path << "/campaigns/#{campaign_id}.json"
      response = MaropostApi.get(@resource_path, {
        query: {
          auth_token: @api_key
        }
      })
    end
    
    private
    
    def get_auth_query
      {
        query: {
          auth_token: @api_key
        }
      }
    end
  end
end