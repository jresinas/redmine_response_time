#require_dependency 'issues_helper'

# Patches Redmine's ApplicationController dinamically. Redefines methods wich
# send error responses to clients
module ResponseTime
  module IssuesHelperPatch
    def self.included(base) # :nodoc:
      base.class_eval do

        def render_accepted_response_time(issue)
          html = "<div class='attribute'>"
          html << "<div class='label'>" + l(:"rt.label_accepted_response_time") + ":</div><div class='value'>"
          if issue.rt_accepted.present?
            html << l_hours(issue.rt_accepted/3600)
          else
            html << "-"
          end
          html << "</div></div>"
          html.html_safe
        end
        
        def render_resolved_response_time(issue)
          html = "<div class='attribute'>"
          html << "<div class='label'>" + l(:"rt.label_resolved_response_time") + ":</div><div class='value'>"
          if issue.rt_resolved.present?
            html << l_hours(issue.rt_resolved/3600)
          else
            html << "-"
          end
          html << "</div></div>"
          html.html_safe
        end
        
        def render_blocked_response_time(issue)
          html = "<div class='attribute'>"
          html << "<div class='label'>" + l(:"rt.label_blocked_response_time") + ":</div><div class='value'>"
          if issue.rt_blocked.present?
            html << l_hours(issue.rt_blocked/3600)
          else
            html << "-"
          end
          html << "</div></div>"
          html.html_safe
        end
        
        def render_refused_response_time(issue)
          html = "<div class='attribute'>"
          html << "<div class='label'>" + l(:"rt.label_refused_response_time") + ":</div><div class='value'>"
          if issue.rt_refused.present?
            html << l_hours(issue.rt_refused/3600)
          else
            html << "-"
          end
          html << "</div></div>"
          html.html_safe
        end
        
      end
    end
  end
end

ActionDispatch::Callbacks.to_prepare do
  IssuesHelper.send(:include, ResponseTime::IssuesHelperPatch)
end

