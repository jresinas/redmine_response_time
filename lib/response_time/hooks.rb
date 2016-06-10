module ResponseTime
  class Hooks < Redmine::Hook::ViewListener
    render_on :view_issues_show_details_bottom,
              :partial => 'issues/response_time_fields'
  end
end