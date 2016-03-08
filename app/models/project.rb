# == Schema Information
#
# Table name: projects
#
#  id                 :integer          not null, primary key
#  is_incomplete      :boolean          default(TRUE), not null
#  github_item_id     :integer
#  name               :string(255)      not null
#  full_name          :string(255)
#  owner_id           :integer
#  owner_login_name   :string(255)      default(""), not null
#  owner_type         :string(30)       default(""), not null
#  github_url         :string(255)
#  is_fork            :boolean          default(FALSE), not null
#  github_description :text(65535)
#  github_created_at  :datetime
#  github_updated_at  :datetime
#  github_pushed_at   :datetime
#  homepage           :text(65535)
#  size               :integer          default(0), not null
#  stargazers_count   :integer          default(0), not null
#  watchers_count     :integer          default(0), not null
#  fork_count         :integer          default(0), not null
#  open_issue_count   :integer          default(0), not null
#  github_score       :string(255)      default(""), not null
#  language           :string(255)      default(""), not null
#  project_type_id    :integer          default(0), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Project < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  # Relations
  belongs_to_active_hash :project_type
  has_many :project_dependencies, foreign_key: :project_from_id, dependent: :destroy
  has_many :projects, through: :project_dependencies, source: :project_to
  has_many :project_readmes, dependent: :destroy

  # Scopes
  scope :incompleted, -> do
    where(is_incomplete: true)
  end

  scope :completed, -> do
    where(is_incomplete: false)
  end

  # 新着プロジェクト一覧
  # プロジェクト情報は完全なもののみ表示する
  def self.recent_new_projects
    Project.completed.limit(10).order(github_updated_at: :desc)
  end
end
