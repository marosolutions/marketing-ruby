RSpec.describe MaropostApi::Campaigns do
  it "gets a list of campaigns" do
    campaign = MaropostApi::Campaigns.new(1000)
    result = campaign.get(1)
    
    expect(result).not_to be_empty
    expect(result).to respond_to(:each)
    expect(result.first).to include("account_id" => 1000)
  end
  
  it "gets an individual campaign" do
    campaign_id = 2
    campaign = MaropostApi::Campaigns.new(1000)
    result = campaign.getCampaign(campaign_id)
    
    expect(result).not_to be_empty
    expect(result).to respond_to(:each)
    expect(result).to include("account_id" => 1000)
  end
end