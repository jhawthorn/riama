
class AmaController < ApplicationController
  def index
    @sort = params[:sort] || 'hot'
    url = case @sort
          when 'new'
            "http://www.reddit.com/r/IAmA/new.json?limit=100"
          when 'top'
            "http://www.reddit.com/r/IAmA/top.json?limit=100&sort=top&t=all"
          else
            "http://www.reddit.com/r/IAmA/.json?limit=100"
          end
    @posts = Reddit.parse_url(url)
  end

  def show
    @post = Reddit.fetch_post(params[:id])
    @author = @post.header.author
  end
end
