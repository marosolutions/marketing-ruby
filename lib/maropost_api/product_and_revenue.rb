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
      
      MaropostApi.delete_result(full_path, query_params)
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
      [:first_name, :email, :last_name].each do |contact_field|
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
      
      private
      
      def full_resource_path(specifics = '', root_resource = 'orders')
        account = MaropostApi.instance_variable_get(:@account)
        "/accounts/#{account}/#{root_resource}" << specifics
      end
    
  end
  
end