class RecentCreatedLibrariesController < ApplicationController
  def index
    @projects = Project.recent_created_libraries

    render json: {
      total_count: @projects.count,
      results: @projects
    }
  end
end
