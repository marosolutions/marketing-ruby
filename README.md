# Maropost API Ruby Gem

## Summary
This gem provides programmatic access to several Maropost services. It 
consists of eight services within the `MaropostApi` module. Each service 
consists of one or more methods that perform an operation against your 
Maropost account. These methods return an OperationResult object indicating 
success/failure, any Exceptions thrown, and the resulting data.

## Installation

### Composer
The gem command lets you interact with RubyGems. Below is the command to install this gem.
    gem install maropost-api

## Usage
To use a service, first instantiate it, providing your Maropost AccountId
and Auth Token. For example, to get your list of reports using the Reports
service, execute:

    reports =MaropostApi::Reports.new(my_account_id, auth_token)
    result = reports.get()
    if (result.success) {
        myReports = result.getData()
    }

The result object contains three fields:

- `success` (boolean)
- `errors` (Exception)
- `data` (Hash|Mixed)

If `success` is `false`, then `errora` will contain information. If `errors` is not `nil`, then `success` will always be `false`.

The object contains accessor, `data`, which contains whatever
data the operation itself provides. Some operations, such as `delete()`
operations, might not provide any data.

## Specific APIs
The specific APIs contained are:

- [Campaigns](#campaigns)
- [AB Test Campaigns](#ab-test-campaigns)
- [Transactional Campaigns](#transactional-campaigns)
- [Contacts](#contacts)
- [Journeys](#journeys)
- [Product and Revenue](#product-and-revenue)
- [Relational Tables](#relational-tables)
- [Reports](#reports)

### Campaigns
#### Instantiation:

    MaropostApi::Campaigns.nwq(account_id, auth_code)

#### Available methods:

 - `get(page)`
   - returns the list of campaigns for the account
   - `page`: page # (>= 1). Up to 200 records returned per page.
 - `get_campaign(int campaign_id)`
   - returns the given campaign
   - `campaign_id`
 - `get_bounce_reports(id, page)`
   - returns the list of bounce reports for the given campaign ID
   - `page`: page # (>= 1). Up to 200 records returned per page.
 - `get_click_reports(id, page, unique = nil)`
   - returns the list of click reports for the given campaign ID
   - `page`: page # (>= 1). Up to 200 records returned per page.
   - `unique`: `true` = get for unique contacts. Otherwise, `false`. 
 - `get_complaint_reports(id, page)`
   - returns the list of complaint reports for the given campaign ID
   - `page`: page # (>= 1). Up to 200 records returned per page.
 - `get_delivered_reports(id, page)`
   - returns the list of delivered reports for the given campaign ID
   - `page`: page # (>= 1). Up to 200 records returned per page.
 - `get_hard_bounce_reports(id, page)`
   - returns the list of hard bounces for the given campaign ID
   - `page`: page # (>= 1). Up to 200 records returned per page.
 - `get_link_reports(id, page, unique = nil)`
   - returns the list of link reports for the given campaign ID
   - `page`: page # (>= 1). Up to 200 records returned per page.
   - `unique`: `true` = get for unique contacts. Otherwise, `false`. 
 - `get_open_reports(id, page, unique = nil)`
   - returns the list of open reports for the given campaign ID
   - `page`: page # (>= 1). Up to 200 records returned per page.
   - `unique`: `true` = get for unique contacts. Otherwise, `false`. 
 - `get_soft_bounce_reports(id, page)`
   - returns the list of soft bounce reports for the given campaign ID
   - `page`: page # (>= 1). Up to 200 records returned per page.
 - `get_unsubscribe_reports(id, page)`
   - returns the list of unsubscribe reports for the given campaign ID
   - `page`: page # (>= 1). Up to 200 records returned per page.
   
### AB Test Campaigns
#### Instantiation:

  MaropostApi::ab_test_campaigns.new(account_id, auth_token)

#### Available Methods:
 - `create_ab_test(name:, from_email:, address:, language:, campaign_groups_attributes:,
     commit:, sendAt:, brand_id:, suppressed_list_ids:, suppressed_journey_ids:, 
     suppressed_segment_ids:, email_preview_link:, decided_by:, lists:, ctags:, segments:)`
   - `name:`: name of the new campaign
   - `from_email:`: default sender email address for campaign emails
   - `address:`: default physical address included on campaign emails
   - `campaign_groups_attributes:`: array of attributes. Each attribute is
     itself an object with the following properties (all strings):
     - `name`: name of the group
     - `content_id`: content ID
     - `subject`: subject line of emails
     - `from_name`: "from name" on emails
     - `percentage`: percentage of emails that should be sent with these settings.
   - `language:`: ISO 639-1 language code (e.g, `"en"`). 2 characters.
   - `commit:`: Commit
   - `send_at`: DateTime string having the format  YYYY-MM-DDTHH:MM:SS-05:00
   - `brand_id:`: Brand ID
   - `suppressed_list_ids:`: Array of list of ids suppressed lists
   - `suppressed_segment_ids:`: Array of list of ids of suppressed segments
   - `email_preview_link:`: Boolean to indicate whether to send email preview link
   - `decided_by:`: Decided by field
   - `lists:`: Array of list ids
   - `ctags:`: Array of list of ctags
   - `segments:`: Array of list of segment ids
   
### Transactional Campaigns

#### Instantiation:

    MaropostApi::transactional_campaigns.new(account_id, auth_token)

#### Available methods:
 - `get(page)`
     * returns the list of Transaction Campaigns
   - `page`: page # (>= 1). Up to 200 records returned per page.
 - `create(name:, subject:, preheader:, from_name:, from_email:, reply_to:, content_id:, email_preview_link:, address:, language:, add_ctags:)`
     * Creates a Transactional Campaign
     * `name:` campaign name
     * `subject:` campaign subject
     * `preheader:` campaign preheader
     * `from_name:` sender name in the email
     * `from_email:` sender email address
     * `reply_to:` reply-to email address
     * `content_id:`
     * `email_preview_link:`
     * `address:` physical address
     * `language:` ISO 639-1 language code
     * `ctags:` array of campaign tags

 - `sendEmail(int $campaignId, 
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
    )`
     * Sends a transactional campaign email to a recipient. Sender's 
     information will be automatically fetched from the transactional 
     campaign, unless provided in the function arguments.
     * `campaign_id`: must be a campaign that already exists when you call `$svc->get()`. If you don't have one, first call `$svc->create()`.
     * `content`: Either an Integer content_id or a Hash of content fields containing keys such as :name, :html_part, :text_part are acceptable. 
                 The transactional campaign's content will be replaced by this content.
     * `send_time:`: Must be a Hash with keys viz. :minute and :hour which have values ranging 0-59 and 1-12 respectively.
     * `ignore_dnm:`: If true, ignores the Do Not Mail list for the recipient contact.
     * `contact:`: Either an Integer contact_id or a Hash of contact fields containing keys such as :email, :first_name, :last_name, :custom_field are acceptable.
                  furthermore, :custom_field is yet another key value pari (Hash)
     * `bcc_email:`: BCC recipient. May only pass a single email address, empty string, or null. If provided, it must be a well-formed email address according to `FILTER_VALIDATE_EMAIL`.
     * `from_name:`: sender's name. If `$fromEmail` is set, it overrides the transactional campaign default sender name. Ignored otherwise.
     * `from_email:`: sender's email address. Overrides the transactional campaign default sender email.
     * `subject:`: subject line of email. Overrides the transactional campaign default subject.
     * `reply_to:`: reply-to address. Overrides the transactional campaign default reply-to.
     * `sender_address:`: physical address of sender. Overrides the transactional campaign default sender address.
     * `tags:`: associative array where the item key is the name of the tag within the content, and the item value is the tag's replacement upon sending. All keys must be strings. All values must be non-null scalars.
     * `add_ctags:`: campaign tags. Must be a simple array of scalar values.
     

### Contacts

#### Instantiation:
    MaropostApi::Contacts.new(account_id, auth_token)

#### Available methods:

 - `get_for_email(email)`
   * Gets the contact according to email address 
   * `email`: email address of the contact

 - `get_opens(contact_id, page)`
   * Gets the list of opens for the specified contact
   - `page`: page # (>= 1). Up to 200 records returned per page.

 - `get_clicks(contact_id, page)`
   * Gets the list of clicks for the specified contact
   - `page`: page # (>= 1). Up to 200 records returned per page.

 - `get_for_list(list_id, page)`
   * Gets the list of contacts for the specified list
   - `page`: page # (>= 1). Up to 200 records returned per page.

 - `get_contact_for_list(list_id, contact_id)`
   - Gets the specified contact from the specified list
   - `list_id`
   - `contact_id`

 - `public function update_for_list_and_contact(
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
    )`
     * Creates a contact within a list. Updates if previous contact is matched by email
     * `list_id:`: [Integer] id of the list for which to update/create contact
     * `email:`: [String] must be an email
     * `first_name:`: [String] Contact First Name
     * `last_name:`: [String] Contact Last Name
     * `phone:`: [String] Contact's phone number
     * `fax:`: [String] Contacts' fax number
     * `uid:`: [String] Unique identifier
     * `custom_field:`: [Hash] list of custom_fields addable for the new contact
     * `add_tags:`: [Array] list of tags to be added to the contact
     * `remove_tags:`: [Array] list of tags to be removed from the contact
     * `remove_from_dnm:`: [Boolean] decides whether to remove contact from dnm or not
     * `subscribe:`: [Boolean] Flags the new contact as subscribed
     * `list_id:`: [Integer] id of the list for which to update/create contact
     * `email:`: [String] must be an email
  
 - `create_or_update_for_list(
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
    )`
     * Creates a contact within a list. Updates if previous contact is matched by email.
     * `list_id`: [Integer] id of the list for which to update/create contact
     * `email`: [String] must be an email
     * `first_name`: [String] Contact First Name
     * `last_name`: [String] Contact Last Name
     * `phone`: [String] Contact's phone number
     * `fax [`:String] Contacts' fax number
     * `uid [`:String] Unique identifier
     * `custom_field`: [Hash] list of custom_fields addable for the new contact
     * `add_tags`: [Array] list of tags to be added to the contact
     * `remove_tags`: [Array] list of tags to be removed from the contact
     * `remove_from_dnm`: [Boolean] decides whether to remove contact from dnm or not
     * `subscribe`: [Boolean] Flags the new contact as subscribed

 
 - `create_or_update_for_lists_and_workflows( 
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
    )`
     * Creates or updates Contact
        - Multiple lists can be subscribed, unsubscribed. 
        - Multiple workflows can be unsubscribed.
     * `email`: [String] must be an email
     * `first_name`: [String] Contact First Name
     * `last_name`: [String] Contact Last Name
     * `phone`: [String] Contact's phone number
     * `fax`: [String] Contacts' fax number
     * `uid`: [String] Unique identifier
     * `custom_field`: [Hash] list of custom_fields addable for the new contact
     * `add_tags`: [Array] list of tags to be added to the contact
     * `remove_tags`: [Array] list of tags to be removed from the contact
     * `remove_from_dnm`: [Boolean] decides whether to remove contact from dnm or not
     * `options`: [Hash] Key value pairs containing other different properties for the new contact

 - `delete_from_all_lists(email)`
     * Deletes specified contact from all lists
     * `email`: email address of the contact

 - `delete_from_lists(contact_id, lists_to_delete_from)`
     * Deletes the specified contact from the specified lists
     * `contact_id`: id of the contact
     * `lists_to_delete_from`: simple array of ids of the lists

 - `delete_contact_for_uid(uid)`
     * Deletes contact having the specified UID

 - `delete_list_contact(list_id, contact_id)`
     * Deletes specified contact from the specified list

 - `unsubscribe_all(contact_field_value, contact_field_name)`
     * Unsubscribes contact having the specified field name/value.
     * `contact_field_value`: the value of the field for the contact(s) being unsubscribed
     * `contact_field_name`: the name of the field being checked for the value. At present, the 
     accepted field names are: 'email' or 'uid'

### Journeys

#### Instantiation:

    MaropostApi::Journeys.new(account_id, auth_token)

#### Available methods:

 - `get(page)`
     * Gets the list of journeys
   - `page`: page # (>= 1). Up to 200 records returned per page.

 - `get_campaigns(journey_id, page)`
     * Gets the list of all campaigns for the specified journey
   - `page`: page # (>= 1). Up to 200 records returned per page.

 - `get_contacts(journey_id, page)`
     * Gets the list of all contacts for the specified journey
   - `page`: page # (>= 1). Up to 200 records returned per page.

 - `stop_all(contact_id: nil, uid: nil, email_recipient: nil)`
     * Stops all journeys, filtered for the matching parameters
     * `contact_id:`: this filter ignored unless greater than 0
     * `email_recipient:`: this filter ignored if null
     * `uid:`: this filter ignored if null

 - `pause_for_contact(journey_id, contact_id)`
     * Pause the specified journey for the specified contact

 - `pause_for_uid(journey_id, uid)`
     * Pause the specified journey for the contact having the specified UID

 - `reset_for_contact(journey_id, contact_id)`
     * Reset the specified journey for the specified active/paused contact. 
     Resetting a contact to the beginning of the journeys will result in 
     sending of the same journey campaigns as originally sent.

 - `reset_for_uid(journey_id, uid)`
     * Reset the specified journey for the active/paused contact having the 
     specified UID. Resetting a contact to the beginning of the journeys 
     will result in sending of the same journey campaigns as originally sent.

 - `start_for_contact(journey_id, contact_id)`
     * Restarts a journey for a paused contact. Adds a new contact in 
     journey. Retriggers the journey for a contact who has finished its 
     journey once. (To retrigger, *make sure* that "Retrigger Journey" option 
     is enabled.)

 - `start_for_uid(journey_id, uid)`
     * Restarts a journey for a paused contact having the specified UID. 
     Adds a new contact in journey. Retriggers the journey for a contact 
     who has finished its journey once. (To retrigger, *make sure* that 
     "Retrigger Journey" option is enabled.)

### Product and Revenue

#### Instantiation:

    MaropostApi.ProductAndRevenue.new(account_id, auth_token)

#### Available methods:

 - `get_order(id)`
     * Gets the specified order
 - `get_order_for_original_order_id(original_order_id)`
     * Gets the specified order

 - `create_order(
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
    )`
     * Creates an order
     * `require_unique`: [Boolean] validates that the order has a unique original_order_id for the given contact.
     * `contact:`: [Hash] Named parameter, which if exists, must contain :email as its key
     * `order:`: [Hash] Named parameter, which must contain :order_date, :order_status, :original_order_id, :order_items as its keys
     * `@order_items:`: [OrderItem] Custom Type containing key value pair to reference an order item
     * `add_tags:`: [Array] List of string tags to be added in the new order
     * `remove_tags:`: [Array] List of string tags to be removed from the new order
     * `uid:`: [String] Unique Identifier
     * `list_ids:`: [String|CSV] A csv list fo list ids
     * `grand_total:`: [Float] An amount referencing the total of the order
     * `campaing_id:`: [Integer] ID of the Campaign the order belongs to
     * `coupon_code:`: [String]

 - `update_order_for_original_order_id(original_order_id, order: {})`
     * Updates an existing eCommerce order using unique original_order_id if the details are changed due to partial
      return or some other update.
     * `original_order_id:`: [String] Orginal Order Id of the Order
     * `order:`: [Hash] Key value pairs that must contain at least :order_date, :order_status and :order_items as its keys

 - `update_order_for_order_id(order_id, order: {})`
     * Updates an existing eCommerce order using unique order_id if the details are changed due to partial return or
     * some other update.
     * `original_order_id:`: [String] Id of the Order
     * `order:`: [Hash] Key value pairs that must contain at least :order_date, :order_status and :order_items as its keys

 - `delete_for_original_order_id(original_order_id)`
     * Deletes the complete eCommerce order if the order is cancelled or 
     returned using Maropost order id
     * `original_order_id`: Maropost original_order_id

 - `delete_products_for_original_order_id(original_order_id, product_ids)`
     * Deletes the specified product(s) from a complete eCommerce order if 
     the product(s) is cancelled or returned
     * `original_order_id`: matches the original_order_id field of the order
     * `product_ids`: the product(s) to delete from the order

 - `delete_products_for_order_id(order_id, product_ids)`
     * Deletes the specified product(s) from a complete eCommerce order if 
     the product(s) is cancelled or returned
     * `order_idid`: Maropost order_id
     * `product_ids`: the product(s) to delete from the order

### Relational Tables

#### Instantiation:
Unlike the other services, the constructor for this requires a third
parameter: `$tableName`. So for example:

    $svc = new Maropost.Api.RelationalTables($myAccountId, $myAuthToken, $tableName);

`$tableName` sets which relational table the service's operations should act against.
To switch tables, you do not need to re-instantiate the service. Instead,
you can call

    $svc->_setTableName($newTableName);

You can also call `_getTableName()` to determine which table is currently
set.

#### Available functions:

 - `get()`
     * Gets the records of the Relational Table

 - `show(int $id)`
     * Gets the specified record from the Relational Table
     * `$id`: ID of the existing record you wish to read

 - `create(KeyValue... $keyValues)`
     * Adds a record to the Relational Table
     * `...$keyValues`: Multiple `Maropost.Api.InputTypes.KeyValue` objects, for the
     record to be created, each item consisting of two fields:
       - `$key`: string representing the name of the field
       - `$value`: scalar value representing the new value for the field.
         - Any DateTime strings must be in one of three formats: "MM/DD/YYYY", 
         "YYYY-MM-DD", or "YYYY-MM-DDThh:mm:ssTZD".
       - NOTE: One of the KeyValues must represent the unique identifier.

 - `update(KeyValue... $keyValues)`
     * Updates a record in the Relational Table.
     * `...$keyValues`: Multiple `Maropost.Api.InputTypes.KeyValue` objects, for the
     record to be updated, each item consisting of two fields:
       - `$key`: string representing the name of the field
       - `$value`: scalar value representing the new value for the field.
         - Any DateTime strings must be in one of three formats: "MM/DD/YYYY", 
         "YYYY-MM-DD", or "YYYY-MM-DDThh:mm:ssTZD".
       - NOTE: One of the KeyValues must represent the unique identifier.

 - `upsert(KeyValue... $keyValues)`
     * Creates or updates a record in the Relational Table.
     * `...$keyValues`: Multiple `Maropost.Api.InputTypes.KeyValue` objects, for the
     record to be created or updated, each item consisting of two fields:
       - `$key`: string representing the name of the field
       - `$value`: scalar value representing the new value for the field.
         - Any DateTime strings must be in one of three formats: "MM/DD/YYYY", 
         "YYYY-MM-DD", or "YYYY-MM-DDThh:mm:ssTZD".
       - NOTE: One of the KeyValues must represent the unique identifier.

 - `delete(int $idFieldName, $idFieldValue)`
     * Deletes the given record of the Relational Table
     * `$idFieldName` name of the field representing the unique identifier (E.g., "id", "email")
     * `$idFieldValue` value of the identifier field, for the record to delete.

### Reports

#### Instantiation:

    new Maropost.Api.Reports($myAccountId, $myAuthToken)

#### Available methods:
 - `get(int $page)`
   - returns the list of reports
   - `$page`: page # (>= 1). Up to 200 records returned per page.

 - `getReport(int $id)`
   - Gets the list of reports
   - `$id`: report ID

 - `getOpens(
        int $page,
        array $fields = [],
        string $from = null,
        string $to = null,
        bool $unique = null,
        string $email = null,
        string $uid = null,
        int $per = null
    )`
   * returns the list of open reports based on filters and fields provided
   - `$page`: page # (>= 1). Up to 200 records returned per page.
   * `$fields`: contact field names to retrieve
   * `$from`: the beginning of date range filter
   * `$to`: the end of the date range filter
   * `$unique`: when true, gets only unique opens
   * `$email`: filters by provided email in the contact
   * `$uid`: filters by uid
   * `$per`: determines how many records per request to receive

 - `getClicks(
        int $page,
        array $fields = [],
        string $from = null,
        string $to = null,
        bool $unique = null,
        string $email = null,
        string $uid = null,
        int $per = null
    )`
   * returns the list of click reports
   * `$page`: page # (>= 1). Up to 200 records returned per page.
   * `$fields`: plucks these contact fields if they exist
   * `$from`: start of specific date range filter
   * `$to`: end of date range filter
   * `$unique`: if true, gets unique records
   * `$email`: gets Clicks for specific email
   * `$uid`: gets Clicks for provided uid
   * `$per`: gets the specified number of records

 - `getBounces(
        int $page,
        array $fields = [],
        string $from = null,
        string $to = null,
        bool $unique = null,
        string $email = null,
        string $uid = null,
        string $type = null,
        int $per = null
    )`
   * returns the list of bounce reports
   * `$page`: page # (>= 1). Up to 200 records returned per page.
   * `$fields`: plucks these contact fields if they exist
   * `$from`: start of specific date range filter
   * `$to`: end of date range filter
   * `$unique`: if true, gets unique records
   * `$email`: gets Bounces for specific email
   * `$uid`: gets Bounces for provided uid
   * `$per`: gets the specified number of records

 - `getUnsubscribes(
        int $page,
        array $fields = [],
        string $from = null,
        string $to = null,
        bool $unique = null,
        string $email = null,
        string $uid = null,
        int $per = null
    )`
   * returns the list of Unsubscribes with provided filter constraints
   * `$page`: page # (>= 1). Up to 200 records returned per page.
   * `$fields`: plucks these contact fields if they exist
   * `$from`: start of specific date range filter
   * `$to`: end of date range filter
   * `$unique` if true, gets unique records
   * `$email` gets Unsubscribes for specific email
   * `$uid` gets Unsubscribes for provided uid
   * `$per` gets the specified number of records

 - `getComplaints(
        array $fields = [],
        string $from = null,
        string $to = null,
        bool $unique = null,
        string $email = null,
        string $uid = null,
        int $per = null
    )`
   * returns the list of complaints filtered by provided params
   * `$page`: page # (>= 1). Up to 200 records returned per page.
   * `$fields`: plucks these contact fields if they exist
   * `$from`: start of specific date range filter
   * `$to`: end of date range filter
   * `$unique`: if true, gets unique records
   * `$email`: gets Complaints for specific email
   * `$uid`: gets Complaints for provided uid
   * `$per`: gets the specified number of records

 - `getAbReports(
        string $name,
        int $page,
        string $from = null,
        string $to = null,
        int $per = null
    )`
   * returns the list of Ab Reports
   * `$name`: to get ab_reports with mentioned name
   * `$page`: page # (>= 1). Up to 200 records returned per page.
   * `$from`: beginning of date range filter
   * `$to`: end of date range filter
   * `$per`: gets the mentioned number of reports

 - `getJourneys(int $page)`
   * returns the list of all Journeys
   * `$page`: page # (>= 1). Up to 200 records returned per page.
