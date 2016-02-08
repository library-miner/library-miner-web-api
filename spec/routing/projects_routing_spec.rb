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

require "rails_helper"

RSpec.describe ProjectsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/projects").to route_to("projects#index")
    end

    it "routes to #new" do
      expect(:get => "/projects/new").to route_to("projects#new")
    end

    it "routes to #show" do
      expect(:get => "/projects/1").to route_to("projects#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/projects/1/edit").to route_to("projects#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/projects").to route_to("projects#create")
    end

    it "routes to #update" do
      expect(:put => "/projects/1").to route_to("projects#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/projects/1").to route_to("projects#destroy", :id => "1")
    end

  end
end
