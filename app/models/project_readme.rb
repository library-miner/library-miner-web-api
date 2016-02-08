# == Schema Information
#
# Table name: project_readmes
#
#  id         :integer          not null, primary key
#  project_id :integer          not null
#  content    :text(65535)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ProjectReadme < ActiveRecord::Base
  # Relations
  belongs_to :project

  # Validations

  # Scopes

  # Delegates

  # Class Methods

  # Methods
end
