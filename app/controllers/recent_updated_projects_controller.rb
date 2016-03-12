class RecentUpdatedProjectsController < ApplicationController
  def index
    @projects = Project.recent_updated_projects

    render json: {
      total_count: @projects.count,
      results: @projects
    }
  end
end
