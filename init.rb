Redmine::Plugin.register :redmine_atas do
  name 'Redmine-ATAS integration Plugin'
  author 'jresinas'
  description 'Integration features between Emergya Redmine and ATAS'
  version '0.0.1'
  author_url 'http://www.emergya.es'

  settings :default => { :trackers => []}, :partial => 'settings/settings'
end