class ProjectReadmeSerializer < ActiveModel::Serializer
  attributes :id, :project_id, :content
  def content
    MarkdownParser.markdown(object.content)
  end
end
