class MinerProjectResponse
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  attr_accessor *%i(
    is_success items total_page total_count current_page
  )

  def self.parse(response, current_page: 1)
    new.tap do |r|
      body = JSON.parse(response.body)
      header = response.headers

      r.is_success = response.success?
      r.total_page = body['total_page'].to_i if body['total_page'].present?
      r.total_count = body['total_count'].to_i if body['total_count'].present?
      r.current_page = current_page
      r.items = if body['result'].present?
                  body['result'].map { |v| HashObject.new(v) }
                else
                  []
                end
    end
  end
end
