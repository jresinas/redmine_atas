RedmineApp::Application.routes.draw do
  get 'atas/projects' => 'atas#projects'
  match '/settings/get_project_services' => 'settings#get_project_services', :via => [:get, :post]
end
