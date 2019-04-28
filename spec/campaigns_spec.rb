RSpec.describe MaropostApi::Campaigns do
  
  it "gets a list of campaigns" do    
    campaign = MaropostApi::Campaigns.new(1000)
    result = campaign.get(1)
    
    expect(result).not_to be_empty
    expect(result).to respond_to(:each)
    expect(result.first).to include("account_id" => 1000)
  end
  
  it "gets an individual campaign" do    
    campaign_id = 4833
    campaign = MaropostApi::Campaigns.new(1000)
    result = campaign.get_campaign(campaign_id)

    expect(result).not_to be_empty
    expect(result).to respond_to(:each)
    expect(result).to include("account_id" => 1000)
    expect(result).to include("id" => campaign_id)
  end
  
  it "gets bounce reports" do    
    campaign_id = 4833
    campaign = MaropostApi::Campaigns.new(1000)
    bounce_reports = campaign.get_bounce_reports(campaign_id, 1)

    expect(bounce_reports.is_a? Array).to eq true
    expect(bounce_reports).to respond_to(:each)
  end
  
  describe "--- click reports ----" do
    it "gets non unique click reports" do      
      campaign_id = 4834
      page = 1
      campaign = MaropostApi::Campaigns.new(1000)
      click_reports = campaign.get_click_reports(campaign_id, page)

      expect(click_reports.is_a? Array).to eq true
      expect(click_reports).to respond_to(:each)

      contact_ids = []
      click_reports.each do |click_report|
        contact_ids.push click_report['contact_id']
      end
      # test for non-uniqueness
      dups = contact_ids.select{|contact| contact_ids.count(contact) > 1}
      
      expect(dups).not_to be_empty
    end  
    
    it "gets unique click reports" do      
      campaign_id = 4834
      page = 1
      unique = true
      campaign = MaropostApi::Campaigns.new(1000)
      click_reports = campaign.get_click_reports(campaign_id, page, unique)

      expect(click_reports.is_a? Array).to eq true
      expect(click_reports).to respond_to(:each)
      
      contact_ids = click_reports.collect{|r| r["contact_id"]}
      # test for uniqueness
      p contact_ids, contact_ids.uniq
      expect(contact_ids.uniq.length == contact_ids.length).to eq true
    end
    
    it "gets click reports for provided page" do      
      campaign_id = 4834
      campaign = MaropostApi::Campaigns.new(1000)
      click_reports_page1 = campaign.get_click_reports(campaign_id, 1)
      click_reports_page2 = campaign.get_click_reports(campaign_id, 2)
      # p click_reports_page1, click_reports_page2
      [click_reports_page1, click_reports_page2].each do |click_report|
        expect(click_report.is_a? Array).to eq true
        expect(click_report).to respond_to(:each)
        expect(click_report).to respond_to(:empty?)
      end
      
      total_pages = click_reports_page1.first["total_pages"] unless click_reports_page1.empty?
      
      expect(click_reports_page2).to be_empty if total_pages == 1
      expect(click_reports_page2).not_to be_empty if total_pages > 1
    end
  end
  
  describe "----complaint reports-----" do
    it "gets complaint reports for given campaign id" do      
      campaign_id = 4834
      campaign = MaropostApi::Campaigns.new(1000)
      complaint_reports = campaign.get_complaint_reports(campaign_id, 1)
      
      expect(complaint_reports).to be_kind_of Array
      expect(complaint_reports).to respond_to :each
      expect(complaint_reports).to respond_to :empty?
      
      unless complaint_reports.empty?
        expect(complaint_reports.first["account_id"]).to eq(1000)
        expect(complaint_reports.first["campaign_id"]).to eq campaign_id
      end
    end
    
    it "gets specified page of complaint reports" do      
      campaign_id = 4834
      campaign = MaropostApi::Campaigns.new(1000)
      complaint_reports_page1 = campaign.get_complaint_reports(campaign_id, 1)
      complaint_reports_page2 = campaign.get_complaint_reports(campaign_id, 2)
      
      total_pages = 0
      [complaint_reports_page1, complaint_reports_page2].each do |report|
        total_pages = report["total_pages"] unless report.empty?
        expect(report).to be_kind_of Array
        expect(report).to respond_to :each
        expect(report).to respond_to :empty?
      end
      
      unless total_pages < 2
        expect(complaint_reports_page2).not_to be_empty
      end
    end
  end
  
  describe "----Delivered Reports-----" do    it "gets delivered reports" do
      # first get campaigns and find which one actually has few delivered reports
      campaign = MaropostApi::Campaigns.new(1000)
      campaigns = campaign.get(1).collect{|c| c["id"]}
      campaign_id = nil
      campaigns.each do |camp_id|
        single_campaign = campaign.get_campaign(camp_id)
        delivered = single_campaign["delivered"]
        campaign_id = camp_id
        break if delivered > 1
      end
      delivered_reports = campaign.get_delivered_reports(campaign_id, 1)
      
      expect(delivered_reports).to be_kind_of Array
      expect(delivered_reports).to respond_to :each
      expect(delivered_reports).to respond_to :empty?
      expect(delivered_reports).not_to be_empty
      
      total_pages = delivered_reports.first["total_pages"] unless delivered_reports.empty?
      total_pages ||= 0
      delivered_reports_page2 = campaign.get_delivered_reports(campaign_id, 2)
      unless total_pages < 2        
        expect(delivered_reports_page2).to be_kind_of Array
        expect(delivered_reports_page2).to respond_to :each
        expect(delivered_reports_page2).to respond_to :empty?
        expect(delivered_reports_page2).not_to be_empty 
      else
        expect(delivered_reports_page2).to be_empty
      end
    end
  end
  
  describe "----Bounce Reports-----" do
    it "get hard bounce reports for specified page" do      
      campaign = MaropostApi::Campaigns.new(1000)
      campaigns = campaign.get(2).collect{|c| c["id"]}
      campaign_id = nil
      campaigns.reverse.each do |camp_id|
        single_campaign = campaign.get_campaign(camp_id)
        hard_bounces = single_campaign["hard_bounced"]
        campaign_id = camp_id
        break if hard_bounces > 0
      end
      hard_bounced_reports = campaign.get_hard_bounce_reports(campaign_id, 1)
      hard_bounced_reports_page2 = campaign.get_hard_bounce_reports(campaign_id, 2)
      
      total_pages = hard_bounced_reports.first["total_pages"]
      expect(hard_bounced_reports_page2).to be_empty unless total_pages < 2
      
      expect(hard_bounced_reports).to be_kind_of Array
      expect(hard_bounced_reports).to respond_to :each
      expect(hard_bounced_reports).to respond_to :empty?
      
    end
    
    it "gets soft bounced reports for specified page" do      
      campaign = MaropostApi::Campaigns.new(1000)
      campaigns = campaign.get(2).collect{|c| c["id"]}
      campaign_id = nil
      campaigns.reverse.each do |camp_id|
        single_campaign = campaign.get_campaign(camp_id)
        soft_bounces = single_campaign["soft_bounced"]
        campaign_id = camp_id
        break if soft_bounces > 0
      end
      soft_bounced_reports = campaign.get_soft_bounce_reports(campaign_id, 1)
      soft_bounced_reports_page2 = campaign.get_soft_bounce_reports(campaign_id, 2)

      total_pages = soft_bounced_reports.first["total_pages"]
      expect(soft_bounced_reports_page2).to be_empty unless total_pages < 2

      expect(soft_bounced_reports).to be_kind_of Array
      expect(soft_bounced_reports).to respond_to :each
      expect(soft_bounced_reports).to respond_to :empty?
    end
  end
  
  it "gets open reports" do    
    campaign = MaropostApi::Campaigns.new(1000)
    campaigns = campaign.get(2).collect{|c| c["id"]}
    campaign_id = nil
    campaigns.reverse.each do |camp_id|
      single_campaign = campaign.get_campaign(camp_id)
      campaign_id = camp_id
      break if single_campaign["opened"] > 5 && single_campaign["unique_opens"] < 5
    end
    
    opened_reports = campaign.get_open_reports(campaign_id, 1)
    
    expect(opened_reports).to be_kind_of Array
    expect(opened_reports).to respond_to :each
    expect(opened_reports).to respond_to :empty?
    # test for uniqueness
    unique_opens = campaign.get_open_reports(campaign_id, 1, true)
    expect(unique_opens.uniq.length == unique_opens.length).to eq true
    expect(unique_opens.length < opened_reports.length).to eq true
  end
  
  it "gets unsubscribe reports" do    
    campaign = MaropostApi::Campaigns.new(1000)
    campaigns = campaign.get(1).collect{|c| c["id"]}
    campaign_id = nil
    campaigns.each do |camp_id|
      single_campaign = campaign.get_campaign(camp_id)
      campaign_id = camp_id
      break if single_campaign["unsubscribed"] > 0
    end
    
    unsubscribes = campaign.get_unsubscribe_reports(campaign_id, 1)
    
    expect(unsubscribes).to be_kind_of Array
    expect(unsubscribes).to respond_to :empty?
    expect(unsubscribes).not_to be_empty
  end
  
end