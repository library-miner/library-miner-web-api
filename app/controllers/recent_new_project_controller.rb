# 新着プロジェクト
class RecentNewProjectController < ApplicationController
  def index
    @projects = Project.recent_new_projects

    render json: @projects
  end
end
