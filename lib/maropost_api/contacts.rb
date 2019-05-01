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
    
    def updated_for_list_and_contact(
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
    
      private
      
      def full_resource_path(specifics = '', root_resource = 'contacts')
        account = MaropostApi.instance_variable_get(:@account)
        "/accounts/#{account}/#{root_resource}" << specifics
      end
  end
end