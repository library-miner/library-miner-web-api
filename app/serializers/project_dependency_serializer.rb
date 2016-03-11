class ProjectDependencySerializer < ActiveModel::Serializer
  attributes(*ProjectDependency.attribute_names.map(&:to_sym))
end
