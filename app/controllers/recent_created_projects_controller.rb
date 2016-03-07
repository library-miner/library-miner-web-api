# 新着プロジェクト
class RecentCreatedProjectsController < ApplicationController
  def index
    @projects = Project.recent_new_projects

    render json: {
      total_count: @projects.count,
      results: @projects
    }
  end
end
