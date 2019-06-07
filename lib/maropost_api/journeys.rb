module MaropostApi
  ##
  # Contains methods that get journey contacts based on provided parameters.
  # The method names themselves reveal the type of reports they are getting.
  class Journeys
    ##
    # Creates a new instance of Reports class.
    # @param account [Integer] is authentic user account id (Integer) provided by maropost.com
    # @param api_key [String] is the auth token (String) that is validated on the server to authenticate the user
    def initialize(account = ENV["ACCOUNT"], api_key = ENV["API_KEY"])
      MaropostApi.instance_variable_set(:@api_key, api_key)
      MaropostApi.instance_variable_set(:@account, account)
    end
    
    ##
    # gets all the journey contacts grouped by
    # @param page [Integer] number that decides which page of result to retrieve
    def get(page)
      full_path = full_resource_path
      query_params = MaropostApi.set_query_params({:page => page})
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    ##
    # gets all campaigns for the provided
    # @param journey_id [Integer] Unique id of Journey
    # @param page [Integer] number that decides which page of result to retrieve
    def get_campaigns(journey_id, page)
      full_path = full_resource_path("/#{journey_id}/journey_campaigns")
      query_params = MaropostApi.set_query_params({:pae => page})
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    ##
    # gets contacts for the provided
    # @param journey_id [Integer] Unique id of Journey
    # @param page [Integer] number that decides which page of result to retrieve
    def get_contacts(journey_id, page)
      full_path = full_resource_path("/#{journey_id}/journey_contacts")
      query_params = MaropostApi.set_query_params({:pae => page})
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    ## 
    # stops all journeys for the given
    # @param contact_id [Integer] Unique id of Contact
    # @param uid [String] Unique ID
    # @param email_recipient [String] Email
    def stop_all(contact_id: nil, uid: nil, email_recipient: nil)
      query_params = {}
      query_params[:contact_id] = contact_id unless contact_id.nil?
      query_params[:uid] = uid unless uid.nil?
      query_params[:email] = email_recipient unless email_recipient.nil?
      full_path = full_resource_path "/stop_all_journeys"
      
      MaropostApi.put_result(full_path, {}, MaropostApi.set_query_params(query_params))
      
    end
    
    ##
    # pauses journey for for the provided
    # @param journey_id [Integer] Unique id of Journey
    # @param contact_id [Integer] Unique id of Contact
    def pause_for_contact(journey_id, contact_id)
      full_path = full_resource_path "/#{journey_id}/stop/#{contact_id}"
      query_params = MaropostApi.set_query_params
      
      MaropostApi.put_result(full_path, {}, query_params)
    end
    
    ##
    # pauses journey for the given
    # @param jouerney_id [Integer] Unique Journey ID
    # @param uid [String] Unique Identifier
    def pause_for_uid(journey_id, uid)
      full_path = full_resource_path "/#{journey_id}/stop/uid"
      query_params = MaropostApi.set_query_params({:uid => uid})
      
      MaropostApi.put_result(full_path, {}, query_params)
    end
    
    ##
    # resets journey for the given contact
    # @param journey_id [Integer] Unique id of Journey
    # @param contact_id [Integer] Unique id of Contact 
    def reset_for_contact(journey_id, contact_id)
      full_path = full_resource_path "/#{journey_id}/reset/#{contact_id}"
      query_params = MaropostApi.set_query_params
      
      MaropostApi.put_result(full_path, {}, query_params)
    end
    
    ##
    # resets journey for the given uid
    # @param jouerney_id [Integer] Unique Journey ID
    # @param uid [String] Unique Identifier
    def reset_for_uid(journey_id, uid)
      full_path = full_resource_path "/#{journey_id}/reset/uid"
      query_params = MaropostApi.set_query_params({:uid => uid})
      
      MaropostApi.put_result(full_path, {}, query_params)
    end
    
    ##
    # starts journey for the given contact
    # @param jouerney_id [Integer] Unique Journey ID
    # @param contact_id [Integer] Unique id of Contact 
    def start_for_contact(journey_id, contact_id)
      full_path = full_resource_path "/#{journey_id}/start/#{contact_id}"
      query_params = MaropostApi.set_query_params
      
      MaropostApi.put_result(full_path, {}, query_params)
    end
    
    ##
    # starts journey for the given uid
    # @param jouerney_id [Integer] Unique Journey ID
    # @param uid [String] Unique Identifier
    def start_for_uid(journey_id, uid)
      full_path = full_resource_path "/#{journey_id}/start/uid"
      query_params = MaropostApi.set_query_params({:uid => uid})
      
      MaropostApi.put_result(full_path, {}, query_params)
    end
    
    
      private
      
      def full_resource_path(specifics = '', root_resource = "journeys")
        account = MaropostApi.instance_variable_get(:@account)
        "/accounts/#{account}/#{root_resource}" << specifics
      end
  end
end