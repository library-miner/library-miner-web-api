module Search
  class Project < Search::Base
    ATTRIBUTES = %i(
      full_name
      project_type_id
      page
      per_page
      dependency_project_ids
      using_project_id
      sort
    ).freeze
    attr_accessor(*ATTRIBUTES)

    SORTABLE_ATTRIBUTES = %i(
      id
      github_updated_at
      stargazers_count
    )

    def initialize(attributes = {})
      super
      self.page ||= 1
      self.per_page ||= 25
      if dependency_project_ids.present?
        self.dependency_project_ids = dependency_project_ids.split(",")
      end
      self.dependency_project_ids ||= []
      self.sort ||= 'stargazers_count desc'
      self.sort = filter_sort_params(self.sort)
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
      results = results.project_using_projects(using_project_id) if using_project_id.present?
      # 名前がスペース区切りで複数きた場合はAND検索とする
      if full_name.present?
        # 全角除去
        names = full_name.gsub('　',' ')
        # 半角スペースで区切る
        names = full_name.split(/\s+/)
        names.each do |n|
          results = results.where(contains(project[:full_name], n))
        end
      end
      results = results.where(project[:project_type_id].eq(project_type_id)) if project_type_id.present?
      results = results.completed

      # 件数制限
      results = results.page(page).per(per_page)

      # sort
      results = results.order(::Project.send(:sanitize_sql, sort)) if sort.present?
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

    private

    def filter_sort_params(sort)
      column, ascdesc = sort.split(" ")
      ascdesc ||= "desc"
      if SORTABLE_ATTRIBUTES.any? { |v| v.to_s == column }
        "#{column} #{ascdesc}"
      else
        ""
      end
    end

    # 名前についてスペース区切りで複数の場合はAND検索
    def search_condition_full_name(results, full_name)
      results = results.where(contains(project[:full_name], full_name)) if full_name.present?
    end
  end
end
