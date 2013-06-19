module RedcarpetHelper
  MARKDOWN_OPTIONS = {
      strikethrough: true,
        autolink: true,
          superscript: true
  }

  class HTMLWithPants < Redcarpet::Render::HTML
      include Redcarpet::Render::SmartyPants
  end

  def markdown text
    renderer = Redcarpet::Markdown.new(HTMLWithPants, MARKDOWN_OPTIONS)
    renderer.render(text).html_safe
  end
end
