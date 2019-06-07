module MaropostApi
  ##
  # Contains methods that get Contacts based on provided parameters.
  # The method names themselves reveal the type of reports they are getting.
  class Contacts
    ##
    # Creates a new instance of Reports class.
    # @param account [Integer] is authentic user account id (Integer) provided by maropost.com
    # @param api_key [String] is the auth token (String) that is validated on the server to authenticate the user
    def initialize(account = ENV["ACCOUNT"], api_key = ENV["API_KEY"])
      MaropostApi.instance_variable_set(:@api_key, api_key)
      MaropostApi.instance_variable_set(:@account, account)
    end
    
    ##
    # gets contact for the provided
    # @param email [String] must be an email
    def get_for_email(email)
      full_path = full_resource_path("/email")
      query_params = MaropostApi.set_query_params({"contact[email]" => email})
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    ##
    # gets opens for the provided
    # @param contact_id [Integer] unique id of the contact
    # @param page [Integer] number that decides which page or result to retrieve
    def get_opens(contact_id, page)
      full_path = full_resource_path("/#{contact_id}/open_report")
      query_params = MaropostApi.set_query_params({page: page})
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    ##
    # gets clicks for the provided
    # @param contact_id [Integer] unique id of the contact
    # @param page [Integer] number that decides which page or result to retrieve
    def get_clicks(contact_id, page)
      full_path = full_resource_path("/#{contact_id}/click_report")
      query_params = MaropostApi.set_query_params({page: page})
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    ##
    # gets contacts for the provided
    # @param list_id [Integer] unique id of the list
    # @param page [Integer] number that decides which page or result to retrieve
    def get_for_list(list_id, page)
      full_path = full_resource_path("/#{list_id}/contacts", 'lists')
      query_params = MaropostApi.set_query_params({page: page})
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    ##
    # gets contacts for the provided
    # @param list_id [Integer] unique id of the list
    # @param contact_id [Integer] unique contact id
    def get_contact_for_list(list_id, contact_id)
      full_path = full_resource_path("/#{list_id}/contacts/#{contact_id}", 'lists')
      query_params = MaropostApi.set_query_params
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    ##
    # creates a contact
    # @param email [String] must be an email
    # @param first_name [String] Contact First Name
    # @param last_name [String] Contact Last Name
    # @param phone [String] Contact's phone number
    # @param fax [String] Contacts' fax number
    # @param uid [String] Unique identifier
    # @param custom_field [Hash] list of custom_fields addable for the new contact
    # @param add_tags [Array] list of tags to be added to the contact
    # @param remove_tags [Array] list of tags to be removed from the contact
    # @param remove_from_dnm [Boolean] decides whether to remove contact from dnm or not
    # @param options [Hash] Key value pairs containing other different properties for the new contact
    def create_contact(
        email,
        first_name,
        last_name,
        phone,
        fax,
        uid = nil,
        custom_field = {},
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
    
    ##
    # creates a contact
    # @param list_id [Integer] id of the list for which to update/create contact
    # @param email [String] must be an email
    # @param first_name [String] Contact First Name
    # @param last_name [String] Contact Last Name
    # @param phone [String] Contact's phone number
    # @param fax [String] Contacts' fax number
    # @param uid [String] Unique identifier
    # @param custom_field [Hash] list of custom_fields addable for the new contact
    # @param add_tags [Array] list of tags to be added to the contact
    # @param remove_tags [Array] list of tags to be removed from the contact
    # @param remove_from_dnm [Boolean] decides whether to remove contact from dnm or not
    # @param subscribe [Boolean] Flags the new contact as subscribed
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
      
      email_existence = get_for_email(email)
      if email_existence.success
        contact_id = email_existence.data["id"]
        full_path = full_resource_path("/#{list_id}/contacts/#{contact_id}", "lists")
        
        MaropostApi.put_result(full_path, body)
      else
        full_path = full_resource_path("/#{list_id}/contacts", "lists")
        
        MaropostApi.post_result(full_path, body)
      end
      
    end
    
    ##
    # creates a contact
    # @param email [String] must be an email
    # @param first_name [String] Contact First Name
    # @param last_name [String] Contact Last Name
    # @param phone [String] Contact's phone number
    # @param fax [String] Contacts' fax number
    # @param uid [String] Unique identifier
    # @param custom_field [Hash] list of custom_fields addable for the new contact
    # @param add_tags [Array] list of tags to be added to the contact
    # @param remove_tags [Array] list of tags to be removed from the contact
    # @param remove_from_dnm [Boolean] decides whether to remove contact from dnm or not
    # @param options [Hash] Key value pairs containing other different properties for the new contact
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
      if email_existence.success
        contact_id = email_existence.data["id"]
        full_path = full_resource_path("/#{contact_id}")
        body[:contact].delete("options")
        body[:contact]["subscribe"] = options[:subscribe] if options.has_key? :subscribe
        
        MaropostApi.put_result(full_path, body)
      else
        full_path = full_resource_path

        MaropostApi.post_result(full_path, body)
      end
      
    end
    
    ##
    # creates a contact
    # @param list_id [Integer] id of the list for which to update/create contact
    # @param email [String] must be an email
    # @param first_name [String] Contact First Name
    # @param last_name [String] Contact Last Name
    # @param phone [String] Contact's phone number
    # @param fax [String] Contacts' fax number
    # @param uid [String] Unique identifier
    # @param custom_field [Hash] list of custom_fields addable for the new contact
    # @param add_tags [Array] list of tags to be added to the contact
    # @param remove_tags [Array] list of tags to be removed from the contact
    # @param remove_from_dnm [Boolean] decides whether to remove contact from dnm or not
    # @param subscribe [Boolean] Flags the new contact as subscribed
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
    
    ##
    # unsubscribes all those contacts matching
    # @param contact_field_value [String|Integer] the value of the contact field name
    # @param contact_field_name [String|Integer] the name of the field to query the contact for
    def unsubscribe_all(contact_field_value, contact_field_name)
      full_path = full_resource_path('/unsubscribe_all')
      query_params = MaropostApi.set_query_params({"contact[#{contact_field_name}]" => contact_field_value})
      
      MaropostApi.put_result(full_path, {}, query_params)
    end
    
    ##
    # deletes contact from all the lists
    # @param email [String] gets deleted if matches the value provided
    def delete_from_all_lists(email)
      full_path = full_resource_path('/delete_all')
      query_params = MaropostApi.set_query_params({"contact[email]" => email})
      
      MaropostApi.delete_result(full_path, query_params)
    end
    
    ##
    # deletes contact from list
    # @param contact_id [Integer] Contact id to delete
    # @param list_to_delete_from [Integer] List id
    def delete_from_lists(contact_id, lists_to_delete_from)
      full_path = full_resource_path("/#{contact_id}")
      query_params = MaropostApi.set_query_params({'list_ids' => lists_to_delete_from.join(',')})
      
      MaropostApi.delete_result(full_path, query_params)
    end
    
    ##
    # deletes contact for uid
    # @param uid [String] unique identifier
    def delete_contact_for_uid(uid)
      full_path = full_resource_path("/delete_all")
      query_params = MaropostApi.set_query_params({"uid" => uid})
      
      MaropostApi.delete_result(full_path, query_params)
    end
    
    ##
    # deletes list for the given contact
    # @param list_id [Integer] List ID
    # @param contact_id [Integer] Contact ID
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