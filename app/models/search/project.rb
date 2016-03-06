module Search
  class Project < Search::Base
    ATTRIBUTES = %i(
      full_name
      project_type_id
      page
      per_page
    )
    attr_accessor(*ATTRIBUTES)

    def initialize(attributes={})
      super
      self.page ||= 1
      self.per_page ||=25
    end

    def matches
      t = ::Project.arel_table
      results = ::Project.all

      results = results.where(contains(t[:full_name], full_name)) if full_name.present?
      results = results.where(t[:project_type_id].eq(project_type_id)) if project_type_id.present?
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
