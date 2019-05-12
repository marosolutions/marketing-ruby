RSpec.describe MaropostApi::Journeys do
  
  before(:each) do
    @test_data = {
      :account_id => 1000
    }
  end
  
  describe "---- GET Endpoints ----" do
    it "gets the list of journeys for the given page" do
      journey = MaropostApi::Journeys.new(@test_data[:account_id])
      journey_page1 = journey.get(1)
      
      expect(journey_page1).to be_kind_of OperationResult
      journey_page1 = journey_page1.data
      # pp journey_page1
      expect(journey_page1).to be_kind_of Array
      expect(journey_page1).not_to be_empty
      expect(journey_page1.first).to have_key "id"
      expect(journey_page1.first).to have_key "total_pages"
      
      page_1_first_id = journey_page1.first["id"]
      total_pages = journey_page1.first["total_pages"]
      
      if total_pages > 1
        journey_page2 = journey.get(2)
        
        expect(journey_page2).to be_kind_of OperationResult
        journey_page2 = journey_page2.data
        
        page_2_first_id = journey_page2.first["id"]
        
        expect(journey_page2).to be_kind_of Array
        expect(journey_page2).not_to be_empty
        expect(journey_page2.first).to have_key "id"
        expect(journey_page2.first).to have_key "total_pages"
        expect(journey_page2.first["id"]).not_to eq journey_page1.first["id"]
        
      end
    end
    
    it "gets list of campaignes for given journey" do
      journey = MaropostApi::Journeys.new(@test_data[:account_id])
      sample_journeys = journey.get(1)
      
      expect(sample_journeys).to be_kind_of OperationResult
      sample_journeys = sample_journeys.data
      
      sample_journeys.each do |sj|
        campaigns = journey.get_campaigns(sj["id"], 1)
        expect(campaigns).to be_kind_of OperationResult
        
        next if campaigns.data.nil? or campaigns.success == false
                
        expect(campaigns.data).to be_kind_of Array
        expect(campaigns.data).not_to be_empty
        expect(campaigns.data.first).to be_kind_of Hash
        expect(campaigns.data.first).to have_key "id"
        
        break
      end
    end
    
    it "gets list of all contacts for given journey" do
      journey = MaropostApi::Journeys.new(@test_data[:account_id])
      sample_journeys = journey.get(1)
      
      expect(sample_journeys).to be_kind_of OperationResult
      sample_journeys = sample_journeys.data
      
      sample_journeys.each do |sj|
        contacts = journey.get_contacts(sj["id"], 1)
        
        expect(contacts).to be_kind_of OperationResult
        contacts = contacts.data
        
        if contacts.kind_of? Hash and contacts.has_key? "message" and contacts["message"] == "No Contacts found."
          next
        else
          expect(contacts).to be_kind_of Array
          expect(contacts).not_to be_empty
          expect(contacts.first).to be_kind_of Hash
          expect(contacts.first).to have_key "journey_id"
          expect(contacts.first["journey_id"]).to eq sj["id"]
          expect(contacts.first).to have_key "contact_id"
          break
        end
      end
    end
  end
  
  describe "---- PUT Endpoints ----" do
    it "stops all journeys, filtered by matching contact_id" do
      journey = MaropostApi::Journeys.new(@test_data[:account_id])
      sample_journeys = journey.get(1)
      
      expect(sample_journeys).to be_kind_of OperationResult
      sample_journeys = sample_journeys.data
      
      sample_journeys.each do |sj|
        contacts = journey.get_contacts(sj["id"], 1)
        
        expect(contacts).to be_kind_of OperationResult
        contacts = contacts.data
        
        if contacts.kind_of? Hash and contacts.has_key? "message"
          next
        else
          # test for contact_id
          contacts.each do |c|
            next if c["contact_id"] < 1
            stop_for_contact = journey.stop_all(:contact_id => c["contact_id"])
            
            expect(stop_for_contact).to be_kind_of OperationResult
            stop_for_contact = stop_for_contact.data
            
            expect(stop_for_contact).to be_kind_of Hash
            expect(stop_for_contact).to have_key "message"
            expect(stop_for_contact["message"]).to be_kind_of String
            expect(stop_for_contact["message"]).to include "Success!"
          end
          break
        end
      end
    end
    
    it "stops all journeys, filtered by matching email_recipient" do
     
      journey = MaropostApi::Journeys.new(@test_data[:account_id])
      sample_journeys = journey.get(1)
      
      expect(sample_journeys).to be_kind_of OperationResult
      sample_journeys = sample_journeys.data
      
      sample_journeys.each do |sj|
        contacts = journey.get_contacts(sj["id"], 1)
        
        expect(contacts).to be_kind_of OperationResult
        contacts = contacts.data
        
        if contacts.kind_of? Hash and contacts.has_key? "message"
          next
        else
      
          # test for contact email
          contacts.each do |c|
            next if c["email"].nil?
            stop_for_email_recipient = journey.stop_all(:email_recipient => c["email"])
                        
            expect(stop_for_email_recipient).to be_kind_of OperationResult
            stop_for_email_recipient = stop_for_email_recipient.data

            expect(stop_for_email_recipient).to be_kind_of Hash
            expect(stop_for_email_recipient).to have_key "message"
            expect(stop_for_email_recipient["message"]).to be_kind_of String
            expect(stop_for_email_recipient["message"]).to include "Success!"
          end
      
          break
        end
      end
      
    end
    
    it "stops all journeys, filtered by matching uid" do
      journey = MaropostApi::Journeys.new(@test_data[:account_id])
      sample_journeys = journey.get(1)
      expect(sample_journeys).to be_kind_of OperationResult
      sample_journeys = sample_journeys.data
      
      sample_journeys.each do |sj|
        contacts = journey.get_contacts(sj["id"], 1)
        expect(contacts).to be_kind_of OperationResult
        contacts = contacts.data
        
        if contacts.kind_of? Hash and contacts.has_key? "message"
          next
        else
      
          # test for contact email
          contacts.each do |c|
            next if c["uid"].nil?
            stop_for_uid = journey.stop_all(:uid => c["uid"])
            expect(stop_for_uid).to be_kind_of OperationResult
            stop_for_uid = stop_for_uid.data
            
            expect(stop_for_uid).to be_kind_of Hash
            expect(stop_for_uid).to have_key "message"
            expect(stop_for_uid["message"]).to be_kind_of String
            expect(stop_for_uid["message"]).to include "Success!"
          end
      
          break
        end
      end
      
    end
    
    it "pauses the specified journey for given contact" do
      journey = MaropostApi::Journeys.new(@test_data[:account_id])
      sample_journeys = journey.get(1)
      expect(sample_journeys).to be_kind_of OperationResult
      sample_journeys = sample_journeys.data
      
      sample_journeys.each do |sj|
        contacts = journey.get_contacts(sj["id"], 1)
        expect(contacts).to be_kind_of OperationResult
        
        next if contacts.data.nil? or contacts.success == false
        # test of contact_id
        contacts.data.each do |c|
          next if c["contact_id"] < 1
          pause_for_contact = journey.pause_for_contact(sj["id"], c["contact_id"])
          expect(pause_for_contact).to be_kind_of OperationResult
          
          if pause_for_contact.success
            expect(pause_for_contact.data).to be_kind_of Hash
            expect(pause_for_contact.data).to have_key "message"
            expect(pause_for_contact.data["message"]).to be_kind_of String
            expect(pause_for_contact.data["message"]).to include("Success!")
          else
            expect(pause_for_contact.data).to be_nil
            expect(pause_for_contact.errors).not_to be_empty
            expect(pause_for_contact.errors).to have_key 'message'
            expect(pause_for_contact.errors['message']).to include 'already stopped'
          end
          break
        end
        break
      end
    end
    
    it "resets the specified journey for specified active/paused contact" do
      journey = MaropostApi::Journeys.new(@test_data[:account_id])
      sample_journeys = journey.get(1)
      expect(sample_journeys).to be_kind_of OperationResult
      sample_journeys = sample_journeys.data
      
      sample_journeys.each do |sj|
        contacts = journey.get_contacts(sj["id"], 1)
        expect(contacts).to be_kind_of OperationResult
        contacts = contacts.data
        
        if contacts.kind_of? Hash and contacts.has_key? "message"
          next
        else
          # test of contact_id
          contacts.each do |c|
            next if c["contact_id"] < 1
            reset_for_contact = journey.reset_for_contact(sj["id"], c["contact_id"])
            expect(reset_for_contact).to be_kind_of OperationResult
            
            if reset_for_contact.success
              expect(reset_for_contact).to be_kind_of Hash
              expect(reset_for_contact).to have_key "message"
              expect(reset_for_contact["message"]).to be_kind_of String
              expect(reset_for_contact["message"]).to include("Success!")
            else
              expect(reset_for_contact.data).to be_nil
              expect(reset_for_contact.errors).not_to be_empty
              expect(reset_for_contact.errors).to have_key 'message'
              expect(reset_for_contact.errors['message']).to include 'Invalid contact status!'
            end
          end
          break
        end
      end
    end
    
    it "resets the specified journey for specified contact having specified uid" do
      
      journey = MaropostApi::Journeys.new(@test_data[:account_id])
      sample_journeys = journey.get(1)
      expect(sample_journeys).to be_kind_of OperationResult
      sample_journeys = sample_journeys.data
      
      sample_journeys.each do |sj|
        contacts = journey.get_contacts(sj["id"], 1)
        expect(contacts).to be_kind_of OperationResult
        contacts = contacts.data
        
        if contacts.kind_of? Hash and contacts.has_key? "message"
          next
        else
          # test of contact_id
          contacts.each do |c|
            next if c["contact_id"] < 1
            start_for_contact = journey.start_for_contact(sj["id"], c["contact_id"])
            expect(start_for_contact).to be_kind_of OperationResult
            start_for_contact = start_for_contact.data
            
            expect(start_for_contact).to be_kind_of Hash
            expect(start_for_contact).to have_key "message"
            expect(start_for_contact["message"]).to be_kind_of String
            expect(start_for_contact["message"]).to include("Success!")
          end
          break
        end
      end
      
    end
    
  end
  
end