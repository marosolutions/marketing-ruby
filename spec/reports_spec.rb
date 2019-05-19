require 'date'

RSpec.describe MaropostApi::Reports do
  before(:each) do
    @test_data = {
      :account_id => 1000,
      :report_id => 11,
      :from_date => '2016-01-01',
      :to_date => ''
    }
    @report = MaropostApi::Reports.new(@test_data[:account_id])
  end

  describe "---- GET Endpoints ----" do
      
    it "gets reports for page 1" do
      reports = @report.get(1)

      expect(reports).to be_kind_of OperationResult
      expect(reports.success).to eq true
      expect(reports.data).to be_kind_of Array
      expect(reports.data).not_to be_empty
    end
    
    it "gets reports for page 2" do
      reports = @report.get(2)
      
      expect(reports).to be_kind_of OperationResult
      expect(reports.success).to eq true
      expect(reports.data).to be_kind_of Array
      expect(reports.data).not_to be_empty
    end
    
    it "gets report for the provided report id" do
      report = @report.get_report(@test_data[:report_id])
      
      expect(report).to be_kind_of OperationResult
      expect(report.success).to eq true
      expect(report.data).not_to be_nil
      expect(report.data).not_to be_empty
      expect(report.data).to have_key "id"
      expect(report.data["id"]).to eq @test_data[:report_id]
    end
    
    it "gets open reports for filters provided" do
      reports = @report.get(1)
      reports_with_opens = reports.data.select{|r| r['open'] > 0 }
      reports_with_opens.each do |report|
        created_at = Date.parse(report['created_at']).to_s
        
        # use the only hint we have to get some reports and use futher
        reports = @report.get_opens(page: 1, :from => created_at)
        
        expect(reports).to be_kind_of OperationResult
        expect(reports.success).to eq true
        expect(reports.data).not_to be_nil
        expect(reports.data.first).to have_key 'contact'
        
        # page 2
        reports_2 = @report.get_opens(page: 2, :from => created_at)
        
        expect(reports_2).to be_kind_of OperationResult
        expect(reports_2.success).to eq true
        expect(reports_2.data).not_to be_nil
        expect(reports_2.data.first).to have_key 'contact'
        
        # unique reports, 5 per page, email, first_name, last_name in fields,
        unique_reports = @report.get_opens(page: 1, unique: true, per: 5, fields: ['email', 'first_name', 'last_name'])
        
        expect(unique_reports).to be_kind_of OperationResult
        expect(unique_reports.success).to eq true
        expect(unique_reports.data).not_to be_nil
        expect(unique_reports.data).not_to be_empty
        expect(unique_reports.data.first).to have_key 'contact_id'
        expect(unique_reports.data.first).to have_key 'contact'
        expect(unique_reports.data.first['contact']).to have_key 'first_name'
        expect(unique_reports.data.first['contact']).to have_key 'last_name'
        expect(unique_reports.data.first['contact']).to have_key 'email'
        expect(unique_reports.data.count).to eq 5
        
        unique_contact_ids = unique_reports.data.map{|r| r['contact_id']}.uniq
        expect(unique_contact_ids.count).to eq unique_reports.data.count
        break
      end
    end
    
    it "gets click reports for filters provided" do
      reports = @report.get(1)
      reports_with_clicks = reports.data.select{|r| r['click'] > 0 }
      reports_with_clicks.each do |report|
        created_at = Date.parse(report['created_at']).to_s
        
        # use the only hint we have to get some reports and use futher
        reports = @report.get_clicks(page: 1, :from => created_at)
        
        expect(reports).to be_kind_of OperationResult
        expect(reports.success).to eq true
        expect(reports.data).not_to be_nil
        expect(reports.data.first).to have_key 'contact'
        
        # page 2
        reports_2 = @report.get_clicks(page: 2, :from => created_at)
        
        expect(reports_2).to be_kind_of OperationResult
        expect(reports_2.success).to eq true
        expect(reports_2.data).not_to be_nil
        expect(reports_2.data.first).to have_key 'contact'
        
        # unique reports, 5 per page, email, first_name, last_name in fields,
        unique_reports = @report.get_clicks(page: 1, unique: true, per: 5, fields: ['email', 'first_name', 'last_name'])
        
        expect(unique_reports).to be_kind_of OperationResult
        expect(unique_reports.success).to eq true
        expect(unique_reports.data).not_to be_nil
        expect(unique_reports.data).not_to be_empty
        expect(unique_reports.data.first).to have_key 'contact_id'
        expect(unique_reports.data.first).to have_key 'contact'
        expect(unique_reports.data.first['contact']).to have_key 'first_name'
        expect(unique_reports.data.first['contact']).to have_key 'last_name'
        expect(unique_reports.data.first['contact']).to have_key 'email'
        expect(unique_reports.data.count).to eq 5
        
        unique_contact_ids = unique_reports.data.map{|r| r['contact_id']}.uniq
        expect(unique_contact_ids.count).to eq unique_reports.data.count
        break
      end
    end
    
    it "gets bounce reports for provided filters" do
      reports = @report.get(1)
      reports_with_bounces = reports.data.select{|r| r['bounce'] > 0 }
      reports_with_bounces.each do |report|
        created_at = Date.parse(report['created_at']).to_s
        
        # use the only hint we have to get some reports and use futher
        reports = @report.get_bounces(page: 1, :from => created_at)
        
        expect(reports).to be_kind_of OperationResult
        expect(reports.success).to eq true
        expect(reports.data).not_to be_nil
        expect(reports.data.first).to have_key 'contact'
        
        # page 2
        reports_2 = @report.get_bounces(page: 2, :from => created_at)
        
        expect(reports_2).to be_kind_of OperationResult
        expect(reports_2.success).to eq true
        expect(reports_2.data).not_to be_nil
        expect(reports_2.data.first).to have_key 'contact'
        
        # unique reports, 5 per page, email, first_name, last_name in fields,
        unique_reports = @report.get_bounces(page: 1, unique: true, per: 5, fields: ['email', 'first_name', 'last_name'], type: 'hard')
        expect(unique_reports).to be_kind_of OperationResult
        expect(unique_reports.success).to eq true
        expect(unique_reports.data).not_to be_nil
        expect(unique_reports.data).not_to be_empty
        expect(unique_reports.data.first).to have_key 'contact_id'
        expect(unique_reports.data.first).to have_key 'contact'
        expect(unique_reports.data.first['contact']).to have_key 'first_name'
        expect(unique_reports.data.first['contact']).to have_key 'last_name'
        expect(unique_reports.data.first['contact']).to have_key 'email'
        expect(unique_reports.data.count).to eq 5
        
        unique_contact_ids = unique_reports.data.map{|r| r['contact_id']}.uniq
        expect(unique_contact_ids.count).to eq unique_reports.data.count
        
        all_are_hard_bounce = unique_reports.data.select{|r| r['type'] == 'Hard'}.count == unique_reports.data.count
        expect(all_are_hard_bounce).to eq true
        
        # repeat for soft bounces
        unique_reports = @report.get_bounces(page: 1, unique: true, per: 5, fields: ['email', 'first_name', 'last_name'], type: 'soft')
        all_are_soft_bounces = unique_reports.data.select{|r| r['type'] == 'Soft'}.count == unique_reports.data.count
        expect(all_are_soft_bounces).to eq true
        
        break
      end
    end
    
    it "gets unsubscribe reports for the provided filters" do
      reports = @report.get(1)
      unsubscribe_reports = reports.data.select{|r| r['click'] > 0 }
      unsubscribe_reports.each do |report|
        created_at = Date.parse(report['created_at']).to_s
        
        # use the only hint we have to get some reports and use futher
        reports = @report.get_unsubscribes(page: 1, :from => created_at)
        
        expect(reports).to be_kind_of OperationResult
        expect(reports.success).to eq true
        expect(reports.data).not_to be_nil
        expect(reports.data.first).to have_key 'contact'
        
        # page 2
        reports_2 = @report.get_unsubscribes(page: 2, :from => created_at)
        
        expect(reports_2).to be_kind_of OperationResult
        expect(reports_2.success).to eq true
        expect(reports_2.data).not_to be_nil
        expect(reports_2.data.first).to have_key 'contact'
        
        # unique reports, 5 per page, email, first_name, last_name in fields,
        unique_reports = @report.get_unsubscribes(page: 1, unique: true, per: 5, fields: ['email', 'first_name', 'last_name'])
        
        expect(unique_reports).to be_kind_of OperationResult
        expect(unique_reports.success).to eq true
        expect(unique_reports.data).not_to be_nil
        expect(unique_reports.data).not_to be_empty
        expect(unique_reports.data.first).to have_key 'contact_id'
        expect(unique_reports.data.first).to have_key 'contact'
        expect(unique_reports.data.first['contact']).to have_key 'first_name'
        expect(unique_reports.data.first['contact']).to have_key 'last_name'
        expect(unique_reports.data.first['contact']).to have_key 'email'
        expect(unique_reports.data.count).to eq 5
        
        unique_contact_ids = unique_reports.data.map{|r| r['contact_id']}.uniq
        expect(unique_contact_ids.count).to eq unique_reports.data.count
        break
      end
    end
    
    it "gets a list of complaint reports for the provided filters" do
      reports = @report.get(1)
      complaint_reports = reports.data.select{|r| r['click'] > 0 }
      complaint_reports.each do |report|
        created_at = Date.parse(report['created_at']).to_s
        
        # use the only hint we have to get some reports and use futher
        reports = @report.get_complaints(page: 1, :from => created_at)
        
        expect(reports).to be_kind_of OperationResult
        expect(reports.success).to eq true
        expect(reports.data).not_to be_nil
        expect(reports.data.first).to have_key 'contact'
        
        # page 2
        reports_2 = @report.get_complaints(page: 2, :from => created_at)
        
        expect(reports_2).to be_kind_of OperationResult
        expect(reports_2.success).to eq true
        expect(reports_2.data).not_to be_nil
        expect(reports_2.data.first).to have_key 'contact'
        
        # unique reports, 5 per page, email, first_name, last_name in fields,
        unique_reports = @report.get_complaints(page: 1, unique: true, per: 5, fields: ['email', 'first_name', 'last_name'])
        
        expect(unique_reports).to be_kind_of OperationResult
        expect(unique_reports.success).to eq true
        expect(unique_reports.data).not_to be_nil
        expect(unique_reports.data).not_to be_empty
        expect(unique_reports.data.first).to have_key 'contact_id'
        expect(unique_reports.data.first).to have_key 'contact'
        expect(unique_reports.data.first['contact']).to have_key 'first_name'
        expect(unique_reports.data.first['contact']).to have_key 'last_name'
        expect(unique_reports.data.first['contact']).to have_key 'email'
        expect(unique_reports.data.count).to eq 5
        
        unique_contact_ids = unique_reports.data.map{|r| r['contact_id']}.uniq
        expect(unique_contact_ids.count).to eq unique_reports.data.count
        break
      end
    end
    
    it "gets a list of Ab Reports for the provided filters" do
      reports = @report.get(1)
      complaint_reports = reports.data.select{|r| r['click'] > 0 }
      complaint_reports.each do |report|
        created_at = Date.parse(report['created_at']).to_s
        
        # use the only hint we have to get some reports and use futher
        reports = @report.get_ab_reports(page: 1, :name => 'Test', :per => 2)
        
        expect(reports).to be_kind_of OperationResult
        expect(reports.success).to eq true
        expect(reports.data).not_to be_nil
        expect(reports.data.first).to have_key 'id'

        page_1_first_item_id = reports.data.first['id']
        
        # page 2
        reports_2 = @report.get_ab_reports(page: 2, :name => 'Test', :per => 2)

        expect(reports_2).to be_kind_of OperationResult
        expect(reports_2.success).to eq true
        expect(reports_2.data).not_to be_nil
        expect(reports_2.data.first).to have_key 'id'

        page_2_first_item_id = reports_2.data.first['id']
        expect(page_1_first_item_id).not_to eq page_2_first_item_id
        
        break
      end
    end
    
    it "gets the list of all journeys" do
      journeys = @report.get_journeys(1)
      
      expect(journeys).to be_kind_of OperationResult
      expect(journeys.success).to eq true
      expect(journeys.data).not_to be_nil
      expect(journeys.data.first).to have_key 'created_at'
      expect(journeys.data.first).to have_key 'total_pages'
      expect(journeys.data.first['total_pages']).to be > 0
      
      first_page_id = Time.parse(journeys.data.first['created_at']).to_i
      
      # page 2
      journeys2 = @report.get_journeys(2)
      
      expect(journeys2).to be_kind_of OperationResult
      expect(journeys2.success).to eq true
      expect(journeys2.data).not_to be_nil
      expect(journeys2.data.first).to have_key 'created_at'
      
      second_page_id = Time.parse(journeys2.data.first['created_at']).to_i
      
      expect(first_page_id).not_to eq second_page_id
      
    end
    
  end
end