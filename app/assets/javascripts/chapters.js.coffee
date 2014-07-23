$(document).ready ->
  setup_page()

window.components = []

my_url = $(location).attr('pathname').replace(/^\//, '')

setup_page = () ->
  SyntaxHighlighter.defaults.gutter = true
  SyntaxHighlighter.defaults['class-name'] = 'bob-code'
  SyntaxHighlighter.defaults.toolbar = false
  SyntaxHighlighter.defaults.ruler = false
  SyntaxHighlighter.all()
  $('#cookies-information-close-button').click ->
    ok_with_cookies()
  $('#toc-button').click ->
    toggle_blog_or_book()
  commentable =  '<span class="comment-button inline"><strong><i class="fi-comment-quotes"></i>'
  commentable += '(<span class="number-of-comments">0</span>)'
  commentable += '</strong></span>'
  commentable += '<div class="comments-row hide row"><div class="large-1 medium-1 columns"></div><div class="large-11 medium-11 columns comments-content">'
  commentable += '(cannot load comments)'
  commentable += '</div></div>'
  $('.commentable').append(commentable)
    
  if window.bob_view == 'book'
    $('.comment-row').hide()
  else 
    $('.comment-row').show()

  $('.comment-button').click ->
    me = $(this)
    if me.next('.comments-row').is(':visible')
      me.next('.comments-row').slideToggle(200)
    else
      # close all other comments first (actually not a good idea)
      # $('.comments-row').hide()
      $.post('/_aj/comments', 
        { chapter_url: my_url, comment_id: me.parent().attr('id') }, 
        (data) -> 
          me.next('.comments-row').find('.comments-content').html(data)
          me.next('.comments-row').slideToggle(200)
        )

  if window.bob_view == 'blog'
    show_number_of_comments()

  $('#allow-notifications').click ->
    $('#notifications_enabled').val($('#allow-notifications-switch').is('.fi-x')) # if there is X now, set it to true
    $('#allow_notifications_form').submit()

show_number_of_comments = ->
  $('.number-of-comments').each (index, element) -> 
    comment_id = $(element).parent().parent().parent().attr('id')
    $.get('/_aj/no_comments', 
      { chapter_url: my_url, comment_id: comment_id },
      (data) -> 
        $(element).html(data)
      )

hide_or_show_menu = () ->
  if window.bob_view == 'book'
    $('#toc-button').removeClass('active')
    $('#sidebar-chapters-menu').hide()
    $('#main-chapter-content').removeClass("large-9 medium-9")
    $('#main-chapter-content').addClass("large-12 medium-12")
    $('.comment-button').hide()
    $('#user-portrait-small-li').hide()
    $('#toc-button-text').text('Book View')
  else
    $('#toc-button').addClass('active')
    $('#sidebar-chapters-menu').show()
    $('#main-chapter-content').removeClass("large-12 medium-12")
    $('#main-chapter-content').addClass("large-9 medium-9")
    $('.comment-button').show()
    $('#user-portrait-small-li').show()
    $('#toc-button-text').text('Blog View')

toggle_blog_or_book = () ->
  if window.bob_view == 'book'
    window.bob_view = 'blog'
  else
    window.bob_view = 'book'
  hide_or_show_menu()
  $.post('/_aj/save_bob_view', {bob_view: window.bob_view} , 
    (data) -> 
      unless data['ok']
        alert('Can not save your view information, sorry.')
  )

ok_with_cookies = () ->
  $.post('/_aj/ok_with_cookies', true, 
    (data) -> 
      unless data['ok']
        alert('Can not save your cookie information, sorry.')
  )
