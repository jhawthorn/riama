require 'json'
require 'open-uri'

module Reddit
  class Post < Struct.new(:header, :comments)
  end
  class Comment
    attr_reader :data, :replies
    def initialize(data={}, replies=[])
      @data, @replies = data, replies
    end
    def to_s
      "#{body.inspect} -#{data['author']}"
    end
    # for t3 only
    def title;    data['title'];   end
    def selftext; data['selftext'];   end
    def id;       data['id'];   end
    def url;      data['url'];   end

    def body;   data['body'];   end
    def author; data['author']; end
    def ups;    data['ups'];    end
    def downs;  data['downs'];  end
    def created
      Time.at(data['created_utc'])
    end
    def permalink
      "http://www.reddit.com/r/IAmA/comments/#{data['link_id'].gsub('t3_','')}##{data['id']}"
    end
    def score
      ups.to_i - downs.to_i
    end
  end
  class RedditVisitor
    def initialize
      @depth = 0
      @author = nil
    end
    def visit o
      return visit_each(o) if o.is_a?(Array)
      kind = o['kind']
      data = o['data']
      if kind == 'more'
      elsif kind == 'Listing'
        visit_each data['children']
      elsif kind == 't3'
        @author = data['author']
        Comment.new(data)
      elsif kind == 't1'
        replies = []
        if r = data['replies']
          replies = visit(r) || []
        end
        if replies.any? || data['author'] == @author
          Comment.new(data, replies)
        end
      end
    end
    def visit_each os
      os.map{|o| visit o }.compact
    end
    def s
      "  " * @depth
    end
  end
  def self.parse_url url
    data = JSON.parse(open(url).read, max_nesting: 100)
    RedditVisitor.new.visit(data)
  end
  def self.fetch_post hash
    (post,), comments = parse_url("http://www.reddit.com/r/IAmA/comments/#{hash}/.json")
    Post.new(post, comments)
  end
end

