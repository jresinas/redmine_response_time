module ResponseTime
  unloadable
  module IssuePatch
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)

      # Same as typing in the class
      base.class_eval do
        unloadable # Send unloadable so it will be reloaded in development

      end
    end

    module ClassMethods
    end

    module InstanceMethods
      # Return the date and time when issue has been on state_id passed by param
      # Time parameter is used to select the ordinal time that issue reached the status (1 => first, 2 => second, ... 0 => last)
      # If issue never has been on status or time param is greater than the number of times that issue has reached the status, return nil
      def has_been(status, time = 0)
        status_id = case status
        when 'accepted'
          Setting.plugin_redmine_response_time['accepted_status']
        when 'resolved'
          Setting.plugin_redmine_response_time['resolved_status']
        when 'blocked'
          Setting.plugin_redmine_response_time['blocked_status']
        #when 'closed'
        when 'refused'
          Setting.plugin_redmine_response_time['refused_status']
        end

        result = journals.joins(:details)
          .where("journal_details.prop_key = ? AND journal_details.value = ?", 'status_id', status_id)
          .order("journals.created_on ASC")

        if result.present? and time <= result.count
          time = result.count if time == 0
          result[time-1].created_on
        else
          nil
        end
      end
    end
  end
end

ActionDispatch::Callbacks.to_prepare do
  require_dependency 'issue'
  Issue.send(:include, ResponseTime::IssuePatch)
end
