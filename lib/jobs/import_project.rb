class Jobs::ImportProject
  def execute(count: 10_000)
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

    [total_count, total_page]
  end

  # Project 連携
  def import_project_information(total_page)
    client = MinerClient.new
    for current_page in 1..total_page do
      response_items = client.import_project(page: current_page)
      # responseの解析と格納
      items = response_items.items
      items.each do |item|
        # project 情報取得
        project = Project.find_or_initialize_by(id: item.id)
        project.attributes = {
          is_incomplete: item.is_incomplete,
          github_item_id: item.github_item_id,
          name: item.name,
          full_name: item.full_name,
          owner_id: item.owner_id,
          owner_login_name: item.owner_login_name,
          owner_type: item.owner_type,
          github_url: item.github_url,
          is_fork: item.is_fork,
          github_description: item.github_description,
          github_created_at: item.github_created_at,
          github_updated_at: item.github_updated_at,
          github_pushed_at: item.github_pushed_at,
          homepage: item.homepage,
          size: item.size,
          stargazers_count: item.stargazers_count,
          watchers_count: item.watchers_count,
          fork_count: item.fork_count,
          open_issue_count: item.open_issue_count,
          github_score: item.github_score,
          language: item.language,
          project_type_id: item.project_type_id
        }

        # project dependency
        if item.project_dependencies.present?
          new_dependencies = []
          item.project_dependencies.each do |p_d|
            project_dependency = project.project_dependencies.build(
              project_from_id: p_d['project_from_id'].to_i,
              project_to_id: p_d['project_to_id'].to_i,
              library_name: p_d['library_name']
            )
            new_dependencies << project_dependency
          end
          project.project_dependencies.replace(new_dependencies)
        end

        # project_readme
        if item.project_readmes.present?
          new_readmes = []
          item.project_readmes.each do |p_r|
            new_readme = project.project_readmes.build(
              content: p_r['content']
            )
            new_readmes << new_readme
          end
          project.project_readmes.replace(new_readmes)
        end

        project.save!
      end
    end
  end

  # Project 連携終了
  def import_project_end
    client = MinerClient.new
    client.import_end
  end
end
