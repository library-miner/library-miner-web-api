class AvailableProjectsController < ApplicationController
  def index
    @ruby_projects = Project.where(project_type_id: ProjectType::PROJECT.id).count
    @ruby_libraries = Project.where(project_type_id: ProjectType::RUBYGEM.id).count

    render json: {
      "items": [{
        project_language: "Ruby",
        projects_count: @ruby_projects,
        library_count: @ruby_libraries
      }]
    }
  end
end
