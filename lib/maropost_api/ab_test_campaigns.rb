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
      body = {contact: {}}
      args.each do |arg|
        k = arg[1].to_s
        v = eval(k)
        body[:contact][k] = v unless v.nil?
      end
      
      pp body
    end
  end
end