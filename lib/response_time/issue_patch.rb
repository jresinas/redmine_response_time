module ResponseTime
  unloadable
  module IssuePatch
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)

      # Same as typing in the class
      base.class_eval do

      end
    end

    module ClassMethods
    end

    module InstanceMethods
      # Return the date and time when issue has been on state_id passed by param
      # Time parameter is used to select the ordinal time that issue reached the status (1 => first, 2 => second, ... 0 => last)
      # If issue never has been on status or time param is greater than the number of times that issue has reached the status, return nil
      def get_datetime(status, time = 0)
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
        when 'closed'
          Setting.plugin_redmine_response_time['closed_status']
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

      def first_accepted
        @first_accepted ||= get_datetime('accepted', 1)
      end

      def last_accepted
        @last_accepted ||= get_datetime('accepted', 0)
      end

      def first_resolved
        @first_resolved ||= get_datetime('resolved', 1)
      end

      def last_resolved
        @last_resolved ||= get_datetime('resolved', 0)
      end

      def first_blocked
        @first_blocked ||= get_datetime('blocked', 1)
      end

      def last_blocked
        @last_blocked ||= get_datetime('blocked', 0)
      end

      def first_refused
        @first_refused ||= get_datetime('refused', 1)
      end

      def last_refused
        @last_refused ||= get_datetime('refused', 0)
      end

      def first_closed
        @first_closed ||= get_datetime('closed', 1)
      end

      def last_closed
        @last_closed ||= get_datetime('closed', 0)
      end

      def rt_accepted
        if first_accepted.present? and created_on.present?
          first_accepted - created_on
        else
          nil
        end
      end

      def rt_resolved
        if last_closed.present? and first_accepted.present?
          last_closed - first_accepted
        elsif last_closed.present? and created_on.present?
          last_closed - created_on
        else
          nil
        end 
      end

      def rt_blocked
        if first_blocked.present? and created_on.present?
          first_blocked - created_on
        else
          nil
        end
      end

      def rt_refused
        if last_refused.present? and created_on.present?
          last_refused - created_on
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
