class PopularLibrariesController < ApplicationController
  def index
    @projects = Project.popular_libraries

    render json: {
      total_count: @projects.count,
      results: @projects
    }
  end
end
