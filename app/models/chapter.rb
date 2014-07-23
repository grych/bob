# == Schema Information
#
# Table name: chapters
#
#  id              :integer          not null, primary key
#  file_name       :string(1024)
#  url             :string(1024)
#  title           :string(1024)
#  chapter_id      :integer
#  chapter_no      :string(1024)
#  file_updated_at :datetime
#  created_at      :datetime
#  updated_at      :datetime
#

class BadFilenameException  < Exception; end
class FileNotFoundException < Exception; end

class Chapter < ActiveRecord::Base
  include Comparable

  validates :file_name,       presence: true, uniqueness: true
  validates :url,             presence: true, uniqueness: true
  validates :title,           presence: true
  validates :chapter_no,      presence: true, uniqueness: true
  serialize :chapter_no
  validates :file_updated_at, presence: true

  has_many :chapters
  belongs_to :chapter

  has_many :comments

  def self.recently_added(how_many)
    Chapter.where.not(id: Chapter.root).order('created_at desc').first(how_many)
  end
  def self.recently_updated(how_many)
    Chapter.where.not(id: Chapter.root).order('file_updated_at desc').first(how_many)
  end

  # reloads the chapters
  def self.reload!
    Chapter.from_dir(BoB::Application.config.chapters_path.to_s)
  end

  # title with number, depends on config
  def full_title
    if BoB::Application.config.show_chapter_no and not root?
      chapter_no.join('.') + '. ' + title
    else
      title
    end
  end

  # full path for the chapters
  def root_dir
    BoB::Application.config.chapters_path.to_s
  end

  # parent chapter id or nil if it is a root
  def parent
    self.chapter
  end
  def parent=(p)
    self.chapter = p
  end
  # am I root?
  def root?
    self.chapter_no == [0]
  end
  def descendants
    self.chapters.sort
  end
  # next chapter
  def next
    chapters = Chapter.all.sort.to_a
    i = chapters.index(self)
    chapters[i + 1]
  end 
  
  def prev
    chapters = Chapter.all.sort.to_a
    i = chapters.index(self)
    if i == 0 
      nil
    else
      chapters[i - 1]
    end
  end

  def self.first_chapter
    Chapter.root.next
  end
  def self.root
    Chapter.find_by(chapter_no: [0].to_yaml)
  end

  # reads the content of the directory and updates/creates chapters
  def self.from_dir(dir_path)
    chapters = []
    raise FileNotFoundException, "Can't find directory: #{dir_path}" unless File.exists?(dir_path) && File.directory?(dir_path)
    files = Dir[dir_path + "/*.html.erb"]
    files.each do |file|
      f = Chapter.create_from_file(file)
      chapters << f
    end
    # update the structure (find parents)
    Chapter.all.sort.each do |ch|
      ch.parent = ch.get_parent(ch.chapter_no)
      ch.save!
    end
    chapters
  end

  # create chapter from the given file
  def self.create_from_file(file_path)
    c = Chapter.from_file(file_path)
    c.save!
    c
  end

  # initialize chapter from the given file
  def self.from_file(file_path)
    raise FileNotFoundException, "Can't find file: #{file_path}" unless File.exists?(file_path) && File.readable?(file_path)
    fn = File.basename(file_path)
    c = Chapter.find_or_initialize_by(file_name: fn)
    c.file_name = fn
    c.url ||= c.urlify
    c.title = c.get_title
    c.chapter_no = c.get_chapter_no
    c.file_updated_at = File.mtime(file_path)
    c
  end

  # Starship defined for sorting the chapters by the chapter number
  def <=> other
    chapter_no <=> other.chapter_no
  end

  # Find parent chapter id
  # chapter c1 is parent for c2 :- exists such X, that c2.chapter_no == c1.chapter_no[first X elements]
  def get_parent(chapno)
    return nil if chapno == [0]
    if chapno.empty?
      # returns the root chapter
      Chapter.root
    else
      chapno = chapno[0 ... chapno.count-1] # cut one element on right
      c = Chapter.find_by(chapter_no: chapno.to_yaml)
      if c
        return c
      else
        get_parent(chapno) 
      end
    end
  end

  # Retrieves chapter number
  def get_chapter_no
    re = /(\s*\d+\s*)\./
    s = file_name.scan(re)
    raise BadFilenameException, "Can't process the file: #{file_name}" if s.empty?
    s.collect { |x| x.first.to_i }
  end

  # Gets title from file name
  def get_title
    r = %r{((\d+\.)+\s*)(?<title>(.)*)\.html\.erb}
    match = r.match(file_name)
    raise BadFilenameException, "Can't match the file: #{file_name}" unless match
    t = match[:title].strip
  end

  # Converts file name to URL
  # WORDS := NUM.[NUM.][WHITESPACE]WORDS[WHITESPACES}.html.erb
  # Ex.: "1.2. What is the Meaning of Life?.html.erb" => 'what-is-the-meaning-of-life'
  # Throws exception when can't match
  def urlify
    Chapter.urlify self.get_title
  end

  def self.urlify(t)
    # remove leading and trailing whitespaces, change all spaces to dash, and remove all non-letters, non-numbers and non-dashes
    url = t.downcase.gsub(/\s/,'-').gsub(/[^0-9a-z-]/i,'')
    # there can be the only one url (adding dash to the end in cause of duplication)
    while Chapter.find_by(url: url)
      url = url + '-'
    end
    url
  end

  # Retrieves last subchapter number
  # NUM.NUM.SUBCHAPTER_NO.[WHITESPACE]WORDS[WHITESPACES}.html.erb
  def self.subchapter_no(filename)
    r = %r{((?<subchapter>\d\.)+\s*)((.)*)\.html\.erb}
    match = r.match(filename)
    raise BadFilenameException, "Can't match the file: #{filename}" unless match
    t = match[:subchapter]
    t.to_i
  end
end
