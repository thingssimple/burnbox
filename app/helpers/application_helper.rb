module ApplicationHelper
  def markdown(text)
    if text
      renderer = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: true)
      markdown = Redcarpet::Markdown.new(renderer, autolink: true, space_after_headers: true, no_intra_emphasis: true, fenced_code_blocks: true)
      markdown.render(text)
    else
      ""
    end
  end
end
