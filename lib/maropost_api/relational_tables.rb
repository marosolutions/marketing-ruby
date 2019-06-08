module MaropostApi 
  class RelationalTableRows
    
    attr_accessor :table_name
    
    def initialize(account = ENV["ACCOUNT"], api_key = ENV["API_KEY"], table_name:)
      MaropostApi.instance_variable_set(:@api_key, api_key)
      MaropostApi.instance_variable_set(:@account, account)
      @table_name = table_name
      
      MaropostApi.base_uri "https://rdb.maropost.com/#{account}"
    end
    
    def get
      full_path = full_resource_path
      query_params = MaropostApi.set_query_params
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    def show(unique_field_name, value)
      raise TypeError.new("#{unique_field_name.inspect} should be a string") unless unique_field_name.is_a? String
      params = {:record => {}}
      params[:record][unique_field_name.to_sym] = value
      full_path = full_resource_path '/show'
      
      MaropostApi.post_result(full_path, params)
    end
    
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