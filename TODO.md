## Essential

+ Redis::InheritedError (Tried to use a connection from a child process without r$
  app/models/user.rb:33:in `find_for_facebook_oauth'
  app/controllers/users/omniauth_callbacks_controller.rb:6:in `facebook'



ActionView::Template::Error (undefined method `id' for nil:NilClass):
    1: <div class="checkin_form" id="<%=user.id%>">
    2: 
    3: <% if checkin_today[0] %>
    4:     <%= render 'checkins/uncheckin', :user => user, :display => display %>
  app/views/checkins/_checkin_form.html.erb:1:in `_app_views_checkins__checkin_form_html_erb___1066208742_106733900'
  app/views/sessions/newuser.html.erb:25:in `_app_views_sessions_newuser_html_erb__315330568_106684050'
  app/controllers/sessions_controller.rb:42:in `newuser'



## High Priority

## Non-High Priority


## Missing tests

+ rspec tests for registrations model (belongs to user)
+ modify rspec for users to add registrations
+ messages:read boolean false default

