RSpec.describe MaropostApi::RelationalTableRows do
  before(:each) do
    @test_data = {
      :account_id => 1000,
      :default_table_name => 'rspec_test_for_api',
      :test_field_name => 'email',
      :test_field_value => 'asdfg@maropost.com'
    }
  end
  
  describe "--- CREATE ----" do    
    it "creates a single valid record" do
      r_table = MaropostApi::RelationalTableRows.new(@test_data[:account_id], :table_name => @test_data[:default_table_name])
      test_email = "test_email" << Time.new.to_i.to_s << '@maropost.com'
      create_record = r_table.create({:email => test_email})
      
      expect(create_record).to be_kind_of OperationResult
      expect(create_record.success).to eq true
      expect(create_record.data).not_to be_nil
      expect(create_record.data).to be_kind_of Hash
      expect(create_record.data).to have_key 'result'
      expect(create_record.data['result']).to be_kind_of Hash
      expect(create_record.data['result']).to have_key 'created'
      expect(create_record.data['result']['created']).to eq 1
    end
    
    it "raises error when passed invalid format records" do
      invalid_emails = [
        ['email', 'invalidemail@maropost.com'],
        'email: someemail@maropost.com',
        'param as only string',
        123123123
      ]
      r_table = MaropostApi::RelationalTableRows.new(@test_data[:account_id], :table_name => @test_data[:default_table_name])
      invalid_emails.each do |invalid_email|
        expect{
          r_table.create(invalid_email)
        }.to raise_error(TypeError, "#{invalid_email.inspect} is not type of Hash")
      end
    end
    
    it "creates multiple valid records" do
      r1 = {:email => "abc_#{Time.now.to_i.to_s}@maropost.com"}
      r2 = {:email => "def_#{Time.now.to_i.to_s}@maropost.com"}
      r3 = {:email => "ghi_#{Time.now.to_i.to_s}@maropost.com"}
      r_table = MaropostApi::RelationalTableRows.new(@test_data[:account_id], :table_name => @test_data[:default_table_name])
      
      create_record = r_table.create(r1, r2, r3)
      # record creation expectations
      expect(create_record).to be_kind_of OperationResult
      expect(create_record.success).to eq true
      expect(create_record.data).not_to be_nil
      expect(create_record.data).to be_kind_of Hash
      expect(create_record.data).to have_key 'result'
      expect(create_record.data['result']).to be_kind_of Hash
      expect(create_record.data['result']).to have_key 'created'
      expect(create_record.data['result']['created']).to eq 3
    end  
    
    it "shows a specified record from the relational table" do
      r_table = MaropostApi::RelationalTableRows.new(@test_data[:account_id], :table_name => @test_data[:default_table_name])
      records = r_table.get
      records.data['records'].each do |rec|
        record = r_table.show('ID', rec["ID"])
        expect(record).to be_kind_of OperationResult
        expect(record.success).to eq true
        expect(record.data).not_to be_nil
        expect(record.data).to be_kind_of Hash
        expect(record.data).to have_key 'result'
        expect(record.data['result']).to have_key 'record'
        expect(record.data['result']['record']).not_to be_empty
        expect(record.data['result']['record']['ID']).to eq rec['ID']
      end
    end  
  end
  
  describe "---- GET ----" do
    it "gets list of records for the provided relation table" do
      r_table = MaropostApi::RelationalTableRows.new(@test_data[:account_id], :table_name => @test_data[:default_table_name])
      records = r_table.get
      
      expect(records).to be_kind_of OperationResult
      expect(records.success).to eq true
      expect(records.data).not_to be_nil
      expect(records.data).to be_kind_of Hash
      expect(records.data).to have_key 'records'
      expect(records.data['records']).to be_kind_of Array
      expect(records.data['records']).not_to be_empty
    end
  end
  
  describe "---- PUT ----" do
    it "updates records in the Relational table" do
      r_table = MaropostApi::RelationalTableRows.new(@test_data[:account_id], :table_name => @test_data[:default_table_name])
      r1 = {:email => "create1#{Time.now.to_i.to_s}@maropost.com", :ID => 100}
      r2 = {:email => "create2#{Time.now.to_i.to_s}@maropost.com", :ID => 101}
      r3 = {:email => "create3#{Time.now.to_i.to_s}@maropost.com", :ID => 102}
      created = r_table.create(r1, r2, r3)
      r1 = {:email => "update1#{Time.now.to_i.to_s}@maropost.com", :ID => 100}
      r2 = {:email => "update2#{Time.now.to_i.to_s}@maropost.com", :ID => 101}
      r3 = {:email => "update3#{Time.now.to_i.to_s}@maropost.com", :ID => 102}

      updated = r_table.update(r1, r2, r3)

      expect(updated).to be_kind_of OperationResult
      expect(updated.success).to eq true
      expect(updated.data).not_to be_nil
      expect(updated.data).to be_kind_of Hash
      expect(updated.data).to have_key "result"
      expect(updated.data['result']).not_to be_empty
      expect(updated.data['result']['updated']).to eq 3
    end
    
    it "creates or updates a record in the table" do
      r_table = MaropostApi::RelationalTableRows.new(@test_data[:account_id], :table_name => @test_data[:default_table_name])
      r1 = {:email => "create_1#{Time.now.to_i.to_s}@maropost.com", :ID => 111}
      r2 = {:email => "create_2#{Time.now.to_i.to_s}@maropost.com", :ID => 222}
      r3 = {:email => "update_1#{Time.now.to_i.to_s}@maropost.com", :ID => 111}
      r4 = {:email => "update_2#{Time.now.to_i.to_s}@maropost.com", :ID => 222}
      
      upsert = r_table.upsert(r1, r2, r3, r4)
      
      expect(upsert).to be_kind_of OperationResult
      expect(upsert.success).to eq true
      expect(upsert.data).not_to be_nil
      expect(upsert.data).to be_kind_of Hash
      expect(upsert.data).to have_key "result"
      expect(upsert.data['result']).not_to be_empty
      expect(upsert.data['result']['updated']).not_to be_empty
      expect(upsert.data['result']['updated']['success']).to eq 2
      
    end
  end
  
  describe "---- DELETE ----" do
    it "deletes the given record of the relational table" do
      r_table = MaropostApi::RelationalTableRows.new(@test_data[:account_id], :table_name => @test_data[:default_table_name])
      all_records = r_table.get
      
      all_records.data['records'].each do |rec|
        delete = r_table.delete('ID', rec["ID"])
        
        expect(delete).to be_kind_of OperationResult
        expect(delete.success).to eq true
        expect(delete.data).not_to be_nil
        expect(delete.data).not_to be_empty
        expect(delete.data).to have_key 'record'
        expect(delete.data['record']).to have_key "ID"
        expect(delete.data['record']['ID']).to eq rec["ID"]
      end      
    end
  end
  
end