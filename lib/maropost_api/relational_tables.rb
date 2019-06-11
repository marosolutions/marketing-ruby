module MaropostApi

  ##
  # Contains methods to operate various operations like create, update, delete or read
  # from the Relational Table Api
  class RelationalTableRows
    
    attr_accessor :table_name

    ##
    # Creates a new instance of Reports class.
    # @param account [Integer] is authentic user account id (Integer) provided by maropost.com
    # @param api_key [String] is the auth token (String) that is validated on the server to authenticate the user
    # @param table_name [String] sets which relational table the service's operations should act against
    def initialize(account = ENV["ACCOUNT"], api_key = ENV["API_KEY"], table_name:)
      MaropostApi.instance_variable_set(:@api_key, api_key)
      MaropostApi.instance_variable_set(:@account, account)
      @table_name = table_name
      
      MaropostApi.base_uri "https://rdb.maropost.com/#{account}"
    end

    ##
    # Gets the records of the relational table
    def get
      full_path = full_resource_path
      query_params = MaropostApi.set_query_params
      
      MaropostApi.get_result(full_path, query_params)
    end

    ##
    # Gets the specified record from the relational table
    # @param unique_field_name [String] the name of the field to retrieve
    # @param value [Mixed] Value of the unique_field_name
    def show(unique_field_name, value)
      raise TypeError.new("#{unique_field_name.inspect} should be a string") unless unique_field_name.is_a? String
      params = {:record => {}}
      params[:record][unique_field_name.to_sym] = value
      full_path = full_resource_path '/show'
      
      MaropostApi.post_result(full_path, params)
    end

    ##
    # Adds a record to the Relational Table
    # @param key_value_col [Hash] A key value pair to be added to the table
    # @param key_value_cols [Hash] Other multile key value pairs that can be added at once in the table
    def create(key_value_col, *key_value_cols)
      raise TypeError.new("#{key_value_col.inspect} is not type of Hash") unless key_value_col.kind_of? Hash
      if (key_value_cols)
        invalid_cols = key_value_cols.select{|c| !c.is_a? Hash }
        raise TypeError.new("#{invalid_cols.join(', ')} are not type of Hash") unless invalid_cols.size == 0
      end
      full_path = full_resource_path '/create'
      all_key_values = [key_value_col] + key_value_cols
      
      MaropostApi.post_result(full_path, :record => all_key_values)
    end

    ##
    # Updates a record in the Relational Table
    # @param key_value_col [Hash] A key value to be updated in the table
    # @param key_value_cols [Hash] Rest of the key value pairs to be updated if there are multiple
    def update(key_value_col, *key_value_cols)
      raise TypeError.new("#{key_value_col.inspect} is not type of Hash") unless key_value_col.kind_of? Hash
      if (key_value_cols)
        invalid_cols = key_value_cols.select{|c| !c.is_a? Hash }
        raise TypeError.new("#{invalid_cols.join(', ')} are not type of Hash") unless invalid_cols.size == 0
      end
      full_path = full_resource_path '/update'
      all_key_values = [key_value_col] + key_value_cols
      query_params = MaropostApi.set_query_params
      
      MaropostApi.put_result(full_path, {:record => all_key_values}, query_params)
    end

    ##
    # Creates or updates a record in the Relational Table
    # @param key_value_col [Hash] A key value to be updated inthe table
    # @param key_value_cols [Hash] Rest of the key value pairs to be added/updated in case of multiple fields
    def upsert(key_value_col, *key_value_cols)
      raise TypeError.new("#{key_value_col.inspect} is not type of Hash") unless key_value_col.kind_of? Hash
      if (key_value_cols)
        invalid_cols = key_value_cols.select{|c| !c.is_a? Hash }
        raise TypeError.new("#{invalid_cols.join(', ')} are not type of Hash") unless invalid_cols.size == 0
      end
      full_path = full_resource_path '/upsert'
      all_key_values = [key_value_col] + key_value_cols

      query_params = MaropostApi.set_query_params
      
      MaropostApi.put_result(full_path, {:record => all_key_values}, query_params)
    end

    ##
    # Deletes the given record from the Relational Table
    # @param unique_field_name [String] name of the unique identifier of the record to be deleted
    # @param value [Mixed] value matching the unique identifier
    def delete(unique_field_name, value)
      raise TypeError.new("#{unique_field_name.inspect} is not a String") unless unique_field_name.is_a? String
      record = {:record => {}}
      record[:record][unique_field_name] = value
      
      # first check if key value exists
      show_record = show(unique_field_name, value)
      return show_record unless show_record.success
      
      full_path = full_resource_path '/delete'
      query_params = MaropostApi.set_query_params
      
      MaropostApi.delete_result(full_path, query_params, record)      
    end
    
      private
    
      def full_resource_path(resource_name = '')
        MaropostApi.base_uri + "/#{@table_name}" + "#{resource_name}"
      end
    
  end
end