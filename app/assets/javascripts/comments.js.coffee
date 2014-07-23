my_url = $(location).attr('pathname').replace(/^\//, '')
$('a[data-comment-id].reply-button').click ->
  comment_id = $(this).data('comment-id')
  comment_dom = $(this).closest('.commentable').attr('id')
  chapter_url = my_url
  $(this).hide()
  $(this).parent().find('.delete-button').hide()
  $(this).parent().find('.edit-button').hide()
  reply_box = $(this).parent().find('.reply-box')
  reply_box.slideToggle(200)
  reply_form = reply_box.find('.reply-form')
  reply_form.find('#comment_id').val(comment_id)
  reply_form.find('#comment_dom').val(comment_dom)
  reply_form.find('#chapter_url').val(chapter_url)
  reply_form.find('#edit_or_reply').val('reply')

$('a[data-comment-id].delete-button').click ->
  comment_id = $(this).data('comment-id')
  comment_dom = $(this).closest('.commentable').attr('id')
  chapter_url = my_url
  $(this).hide()
  $(this).parent().find('.reply-button').hide()
  $(this).parent().find('.edit-button').hide()
  $.ajax '_aj/delete_comment',
    data: { comment_id: comment_id, comment_dom: comment_dom, chapter_url: chapter_url }
    type: 'DELETE'

$('a[data-comment-id].edit-button').click ->
  comment_id = $(this).data('comment-id')
  comment_dom = $(this).closest('.commentable').attr('id')
  chapter_url = my_url
  $(this).hide()
  $(this).parent().find('.reply-button').hide()
  $(this).parent().find('.delete-button').hide()
  reply_box = $(this).parent().find('.reply-box')
  reply_box.slideToggle(200)
  reply_form = reply_box.find('.reply-form')
  reply_form.find('#comment_id').val(comment_id)
  reply_form.find('#comment_dom').val(comment_dom)
  reply_form.find('#chapter_url').val(chapter_url)
  reply_form.find('#edit_or_reply').val('edit')
  reply_form.find('#comment_text').val(reply_form.find('#comment_text_raw').val())
