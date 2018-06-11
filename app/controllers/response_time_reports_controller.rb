require 'csv'
class ResponseTimeReportsController < ApplicationController
	include ResponseTimeReportsHelper
	before_filter :find_project_by_project_id, :authorize

	menu_item :response_time_report

	def show
		limit = (params[:format] and params[:format] == 'csv') ? Issue.count : 25

		if params[:versions]
			@issue_pages, @issues = paginate @project.issues.where("tracker_id IN (?) AND fixed_version_id IN (?)", Setting.plugin_redmine_response_time[:trackers], params[:versions]), :per_page => limit
		else
			@issue_pages, @issues = paginate @project.issues.where("tracker_id IN (?)", Setting.plugin_redmine_response_time[:trackers]), :per_page => limit
		end

	    respond_to do |format|
	      format.html {  }
	      format.csv  { 
	      	issues_csv = CSV.generate(:col_sep => ';') do |csv|
	      		csv << rt_reports_headers
		      	@issues.each do |issue|
					csv << rt_reports_fields(issue)
		      	end
		    end
	      	send_data(issues_csv, :type => 'text/csv; header=present', :filename => 'response_time_report.csv') 

	      }
	    end
	end

	def search
		redirect_to :show
	end
end
