module Search
  class Project < Search::Base
    ATTRIBUTES = %i(
      full_name
      project_type_id
      page
      per_page
      dependency_project_ids
      sort
      order
    ).freeze
    attr_accessor(*ATTRIBUTES)

    def initialize(attributes = {})
      super
      self.page ||= 1
      self.per_page ||= 25
      if dependency_project_ids.present?
        self.dependency_project_ids = dependency_project_ids.split(",")
      end
      self.dependency_project_ids ||= []
      self.sort ||= 'stargazers_count'
      self.order ||= 'desc'
    end

    def matches
      project = ::Project.arel_table

      # join 条件
      # 検索条件のライブラリを全て使用しているプロジェクトを検索する
      join_condition = nil
      if dependency_project_ids.present?
        join_condition = match_to_all_dependency_library(project, dependency_project_ids)
      end

      results = ::Project.joins(join_condition).all

      # Where 条件
      results = results.where(contains(project[:full_name], full_name)) if full_name.present?
      results = results.where(project[:project_type_id].eq(project_type_id)) if project_type_id.present?

      # 件数制限
      results = results.page(page).per(per_page)

      # sort
      results = results.order(sort + ' ' + order)
      results = results.order('github_updated_at desc')

      results
    end

    # 引数のライブラリを全て利用しているプロジェクトを取得する
    def match_to_all_dependency_library(project, library_ids)
      join_conditions = []

      # FIXME: 暫定的に同時検索上限数をもうける
      dependency_project_limit = 10

      library_ids.take(dependency_project_limit).each do |library_id|
        p_d = ::ProjectDependency.arel_table.alias("project_#{library_id}")
        join_condition = project
                         .join(p_d, Arel::Nodes::InnerJoin)
                         .on(p_d[:project_from_id].eq(project[:id])
                         .and(p_d[:project_to_id].eq(library_id)))
                         .join_sources
        join_conditions.push(join_condition)
      end

      join_conditions
    end

    def total_page(total_count)
      total_page = 0
      if total_count > 0
        total_page = 1 + (total_count / per_page.to_i).to_i
      end
      total_page
    end
  end
end
