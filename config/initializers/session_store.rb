# Be sure to restart your server when you modify this file.
# I don't understand quite why, but load-balancing causes CSRF tests to fail.  I think it's because
# server A generates the magic token, renders the page and then server B receives the request and
# finds a different token than it expects.  Only thing is, I thought this was stored in the session in a
# cookie, which seems like it should work.   But web articles imply that using a shared session store between
# instances (such as dalli and memcached)  avoids this.

Rails.application.config.session_store :cookie_store, key: '_maint_session'
