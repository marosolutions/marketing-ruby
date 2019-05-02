module MaropostApi
  
  class Contacts

    def initialize(account = ENV["ACCOUNT"], api_key = ENV["API_KEY"])
      MaropostApi.instance_variable_set(:@api_key, api_key)
      MaropostApi.instance_variable_set(:@account, account)
    end
    
    def get_for_email(email)
      full_path = full_resource_path("/email")
      query_params = MaropostApi.set_query_params({"contact[email]" => email})
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    def get_opens(contact_id, page)
      full_path = full_resource_path("/#{contact_id}/open_report")
      query_params = MaropostApi.set_query_params({page: page})
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    def get_clicks(contact_id, page)
      full_path = full_resource_path("/#{contact_id}/click_report")
      query_params = MaropostApi.set_query_params({page: page})
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    def get_for_list(list_id, page)
      full_path = full_resource_path("/#{list_id}/contacts", 'lists')
      query_params = MaropostApi.set_query_params({page: page})
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    def get_contact_for_list(list_id, contact_id)
      full_path = full_resource_path("/#{list_id}/contacts/#{contact_id}", 'lists')
      query_params = MaropostApi.set_query_params
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    def create_contact(
        email,
        first_name,
        last_name,
        phone,
        fax,
        uid = nil,
        custom_field = [],
        add_tags = [],
        remove_tags = [],
        remove_from_dnm = false,
        **options
      )
      args = method(__method__).parameters
      body = {contact: {}}
      args.each do |arg|
        k = arg[1].to_s
        v = eval(k)
        body[:contact][k] = v unless v.nil?
      end
      # p body
      path = full_resource_path()
      
      MaropostApi.post_result(path, body)
    end
    
    def create_or_update_for_list(
        list_id, 
        email, 
        first_name, 
        last_name, 
        phone, 
        fax, 
        uid = nil,
        custom_field = {},
        add_tags = [], 
        remove_tags = [], 
        remove_from_dnm = true, 
        subscribe = true
      )
      args = method(__method__).parameters
      body = {contact: {}}
      args.each do |arg|
        k = arg[1].to_s
        next if k == "list_id"
        v = eval(k)
        body[:contact][k] = v unless v.nil?
      end
      
      email_existence = get_for_email email
      if email_existence.has_key? "email"
        contact_id = email_existence["id"]
        full_path = full_resource_path("/#{list_id}/contacts/#{contact_id}", "lists")
        
        MaropostApi.put_result(full_path, body)
      else
        full_path = full_resource_path("/#{list_id}/contacts", "lists")
        
        MaropostApi.post_result(full_path, body)
      end
      
    end
    
    def create_or_update_for_lists_and_workflows( 
        email,
        first_name,
        last_name,
        phone,
        fax,
        uid = nil,
        custom_field = {},
        add_tags = [],
        remove_tags = [],
        remove_from_dnm = true,
        **options
      )
      args = method(__method__).parameters
      body = {contact: {}}
      args.each do |arg|
        k = arg[1].to_s
        v = eval(k)
        body[:contact][k] = v unless v.nil?
      end
      
      email_existence = get_for_email email
      if email_existence.has_key? "email"
        contact_id = email_existence["id"]
        full_path = full_resource_path("/#{contact_id}")
        body[:contact].delete("options")
        body[:contact]["subscribe"] = options[:subscribe] if options.has_key? :subscribe
        
        MaropostApi.put_result(full_path, body)
      else
        full_path = full_resource_path

        MaropostApi.post_result(full_path, body)
      end
      
    end
    
    def update_for_list_and_contact(
        list_id,
        contact_id,
        email,
        first_name,
        last_name,
        phone,
        fax,
        uid = nil,
        custom_field = {},
        add_tags = [],
        remove_tags = [],
        remove_from_dnm = true,
        subscribe = true
      )
      args = method(__method__).parameters
      body = {contact: {}}
      args.each do |arg|
        k = arg[1].to_s
        next if ["list_id", "contact_id"].include? k
        v = eval(k)
        body[:contact][k] = v unless v.nil?
      end
      
      full_path = full_resource_path("/#{list_id}/contacts/#{contact_id}", "lists")
      
      MaropostApi.put_result(full_path, body)
    end
    
    def unsubscribe_all(contact_field_value, contact_field_name)
      full_path = full_resource_path('/unsubscribe_all')
      query_params = MaropostApi.set_query_params({"contact[#{contact_field_name}]" => contact_field_value})
      
      MaropostApi.put_result(full_path, {}, query_params)
    end
    
    def delete_from_all_lists(email)
      full_path = full_resource_path('/delete_all')
      query_params = MaropostApi.set_query_params({"contact[email]" => email})
      
      MaropostApi.delete_result(full_path, query_params)
    end
    
    def delete_from_lists(contact_id, lists_to_delete_from)
      full_path = full_resource_path("/#{contact_id}")
      query_params = MaropostApi.set_query_params({'list_ids' => lists_to_delete_from.join(',')})
      
      MaropostApi.delete_result(full_path, query_params)
    end
    
    def delete_contact_for_uid(uid)
      full_path = full_resource_path("/delete_all")
      query_params = MaropostApi.set_query_params({"uid" => uid})
      
      MaropostApi.delete_result(full_path, query_params)
    end
    
    def delete_list_contact(list_id, contact_id)
      full_path = full_resource_path("/#{list_id}/contacts/#{contact_id}", "lists")
      query_params = MaropostApi.set_query_params
      
      MaropostApi.delete_result(full_path, query_params)
    end
      
      private
      
      def full_resource_path(specifics = '', root_resource = 'contacts')
        account = MaropostApi.instance_variable_get(:@account)
        "/accounts/#{account}/#{root_resource}" << specifics
      end
  end
end