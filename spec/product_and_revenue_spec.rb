RSpec.describe MaropostApi::ProductAndRevenue do
  
  before(:each) do
    @test_data = {
      :account_id => 1000,
      :original_order_id => 'getorderbyoriginalorderidtest'
    }
  end
  
  describe "---- Order Creation ----" do
    it "creates new order" do
      original_order_id = "order#-#{Time.now.to_i.to_s}"
      order = create_test_order(order: {original_order_id: original_order_id})
      
      expect(order).to be_kind_of OperationResult
      expect(order.success).to eq true
      expect(order.errors).to be_nil
      expect(order.data).to have_key "original_order_id"
      expect(order.data).to have_key "created_at"
      expect(order.data).to have_key "updated_at"
      expect(order.data["original_order_id"]).to eq original_order_id
      expect(order.data["created_at"].to_i).to eq order.data["updated_at"].to_i
    end
  end
  
  describe "---- Order Updates ----" do
    it "updates order for given original order id" do
      prod_and_rev = MaropostApi::ProductAndRevenue.new(@test_data[:account_id])
      org_order_id = @test_data[:original_order_id]
      # order_to_update = prod_and_rev.get_order_for_original_order_id(org_order_id)
      order = {
        order_date: Time.now,
        order_status: 'Updated',
        campaign_id: nil,
        coupon_code: nil,
        order_items: [
          OrderItem.new(1001, 500, 2, 'updates order for given original order id', 'ADCODE-01', 'Original Order ID Update Test Category')
        ]
      }
      update_result = prod_and_rev.update_order_for_original_order_id(org_order_id, :order => order)
      
      expect(update_result).to be_kind_of OperationResult
      expect(update_result.success).to eq true
      expect(update_result.data).to include 'Order was successfully updated'
    end
    
    it "updates order for given order id" do
      prod_and_rev = MaropostApi::ProductAndRevenue.new(@test_data[:account_id])
      order_to_update = prod_and_rev.get_order_for_original_order_id(@test_data[:original_order_id])
      order_id = order_to_update.data["id"]
      
      order = {
        order_date: Time.now,
        order_status: 'Updated For ID',
        campaign_id: nil,
        coupon_code: nil,
        order_items: [
          OrderItem.new(2001, 502, 3, 'update order for given order_id', 'ADCODE-02', 'this is a test')
        ]
      }
      
      update_result = prod_and_rev.update_order_for_order_id(order_id, order: order)
      
      expect(update_result).to be_kind_of OperationResult
      expect(update_result.success).to eq true
      expect(update_result.data).to include 'Order was successfully updated'
    end
  end
  
  describe "---- Delete Orders ----" do
    it "deletes order for given original_order_id" do
      ## create products for given original_order_id first
      original_order_id = Time.now.to_i.to_s << '_to_be_deleted'
      new_order = create_test_order(order: {original_order_id: original_order_id})
      expect(new_order).to be_kind_of OperationResult
      expect(new_order.data).to have_key "original_order_id"
      expect(new_order.data["original_order_id"]).to eq original_order_id
      
      prod_and_rev = MaropostApi::ProductAndRevenue.new(@test_data[:account_id])
      
      delete_result = prod_and_rev.delete_for_original_order_id(original_order_id)
      
      expect(delete_result).to be_kind_of OperationResult
      expect(delete_result.success).to eq true
      expect(delete_result.data).to include 'Order was successfully deleted'
      
      the_created_order = prod_and_rev.get_order_for_original_order_id(original_order_id)
      
      expect(the_created_order).to be_kind_of OperationResult
      expect(the_created_order.success).to eq false
      expect(the_created_order.errors).not_to be_nil
      expect(the_created_order.errors).to be_kind_of Hash
      expect(the_created_order.errors).to have_key "message"
      expect(the_created_order.errors["message"]).to include "Order ID not found"
    end
    
    it "deletes order for given order_id" do
      prod_and_rev = MaropostApi::ProductAndRevenue.new(@test_data[:account_id])
      
      original_order_id = Time.now.to_i.to_s << '_to_be_deleted'
      new_order = create_test_order(order: {original_order_id: original_order_id})
      new_order = prod_and_rev.get_order_for_original_order_id(original_order_id)
      expect(new_order).to be_kind_of OperationResult
      expect(new_order.data).to have_key "original_order_id"
      expect(new_order.data["original_order_id"]).to eq original_order_id
      
      order_id = new_order.data["id"]
      delete_result = prod_and_rev.delete_for_order_id(order_id)
      
      expect(delete_result).to be_kind_of OperationResult
      expect(delete_result.success).to eq true
      expect(delete_result.data).to include 'Order was successfully deleted'
      
      new_order_deleted = prod_and_rev.get_order(order_id)
      
      expect(new_order_deleted).to be_kind_of OperationResult
      expect(new_order_deleted.success).to eq false
      expect(new_order_deleted.errors).not_to be_nil
      expect(new_order_deleted.errors).to have_key "message"
      expect(new_order_deleted.errors["message"]).to include "Order ID not found"
    end
    
    it "deletes products for given original_order_id" do
      prod_and_rev = MaropostApi::ProductAndRevenue.new(@test_data[:account_id])
      ## create products for given original_order_id first
      original_order_id = Time.now.to_i.to_s << '_to_be_deleted'
      new_order = create_test_order(order: {original_order_id: original_order_id})
      new_order = prod_and_rev.get_order_for_original_order_id(original_order_id)
      product_ids = new_order.data['products'].map{|prod| prod["item_id"].to_i }
      
      product_deletion = prod_and_rev.delete_products_for_original_order_id(original_order_id, product_ids)
      
      expect(product_deletion).to be_kind_of OperationResult
      expect(product_deletion.success).to eq true
      expect(product_deletion.data).to be_kind_of String
      expect(product_deletion.data).to include "Order Item was successfully deleted."
    end
    
    it "deletes products for given order_id" do
      prod_and_rev = MaropostApi::ProductAndRevenue.new(@test_data[:account_id])
      ## create products for given original_order_id first
      original_order_id = Time.now.to_i.to_s << '_to_be_deleted'
      new_order = create_test_order(order: {original_order_id: original_order_id})
      new_order = prod_and_rev.get_order_for_original_order_id(original_order_id)
      order_id = new_order.data["id"]
      product_ids = new_order.data['products'].map{|prod| prod["item_id"].to_i }
      
      product_deletion = prod_and_rev.delete_products_for_order_id(order_id, product_ids)
      
      expect(product_deletion).to be_kind_of OperationResult
      expect(product_deletion.success).to eq true
      expect(product_deletion.data).to be_kind_of String
      expect(product_deletion.data).to include "Order Item was successfully deleted."
    end
  end
  
  describe "---- Get Orders ----" do
    it "gets order for specified id" do
      org_order_id = 'get-order-test-id-01'
      new_order = create_test_order(order: {original_order_id: org_order_id})
      prod_and_rev = MaropostApi::ProductAndRevenue.new(@test_data[:account_id])
      
      get_order = prod_and_rev.get_order(new_order.data['id'])
      
      expect(get_order).to be_kind_of OperationResult
      expect(get_order.success).to eq true
      expect(get_order.errors).to be_nil
      expect(get_order.data).not_to be_nil
      expect(get_order.data).to have_key 'original_order_id'
      expect(get_order.data).to have_key 'created_at'
      expect(get_order.data).to have_key 'updated_at'
      expect(get_order.data['original_order_id']).to eq org_order_id
      expect(get_order.data['created_at'].to_i).to eq get_order.data['updated_at'].to_i
    end
    
    it "gets order for specified original order id" do
      org_order_id = @test_data[:original_order_id]
      new_order = create_test_order(order: {original_order_id: org_order_id})
      prod_and_rev = MaropostApi::ProductAndRevenue.new(@test_data[:account_id])
      
      get_order = prod_and_rev.get_order_for_original_order_id(org_order_id)
      
      expect(get_order).to be_kind_of OperationResult
      expect(get_order.success).to eq true
      expect(get_order.errors).to be_nil
      expect(get_order.data).not_to be_nil
      expect(get_order.data).to have_key 'original_order_id'
      expect(get_order.data).to have_key 'created_at'
      expect(get_order.data).to have_key 'updated_at'
      expect(get_order.data['original_order_id']).to eq org_order_id
      expect(get_order.data['created_at'].to_i).to eq get_order.data['updated_at'].to_i
    end
  end
  
    private
    
      def create_test_order(contact: {}, order: {}, order_items: [])
        prodrev = MaropostApi::ProductAndRevenue.new(@test_data[:account_id])
        contact = contact.merge({
          :first_name => 'Ashisih', :email => 'writetoaashu@gmail.com', :last_name => 'Acharya'
        })
        order = order.merge({
          :order_date => Time.now,
          :order_status => 'Placed'
        })
        order_items = order_items.concat([
            OrderItem.new(1001, 5005, 5, 'Test Order', 'AD001', 'Test Cat'),
            OrderItem.new(1002, 5001, 2, 'Test Order#2', 'AD002', 'Apple'),
          ])
        prodrev.create_order(true, :contact => contact, :order => order, :order_items => order_items)
      end
end