RSpec.describe MaropostApi::AbTestCampaigns do
  before(:each) do
    @test_data = {
      :account_id => 1000
    }
  end
  
  it "creates an Ab Test Campaign when provided only the required params" do
    required_params = [:name, :from_email, :reply_to, :address, :language, :campaign_groups_attributes, :send_at, :commit]
    
    ab_test_camp = MaropostApi::AbTestCampaigns.new(@test_data[:account_id])
    
    create_result = ab_test_camp.create_ab_test(
      :name => 'Test AbTestCampaign User',
      :from_email => 'fakeemail@abtestcampaign.com',
      :language => 'English',
      :address => 'Kathmandu, Nepal',
      :campaign_groups_attributes => ['some attributes'],
      :commit => 'Save as Draft',
      :sendAt => Time.now
    )
    
    # pp create_result
    
  end
end