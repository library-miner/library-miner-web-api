create_table 'projects', collate: 'utf8_bin', comment: 'プロジェクト基本情報' do |t|
  t.int :id, comment: 'Id', primary_key: true, extra: :auto_increment

  t.boolean :is_incomplete, default: true, comment: "不完全フラグ"
  t.bigint :github_item_id, comment: 'Github Item ID', null: true
  t.varchar :name
  t.varchar :full_name, null: true
  t.bigint :owner_id, null: true
  t.varchar :owner_login_name, default: ""
  t.varchar :owner_type, limit: 30, default: ""
  t.varchar :github_url, null: true
  t.boolean :is_fork, default: false
  t.text :github_description, null: true
  t.datetime :github_created_at, null: true
  t.datetime :github_updated_at, null: true
  t.datetime :github_pushed_at, null: true
  t.text :homepage, null: true
  t.bigint :size, default: 0
  t.bigint :stargazers_count, default: 0, comment: 'スター数'
  t.bigint :watchers_count, default: 0, comment: 'ウォッチャー数'
  t.bigint :fork_count, default: 0, comment: 'フォーク数'
  t.bigint :open_issue_count, default: 0, comment: 'イシュー数'
  t.varchar :github_score, default: '', comment: 'Github上のスコア'
  t.varchar :language, default: ''
  t.int :project_type_id, default: 0, comment: '外部ライブラリかどうか判定用'

  t.datetime :created_at
  t.datetime :updated_at

  t.index :github_item_id, unique: true
  t.index :full_name, unique: false
end


