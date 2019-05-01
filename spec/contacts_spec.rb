RSpec.describe MaropostApi::Contacts do
  
  before(:each) do
    @test_data = {
      :account_id => 1000,
      :first_name => "Rspec Test",
      :last_name  => "Last Test",
      :email      => "test@rspecttest.com",
      :phone      => "9876543210",
      :fax        => "9876543210",
      :uid        => "testrspceuid",
      :custom_field => {
        :rspec_custom_boolean => true,
        :rspec_custom_string  => 'some kind of string',
        :rspec_custom_nil     => nil
      },
      :add_tags => ["rspec_tag_1", "rspec_tag_2", "rspec_tag_3"],
      :remove_tags => ["rspec_tag_2"],
      :remove_from_dnm => false,
      :options => {
        :subscribe_list_ids => "23,24,25",
        :unsubscribe_list_ids => "24",
        :unsubscribe_workflow_ids => "3443,43434",
        :unsubscribe_campaign => "9261"
      }
    }
    
    @test_list_ids = [381,153,174,15,168] # selected from the api which has considerable subscribers
    
    @test_emails = [
      "test@test1.com",
      "abc@abc.com",
      "test@test.com",
      "vivek@maropost.com",
      "vechet.voun68@gmail.com",
      "pandoramp13@gmail.com",
      "komangsatya30@gmail.com"
    ]
  end
  
  describe "---- POST Endpoints ----" do
    it "creates new contact with just required params" do
      contact = MaropostApi::Contacts.new(@test_data[:account_id])
      new_contact = contact.create_contact(
        @test_data[:email],
        @test_data[:first_name],
        @test_data[:last_name],
        @test_data[:phone],
        @test_data[:fax]
      )

      expect(new_contact).to be_kind_of Hash
      expect(new_contact).to have_key "id"
      expect(new_contact).to have_key "account_id"
      expect(new_contact).to have_key "email"
      expect(new_contact["email"]).to eq @test_data[:email]
      expect(new_contact["account_id"]).to eq @test_data[:account_id]
    end
    
    it "creates new contact with other optional fields provided" do
      contact = MaropostApi::Contacts.new(@test_data[:account_id])
      new_contact = contact.create_contact(
        @test_data[:email],
        @test_data[:first_name],
        @test_data[:last_name],
        @test_data[:phone],
        @test_data[:fax],
        nil, # the api endpoint doesn't recognise uid [says 'unknown attribute uid']
        @test_data[:custom_field],
        @test_data[:add_tags],
        @test_data[:remove_tags],
        @test_data[:remove_from_dnm],
        @test_data[:options]
      )
      
      expect(new_contact).to be_kind_of Hash
      expect(new_contact).to have_key "id"
      expect(new_contact).to have_key "account_id"
      expect(new_contact).to have_key "email"
      expect(new_contact).to have_key "first_name"
      expect(new_contact).to have_key "last_name"
      expect(new_contact).to have_key "phone"
      expect(new_contact).to have_key "fax"
      expect(new_contact["email"]).to eq @test_data[:email]
      expect(new_contact["account_id"]).to eq @test_data[:account_id]
      expect(new_contact["first_name"]).to eq @test_data[:first_name]
      expect(new_contact["last_name"]).to eq @test_data[:last_name]
      expect(new_contact["phone"]).to eq @test_data[:phone]
      expect(new_contact["fax"]).to eq @test_data[:fax]
    end
    
    it "creates for a list when no existing contact found" do
      contact = MaropostApi::Contacts.new(@test_data[:account_id])
      new_email = (0..10).map{('a'..'z').to_a[rand(26)]}.join << Time.now.to_i.to_s << "@rspectest.com"
      email_existence = contact.get_for_email(new_email)
      list_id = @test_list_ids[rand(0..4)]
      # p new_email, email_existence, list_id

      new_contact = contact.create_or_update_for_list(
        list_id, 
        new_email, 
        @test_data[:first_name], 
        @test_data[:last_name], 
        @test_data[:phone],
        @test_data[:fax],
        nil,
        @test_data[:custom_field],
        @test_data[:add_tags],
        @test_data[:remove_tags],
        true,
        true
      )
      expect(new_contact).to be_kind_of Hash
      expect(new_contact).to have_key "email"
      expect(new_contact).to have_key "account_id"
      expect(new_contact).to have_key "first_name"
      expect(new_contact).to have_key "last_name"
      expect(new_contact).to have_key "subscribed"
      expect(new_contact).to have_key "address_type"
      expect(new_contact).to have_key "created_at"
      expect(new_contact).to have_key "updated_at"
      expect(new_contact["email"]).to eq new_email
      expect(new_contact["account_id"]).to eq @test_data[:account_id]
      expect(new_contact["first_name"]).to eq @test_data[:first_name]
      expect(new_contact["last_name"]).to eq @test_data[:last_name]
      expect(new_contact["subscribed"]).to eq true
      expect(new_contact["address_type"]).to include "new add"

      create_time = Time.parse(new_contact["created_at"]).to_i
      update_time = Time.parse(new_contact["updated_at"]).to_i
      
      # created_time and updated_time should be equal for new contact
      expect(create_time).to eq update_time
      
    end
  end
  
  describe "---- PUT Endpoints ----" do
    it "updates contact for a list when provided email is existent" do
      contact = MaropostApi::Contacts.new(@test_data[:account_id])
      existing_contact_id, existing_email = nil
      @test_emails.each do |email|
        email_returned = contact.get_for_email(email)
        if email_returned.has_key? "email"
          existing_contact_id = email_returned["id"]
          existing_email = email
          break unless existing_contact_id.nil?
        end
      end
      list_id = @test_list_ids[rand(0..4)]
      # p new_email, email_existence, list_id

      updated_contact = contact.create_or_update_for_list(
        list_id, 
        existing_email, 
        @test_data[:first_name], 
        @test_data[:last_name], 
        @test_data[:phone],
        @test_data[:fax],
        nil,
        @test_data[:custom_field],
        @test_data[:add_tags],
        @test_data[:remove_tags],
        true,
        true
      )
      expect(updated_contact).to be_kind_of Hash
      expect(updated_contact).to have_key "email"
      expect(updated_contact).to have_key "account_id"
      expect(updated_contact).to have_key "first_name"
      expect(updated_contact).to have_key "last_name"
      expect(updated_contact).to have_key "subscribed"
      expect(updated_contact).to have_key "created_at"
      expect(updated_contact).to have_key "updated_at"
      expect(updated_contact["email"]).to eq existing_email
      expect(updated_contact["account_id"]).to eq @test_data[:account_id]
      expect(updated_contact["first_name"]).to eq @test_data[:first_name]
      expect(updated_contact["last_name"]).to eq @test_data[:last_name]
      expect(updated_contact["subscribed"]).to eq true
      
      create_time = Time.parse(updated_contact["created_at"]).to_i
      update_time = Time.parse(updated_contact["updated_at"]).to_i
      
      # created_time should be less than updated_time for updated contact
      expect(create_time < update_time).to eq true
    end
    
    it "updates contact for a given list and contact" do
      contact = MaropostApi::Contacts.new(@test_data[:account_id])
      existing_contact_id, existing_email = nil
      list_id = @test_list_ids[rand(0..4)]
      contacts_for_list = contact.get_for_list(list_id, 1)
      contact_to_update = contacts_for_list.first

      first_name = contact_to_update["first_name"] << " updated"
      last_name = contact_to_update["last_name"] << " updated"
      phone = 1234567890
      fax = 1234567890
      email = "updated_" << contact_to_update["email"]
      
      updated_contact = contact.updated_for_list_and_contact(
        list_id,
        contact_to_update["id"],
        email,
        first_name,
        last_name,
        phone,
        fax,
        nil,
        @test_data[:custom_field],
        @test_data[:add_tags],
        @test_data[:remove_tags],
        true,
        true
      )
      
      expect(updated_contact).to be_kind_of Hash
      expect(updated_contact).to have_key "email"
      expect(updated_contact).to have_key "account_id"
      expect(updated_contact).to have_key "first_name"
      expect(updated_contact).to have_key "last_name"
      expect(updated_contact).to have_key "subscribed"
      expect(updated_contact).to have_key "created_at"
      expect(updated_contact).to have_key "updated_at"
      expect(updated_contact["email"]).to eq email
      expect(updated_contact["account_id"]).to eq @test_data[:account_id]
      expect(updated_contact["first_name"]).to eq first_name
      expect(updated_contact["last_name"]).to eq last_name
      expect(updated_contact["phone"]).to eq phone.to_s
      expect(updated_contact["fax"]).to eq fax.to_s
      expect(updated_contact["subscribed"]).to eq true
      
      create_time = Time.parse(updated_contact["created_at"]).to_i
      update_time = Time.parse(updated_contact["updated_at"]).to_i
      
      # created_time should be less than updated_time for updated contact
      expect(create_time < update_time).to eq true
    end
  end

  describe "---- GET Endpoints ----" do
    it "cannot find contact without email" do
      email = nil # first test with no email provided
      contact = MaropostApi::Contacts.new(@test_data[:account_id])
      contacts_for_email = contact.get_for_email(email)

      expect(contacts_for_email).to be_kind_of Hash
      expect(contacts_for_email).to have_key "message"
      expect(contacts_for_email["message"]).to include "Contact is not present"
    end
    
    it "gets contact for provided email" do
      contact = MaropostApi::Contacts.new(@test_data[:account_id])
      contacts_for_email = contact.get_for_email(@test_data[:email])
      
      expect(contacts_for_email).to be_kind_of Hash
      expect(contacts_for_email).not_to be_empty
      expect(contacts_for_email["email"]).to eq @test_data[:email]
      expect(contacts_for_email["account_id"]).to eq @test_data[:account_id]
    end

    it "gets opens for a contact" do
      contact = MaropostApi::Contacts.new(@test_data[:account_id])
      @test_emails.each do |email|
        contact_for_email = contact.get_for_email email
        contact_id = contact_for_email["id"]
        
        opens_for_contact = contact.get_opens(contact_id, 1)
        
        unless opens_for_contact.empty? or opens_for_contact.kind_of? Hash
          expect(opens_for_contact.first["campaign_id"]).not_to be_nil
          expect(opens_for_contact.first["campaign_id"]).to respond_to :next
          expect(opens_for_contact.first["ip_address"]).not_to be_empty
          expect(opens_for_contact.first["contact_id"]).to eq contact_id
        end
        
        unless opens_for_contact.kind_of? Array
          expect(opens_for_contact).not_to be_empty
          expect(opens_for_contact).to have_key "message"
          expect(opens_for_contact["message"]).to eq "Contact is not present!"
        end
      end
    end

    it "gets clicks for a contact" do
      contact = MaropostApi::Contacts.new(@test_data[:account_id])
      @test_emails.each do |email|
        contact_for_email = contact.get_for_email email
        contact_id = contact_for_email["id"]
        
        clicks_for_contact = contact.get_clicks(contact_id, 1)
        
        unless clicks_for_contact.empty? or clicks_for_contact.kind_of? Hash
          expect(clicks_for_contact.first["contact_id"]).to eq contact_id
          expect(clicks_for_contact.first["account_id"]).to eq @test_data[:account_id]
          expect(clicks_for_contact.first["browser"]).not_to be_empty
          expect(clicks_for_contact.first["url"]).not_to be_empty
          expect(clicks_for_contact.first["ip_address"]).not_to be_nil
        end
        
        unless clicks_for_contact.kind_of? Array
          expect(clicks_for_contact).not_to be_empty
          expect(clicks_for_contact).to have_key "message"
          expect(clicks_for_contact["message"]).to eq "Contact is not present!"
        end
      end
    end

    it "gets all contacts for a provided list" do
      contact = MaropostApi::Contacts.new(@test_data[:account_id])
      @test_list_ids.each do |list_id|
        contacts_in_list = contact.get_for_list(list_id, 1)
        
        unless contacts_in_list.empty? or contacts_in_list.kind_of? Hash
          expect(contacts_in_list).to be_kind_of Array
          expect(contacts_in_list.first["account_id"]).to eq @test_data[:account_id]
          expect(contacts_in_list.first["email"]).not_to be_empty
          expect(contacts_in_list.first["id"]).to respond_to :next
        end
        
        unless contacts_in_list.kind_of? Array
          p contacts_in_list
        end
      end
    end

    it "gets specific contact for a provided list" do
      contact = MaropostApi::Contacts.new(@test_data[:account_id])
      @test_list_ids.each do |list_id|
        contacts_in_list = contact.get_for_list(list_id, 1)
        
        unless contacts_in_list.empty? or contacts_in_list.kind_of? Hash
          contacts_in_list.each do |contac|
            contact_email = contac["email"]
            contact_id = contact.get_for_email(contact_email)["id"]
            contact_from_list = contact.get_contact_for_list(list_id, contact_id)
            expect(contact_from_list).to be_kind_of Hash
            expect(contact_from_list).to have_key "email"
            expect(contact_from_list["email"]).to eq contact_email
            expect(contact_from_list).to have_key "list_subscriptions"
            
            subscription_list_ids = contact_from_list['list_subscriptions'].collect{|list| list["list_id"]}
            expect(subscription_list_ids).to include list_id
            
            break
          end
          break
        end
      end
      
    end
    
  end
  
end