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

      expect(new_contact).to be_kind_of OperationResult
      new_contact = new_contact.data
      
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
      
      expect(new_contact).to be_kind_of OperationResult
      new_contact = new_contact.data
      
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
      
      expect(new_contact).to be_kind_of OperationResult
      new_contact = new_contact.data
      
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

      create_time = Time.parse(new_contact["created_at"]).to_i
      update_time = Time.parse(new_contact["updated_at"]).to_i
      
      # created_time and updated_time should be equal for new contact
      expect(create_time).to eq update_time
      
    end
    
    it "creates contact for lists and workflows" do
      contact = MaropostApi::Contacts.new(@test_data[:account_id])
      new_email = (0..10).map{('a'..'z').to_a[rand(26)]}.join << Time.now.to_i.to_s << "@rspectest.com"
      email_existence = contact.get_for_email(new_email)
      subscribe_list_ids = @test_list_ids.join(',')
      unsubscribe_list_ids = @test_list_ids.last(2).join(',')
      unsubscribe_workflow_ids = "3443,43434"
      unsubscribe_campaign = "1123,4321"
      
      new_contact = contact.create_or_update_for_lists_and_workflows(
        new_email,
        @test_data[:first_name],
        @test_data[:last_name],
        @test_data[:phone],
        @test_data[:fax],
        nil,
        @test_data[:custom_field],
        @test_data[:add_tags],
        @test_data[:remove_tags],
        @test_data[:remove_from_dnm],
        :subscribe_list_ids => subscribe_list_ids,
        :unsubscribe_list_ids => unsubscribe_list_ids,
        :unsubscribe_workflow_ids => unsubscribe_workflow_ids,
        :unsubscribe_campaign => unsubscribe_campaign
      )
      
      expect(new_contact).to be_kind_of OperationResult
      new_contact = new_contact.data
      
      expect(new_contact).to be_kind_of Hash
      expect(new_contact).to have_key "email"
      expect(new_contact).to have_key "account_id"
      expect(new_contact).to have_key "first_name"
      expect(new_contact).to have_key "last_name"
      expect(new_contact).to have_key "created_at"
      expect(new_contact).to have_key "updated_at"
      expect(new_contact["email"]).to eq new_email
      expect(new_contact["account_id"]).to eq @test_data[:account_id]
      expect(new_contact["first_name"]).to eq @test_data[:first_name]
      expect(new_contact["last_name"]).to eq @test_data[:last_name]
      
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
        
        expect(email_returned).to be_kind_of OperationResult
        email_returned = email_returned.data
        
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
      
      expect(updated_contact).to be_kind_of OperationResult
      updated_contact = updated_contact.data
      
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
      
      expect(contacts_for_list).to be_kind_of OperationResult
      contacts_for_list = contacts_for_list.data
      
      contact_to_update = contacts_for_list.first

      first_name = contact_to_update["first_name"] << " updated"
      last_name = contact_to_update["last_name"] << " updated"
      phone = 1234567890
      fax = 1234567890
      email = "updated_" << contact_to_update["email"]
      
      updated_contact = contact.update_for_list_and_contact(
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
      
      expect(updated_contact).to be_kind_of OperationResult
      updated_contact = updated_contact.data
      
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
    
    it "updates contact for lists and workflows" do
      contact = MaropostApi::Contacts.new(@test_data[:account_id])
      existing_contact_id, existing_email = nil
      @test_emails.each do |email|
        email_returned = contact.get_for_email(email)
        
        expect(email_returned).to be_kind_of OperationResult
        email_returned = email_returned.data
        
        if email_returned.has_key? "email"
          existing_contact_id = email_returned["id"]
          existing_email = email
          break unless existing_contact_id.nil?
        end
      end
      
      list_id = @test_list_ids[rand(0..4)]
      contacts_for_list = contact.get_for_list(list_id, 1)
      
      expect(contacts_for_list).to be_kind_of OperationResult
      contacts_for_list = contacts_for_list.data
      
      contact_to_update = contacts_for_list.first
      subscribe_list_ids = @test_list_ids.join(',')
      unsubscribe_list_ids = @test_list_ids.last(2).join(',')
      unsubscribe_workflow_ids = "3443,43434"
      unsubscribe_campaign = "1123,4321"
      existing_email = "updated_" << existing_email
      first_name = @test_data[:last_name] << "_updated"
      last_name = @test_data[:last_name] << "_updated"
      phone = @test_data[:phone] << "_updated"
      fax = @test_data[:fax] << "_updated"
      updated_contact = contact.create_or_update_for_lists_and_workflows(
        existing_email,
        first_name,
        last_name,
        phone,
        fax,
        nil,
        @test_data[:custom_field],
        @test_data[:add_tags],
        @test_data[:remove_tags],
        @test_data[:remove_from_dnm],
        :subscribe => true
      )

      expect(updated_contact).to be_kind_of OperationResult
      updated_contact = updated_contact.data

      expect(updated_contact).to be_kind_of Hash
      expect(updated_contact).to have_key "email"
      expect(updated_contact).to have_key "account_id"
      expect(updated_contact).to have_key "first_name"
      expect(updated_contact).to have_key "last_name"
      expect(updated_contact).to have_key "phone"
      expect(updated_contact).to have_key "fax"
      expect(updated_contact).to have_key "created_at"
      expect(updated_contact).to have_key "updated_at"
      expect(updated_contact["email"]).to eq existing_email
      expect(updated_contact["account_id"]).to eq @test_data[:account_id]
      expect(updated_contact["first_name"]).to eq first_name
      expect(updated_contact["last_name"]).to eq last_name
      expect(updated_contact["phone"]).to eq phone
      expect(updated_contact["fax"]).to eq fax

      create_time = Time.parse(updated_contact["created_at"]).to_i
      update_time = Time.parse(updated_contact["updated_at"]).to_i
      
      # created_time and updated_time should be different for updated contact
      expect(create_time < update_time).to eq true
    end
    
    it "unsubscribes contact having email|uid as specified by value parameter" do
      contact = MaropostApi::Contacts.new(@test_data[:account_id])
      new_email = (0..10).map{('a'..'z').to_a[rand(26)]}.join << Time.now.to_i.to_s << "@rspectest.com"
      list_ids = @test_list_ids
      
      # creates a contact because the email is new
      new_contact = contact.create_or_update_for_lists_and_workflows(
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
        :subscribe_list_ids => list_ids.join(',')
      )
      
      expect(new_contact).to be_kind_of OperationResult
      new_contact = new_contact.data
      
      expect(new_contact).not_to be_empty
      
      new_contact = contact.get_for_email(new_email)
      expect(new_contact).to be_kind_of OperationResult
      new_contact = new_contact.data
      
      subscribed_count = new_contact["list_subscriptions"].select{|l| l["status"] == 'Subscribed'}.count
      
      expect(new_contact).not_to be_empty
      expect(new_contact).to have_key "list_subscriptions"
      expect(new_contact["list_subscriptions"]).not_to be_empty
      expect(subscribed_count).to eq list_ids.count
      
      unsubscribe = contact.unsubscribe_all(new_email, 'email')
      expect(unsubscribe).to be_kind_of OperationResult
      unsubscribe = unsubscribe.data
      
      contact_after_unsubscription = contact.get_for_email(new_email)
      expect(contact_after_unsubscription).to be_kind_of OperationResult
      contact_after_unsubscription = contact_after_unsubscription.data
      
      unsubscribed_count = contact_after_unsubscription["list_subscriptions"].select{|l| l["status"] == 'Unsubscribed'}.count
      
      expect(contact_after_unsubscription).not_to be_empty
      expect(contact_after_unsubscription).to have_key "list_subscriptions"
      expect(unsubscribed_count).to eq list_ids.count
      
    end
  end

  describe "---- GET Endpoints ----" do
    it "cannot find contact without email" do
      email = nil # first test with no email provided
      contact = MaropostApi::Contacts.new(@test_data[:account_id])
      contacts_for_email = contact.get_for_email(email)
      
      expect(contacts_for_email).to be_kind_of OperationResult
      expect(contacts_for_email.success).to eq false
      expect(contacts_for_email.errors).not_to be_empty
      expect(contacts_for_email.errors).to have_key "message"
      expect(contacts_for_email.errors["message"]).to include "Contact is not present"
    end
    
    it "gets contact for provided email" do
      contact = MaropostApi::Contacts.new(@test_data[:account_id])
      contacts_for_email = contact.get_for_email(@test_data[:email])
      
      expect(contacts_for_email).to be_kind_of OperationResult
      contacts_for_email = contacts_for_email.data
      
      expect(contacts_for_email).to be_kind_of Hash
      expect(contacts_for_email).not_to be_empty
      expect(contacts_for_email["email"]).to eq @test_data[:email]
      expect(contacts_for_email["account_id"]).to eq @test_data[:account_id]
    end

    it "gets opens for a contact" do
      contact = MaropostApi::Contacts.new(@test_data[:account_id])
      @test_emails.each do |email|
        contact_for_email = contact.get_for_email email
        
        expect(contact_for_email).to be_kind_of OperationResult
        next unless contact_for_email.success
        contact_for_email = contact_for_email.data        
        contact_id = contact_for_email["id"]
        
        opens_for_contact = contact.get_opens(contact_id, 1)
        expect(opens_for_contact).to be_kind_of OperationResult
        
        next unless opens_for_contact.success
        opens_for_contact = opens_for_contact.data
        
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
        
        expect(contact_for_email).to be_kind_of OperationResult
        next unless contact_for_email.success
        
        contact_for_email = contact_for_email.data
        contact_id = contact_for_email["id"]
        
        clicks_for_contact = contact.get_clicks(contact_id, 1)
        expect(clicks_for_contact).to be_kind_of OperationResult
        next unless clicks_for_contact.success
        clicks_for_contact = clicks_for_contact.data
        
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
        
        expect(contacts_in_list).to be_kind_of OperationResult
                
        if contacts_in_list.success
          expect(contacts_in_list.data).to be_kind_of Array
          expect(contacts_in_list.data.first["account_id"]).to eq @test_data[:account_id]
          expect(contacts_in_list.data.first["email"]).not_to be_empty
          expect(contacts_in_list.data.first["id"]).to respond_to :next
        else
          expect(contacts_in_list.errors).not_to be_empty
          expect(contacts_in_list.errors).to have_key "message"
        end
      end
    end

    it "gets specific contact for a provided list" do
      contact = MaropostApi::Contacts.new(@test_data[:account_id])
      @test_list_ids.each do |list_id|
        contacts_in_list = contact.get_for_list(list_id, 1)
        
        expect(contacts_in_list).to be_kind_of OperationResult
        next unless contacts_in_list.success
        contacts_in_list = contacts_in_list.data
        
        unless contacts_in_list.empty? or contacts_in_list.kind_of? Hash
          contacts_in_list.each do |contac|
            contact_email = contac["email"]
            contact_for_id = contact.get_for_email(contact_email)
            
            expect(contact_for_id).to be_kind_of OperationResult
            contact_id = contact_for_id.data["id"]
            
            contact_from_list = contact.get_contact_for_list(list_id, contact_id)
            
            expect(contact_from_list).to be_kind_of OperationResult
            contact_from_list = contact_from_list.data
            
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
  
  describe "---- DELETE Endponts ----" do
    it "deletes contact from all the lists" do
      contact = MaropostApi::Contacts.new(@test_data[:account_id])
      
      email = @test_emails[rand(4)]
      
      deleted_result = contact.delete_from_all_lists(email)
      
      expect(deleted_result).to be_kind_of OperationResult
      deleted_result = deleted_result.data
            
      expect(deleted_result).to eq nil
    end
    
    it "deletes contact from specified lists" do
      contact = MaropostApi::Contacts.new(@test_data[:account_id])
      @test_emails.each do |email|
        contact_for_email = contact.get_for_email(email)
        
        expect(contact_for_email).to be_kind_of OperationResult
        contact_for_email = contact_for_email.data
        # pp contact_for_email
        next if contact_for_email.has_key? "message" and contact_for_email["message"] != nil and contact_for_email["message"].include? "Contact is not present"
        
        list_subscription_ids = contact_for_email['list_subscriptions'].collect{|list| list["list_id"] }
        next if list_subscription_ids.empty?
        
        contact_id = contact_for_email["id"]
        total_list_ids = list_subscription_ids.count
        lists_to_delete_from = list_subscription_ids.last(1)
      
        delete_result = contact.delete_from_lists(contact_id, lists_to_delete_from)
        
        expect(delete_result).to be_kind_of OperationResult
        delete_result = delete_result.data
      
        expect(delete_result.nil?).to eq true

        contact_after_deleting = contact.get_for_email(contact_for_email["email"])
        
        expect(contact_after_deleting).to be_kind_of OperationResult
        contact_after_deleting = contact_after_deleting.data
        
        existing_list_ids = contact_after_deleting['list_subscriptions'].collect{|list| list["list_id"] }
        # verify if new_existing_list_ids are less than the olde ones - to prove deletion success
        expect(list_subscription_ids.count > existing_list_ids.count).to eq true
        lists_to_delete_from.each do |deleted_list_id|
          expect(existing_list_ids).not_to include deleted_list_id
        end
        break unless list_subscription_ids.empty?
      end
    end
    
    it "deletes a list contact" do
      contact = MaropostApi::Contacts.new(@test_data[:account_id])
      new_email = (0..10).map{('a'..'z').to_a[rand(26)]}.join << Time.now.to_i.to_s << "@rspectest.com"
      list_ids = @test_list_ids[0..3]
      
      # creates a contact because the email is new
      new_contact = contact.create_or_update_for_lists_and_workflows(
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
        :subscribe_list_ids => list_ids.join(',')
      )
      
      expect(new_contact).to be_kind_of OperationResult
      new_contact = new_contact.data
      
      expect(new_contact).not_to be_empty
      
      list_contact_before_delete = contact.get_for_email(new_email)
      
      expect(list_contact_before_delete).to be_kind_of OperationResult
      list_contact_before_delete = list_contact_before_delete.data
      contact_id = list_contact_before_delete["id"]

      delete_contact = contact.delete_list_contact(list_ids[0], contact_id)
      
      expect(delete_contact).to be_kind_of OperationResult
      delete_contact = delete_contact.data
      
      list_contact_after_delete = contact.get_for_email(new_email)
      
      expect(list_contact_after_delete).to be_kind_of OperationResult
      list_contact_after_delete = list_contact_after_delete.data
      
      list_subscriptions_before_delete = list_contact_before_delete["list_subscriptions"].collect{|l| l["list_id"]}
      list_subscriptions_after_delete = list_contact_after_delete["list_subscriptions"].collect{|l| l["list_id"]}
            
      expect(delete_contact.nil?).to eq true
      expect(list_contact_before_delete).to be_kind_of Hash
      expect(list_subscriptions_after_delete.count < list_subscriptions_before_delete.count).to eq true
      expect(list_subscriptions_before_delete).to include list_ids[0]
      expect(list_subscriptions_after_delete).not_to include list_ids[0]
    end    
  end
  
end