class Jobs::ImportProject
  def self.execute(count: 10000)
    Rails.logger.info('Import Project Start')

    # Project 連携準備
    total_count, total_page = import_project_ready(count)
    Rails.logger.info(
      'Import Project total_count:' + total_count.to_s \
      + ', total_page:' + total_page.to_s)

    # Project 連携開始
    import_project_information(total_page)
    # Project 連携完了
    import_project_end

    Rails.logger.info('Import Project End')
  end

  private

  # Project 連携準備
  def import_project_ready(count)
    client = MinerClient.new
    response = client.import_ready(count: count)
    total_count = response.total_count.to_i
    total_page = response.total_page.to_i

    [total_count,total_page]
  end

  # Project 連携
  def import_project_information(total_page)
    client = MinerClient.new
   for current_page in 1..total_page do
      response_items = client.import_project(page: current_page)
      # responseの解析と格納
    end
  end

  # Project 連携終了
  def import_project_end
    client = MinerClient.new
    client.import_end
  end
end
