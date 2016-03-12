class RecentUpdatedLibrariesController < ApplicationController
  def index
    @projects = Project.recent_updated_libraries

    render json: {
      total_count: @projects.count,
      results: @projects
    }
  end
end
