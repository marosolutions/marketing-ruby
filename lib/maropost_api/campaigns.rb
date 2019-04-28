module MaropostApi
  
  class Campaigns
    
    def initialize(account = ENV["ACCOUNT"], api_key = ENV["API_KEY"])
      MaropostApi.instance_variable_set(:@api_key, api_key)
      MaropostApi.instance_variable_set(:@account, account)
    end
    
    def get(page)
      full_path = full_resource_path('')
      query_params = MaropostApi.set_query_params({page: page})
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    def get_campaign(campaign_id)
      full_path = full_resource_path("/#{campaign_id}")
      query_params = MaropostApi.set_query_params()

      MaropostApi.get_result(full_path, query_params)
    end
    
    def get_bounce_reports(campaign_id, page)
      full_path = full_resource_path("/#{campaign_id}/bounce_report")
      query_params = MaropostApi.set_query_params({page:page})
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    def get_click_reports(campaign_id, page, unique = nil)
      full_path = full_resource_path("/#{campaign_id}/click_report")
      query_params = MaropostApi.set_query_params({page: page})
      query_params[:query][:unique] = unique unless unique.nil?
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    def get_complaint_reports(campaign_id, page)
      full_path = full_resource_path("/#{campaign_id}/complaint_report")
      query_params = MaropostApi.set_query_params({page: page})
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    def get_delivered_reports(campaign_id, page)
      full_path = full_resource_path("/#{campaign_id}/delivered_report")
      query_params = MaropostApi.set_query_params({page: page})
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    def get_hard_bounce_reports(campaign_id, page)
      full_path = full_resource_path("/#{campaign_id}/hard_bounce_report")
      query_params = MaropostApi.set_query_params({page: page})
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    def get_soft_bounce_reports(campaign_id, page)
      full_path = full_resource_path("/#{campaign_id}/soft_bounce_report")
      query_params = MaropostApi.set_query_params({page: page})
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    def get_open_reports(campaign_id, page, unique = nil)
      full_path = full_resource_path("/#{campaign_id}/open_report")
      query_params = MaropostApi.set_query_params({page: page})
      query_params[:query][:unique] = unique unless unique.nil?
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    def get_unsubscribe_reports(campaign_id, page)
      full_path = full_resource_path("/#{campaign_id}/unsubscribe_report")
      query_params = MaropostApi.set_query_params({page: page})
      
      MaropostApi.get_result(full_path, query_params)
    end
    
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