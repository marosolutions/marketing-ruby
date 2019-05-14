require 'maropost_api/custom_types/order_item'

module MaropostApi
  
  class ProductAndRevenue
    
    def initialize(account = ENV["ACCOUNT"], api_key = ENV["API_KEY"])
      MaropostApi.instance_variable_set(:@api_key, api_key)
      MaropostApi.instance_variable_set(:@account, account)
    end
    
    def get_order(id)
      full_path = full_resource_path("/find")
      query_params = MaropostApi.set_query_params({"where[id]" => id})
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    def get_order_for_original_order_id(original_order_id)
      full_path = full_resource_path("/#{original_order_id}")
      query_params = MaropostApi.set_query_params
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    def create_order(
      require_unique, 
      contact: {}, 
      order: {},
      order_items: [],
      add_tags: [], 
      remove_tags: [],
      uid: nil, 
      list_ids: nil, 
      grand_total: nil,
      campaign_id: nil,
      coupon_code: nil
    )
      # required contacts fields to check for
      [:email,].each do |contact_field|
        raise ArgumentError.new "contact[:#{contact_field}] is required!" if contact.has_key?(contact_field.to_sym) == false
      end
      # order items validation
      order_items.each do |item|
        raise TypeError.new("Each order item must be an instance of maropost_api/custom_types/OrderItem: " << item.class.to_s << " given") unless item.kind_of?(OrderItem)
        order[:order_items] ||= []
        order[:order_items].push(item.to_hash)
      end
      # required order fields to check for
      [:order_date, :order_status, :original_order_id, :order_items].each do |order_field|
        raise ArgumentError.new "order[:#{order_field}] is required!" if order.has_key?(order_field) == false
      end

      params = order
      params[:contact] = contact
      params[:uid] = uid
      params[:list_ids] = list_ids
      params[:grand_total] = grand_total
      params[:campaign_id] = campaign_id
      params[:coupon_code] = coupon_code
      
      full_path = full_resource_path
      
      MaropostApi.post_result(full_path, {"order" => params})
    end
    
    def update_order_for_original_order_id(original_order_id, order: {})
      raise ArgumentError.new('original_order_id is required') if original_order_id.nil?
      
      [:order_date, :order_status, :order_items].each do |f|
        raise ArgumentError.new("order[:#{f}] is required") unless order.has_key?(f)
      end
      order[:order_items].each do |oi|
        raise TypeError.new('each order item should be a type of ' << OrderItem.class.to_s) unless oi.kind_of? OrderItem
      end
      order[:order_items].map! {|i| i.to_hash }
      
      full_path = full_resource_path("/#{original_order_id}")
      form_body = {order: order}
      
      MaropostApi.put_result(full_path, form_body)   
    end
    
    def update_order_for_order_id(order_id, order: {})
      raise ArgumentError.new('order_id is required') if order_id.nil?
      
      [:order_date, :order_status, :order_items].each do |f|
        raise ArgumentError.new("order[:#{f}] is required") unless order.has_key?(f)
      end
      order[:order_items].each do |oi|
        raise TypeError.new('each order item should be a type of ' << OrderItem.class.to_s) unless oi.kind_of? OrderItem
      end
      order[:order_items].map! {|i| i.to_hash }
      
      full_path = full_resource_path("/find")
      query_params = MaropostApi.set_query_params({"where[id]" => order_id})
      
      MaropostApi.put_result(full_path, {order: order}, query_params)
    end
    
    def delete_for_original_order_id(original_order_id)
      full_path = full_resource_path("/#{original_order_id}")
      query_params = MaropostApi.set_query_params
      
      MaropostApi.delete_result(full_path, query_params)
    end
    
    def delete_for_order_id(order_id)
      full_path = full_resource_path('/find')
      query_params = MaropostApi.set_query_params({'where[id]' => order_id})
      
      MaropostApi.delete_result(full_path, query_params)
    end
    
    def delete_products_for_original_order_id(original_order_id, product_ids)
      raise TypeError.new('product_ids should be an Array') if ! product_ids.kind_of? Array
      full_path = full_resource_path("/#{original_order_id}")
      query_params = MaropostApi.set_query_params({"product_ids" => product_ids.join(',')})
      
      MaropostApi.delete_result(full_path, query_params)
    end
    
    def delete_products_for_order_id(order_id, product_ids)
      raise TypeError.new('product_ids should be an Array') if ! product_ids.kind_of? Array
      full_path = full_resource_path("/find")
      query_params = MaropostApi.set_query_params({"product_ids" => product_ids.join(','), 'where[id]' => order_id})
      
      MaropostApi.delete_result(full_path, query_params)
    end
      
      private
      
      def full_resource_path(specifics = '', root_resource = 'orders')
        account = MaropostApi.instance_variable_get(:@account)
        "/accounts/#{account}/#{root_resource}" << specifics
      end
    
  end
  
end