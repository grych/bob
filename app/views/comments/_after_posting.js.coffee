$.post('/_aj/comments',
  { chapter_url: "<%= @chapter_url %>", comment_id: "<%= @comment_dom %>" },
  (data) ->
    $('#<%= @comment_dom %>').find('.comments-content').html(data)
  )

$.get('/_aj/no_comments', { chapter_url: "<%= @chapter_url %>", comment_id: "<%= @comment_dom %>" },
  (data) -> 
    $('#<%= @comment_dom %>').find('.number-of-comments').html(data)
  )
