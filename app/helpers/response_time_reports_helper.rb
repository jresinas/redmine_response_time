module ResponseTimeReportsHelper
  def rt_reports_headers
    [ 
      l(:"field_identifier"),
      l(:"field_subject"),
      l(:"field_fixed_version"),
      l(:"rt.label_location"),
      l(:"field_category"),
      l(:"field_priority"),
      l(:"field_created_on"),
      l(:"rt.label_first_accepted"),
      l(:"rt.label_last_accepted"),
      l(:"rt.label_first_resolved"),
      l(:"rt.label_last_resolved"),
      l(:"rt.label_first_blocked"),
      l(:"rt.label_last_blocked"),
      l(:"rt.label_first_refused"),
      l(:"rt.label_last_refused"),
      l(:"rt.label_first_closed"),
      l(:"rt.label_last_closed"),
      l(:"rt.label_rt_accepted"),
      l(:"rt.label_rt_resolved"),
      l(:"rt.label_rt_blocked"),
      l(:"rt.label_rt_refused")
    ]
  end

  def rt_reports_fields(issue)
    [
      issue.id,
      issue.subject,
      issue.fixed_version ? issue.fixed_version.name : '-',
      Setting.plugin_redmine_response_time[:location].present? ? issue.custom_values.where(custom_field_id: Setting.plugin_redmine_response_time[:location]).first.value : '-',
      issue.category ? issue.category.name : '-',
      issue.priority ? issue.priority.name : '-',
      show_date(issue.created_on),
      show_date(issue.first_accepted),
      show_date(issue.last_accepted),
      show_date(issue.first_resolved),
      show_date(issue.last_resolved),
      show_date(issue.first_blocked),
      show_date(issue.last_blocked),
      show_date(issue.first_refused),
      show_date(issue.last_refused),
      show_date(issue.first_closed),
      show_date(issue.last_closed),
      show_rt(issue.rt_accepted),
      show_rt(issue.rt_resolved),
      show_rt(issue.rt_blocked),
      show_rt(issue.rt_refused)
    ]
  end

  def show_date(date)
    date ? date.strftime('%Y-%m-%d %H:%M:%S') : '-'
  end

  def show_rt(time)
    time ? l_hours(time/3600) : '-'
  end

end