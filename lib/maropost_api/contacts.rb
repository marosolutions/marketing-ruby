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
    
    def get_opens(contact_id)
      full_path = full_resource_path("/#{contact_id}/open_report")
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
    
      private
      
      def full_resource_path(specifics = '')
        account = MaropostApi.instance_variable_get(:@account)
        "/accounts/#{account}/contacts" << specifics
      end
  end
end