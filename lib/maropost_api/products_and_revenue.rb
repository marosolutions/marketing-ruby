require 'maropost_api/custom_types/order_item'

module MaropostApi
  ##
  # Contains methods that will create, update, read and delete the services
  # provided in the Product and Revenue Api
  class ProductsAndRevenue
    ##
    # Creates a new instance of Reports class.
    # @param account [Integer] is authentic user account id (Integer) provided by maropost.com
    # @param api_key [String] is the auth token (String) that is validated on the server to authenticate the user
    def initialize(account = ENV["ACCOUNT"], api_key = ENV["API_KEY"])
      MaropostApi.instance_variable_set(:@api_key, api_key)
      MaropostApi.instance_variable_set(:@account, account)
    end
    
    ##
    # Gets the order for the specified id
    # @param id [Integer] unique identifier of the order
    def get_order(id)
      full_path = full_resource_path("/find")
      query_params = MaropostApi.set_query_params({"where[id]" => id})
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    ##
    # gets the order for the specified original order id
    # @param original_order_id [String] A unique identifier that's not changed since the creation date
    def get_order_for_original_order_id(original_order_id)
      full_path = full_resource_path("/#{original_order_id}")
      query_params = MaropostApi.set_query_params
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    ##
    # Creates a new order from the given parameters
    # @param require_unique [Boolean] validates that the order has a unique original_order_id for the given contact.
    # @param contact [Hash] Named parameter, which if exists, must contain :email as its key
    # @param order [Hash] Named parameter, which must contain :order_date, :order_status, :original_order_id, :order_items as its keys
    # @param @order_items [OrderItem] Custom Type containing key value pair to reference an order item
    # @param add_tags [Array] List of string tags to be added in the new order
    # @param remove_tags [Array] List of string tags to be removed from the new order
    # @param uid [String] Unique Identifier
    # @param list_ids [String|CSV] A csv list fo list ids
    # @param grand_total [Float] An amount referencing the total of the order
    # @param campaing_id [Integer] ID of the Campaign the order belongs to
    # @param coupon_code [String] 
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
    
    ##
    # updates an order fo the given original order id
    # @param original_order_id [String] Orginal Order Id of the Order
    # @param order [Hash] Key value pairs that must contain at least :order_date, :order_status and :order_items as its keys
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
    
    ##
    # updates an order fo the given original order id
    # @param original_order_id [String] Id of the Order
    # @param order [Hash] Key value pairs that must contain at least :order_date, :order_status and :order_items as its keys
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
    
    ##
    # deletes an order fo the given original order id
    # @param original_order_id [String] Orginal Order Id of the Order
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
    
    ##
    # deletes products for the given original order id
    # @param original_order_id [String] Orginal Order Id of the Order
    # @param product_ids [Array] List of product ids to delete
    def delete_products_for_original_order_id(original_order_id, product_ids)
      raise TypeError.new('product_ids should be an Array') until product_ids.is_a? Array
      full_path = full_resource_path("/#{original_order_id}")
      query_params = MaropostApi.set_query_params({"product_ids" => product_ids.join(',')})
      
      MaropostApi.delete_result(full_path, query_params)
    end
    
    ##
    # deletes products for the specified order id
    # @param order_id [Integer] ID of the order
    # @param product_ids [Array] List of product IDs to be deleted    
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