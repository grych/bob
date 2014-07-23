# Be sure to restart your server when you modify this file.

BoB::Application.config.session_store :active_record_store, key: '_bob_session', expire_after: 100.years
#BoB::Application.config.session_store :cookie_store, key: '_bob_session', expire_after: 100.years
