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
    ).freeze
    attr_accessor(*ATTRIBUTES)

    def initialize(attributes = {})
      super
      self.page ||= 1
      self.per_page ||= 25
      self.dependency_projects ||= []
      self.sort ||= 'stargazers_count'
      self.order ||= 'desc'
    end

    def matches
      projects = ::Project.arel_table

      # join 条件
      # 検索条件のライブラリを全て使用しているプロジェクトを検索する
      join_condition = nil
      if dependency_projects.count > 0
        join_condition = match_to_all_dependency_library(projects, dependency_projects)
      end

      results = ::Project.joins(join_condition).all

      # Where 条件
      results = results.where(contains(projects[:full_name], full_name)) if full_name.present?
      results = results.where(projects[:project_type_id].eq(project_type_id)) if project_type_id.present?

      # 件数制限
      results = results.page(page).per(per_page)

      # sort
      results = results.order(sort + ' ' + order)
      results = results.order('github_updated_at desc')

      results
    end

    # 引数のライブラリを全て利用しているプロジェクトを取得する
    def match_to_all_dependency_library(projects, libraries)
      join_conditions = []
      libraries.each_with_index do |library, i|
        # FIXME: 暫定的に同時検索上限数をもうける
        next unless i < 10
        p_d = ::ProjectDependency.arel_table.alias(i.to_s)
        join_condition = projects
                         .join(p_d, Arel::Nodes::InnerJoin)
                         .on(p_d[:project_from_id].eq(projects[:id])
                         .and(p_d[:project_to_id].eq(library[:id])))
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
