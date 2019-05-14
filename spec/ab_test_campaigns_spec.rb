RSpec.describe MaropostApi::AbTestCampaigns do
  before(:each) do
    @test_data = {
      :account_id => 1000
    }
  end
  
  it "creates an Ab Test Campaign when provided only the required params" do
    required_params = [:name, :from_email, :reply_to, :address, :language, :campaign_groups_attributes, :send_at, :commit]
    
    ab_test_camp = MaropostApi::AbTestCampaigns.new(@test_data[:account_id])
    
    ab_test_camp.create_ab_test('my name')
    
  end
end