class AvailableProjectsController < ApplicationController
  def index
    @ruby_projects = Project.type_project.completed.count
    @ruby_libraries = Project.type_library.completed.count

    render json: {
      "items": [{
        project_language: 'Ruby',
        projects_count: @ruby_projects,
        library_count: @ruby_libraries
      }]
    }
  end
end
