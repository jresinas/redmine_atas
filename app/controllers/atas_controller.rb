class AtasController < ApplicationController
	# skip_before_filter :check_if_login_required
	# skip_before_filter :verify_authenticity_token
	accept_api_auth :projects, :project

	def projects
		forbidden_services = ["Estructura", "Otros", "No Clasificado", "Gestión de producción", "No clasificado"]
	  @user = User.joins(:email_address).where("email_addresses.address = ?", params[:email]).first

	  if @user.present?
			scope = @user.projects.joins(:custom_values).where("custom_values.custom_field_id = ? AND custom_values.value NOT IN (?)", 102, forbidden_services)
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
        @projects = scope.offset(@offset).limit(@limit).to_a
      }
      format.atom {
        projects = scope.reorder(:created_on => :desc).limit(Setting.feeds_limit.to_i).to_a
        render_feed(projects, :title => "#{Setting.app_title}: #{l(:label_project_latest)}")
      }
    end
	end
end