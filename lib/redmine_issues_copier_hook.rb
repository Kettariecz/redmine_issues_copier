class RedmineIssuesCopierHook < Redmine::Hook::ViewListener
  include ApplicationHelper

  #Добавляем выбор трекеров в форму создания и редактирования задачи
  render_on :view_issues_form_details_bottom, :partial => "trackers_for_copy" 

  #После сохранения новой задачи необходимо создать ее копии в указанных трекерах
  #Для работы с новой и измененной задачей используются разные хуки. 
  def controller_issues_new_after_save(context={ })
    coping_issue_by_userslist(context[:issue], context[:params][:user_tr_copylist]) if !context[:params][:user_tr_copylist].nil?    
  end
  
  #После сохранения измененной задачи необходимо создать ее копии в указанных трекерахg6
  def controller_issues_edit_after_save(context={ })
    coping_issue_by_userslist(context[:issue], context[:params][:user_tr_copylist]) if !context[:params][:user_tr_copylist].nil?    
  end
  
  private
  
  #Процедура копирует указанную задачу в один или несколько указанных трекеров
  def coping_issue_by_trackerslist(issue, list)
    list.each { |tracker_id|
#      new_copy = issue.copy()              #копируем задачу
      new_copy = Issue.new.copy_from(issue) #копируем задачу
      new_copy.tracker_id=tracker_id  #меняем трекер
      new_copy.assigned_to_id = (Setting.plugin_redmine_issues_copier['user_for_tracker'][tracker_id.to_s].nil? ? nil : Setting.plugin_redmine_issues_copier['user_for_tracker'][tracker_id.to_s])
      new_copy.custom_field_values = issue.custom_field_values.inject({}) {|h,v| h[v.custom_field_id] = v.value; h}
      new_copy.save                   #сохраняем
    } 
  end

  #Процедура копирует указанную задачу в один или несколько указанных трекеров, на основании выбранных пользователей.
  def coping_issue_by_userslist(issue, list)
    list.each { |user_id|
      if user_id.to_i > 0 then 
        new_copy = Issue.new.copy_from(issue) #копируем задачу
        new_copy.assigned_to_id = user_id.to_i
        if Setting.plugin_redmine_issues_copier['tracker_for_user'][user_id.to_s].nil? == false then
          new_copy.tracker_id=  Setting.plugin_redmine_issues_copier['tracker_for_user'][user_id.to_s]
        end  
        new_copy.custom_field_values = issue.custom_field_values.inject({}) {|h,v| h[v.custom_field_id] = v.value; h}
        new_copy.save                   #сохраняем
      end
    } 
  end

end
