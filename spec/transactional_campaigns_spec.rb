RSpec.describe MaropostApi::TransactionalCampaigns do
  
  before(:each) do
    @test_data = {
      :account_id => 1000,
      :send_content_id => 162
    }
    @transactional_campaign = MaropostApi::TransactionalCampaigns.new(@test_data[:account_id])
  end
  
  describe "Gets Transactional Campaigns" do
    it "gets the transactional campaigns for the given page" do
      page_1_campaigns = @transactional_campaign.get(1)
      page_2_campaigns = @transactional_campaign.get(2)

      expect(page_1_campaigns).to be_kind_of OperationResult
      expect(page_1_campaigns.success).to eq true
      expect(page_1_campaigns.data).not_to be_nil
      expect(page_1_campaigns.data).not_to be_empty
      expect(page_1_campaigns.data.first).to have_key 'total_pages'
      
      expect(page_2_campaigns).to be_kind_of OperationResult
      expect(page_2_campaigns.success).to eq true
      expect(page_2_campaigns.data).not_to be_nil
      expect(page_2_campaigns.data).not_to be_empty if page_1_campaigns.data.first['total_pages'] > 1      
    end
  end
  
  describe "Create Campaigns" do
    it "creates a transactional campaign" do
      name, subject, preheader, from_name, from_email, reply_to, email_preview_link, address, language, add_ctags = [
        Time.now.to_i.to_s + '_testname',
        'Rspec Unit Test Subject',
        'Rspect Unit Test preheader',
        'Rspec Unit Test From Name',
        'rspecunittestemail@maropost.com',
        'rspecunittestreplytoemail@maropost.com',
        true,
        'Test Address, USA',
        'en',
        ['test_tag1', 'test_tag2']
      ]
      new_campaign = @transactional_campaign.create(
        name: name,
        subject: subject,
        preheader: preheader, 
        from_name: from_name, 
        from_email: from_email, 
        reply_to: reply_to,
        email_preview_link: email_preview_link,
        address: address, 
        language: language,
        content_id: @test_data[:send_content_id],
        add_ctags: add_ctags
      )
      
      expect(new_campaign).to be_kind_of OperationResult
      expect(new_campaign.success).to eq true
      expect(new_campaign.errors).to be_nil
      expect(new_campaign.data).not_to be_nil
      expect(new_campaign.data).not_to be_empty
      expect(new_campaign.data).to have_key "name"
      expect(new_campaign.data).to have_key "subject"
      expect(new_campaign.data).to have_key "preheader"
      expect(new_campaign.data).to have_key "from_name"
      expect(new_campaign.data).to have_key "from_email"
      expect(new_campaign.data).to have_key "reply_to"
      expect(new_campaign.data).to have_key "email_preview_link"
      expect(new_campaign.data).to have_key "address"
      expect(new_campaign.data).to have_key "language"
      expect(new_campaign.data).to have_key "content_id"
      
      expect(new_campaign.data["name"]).to eq name
      expect(new_campaign.data["subject"]).to eq subject
      expect(new_campaign.data["preheader"]).to eq preheader
      expect(new_campaign.data["from_name"]).to eq from_name
      expect(new_campaign.data["from_email"]).to eq from_email
      expect(new_campaign.data["reply_to"]).to eq reply_to
      expect(new_campaign.data["email_preview_link"]).to eq email_preview_link
      expect(new_campaign.data["address"]).to eq address
      expect(new_campaign.data["language"]).to eq language
      expect(new_campaign.data["content_id"]).to eq @test_data[:send_content_id]
    end
  end
  
  describe "Sends Email" do
    it "raises argument error if content is not provided" do        
        expect{
          @transactional_campaign.send_email(campaign_id: 162)
        }.to raise_error ArgumentError
    end
    
    it "raises exception when content other than Hash or Integer is given" do
      expect{
        @transactional_campaign.send_email(campaign_id: 162, content: 'somestring')
      }.to raise_error ArgumentError, 'Content must be a type of Integer (content_id) or a Hash (content field values)'
    end
    
    it "accepts content_id as parameter" do
      expect{
        @transactional_campaign.send_email(campaign_id: 162, content: 450)
      }.not_to raise_error(ArgumentError, 'Content must be a type of Integer (content_id) or a Hash (content field values)')
    end
    
    it "raises error when no matching keys for content is provided" do
      expect{
        @transactional_campaign.send_email(campaign_id: 162, content: {somekey: 'value'})
      }.to raise_error ArgumentError, 'Content field values must have all or some of :name, :html_part and :text_part as keys'
    end
    
    
    it "raises exception when contact other than Hash or Integer is given" do
      expect{
        @transactional_campaign.send_email(campaign_id: 162, contact: 'somestring', content: {:name => 'Test content'})
      }.to raise_error ArgumentError, 'Contact must be a type of Integer (contact_id) or a Hash (contact field valeus)'
    end
      
    it "requires contact to have one of id or email" do
      expect{
        @transactional_campaign.send_email(campaign_id: 162, content: {:name => 'Test Content'}, contact: 1)
        @transactional_campaign.send_email(campaign_id: 162, content: {:name => 'Test Content'}, contact: {:email=>'test@maropost.com'})
      }.not_to raise_error ArgumentError, 'Contact must be a type of Integer (contact_id) or a Hash (contact field valeus)'
      
      expect{
        @transactional_campaign.send_email(campaign_id: 162, content: {:name => 'Test Content'}, contact:{:first_name=>'Test',:last_name=>'Test Test'})
        }.to raise_error ArgumentError, 'Contact field values must have :email and any or both of :first_name and :last_name as keys'
    end
    
    it "validates all emails" do
      invalid_emails = [
        "plainaddress",
        "#@%^%#.com",
        "@example.com",
        "Joe Smith <email@example.com>",
        "email.example.com",
        "email@example@example.com",
        "あいうえお@example.com",
        "email@example.com (Joe Smith)",
        "email@example",
        "email@111.222.333.44444",
        "email@example..com",
      ]
          
      invalid_emails.each_with_index do |email, i|
        #contact[:email]
        expect{
          @transactional_campaign.send_email(
            campaign_id: 162, 
            content: {:name => 'Test Content'}, 
            contact: {:email=> email}
          )
        }.to raise_error ArgumentError, 'contact[:email] must be a valid email address'
        #bcc_email
        expect{
          @transactional_campaign.send_email(
            campaign_id: 162, 
            content: {:name => 'Test Content'}, 
            contact: {:email=> 'valid_email@maropost.com'},
            bcc_email: email
          )
        }.to raise_error ArgumentError, 'bcc_email must be a valid email address'
        #reply_to
        expect{
          @transactional_campaign.send_email(
            campaign_id: 162, 
            content: {:name => 'Test Content'}, 
            contact: {:email=> 'valid_email@maropost.com'},
            reply_to: email
          )
        }.to raise_error ArgumentError, 'reply_to must be a valid email address'
        #from_email
        expect{
          @transactional_campaign.send_email(
            campaign_id: 162, 
            content: {:name => 'Test Content'}, 
            contact: {:email=> 'valid_email@maropost.com'},
            from_email: email
          )
        }.to raise_error ArgumentError, 'from_email must be a valid email address'
      end
    end
    
    it "sends email" do
      name, subject, preheader, from_name, from_email, reply_to, email_preview_link, address, language, add_ctags = [
        Time.now.to_i.to_s + '_testname',
        'Rspec Unit Test Subject',
        'Rspect Unit Test preheader',
        'Rspec Unit Test From Name',
        'rspecunittestemail@maropost.com',
        'rspecunittestreplytoemail@maropost.com',
        true,
        'Test Address, USA',
        'en',
        ['test_tag1', 'test_tag2']
      ]
      new_campaign = @transactional_campaign.create(
        name: name,
        subject: subject,
        preheader: preheader, 
        from_name: from_name, 
        from_email: from_email, 
        reply_to: reply_to,
        email_preview_link: email_preview_link,
        address: address, 
        language: language,
        content_id: @test_data[:send_content_id],
        add_ctags: add_ctags
      )
      send_email = @transactional_campaign.send_email(
        campaign_id: new_campaign.data['id'],
        contact: {
          :email => 'rspecunittestemail@maropost.com',
          :first_name => 'Rspec',
          :last_name  => 'Unit Test'
        },
        content: {
          :name => 'Rspec Test Content',
          :html_part => '<h1>Sample</h2>',
          :text_part => 'Text Sample'
        },
        from_name: 'Rspec Unit Tester',
        from_email: 'rspecunittest@maropost.com',
        subject: 'Test Email Send',
        reply_to: 'rspecunittest@maropost.com',
        address: 'Des Moines, USA',
        tags: {'rspec_test_tag' => 'tag success'},
        add_ctags: ['rspec_test_ctags', 1]
      )
      
      p send_email
    end
  end
end