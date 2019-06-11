# Summary

This provides programmatic access to several services within the Maropost API. The functions contained perform actions against your Maropost account, and they return a result object indicating success/failure, any Exceptions thrown, and the resulting data.

# Installation

[RubyGems](https://rubygems.org/) is the standard Ruby packaging system. You can find this package at https://rubygems.org/gems/maropost-api. You can install this gem by running

    gem install maropost-api

# Usage
To use a service, first instantiate it, providing your Maropost account_id
and Auth Token. For example, to get your list of reports using the Reports
service, execute:

    reports = MaropostApi::Reports.new(account_id, auth_token)
    result = reports.Get(1);
    if (result.success) {
        myReports = result.data;
    }

The result object contains three fields:

- `success` (bool)
- `errors` (object)
- `data` (Hash|Mixed)

If `success` is `false`, then `errors` will have details about the reason for
failure. If `errors` is not `nil`, then `success` will always be `false`.

The object also contains accessor, `data`, which contains whatever
data the operation itself provides. Some operations, such as `delete()`
operations, might not provide any data.

# Specific APIs
The specific APIs contained are:

- [Campaigns](#campaigns)
- [AB Test Campaigns](#ab-test-campaigns)
- [Transactional Campaigns](#transactional-campaigns)
- [Contacts](#contacts)
- [Journeys](#journeys)
- [Products and Revenue](#products-and-revenue)
- [Relational Table Rows](#relational-table-rows)
- [Reports](#reports)

## Campaigns
### Instantiation:

    MaropostApi::Campaigns.new(account_id, auth_token)

### Available methods:

 - `get(page)`
   - returns the list of campaigns for the account
   - `page`: page # (>= 1). Up to 200 records returned per page.
 - `get_campaign(campaign_id)`
   - returns the given campaign
 - `get_bounce_reports(campaign_id, page)`
   - returns the list of bounce reports for the given campaign ID
   - `page`: page # (>= 1). Up to 200 records returned per page.
 - `get_click_reports(campaign_id, page, unique = nil)`
   - returns the list of click reports for the given campaign ID
   - `page`: page # (>= 1). Up to 200 records returned per page.
   - `unique`: `true` = get for unique contacts. Otherwise, `false`. 
 - `get_complaint_reports(campaign_id, page)`
   - returns the list of complaint reports for the given campaign ID
   - `page`: page # (>= 1). Up to 200 records returned per page.
 - `get_delivered_reports(campaign_id, page)`
   - returns the list of delivered reports for the given campaign ID
   - `page`: page # (>= 1). Up to 200 records returned per page.
 - `get_hard_bounce_reports(campaign_id, page)`
   - returns the list of hard bounces for the given campaign ID
   - `page`: page # (>= 1). Up to 200 records returned per page.
 - `get_link_reports(campaign_id, page, unique = nil)`
   - returns the list of link reports for the given campaign ID
   - `page`: page # (>= 1). Up to 200 records returned per page.
   - `unique`: `true` = get for unique contacts. Otherwise, `false`. 
 - `get_open_reports(campaign_id, page, unique = nil)`
   - returns the list of open reports for the given campaign ID
   - `page`: page # (>= 1). Up to 200 records returned per page.
   - `unique`: `true` = get for unique contacts. Otherwise, `false`. 
 - `get_soft_bounce_reports(campaign_id, page)`
   - returns the list of soft bounce reports for the given campaign ID
   - `page`: page # (>= 1). Up to 200 records returned per page.
 - `get_unsubscribe_reports(campaign_id, page)`
   - returns the list of unsubscribe reports for the given campaign ID
   - `page`: page # (>= 1). Up to 200 records returned per page.
   
## AB Test Campaigns
### Instantiation:

    MaropostApi::AbTestCampaigns.new(account_id, auth_token)

### Available Methods:
 - `create_ab_test(name, from_email, address, language, campaign_groups_attributes,`
                  `commit, sendAt, brand_id: nil, suppressed_list_ids: [],`
                  `suppressed_journey_ids: [], suppressed_segment_ids: [], email_preview_link: nil,`
                  `decided_by: nil, lists: [], ctags: [], segments: [])`
   * Creates an Ab Test campaign
   - `name`: name of the new campaign
   - `from_email`: default sender email address for campaign emails
   - `address`: default physical address included on campaign emails
   - `language`: ISO 639-1 language code (e.g., "en"). 2 characters
   - `campaign_groups_attributes`: array of attributes. Each attribute is itself a hash with the following fields (all strings):
     - `name`: name of the group
     - `content_id`: content ID
     - `subject`: subject line of emails
     - `from_name`: "from name" on emails
     - `percentage`: percentage of emails that should be send with these settings 
     - `preheader`:
     - `sendAt`: DateTime string having the format `YYYY-MM-DD HH:mm:ss`
   - `commit`: allowed values: 'Save as Draft' or 'Send Test' or 'Schedule'
   - `sendAt`: should be in "yyyy-mm-dd %H:%M:%S" where %H - Hour of the day, 24-hour clock (00..23), %M - Minute of the hour (00..59), %S - Second of the minute (00..60)
   - `brand_id`: brand ID as a string
   - `suppressed_list_ids`: array of list IDs in string format
   - `suppressed_journey_ids`: array of journey IDs in string format
   - `suppressed_segment_ids`: array of segment IDs in string format
   - `email_preview_link`: "0" for false. "1" for true.
   - `decided_by`: allowed values: ('TopChoice' for Top Choices) or ('Opens' for Highest Open Rate) or ('Clicks' for Highest Click Rate) or ('Manual' for Manual Selection) or ('click_to_open' for Highest Click-to-Open Rate) or ('conversions' for Highest Conversion Rate)
   - `lists`: array of list IDs in string format
   - `ctags`: array of tags in string format
   - `segments`: array of segments in string format
   
## Transactional Campaigns

### Instantiation:

    MaropostApi::TransactionalCampaigns.new(account_id, auth_token)

### Available methods:
 - `get(page)`
     * returns the list of Transaction Campaigns
   - `page`: page # (>= 1). Up to 200 records returned per page.
 - `create(name, subject, preheader, from_name, from_email, reply_to,`
           `content_id, email_preview_link, address, language, add_ctags)`
     * Creates a Transactional Campaign
     - `name`: campaign name
     - `subject`: campaign subject
     - `preheader`: campaign preheader
     - `from_name`: sender name in the email
     - `from_email`: sender email address
     - `reply_to`: reply-to email address
     - `content_id`:
     - `email_preview_link`: boolean. `true` to send email; `false` otherwise.
     - `address`: physical address
     - `language`: ISO 639-1 language code (e.g., "en"). 2 characters
     - `add_ctags`: array of campaign tags

 - `send_email(campaign_id,
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
                 add_ctags: [])`
     * Sends a transactional campaign email to a recipient contact. Sender's information will be automatically fetched from the transactional campaign, unless provided in the function arguments.
     - `campaign_id`: must be a campaign that already exists when you call `get()`. If you don't have one, first call `create(...)`.
     - `content`: hash with the following fields: `name`, `html_part`, `text_part`
     - `ignore_dnm`: If true, ignores the Do Not Mail list for the recipient contact.
     - `contact`: hash defining the recipient with the following fields: `email`, `first_name`, `last_name`, `custom_field`
       - `custom_field`: is a hash of the custom fields.
     - `send_time`: hash with the following string fields: `hour` ("1" - "12") and `minute` ("00" - "59")
       - If the hour is less than the current hour, the email will go out the following day.
       - If the hour and minute combine to less than the current time, the email will go out the following day.
     - `bcc`: BCC recipient. May only pass a single email address, empty string, or nil. If provided, it must be a well-formed email address.
     - `from_name`: sender's name. If `from_email` is set, it overrides the transactional campaign default sender name. Ignored otherwise.
     - `from_email`: sender's email address. Overrides the transactional campaign default sender email.
     - `subject`: subject line of email. Overrides the transactional campaign default subject.
     - `reply_to`: reply-to address. Overrides the transactional campaign default reply-to.
     - `address`: physical address of sender. Overrides the transactional campaign default sender address.
     - `tags`: hash where the field name is the name of the tag within the content, and the field value is the tag's replacement upon sending. All values must be non-nil scalars.
     - `ctags`: campaign tags. Must be a simple array of scalar values.
     
## Contacts

### Instantiation:
	
	MaropostApi::Contacts.new(account_id, auth_token)

### Available methods:

 - `get_for_email(email)`
   * Gets the contact according to email address 
   * `email`: email address of the contact

 - `get_opens(contact_id, page)`
   * Gets the list of opens for the specified contact
   - `contact_id`: contact id of contact to for which the contact is being retrieved
   - `page`: page # (>= 1). Up to 200 records returned per page.

 - `get_clicks(contact_id, page)`
   * Gets the list of clicks for the specified contact
   - `contact_id`: contact id of contact to for which the contact is being retrieved
   - `page`: page # (>= 1). Up to 200 records returned per page.

 - `get_for_list(list_id, page)`
   * Gets the list of contacts for the specified list
   - `list_id`: ID of the list to which the contact being retrieved
   - `page`: page # (>= 1). Up to 200 records returned per page.

 - `get_contact_for_list(list_id, contact_id)`
   - Gets the specified contact from the specified list
   - `list_id`: ID of the list to which the contact is being retrieved
   - `contact_id`: contact id of contact to for which the contact is being retrieved

 - `create_or_update_for_list(list_id, email, first_name: nil, last_name: nil, phone: nil,`
                              `fax: nil, uid: nil, custom_field: nil, add_tags: nil,`
                              `remove_tags: nil, remove_from_dnm: true, subscribe: true)`
     * Creates a contact within a list. Updates if previous contact is matched by email
     - `list_id`: ID of the list to which the contact being updated belongs
     - `contact_id`: ID of the contact being updated
     - `email`: Email address for the contact to be updated
     - `first_name`: first name of Contact
     - `last_name`: last name of Contact
     - `phone`: phone number of Contact
     - `fax`: fax number of Contact
     - `uid`: UID for the Contact
     - `custom_field`: custom fields passed as associative array. Keys represent the field names while values represent the values
     - `add_tags`: tags to add to the contact. Simple array of tag names
     - `remove_tags`: tags to remove from the contact. Simple array of tag names
     - `remove_from_dnm`: set this true to subscribe contact to the list, and remove it from DNM)
     - `subscribe`: set this true to subscribe contact to the list; false otherwise
  
 - `update_for_list_and_contact(list_id, contact_id, email, first_name: nil, last_name: nil, phone: nil, fax: nil,`
                                `uid: nil, custom_field: nil, add_tags: nil, remove_tags: nil, remove_from_dnm: true, subscribe: true)`
     * Creates a contact within a list. Updates if previous contact is matched by email.
     - `list_id`: ID of the list for which the contact is being created
     - `email`: email address for the contact to be created|updated
     - `first_name`: first name of Contact
     - `last_name`: last Name of Contact
     - `phone`: phone number of Contact
     - `fax`: fax number of Contact
     - `uid`: UID for the contact
     - `custom_field`: custom fields passed as associative array. Keys represent the field names while values represent the values.
     - `add_tags`: tags to add to the contact. Simple array of tag names (strings).
     - `remove_tags`: tags to remove from the contact. Simple array of tag names (strings).
     - `remove_from_dnm`: Set this true to subscribe contact to the list, and remove it from DNM.
     - `subscribe`: true to subscribe the contact to the list; false otherwise.
 
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
	 - `uid`: UID of the Contact for which the contact is being deleted

 - `delete_list_contact(list_id, contact_id)`
     * Deletes specified contact from the specified list
	 - `list_id`: ID of the list for which the contact is being deleted
	 - `contact_id`: contact id of the list for which the contact is being deleted

 - `unsubscribe_all(contact_field_value, contact_field_name: "email")`
     * Unsubscribes contact having the specified field name/value.
     * `contact_field_value`: the value of the field for the contact(s) being unsubscribed
     * `contact_field_name`: the name of the field being checked for the value. At present, the 
     accepted field names are: 'email' or 'uid'

## Journeys

### Instantiation:

    MaropostApi::Journeys.new(account_id, auth_token)

### Available methods:

 - `get(page)`
     * Gets the list of journeys
     - `page`: page # (>= 1). Up to 200 records returned per page.

 - `get_campaigns(journey_id, page)`
     * Gets the list of all campaigns for the specified journey
	 - `journey_id`: get campaigns filtered with journey_id
     - `page`: page # (>= 1). Up to 200 records returned per page.

 - `get_contacts(journey_id, page)`
     * Gets the list of all contacts for the specified journey
	 - `journey_id`: get contacts filtered with journey_id
     - `page` : page # (>= 1). Up to 200 records returned per page.

 - `stop_all(contact_id: nil, uid: nil, email_recipient: nil)`
     * Stops all journeys, filtered for the matching parameters
     * `contact_id:`: this filter ignored unless greater than 0
     * `uid:`: this filter ignored if null
     * `email_recipient:`: this filter ignored if null

 - `pause_for_contact(journey_id, contact_id)`
     * Pause the specified journey for the specified contact
	 - `journey_id`: journey to pause
	 - `contact_id`: pause journey for specified contact id

 - `pause_for_uid(journey_id, uid)`
     * Pause the specified journey for the contact having the specified UID
	 - `journey_id`: journey to pause
	 - `uid`: pause journey for specified uid

 - `reset_for_contact(journey_id, contact_id)`
     * Reset the specified journey for the specified active/paused contact. 
     Resetting a contact to the beginning of the journeys will result in 
     sending of the same journey campaigns as originally sent.
	 - `journey_id`: journey to reset
	 - `contact_id`: reset journey for specified contact id

 - `reset_for_uid(journey_id, uid)`
     * Reset the specified journey for the active/paused contact having the 
     specified UID. Resetting a contact to the beginning of the journeys 
     will result in sending of the same journey campaigns as originally sent.
	 - `journey_id`: journey to reset
	 - `uid`: uid of contact to reset journey

 - `start_for_contact(journey_id, contact_id)`
     * Restarts a journey for a paused contact. Adds a new contact in 
     journey. Retriggers the journey for a contact who has finished its 
     journey once. (To retrigger, *make sure* that "Retrigger Journey" option 
     is enabled.)
	- `journey_id`: journey to start
	- `contact_id`: contact id of contact to start journey

 - `start_for_uid(journey_id, uid)`
     * Restarts a journey for a paused contact having the specified UID. 
     Adds a new contact in journey. Retriggers the journey for a contact 
     who has finished its journey once. (To retrigger, *make sure* that 
     "Retrigger Journey" option is enabled.)
	- 'journey_id': journey to start
	- 'uid': uid of contact to start journey

## Products and Revenue

### Instantiation:

    MaropostApi::ProductsAndRevenue.new(account_id, auth_token)

### Available methods:

 - `get_order(id)`
     * Gets the specified order
 - `get_order_for_original_order_id(original_order_id)`
     * Gets the specified order

 - `create_order(require_unique, contact: {}, order: {}, order_items: [], add_tags: [], `
                   `remove_tags: [], uid: nil, list_ids: nil, grand_total: nil, `
                   `campaign_id: nil, coupon_code: nil)`
     * Creates an order
     - `require_unique`: true to validate that the order has a unique original_order_id for the given contact.
     - `contact`: hash containing the following fields: `email`, `first_name`, `last_name`
     - `order`: hash containing the following fields:
         - `order_date`: uses the format: "YYYY-MM-DDTHH:MM:SS-05:00"
         - `order_status`: status of order
         - `original_order_id`: sets the original_order_id field
     - `order_items`: must contain at least one `OrderItem`. When creating an item, do not manually set the properties. Just use the constructor, itself having the parameters:
	     - `item_id`
		 - `price`: price of the order_item
		 - `quantity`: quantity purchased
		 - `description`: description of the product
		 - `adcode`: adcode of the order_item
		 - `category`: category of the product
     - `add_tags` array of strings
     - `remove_tags` array of strings
     - `uid`: unique id
     - `list_ids` CSV list of IDs (e.g, "12,13")
     - `grand_total`: grand total
     - `campaign_id`: campaign id
     - `coupon_code`: coupon code

 - `update_order_for_original_order_id(original_order_id, order: {})`
     * Updates an existing eCommerce order using unique original_order_id if the details are changed due to partial
      return or some other update.
     * `original_order_id:`: [String] Orginal Order Id of the Order
     * `order:`: [Hash] Contains the following fields:
         - `order_date_time`: uses the format: YYYY-MM-DDTHH:MM:SS-05:00
         - `order_status`: order status
         - `order_items`: must contain at least one order_item.
         - `campaign_id`: campaign id
         - `coupon_code`: coupon code

 - `update_order_for_order_id(order_id, order: {})`
     * Updates an existing eCommerce order using unique order_id if the details are changed due to partial return or
     * some other update.
     * `original_order_id:`: [String] Original Order Id of the Order
     * `order:`: [Hash] Contains the following fields:
         - `order_date`: uses the format: YYYY-MM-DDTHH:MM:SS-05:00
         - `order_status`: order status
         - `order_items`: must contain at least one order_item.
         - `campaign_id`: campaign id
         - `coupon_code`: coupon code

 - `delete_for_original_order_id(original_order_id)`
     * Deletes the complete eCommerce order if the order is cancelled or returned
     - `original_order_id` matches the original_order_id field of the order

 - `delete_for_order_id(id)`
     * Deletes the complete eCommerce order if the order is cancelled or returned using Maropost order id
     - `id`: Maropost order_id

 - `delete_products_for_original_order_id(original_order_id, product_ids)`
     * Deletes the specified product(s) from a complete eCommerce order if 
     the product(s) is cancelled or returned
     * `original_order_id`: matches the original_order_id field of the order
     * `product_ids`: the product(s) to delete from the order

 - `delete_products_for_order_id(order_id, product_ids)`
     * Deletes the specified product(s) from a complete eCommerce order if 
     the product(s) is cancelled or returned
     * `order_ids`: Maropost order_id
     * `product_ids`: the product(s) to delete from the order

## Relational Table Rows

### Instantiation:
Unlike the other services, the constructor for this requires a third
parameter: `table_name`. So for example:

    MaropostApi::RelationalTableRows.new(my_account_id, my_auth_token, "someTableName")

`table_name` sets which relational table the service's operations should act against.
To switch tables, you do not need to re-instantiate the service. Simply update the `table_name` property of the instance:

    rows = MaropostApi::RelationalTableRows.new(myId, myToken, "table1");
	rows.table_name = "table2";

### Available functions:

 - `get()`
     * Gets the records of the Relational Table

 - `show(unique_field_name, value)`
     * Gets the specified record from the Relational Table
     * `unique_field_namae`: name of the field representing the unique identifier (E.g., "id", "email")
     * `value`: value of the identifier field, for the record to show

 - `create(key_value_col, *key_value_cols)`
     * Adds a record to the Relational Table
     * `key_value_col`: object hash representing the unique identifier of the record to add.
         * hash key represents the column name and the hash value is the column value.  
     * `*key_value_cols`: other hashes representing other columns to add

 - `update(key_value_col, *key_value_cols)`
     * Updates a record in the Relational Table.
     * `key_value_col`: object hash representing the unique identifier of the record to add.
         * hash key represents the column name and the hash value is the column value.  
     * `*key_value_cols`: other hashes representing other columns to add

 - `upsert(key_value_col, *key_value_cols)`
     * Creates or updates a record in the Relational Table.
     * `key_value_col`: object hash representing the unique identifier of the record to add.
         * hash key represents the column name and the hash value is the column value.  
     * `*key_value_cols`: other hashes representing other columns to add

 - `delete(unique_field_name, value)`
     * Deletes the given record of the Relational Table
     * `unique_field_name` name of the field representing the unique identifier (E.g., "id", "email")
     * `value` value of the identifier field, for the record to delete.

## Reports

### Instantiation:

    MaropostApi::Reports.new(account_id, auth_token)

### Available methods:
 - `get(page)`
   - returns the list of reports
   - `page`: page # (>= 1). Up to 200 records returned per page.

 - `get_report(id)`
   - Gets the list of reports
   - `id`: report ID

 - `get_opens(page,`
             `fields: [],`
             `from: nil,`
             `to: nil,`
             `unique: nil,`
             `email: nil,`
             `uid: nil,`
             `per: nil)`
   * returns the list of open reports based on filters and fields provided
   - `page`: page # (>= 1). Up to 200 records returned per page.
   * `fields`: contact field names to retrieve
   * `from`: the beginning of date range filter
   * `to`: the end of the date range filter
   * `unique`: when true, gets only unique opens
   * `email`: filters by provided email in the contact
   * `uid`: filters by uid
   * `per`: determines how many records per request to receive

 - `get_clicks(page,`
              `fields: [],`
              `from: nil,`
              `to: nil,`
              `unique: nil,`
              `email: nil,`
              `uid: nil,`
              `per: nil)`
   * returns the list of click reports
   * `page`: page # (>= 1). Up to 200 records returned per page.
   * `fields`: plucks these contact fields if they exist
   * `from`: start of specific date range filter
   * `to`: end of date range filter
   * `unique`: if true, gets unique records
   * `email`: gets Clicks for specific email
   * `uid`: gets Clicks for provided uid
   * `per`: gets the specified number of records

 - `get_bounce(page,`
              `fields: [],`
              `from: nil,`
              `to: nil,`
              `unique: nil,`
              `email: nil,`
              `uid: nil,`
              `type: nil,`
              `per: nil)`
   * returns the list of bounce reports
   * `page`: page # (>= 1). Up to 200 records returned per page.
   * `fields`: plucks these contact fields if they exist
   * `from`: start of specific date range filter
   * `to`: end of date range filter
   * `unique`: if true, gets unique records
   * `email`: gets Bounces for specific email
   * `uid`: gets Bounces for provided uid
   * `type`: if provided, should be either "soft", or "hard".
   * `per`: gets the specified number of records

 - ` get_unsubscribes(page,`
                     `fields: [],`
                     `from: nil,`
                     `to: nil,`
                     `unique: nil,`
                     `email: nil,`
                     `uid: nil,`
                     `per: nil)`
   * returns the list of Unsubscribes with provided filter constraints
   * `page`: page # (>= 1). Up to 200 records returned per page.
   * `fields`: plucks these contact fields if they exist
   * `from`: start of specific date range filter
   * `to`: end of date range filter
   * `unique` if true, gets unique records
   * `email` gets Unsubscribes for specific email
   * `uid` gets Unsubscribes for provided uid
   * `per` gets the specified number of records

 - `get_complaints(page,`
                  `fields: nil,`
                  `from: nil,`
                  `to: nil,`
                  `unique: nil,`
                  `email: nil,`
                  `uid: nil,`
                  `per: nil)`
   * returns the list of complaints filtered by provided params
   * `page`: page # (>= 1). Up to 200 records returned per page.
   * `fields`: plucks these contact fields if they exist
   * `from`: start of specific date range filter
   * `to`: end of date range filter
   * `unique`: if true, gets unique records
   * `email`: gets Complaints for specific email
   * `uid`: gets Complaints for provided uid
   * `per`: gets the specified number of records

 - ` get_ab_reports(name,`
                  `page,`
                  `from: nil,`
                  `to: nil,`
                  `per: nil)`
   * returns the list of Ab Reports
   * `name`: to get ab_reports with mentioned name
   * `page`: page # (>= 1). Up to 200 records returned per page.
   * `from`: beginning of date range filter
   * `to`: end of date range filter
   * `per`: gets the mentioned number of reports

 - `get_journeys(page)`
   * returns the list of all Journeys
   * `page`: page # (>= 1). Up to 200 records returned per page.
