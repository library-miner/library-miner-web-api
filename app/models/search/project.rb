module Search
  class Project < Search::Base
    ATTRIBUTES = %i(
      full_name
      project_type_id
      page
      per_page
      dependency_projects
      sort
      order
    )
    attr_accessor(*ATTRIBUTES)

    def initialize(attributes={})
      super
      self.page ||= 1
      self.per_page ||=25
      self.dependency_projects ||=[]
      self.sort ||= "stargazers_count"
      self.order ||= "desc"
    end

    def matches
      projects = ::Project.arel_table
      results = ::Project.all

      results = results.where(contains(projects[:full_name], full_name)) if full_name.present?
      results = results.where(projects[:project_type_id].eq(project_type_id)) if project_type_id.present?

      # 検索条件のライブラリを全て使用しているプロジェクトを検索する
      if dependency_projects.count > 0
        target_projects = match_to_all_dependency_library(dependency_projects)
        results = results.where(projects[:id].in(target_projects))
      end

      results = results.page(page).per(per_page)

      # sort
      results = results.order(sort + " " + order)
      results = results.order("github_updated_at desc")

      results
    end

    # 引数のライブラリを全て利用しているプロジェクトを取得する
    def match_to_all_dependency_library(libraries)
      projects = []

      # 候補を探す
      libraries.each do |library|
        p = ProjectDependency
          .where(project_to_id: library[:id])
          .distinct
          .pluck(:project_from_id)
        projects.push(p.to_a)
      end

      # 全ての条件に合致するプロジェクトを抽出する
      results = []
      first = true
      projects.each do |project|
        if first
          results = project
          first = false
        else
          results = results & project
        end
      end

      results
    end

    def total_page(total_count)
      total_page = 0
      if total_count > 0
        total_page = 1 + (total_count / per_page).to_i
      end
      total_page
    end

  end
end
