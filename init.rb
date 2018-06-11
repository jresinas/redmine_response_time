require 'response_time/hooks'
require 'response_time/issue_patch'
require 'response_time/issues_helper_patch'

Redmine::Plugin.register :redmine_response_time do
  name 'Redmine Response Time'
  author 'jresinas'
  description "Measurement of Redmine ticket response time"
  version '0.0.1'
  author_url 'http://www.emergya.es'

  settings :default => { 'trackers' => '[]' }, 
  	:partial => 'settings/response_time_settings'

  project_module :response_time do
    permission :view_response_time, {:issues => [:show]}
    permission :view_response_time_report, {:response_time_reports => [:show]}
  end

  menu :project_menu, :response_time_report, { :controller => 'response_time_reports', :action => 'show' },
       :caption => :"rt.label_response_time_reports",
       :param => :project_id
end