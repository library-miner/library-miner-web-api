module Search
  class Project < Search::Base
    ATTRIBUTES = %i(
      full_name
      project_type_id
      page
      per_page
    )
    attr_accessor(*ATTRIBUTES)

    def matches
      t = ::Project.arel_table
      results = ::Project.all

      results = results.where(contains(t[:full_name], full_name)) if full_name.present?
      results = results.where(t[:project_type_id].eq(project_type_id)) if project_type_id.present?
      results = results.page(page).per(per_page)
      results
    end
  end
end
