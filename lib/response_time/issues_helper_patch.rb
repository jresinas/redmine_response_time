#require_dependency 'issues_helper'

# Patches Redmine's ApplicationController dinamically. Redefines methods wich
# send error responses to clients
module ResponseTime
  module IssuesHelperPatch
    def self.included(base) # :nodoc:
      base.class_eval do
        unloadable  # Send unloadable so it will be reloaded in development

        def render_accepted_response_time(issue)
          html = ""
          html << "<th>" + l(:"response_time.label_accepted_response_time") + ":</th>"
          if issue.has_been('accepted').present?
            html << "<td>" + l_hours((issue.has_been('accepted',1)-issue.created_on)/3600) + "</td>"
          else
            html << "<td>-</td>"
          end
          html.html_safe
        end
        
        def render_resolved_response_time(issue)
          html = ""
          html << "<th>" + l(:"response_time.label_resolved_response_time") + ":</th>"
          if issue.has_been('accepted').present? and issue.has_been('resolved').present?
            html << "<td>" + l_hours((issue.has_been('resolved',0) - issue.has_been('accepted',1))/3600) + "</td>"
          else
            html << "<td>-</td>"
          end
          html.html_safe
        end
        
        def render_blocked_response_time(issue)
          html = ""
          html << "<th>" + l(:"response_time.label_blocked_response_time") + ":</th>"
          if issue.has_been('blocked').present?
            html << "<td>" + l_hours((issue.has_been('blocked',1) - issue.created_on)/3600) + "</td>"
          else
            html << "<td>-</td>"
          end
          html.html_safe
        end
        
        def render_refused_response_time(issue)
          html = ""
          html << "<th>" + l(:"response_time.label_refused_response_time") + ":</th>"
          if issue.has_been('refused').present?
            html << "<td>" + l_hours((issue.has_been('refused',0) - issue.created_on)/3600) + "</td>"
          else
            html << "<td>-</td>"
          end
          html.html_safe
        end
        
      end
    end
  end
end

ActionDispatch::Callbacks.to_prepare do
  IssuesHelper.send(:include, ResponseTime::IssuesHelperPatch)
end

