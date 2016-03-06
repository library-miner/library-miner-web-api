module Search
  class Project < Search::Base
    ATTRIBUTES = %i(
      full_name
      project_type_id
      page
      per_page
      dependency_projects
    )
    attr_accessor(*ATTRIBUTES)

    def initialize(attributes={})
      super
      self.page ||= 1
      self.per_page ||=25
      self.dependency_projects ||=[]
    end

    def matches
      projects = ::Project.arel_table
      project_dependencies = ::ProjectDependency.arel_table

      results = ::Project.all

      results = results.where(contains(projects[:full_name], full_name)) if full_name.present?
      results = results.where(projects[:project_type_id].eq(project_type_id)) if project_type_id.present?
      binding.pry
      # 依存ライブラリ
      dependency_projects.each do |d|
        join_condition = projects.join(project_dependencies, Arel::Nodes::OuterJoin)
          .on(projects[:id].eq(project_dependencies[:project_from_id]))
          .join_sources

        results = results.joins(join_condition)
        results = results.where(project_dependencies[:project_from_id].eq(d[:id]))
      end

      results = results.page(page).per(per_page)
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
