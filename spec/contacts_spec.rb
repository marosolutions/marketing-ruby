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
    
    @test_emails = [
      "test@test1.com",
      "abc@abc.com",
      "test@test.com"
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
        
        opens_for_contact = contact.get_opens(contact_id)
        expect(opens_for_contact).to be_kind_of Array
        unless opens_for_contact.empty?
          expect(opens_for_contact.first["email"]).to eq email
          expect(opens_for_contact.first["contact_id"]).to eq contact_id
        end
      end
    end

    it "gets clicks for a contact" do

    end

    it "gets all contacts for a provided list" do

    end

    it "gets specific contact for a provided list" do

    end
  end
  
end