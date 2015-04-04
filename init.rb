require 'redmine'

require_dependency 'redmine_issues_copier_hook'

unless Redmine::Plugin.registered_plugins.keys.include?(:redmine_issues_copier)
	Redmine::Plugin.register :redmine_issues_copier do
	  name 'Views collection'
	  author 'Alexander Kulemin'
	  description 'Plugin can help you ti create few issues for different trackers - you only check them in create or edit issues form.'
	  version '0.0.1'
	  
	  settings :default => {'tracker_for_user' => ''}, :partial => 'settings/redmine_issues_copier'

    project_module :redmine_issues_copier do
      permission :issues_coping, :issues => :coping_issue_by_trackerslist
    end	  
	  
	end
end
