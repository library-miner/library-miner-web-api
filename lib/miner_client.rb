require 'dotenv'
class MinerClient
  MINER_PROJECT_EXPORT_URL = 'api/project_export'
  MINER_PROJECT_READY_URL = 'api/project_export/export_ready'
  MINER_PROJECT_END_URL = 'api/project_export/export_end'

  # Miner より Webデータ連携準備
  def import_ready(count: 100)
    path = "#{MINER_PROJECT_READY_URL}?count=#{count}"
    Rails.logger.info("MinerClient Access to #{path} - project ready")

    MinerProjectResponse.parse(get_request_to(path))
  end

  # Miner より データ取得
  def import_project(page: 1)
    path = "#{MINER_PROJECT_EXPORT_URL}?page=#{page}"
    Rails.logger.info("MinerClient Access to #{path} - project import page:" + page.to_s)

    MinerProjectResponse.parse(get_request_to(path))
  end

  # Miner に Web連携完了通知
  def import_end
    path = "#{MINER_PROJECT_END_URL}"
    Rails.logger.info("MinerClient Access to #{path} - project end")

    MinerProjectResponse.parse(get_request_to(path))
  end

  private

  def build_api_connection
    Faraday.new(url: ENV['LIBRARY_MINER_URL']) do |builder|
      builder.request :url_encoded
      builder.adapter Faraday.default_adapter
    end
  end

  def get_request_to(path, page: 1)
    conn = build_api_connection
    conn.get do |req|
      req.url path, page: page
    end
  end

end
