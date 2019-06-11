module MaropostApi
  class TransactionalCampaigns
    
    def initialize(account = ENV["ACCOUNT"], api_key = ENV["API_KEY"])
      MaropostApi.instance_variable_set(:@api_key, api_key)
      MaropostApi.instance_variable_set(:@account, account)
    end
    
    def get(page)
      full_path = full_resource_path
      query_params = MaropostApi.set_query_params({:page => page})
      
      MaropostApi.get_result(full_path, query_params)
    end
    
    def create(name:, subject:, preheader:, from_name:, from_email:, reply_to:, content_id:, email_preview_link:, address:, language:, add_ctags: [])
      params = {}
      method(__method__).parameters.each{|p| params[p[1]] = eval(p[1].to_s)}
      params.reject!{|k,v| v.nil? or (v.respond_to? :empty? and v.empty?) }
      
      full_path = full_resource_path
      
      MaropostApi.post_result(full_path, :campaign => params)
    end
    
    def send_email(
          campaign_id:,
          content: {},
          contact: {},
          send_time: {},
          ignore_dnm: nil,
          bcc: nil,
          from_name: nil,
          from_email: nil,
          subject: nil,
          reply_to: nil,
          address: nil,
          tags: {},
          add_ctags: []
      )
        email_regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
        # check for content field values or content id
        raise ArgumentError.new('Content must be a type of Integer (content_id) or a Hash (content field values)') until content.kind_of? Hash or content.kind_of? Integer
        if (content.kind_of? Hash)
          content = content.slice(:name, :html_part, :text_part)
          raise ArgumentError.new('Content field values must have all or some of :name, :html_part and :text_part as keys') until content.empty? || content.count > 0          
        end
        # check for contact field values or contact_id
        raise ArgumentError.new('Contact must be a type of Integer (contact_id) or a Hash (contact field values)') until contact.kind_of? Hash or contact.kind_of? Integer
        if (contact.kind_of? Hash)
          contact = contact.slice(:email, :first_name, :last_name, :custom_field)
          raise ArgumentError.new('Contact field values must have :email and any or all of :first_name and :last_name :custom_field as keys') if contact.empty? || contact[:email].nil?
          raise ArgumentError.new("contact[:custom_field] must be a type of Hash - #{contact[:custom_field].class} given!") until contact[:custom_field].is_a?(Hash) || contact[:custom_field].nil?
        end
        raise ArgumentError.new('contact[:email] must be a valid email address') until contact.is_a? Integer or contact[:email].match? email_regex
        raise ArgumentError.new('bcc must be a valid email address') until bcc.nil? or bcc.match? email_regex
        raise ArgumentError.new('from_email must be a valid email address') until from_email.nil? or from_email.match? email_regex
        raise ArgumentError.new('reply_to must be a valid email address') until reply_to.nil? or reply_to.match? email_regex
        raise ArgumentError.new('add_ctags must be a valid Array of string') until address_ctags.is_a? Array and add_ctags.all?{|t| t.is_a? String }
        raise ArgumentError.new('send_time must have two keys viz. :hour, :minute') until send_time.has_key?(:hour) and send_time.has_key?(:minute)
        raise ArgumentError.new('send_time[:hour] must be between 1-12 and send_time[:minute] must be between 0-59') until (1..12).to_a.include?(send_time[:hour]) and (0..59).to_a.include?(send_time[:minute])
        
        params = {}
        method(__method__).parameters.each{|p| params[p[1]] = eval(p[1].to_s)}
        params.reject!{|k,v| v.nil? or (v.respond_to? :empty? and v.empty?) }
        params[:content_id] = params.delete(:content) if params[:content].kind_of? Integer
        params[:contact_id] = params.delete(:contact) if params[:contact].kind_of? Integer
        
        full_path = full_resource_path('/deliver', 'emails')
        
        MaropostApi.post_result(full_path, :email => params)
    end
    
      private
    
      def full_resource_path(specifics = '', root_resource = 'transactional_campaigns')
        account = MaropostApi.instance_variable_get(:@account)
        "/accounts/#{account}/#{root_resource}" << specifics
      end
    
  end
end