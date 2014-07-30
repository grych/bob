class NewsItem
  def self.ordered
    Chapter.order("created_at desc")
  end
end
