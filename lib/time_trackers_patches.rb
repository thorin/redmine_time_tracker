# use require_dependency if you plan to utilize development mode
require 'application_helper'

module TimeTrackers
  module Patches
    module ApplicationHelperPatch
      def self.included(base) # :nodoc:
        base.class_eval do
          unloadable

          def menu_refresh_rate
            refresh_rate = Setting.plugin_redmine_time_tracker['refresh_rate'].to_i
            [refresh_rate == 0 ? 60 : refresh_rate, 5].max
          end

          def time_tracker_for(user)
            TimeTracker.find(:first, :conditions => { :user_id => user.id })
          end
  
          def status_from_id(status_id)
            IssueStatus.find(:first, :conditions => { :id => status_id })
          end
  
          def statuses_list()
            IssueStatus.find(:all)
          end
  
          def to_status_options(statuses)
            options_from_collection_for_select(statuses, 'id', 'name')
          end
  
          def new_transition_from_options(transitions)
            statuses = []
            for status in statuses_list()
              if !transitions.has_key?(status.id.to_s)
                statuses << status
              end
            end
            to_status_options(statuses)
          end
        
          def new_transition_to_options()
            to_status_options(statuses_list())
          end
        
          def global_allowed_to?(user, action)
            return false if user.nil?
            
            projects = Project.find(:all)
            for p in projects
                if user.allowed_to?(action, p)
              return true
                end
            end
            
            return false
          end

        end
      end
    end
  end
end

unless ApplicationHelper.included_modules.include? TimeTrackers::Patches::ApplicationHelperPatch
  ApplicationHelper.send(:include, TimeTrackers::Patches::ApplicationHelperPatch)
end