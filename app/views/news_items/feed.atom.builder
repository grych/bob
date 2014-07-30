atom_feed :language => 'en-US' do |feed|
  feed.title @title
  feed.updated @updated

  @news_items.each do |item|
    next if item.updated_at.blank?

    feed.entry(item) do |entry|
      entry.url chapter_url(item)
      entry.title item.title
      entry.content "New chapter in <i>#{BoB::Application.config.book_title}: \"#{item.title}\"</i>.<br>
          <a href=\"#{chapter_url(item)}\">#{chapter_url(item)}</a>" ,
          type: 'html'
      entry.updated(item.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")) 
      entry.author do |author|
        author.name BoB::Application.config.book_author
        author.email BoB::Application.config.book_author_email
      end
    end
  end
end
