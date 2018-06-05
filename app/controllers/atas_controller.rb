class AtasController < ApplicationController
	# skip_before_filter :check_if_login_required
	# skip_before_filter :verify_authenticity_token
	accept_api_auth :projects, :project

	def projects
		forbidden_services = Setting.plugin_redmine_atas['ignored_project_services'] # ["Estructura", "Otros", "No Clasificado", "Gestión de producción", "No clasificado"]
	  project_service = Setting.plugin_redmine_atas['project_service']
    project_manager = Setting.plugin_redmine_atas['project_manager']

    @user = User.joins(:email_address).where("email_addresses.address = ?", params[:email]).first

	  if @user.present?
			data = @user.projects
        .joins("LEFT JOIN custom_values AS service ON service.customized_type = 'Project' AND service.customized_id = projects.id AND service.custom_field_id = #{project_service}")
        .joins("LEFT JOIN custom_values AS pm ON pm.customized_type = 'Project' AND pm.customized_id = projects.id AND pm.custom_field_id = #{project_manager}")
        .where("service.value NOT IN (?)", forbidden_services)
      scope = data
		else
			scope = Project.none
		end

    respond_to do |format|
      format.html {
      	unless params[:closed]
          scope = scope.active
        end
        @projects = scope.to_a
      }
      format.api  {
        # @offset, @limit = api_offset_and_limit
        @offset = 0
        @limit = scope.count
        @project_count = scope.count
        @projects = scope.select("pm.value AS pm_id, projects.*").offset(@offset).limit(@limit).to_a
      }
      format.atom {
        projects = scope.reorder(:created_on => :desc).limit(Setting.feeds_limit.to_i).to_a
        render_feed(projects, :title => "#{Setting.app_title}: #{l(:label_project_latest)}")
      }
    end
	end
end