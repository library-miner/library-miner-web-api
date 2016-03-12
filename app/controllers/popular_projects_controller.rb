class PopularProjectsController < ApplicationController
  def index
    @projects = Project.popular_projects

    render json: {
      total_count: @projects.count,
      results: @projects
    }
  end
end
