module MaropostApi
  
  class AbTestCampaigns
    
    def initialize(account = ENV["ACCOUNT"], api_key = ENV["API_KEY"])
      MaropostApi.instance_variable_set(:@api_key, api_key)
      MaropostApi.instance_variable_set(:@account, account)
    end
    
    def create_ab_test(
      name:,
      from_email:,
      address:,
      language:,
      campaign_groups_attributes:,
      commit:,
      sendAt:,
      brand_id: nil,
      suppressed_list_ids: [],
      suppressed_journey_ids: [],
      suppressed_segment_ids: [],
      email_preview_link: nil,
      decided_by: nil,
      lists: [],
      ctags: [],
      segments: []
    )
      args = method(__method__).parameters
      body = {:ab_test => {}}
      args.each do |arg|
        k = arg[1].to_s
        v = eval(k)
        body[:ab_test][k] = v unless v.nil?
      end
      
      full_path = full_resource_path('/ab_test')

      MaropostApi.post_result(full_path, :body => {campaign: body[:ab_test]})
    end
  
    private
    
      def full_resource_path(specifics = '', root_resource = "campaigns")
        account = MaropostApi.instance_variable_get(:@account)
        "/accounts/#{account}/#{root_resource}" << specifics
      end
  end
end