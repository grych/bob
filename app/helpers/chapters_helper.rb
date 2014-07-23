module ChaptersHelper
  def chapter_path(chapter)
    chapter.url
  end

  def check_session_view
    session['view'] ||= BoB::Application.config.default_view
  end

  def blog?
    check_session_view
    session['view'] == :blog
  end

  def book?
    check_session_view
    session['view'] == :book
  end

  # includes the code, as found if code/filename
  # options: 
  #  filename: name of the file in rails_root/code/
  #  brush: :ruby, :js, :shell etc
  #  highlight_lines: line numbers to highlight (number or array of numbers)
  def bob_code(options={}, &block)
    # if the only string is give, it must be filename by default
    if options.is_a? String
      f = options
      options = {}
      options[:filename] = f 
    end
    if block_given?
      code = capture(&block)
      options[:brush] ||= :plain
    else
      unless options[:brush]
        # determine the brush from the filename
        if options[:filename]
          options[:brush] = case File.extname(options[:filename]).downcase
          when '.rb'
            :ruby
          when '.sh', '.ksh', '.csh'
            :shell
          when '.as3'
            :as3
          when '.cf'
            :cf
          when '.c#'
            :csharp
          when '.cpp', '.c'
            :cpp
          when '.css'
            :css
          when '.pas'
            :pascal
          when '.diff'
            :diff
          when '.erl'
            :elang
          when '.js'
            :javascript
          when '.java'
            :java
          when '.pl'
            :perl
          when '.php', '.php3'
            :php
          when '.txt'
            :plain
          when '.ps'
            :powershell
          when '.py', '.jy'
            :python
          when '.scala'
            :scala
          when '.sql'
            :sql
          when '.vb', '.vbs'
            :vb
          when '.xml', '.xhtml', '.xslt', '.html', '.xhtml'
            :xml
          else 
            :plain # default value
          end
        end
      end
      code = raw File.read(Rails.root.join('code', options[:filename]))
    end
    s = raw "<pre class=\"brush: #{options[:brush]}; highlight: #{options[:highlight_lines]}\">"
    s += code
    s += raw '</pre>'
  end

  # generates link to chapter
  # chapter_no can be:
  #   :first
  # title - if not given, it will be a chapter title as in database
  def bob_link_to_chapter chapter_no, title=nil
    chapter = case chapter_no
      when Symbol
        case chapter_no
        when :first
          Chapter.first_chapter
        when :next
          @chapter.next
        end
      when Array 
        Chapter.find_by(chapter_no: chapter_no.to_yaml)
      when String
        Chapter.find_by(title: chapter_no)
      end
    raise "I don't know how to link to chapter number: '#{chapter_no}'' '#{title}'" unless chapter
    link_to title || Chapter.first_chapter.title, chapter
  end

  # generates link_to
  def bob_link_to url
    link_to(url, url, target: "_blank")
  end

  # Generates new_arrivals list
  # the number of last added chapters
  #    no_chapters - max number of chapters to generate
  def bob_new_arrivals(no_chapters)
    render partial: 'chapters/new_arrivals', locals: {
      recently_added: Chapter.recently_added(no_chapters), recently_updated: Chapter.recently_updated(no_chapters), no_chapters: no_chapters
    }
  end

  def last_read
    session[:last_read]
  end

  def bob_view
    session[:view]
  end

  def set_bob_view(view)
    session[:view] = view
  end

  def bob_last_read
    render partial: 'chapters/last_read', locals: {last_read: last_read} if last_read
  end

  # Header <h5>
  def bob_header(header)
    raw "<br><a name='#{Chapter.urlify(header)}'></a><h5 class=''>#{header}</h5>"
  end

  # Spans. Divides current paragraph into two spans. Usage
  # <%= bob_left_span %>
  #   html in the left span
  # <%= bob_right_span %>
  #   html to put in the right span
  # <%= bob_end_spans %>
  def bob_left_span
    raw '<div class="row">' \
        '  <div class="large-8 medium-6 small-12 columns">'
  end
  def bob_right_span
    raw '  </div>' \
        '  <div class="large-4 medium-6 small-0 columns bob-additional">'
  end
  def bob_end_spans
    raw '  </div>' \
        '</div>'
  end

  # def bob_comment
  #   render partial: 'chapters/comments'
  # end
end
