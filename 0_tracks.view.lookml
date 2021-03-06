- view: tracks
  sql_table_name: hoodie.tracks
  fields:

# Required Fields

  - dimension: event_id
    primary_key: true
    sql: ${TABLE}.event_id

  - dimension: anonymous_id
    sql: ${TABLE}.anonymous_id
  
  - dimension: user_id
    sql: ${TABLE}.user_id
    
  - dimension_group: received
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.received_at 
    
  - dimension: event
    sql: ${TABLE}.event

  - dimension: event_text
    sql: ${TABLE}.event_text


# Additional Fields

  - dimension: context_app_build
    sql: ${TABLE}.context_app_build

  - dimension: context_app_release_version
    sql: ${TABLE}.context_app_release_version

  - dimension: context_app_version
    sql: ${TABLE}.context_app_version

  - dimension: context_carrier
    sql: ${TABLE}.context_carrier

  - dimension: context_device_idfa
    sql: ${TABLE}.context_device_idfa

  - dimension: context_device_manufacturer
    sql: ${TABLE}.context_device_manufacturer

  - dimension: context_device_model
    sql: ${TABLE}.context_device_model

  - dimension: context_device_type
    sql: ${TABLE}.context_device_type

  - dimension: context_ip
    sql: ${TABLE}.context_ip

  - dimension: context_library_name
    sql: ${TABLE}.context_library_name

  - dimension: context_library_version
    sql: ${TABLE}.context_library_version

  - dimension: context_os
    sql: ${TABLE}.context_os

  - dimension: context_os_name
    sql: ${TABLE}.context_os_name

  - dimension: context_os_version
    sql: ${TABLE}.context_os_version

  - dimension: context_screen_height
    type: number
    sql: ${TABLE}.context_screen_height

  - dimension: context_screen_width
    type: number
    sql: ${TABLE}.context_screen_width

  - dimension: context_user_agent
    sql: ${TABLE}.context_user_agent

#   - dimension_group: send
#     type: time                               ##DEPRECATED
#     timeframes: [time, date, week, month]
#     sql: ${TABLE}.send_at
    
  - dimension_group: sent
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.sent_at  

  - measure: count
    type: count
    drill_fields: [context_library_name, context_os_name]


## Advanced Fields (require joins to other views) 

  - dimension_group: weeks_since_first_visit
    type: number
    sql: FLOOR(DATEDIFF(day,${user_session_facts.first_date}, ${sent_date})/7)

  - dimension: is_new_user
    sql:  |
        CASE 
        WHEN ${sent_date} = ${user_session_facts.first_date} THEN 'New User'
        ELSE 'Returning User' END
  
  - measure: count_percent_of_total
    type: percent_of_total
    sql: ${count}
    value_format_name: decimal_1
  
    
## Advanced -- Session Count Funnel Meausures
  
  - filter: event1
    suggestions: [added_item, app_became_active, app_entered_background, 
                  app_entered_foreground, app_launched, app_resigned_active,
                  asked_for_sizes, completed_order, failed_auth_validation, logged_in,
                  made_purchase, payment_available, payment_failed, payment_form_shown,
                  payment_form_submitted, removed_item, saved_sizes, shipping_available,
                  shipping_form_failed, shipping_form_shown, shipping_form_submitted,
                  signed_up, submitted_order, switched_auth_forms, tapped_shipit,
                  view_buy_page, viewed_auth_page]

  - measure: event1_session_count
    type: number
    sql: | 
      COUNT(
        DISTINCT(
          CASE 
            WHEN 
            {% condition event1 %} ${event} {% endcondition %} 
              THEN ${track_facts.session_id}
            ELSE NULL END 
        )
      )

  - filter: event2
    suggestions: [added_item, app_became_active, app_entered_background, 
                  app_entered_foreground, app_launched, app_resigned_active,
                  asked_for_sizes, completed_order, failed_auth_validation, logged_in,
                  made_purchase, payment_available, payment_failed, payment_form_shown,
                  payment_form_submitted, removed_item, saved_sizes, shipping_available,
                  shipping_form_failed, shipping_form_shown, shipping_form_submitted,
                  signed_up, submitted_order, switched_auth_forms, tapped_shipit,
                  view_buy_page, viewed_auth_page]

  - measure: event2_session_count
    type: number
    sql: | 
      COUNT(
        DISTINCT(
          CASE 
            WHEN 
            {% condition event2 %} ${event} {% endcondition %} 
              THEN ${track_facts.session_id}
            ELSE NULL END 
        )
      )
      
  - filter: event3
    suggestions: [added_item, app_became_active, app_entered_background, 
                  app_entered_foreground, app_launched, app_resigned_active,
                  asked_for_sizes, completed_order, failed_auth_validation, logged_in,
                  made_purchase, payment_available, payment_failed, payment_form_shown,
                  payment_form_submitted, removed_item, saved_sizes, shipping_available,
                  shipping_form_failed, shipping_form_shown, shipping_form_submitted,
                  signed_up, submitted_order, switched_auth_forms, tapped_shipit,
                  view_buy_page, viewed_auth_page]

  - measure: event3_session_count
    type: number
    sql: | 
      COUNT(
        DISTINCT(
          CASE 
            WHEN 
            {% condition event3 %} ${event} {% endcondition %} 
              THEN ${track_facts.session_id}
            ELSE NULL END 
        )
      )
      
  - filter: event4
    suggestions: [added_item, app_became_active, app_entered_background, 
                  app_entered_foreground, app_launched, app_resigned_active,
                  asked_for_sizes, completed_order, failed_auth_validation, logged_in,
                  made_purchase, payment_available, payment_failed, payment_form_shown,
                  payment_form_submitted, removed_item, saved_sizes, shipping_available,
                  shipping_form_failed, shipping_form_shown, shipping_form_submitted,
                  signed_up, submitted_order, switched_auth_forms, tapped_shipit,
                  view_buy_page, viewed_auth_page]

  - measure: event4_session_count
    type: number
    sql: | 
      COUNT(
        DISTINCT(
          CASE 
            WHEN 
            {% condition event4 %} ${event} {% endcondition %} 
              THEN ${track_facts.session_id}
            ELSE NULL END 
        )
      )