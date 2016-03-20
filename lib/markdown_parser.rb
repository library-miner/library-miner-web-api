class MarkdownParser
  def self.markdown(text)
    if text.present?
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)

      markdown.render(text).html_safe
    end
  end
end
