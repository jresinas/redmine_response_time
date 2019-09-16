require 'csv'

TICKETING_PROJECT_ID = 36
CALIDAD_PROJECT_ID = 73

TASKS_TRACKER_ID = 2

CF_TIPO_TICKETING_ID = 6
CF_LUGAR_ID = 69



namespace :response_time do
	desc "Crea un repositorio para generar los informes de seguimiento de Soporte Interno y Calidad"
	task :generate_archive => :environment do
		headers = ["Identificador","Tipo de Ticketing","id Proyecto","Asunto","Versión prevista","Lugar","Categoría","Prioridad","Creado","Primera Aceptada","Última Aceptada","Primera Resuelta","Última Resuelta","Primera Bloqueada","Última bloqueada","Primera Rechazada","Última Rechazada","Primera Cerrada","Última Cerrada","TR Aceptada","TR Resuelta","TR Bloqueada","TR Rechazada"]
		results = [headers]

		projects = Project.find([TICKETING_PROJECT_ID, CALIDAD_PROJECT_ID])

		issues = Issue.where({project: projects,tracker_id: TASKS_TRACKER_ID, closed_on: (Date.today - 1.year).beginning_of_year..Date.today}).order(:created_on)

		issues.each do |i|
			result = []
			#Identificador
			result << i.project.identifier
			#Tipo de Ticketing
			result << (cf = CustomValue.where("customized_id = ? AND customized_type = 'Issue' AND custom_field_id = ?", i.id, CF_TIPO_TICKETING_ID).first) ? (cf.present? ? cf.value : '') : 0
			#id Proyecto
			result << i.project_id
			#Asunto
			result << i.subject
			#Versión prevista
			result << (i.fixed_version ? i.fixed_version.name : '-')
			#Lugar
			result << (cf = CustomValue.where("customized_id = ? AND customized_type = 'Issue' AND custom_field_id = ?", i.id, CF_LUGAR_ID).first) ? (cf.present? ? cf.value : '') : 0
			#Categoría
			result << (i.category ? i.category.name : '-')
			#Prioridad
			result << (i.priority ? i.priority.name : '-')
			#Creado
			result << (i.created_on ? i.created_on.strftime('%Y-%m-%d %H:%M:%S') : '-')
			#Primera Aceptada
			result << (i.first_accepted ? i.first_accepted.strftime('%Y-%m-%d %H:%M:%S') : '-')
			#Última Aceptada
			result << (i.last_accepted ? i.last_accepted.strftime('%Y-%m-%d %H:%M:%S') : '-')
			#Primera Resuelta
			result << (i.first_resolved ? i.first_resolved.strftime('%Y-%m-%d %H:%M:%S') : '-')
			#Última Resuelta
			result << (i.last_resolved ? i.last_resolved.strftime('%Y-%m-%d %H:%M:%S') : '-')
			#Primera Bloqueada
			result << (i.first_blocked ? i.first_blocked.strftime('%Y-%m-%d %H:%M:%S') : '-')
			#Última bloqueada
			result << (i.last_blocked ? i.last_blocked.strftime('%Y-%m-%d %H:%M:%S') : '-')
			#Primera Rechazada
			result << (i.first_refused ? i.first_refused.strftime('%Y-%m-%d %H:%M:%S') : '-')
			#Última Rechazada
			result << (i.last_refused ? i.last_refused.strftime('%Y-%m-%d %H:%M:%S') : '-')
			#Primera Cerrada
			result << (i.first_closed ? i.first_closed.strftime('%Y-%m-%d %H:%M:%S') : '-')
			#Última Cerrada
			result << (i.last_closed ? i.last_closed.strftime('%Y-%m-%d %H:%M:%S') : '-')
			#TR Aceptada
			result << (i.rt_accepted ? (i.rt_accepted/3600).round(2) : '-')
			#TR Resuelta
			result << (i.rt_resolved ? (i.rt_resolved/3600).round(2) : '-')
			#TR Bloqueada
			result << (i.rt_blocked ? (i.rt_blocked/3600).round(2) : '-')
			#TR Rechazada
			result << (i.rt_refused ? (i.rt_refused/3600).round(2) : '-')

			results << result
		end

		generate_csv("response_time_archive", results)
	end

	def generate_csv(filename, data)
		CSV.open("public/"+filename+".csv","w",:col_sep => ';',:encoding=>'UTF-8') do |file|
			data.each do |row|
				file << row
			end
		end
	end
end