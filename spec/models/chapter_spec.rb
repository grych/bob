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

require 'spec_helper'

describe Chapter do
  describe '.urlify and .chapter_no' do
    before :each do
      @names_and_urls = [
        ['1.2. What is the Meaning of Life?.html.erb',     'what-is-the-meaning-of-life', [1,2], 'What is the Meaning of Life?'],
        ['1.What is the Meaning of Life? .html.erb',       'what-is-the-meaning-of-life', [1], 'What is the Meaning of Life?'],
        ['1.3.4. What is the meaning of Life???.html.erb', 'what-is-the-meaning-of-life', [1,3,4], 'What is the meaning of Life???']
      ]
      @chapter = Chapter.new
    end
    it 'should generate proper url from file name' do
      @names_and_urls.each do |name, url|
        @chapter.file_name = name
        @chapter.urlify.should eq url
      end
    end
    it 'should raise an exception when the title does not match' do
      expect { @chapter.file_name = '1.2. What is the meaning of Life?'; @chapter.urlify }.to raise_error(BadFilenameException)
      expect { @chapter.file_name = 'What is the meaning of Life?.html.erb'; @chapter.urlify }.to raise_error(BadFilenameException)
    end
    it 'should get the proper chapter no' do
      @names_and_urls.each do |name, _, number|
        @chapter.file_name = name
        @chapter.get_chapter_no.should eq number
      end
    end
    it 'should raise an exception when the title does not match' do
      expect { @chapter.file_name = 'What is the meaning of Life?.html.erb'; @chapter.get_chapter_no }.to raise_error(BadFilenameException)
    end
    it 'should generate the proper file name' do
      @names_and_urls.each do |name, _, _, title|
        @chapter.file_name = name
        @chapter.get_title.should eq title
      end
    end
  end
  describe 'from file' do
    describe 'initialized with non existing file' do
      it 'should raise an exception' do
        expect { Chapter.from_file('/non/existent') }.to raise_error(FileNotFoundException)
      end
    end
    describe 'should initialize valid chapter from file' do
      before :each do
        @file_path = Rails.root.join('spec','fixtures','files', 'chapters', '1.2.3. Test chapter? Yes! .html.erb')
        @chapter = Chapter.from_file(File.open(@file_path))
      end
      subject { @chapter }
      it { should be_valid }
      its(:file_name)       { should eq File.basename(@file_path) }
      its(:chapter_no)      { should eq [1,2,3] }
      its(:url)             { should eq 'test-chapter-yes' }
      its(:title)           { should eq 'Test chapter? Yes!' }
      its(:file_updated_at) { should eq File.mtime(@file_path) }
      describe "should not allow to create new chapter" do
        before :each do
          @chapter.save!
        end
        it "from the same file" do
          c = Chapter.create_from_file(File.open(@file_path))
          c.should be_valid 
          Chapter.count.should eq 1
        end
      end 
    end
  end
  describe 'from directory' do
    describe 'initialized with non-exestent directory' do
      it 'should raise an exception' do
        expect { Chapter.from_dir('/non/existent') }.to raise_error(FileNotFoundException)
      end
    end
    describe 'should have' do
      before :each do 
        #Chapter.create(file_name: 'root chapter', title: 'Intruduction', url: '/', chapter_no: [0], chapter_id: nil, file_updated_at: Time.now)
        @chapters = Chapter.from_dir(Rails.root.join('spec','fixtures','files', 'chapters').to_s) 
      end
      it '7 DB entries' do        
        @chapters.count.should eq 7
        Chapter.count.should eq 7
      end
      it 'well sorted entries' do
        Chapter.all.sort[-1].chapter_no.should eq [20]
        Chapter.all.sort.collect{|x| x.chapter_no}.should eq [[0], [1], [1, 2], [1, 2, 3], [2], [3], [20]]
      end
      it 'proper parents' do
        Chapter.find_by(chapter_no: [1, 2].to_yaml).parent.should eq Chapter.find_by(chapter_no: [1].to_yaml)
        Chapter.find_by(chapter_no: [1, 2, 3].to_yaml).parent.should eq Chapter.find_by(chapter_no: [1, 2].to_yaml)
        Chapter.find_by(chapter_no: [1].to_yaml).parent.should eq Chapter.find_by(chapter_no: [0].to_yaml)
        Chapter.find_by(chapter_no: [2].to_yaml).parent.should eq Chapter.find_by(chapter_no: [0].to_yaml)
        Chapter.find_by(chapter_no: [3].to_yaml).parent.should eq Chapter.find_by(chapter_no: [0].to_yaml)
        Chapter.find_by(chapter_no: [20].to_yaml).parent.should eq Chapter.find_by(chapter_no: [0].to_yaml)
        Chapter.find_by(chapter_no: [0].to_yaml).parent.should eq nil
      end
      it 'proper next and prev' do
        Chapter.find_by(chapter_no: [0].to_yaml).prev.should eq nil
        Chapter.find_by(chapter_no: [0].to_yaml).next.should eq Chapter.find_by(chapter_no: [1].to_yaml)
        Chapter.find_by(chapter_no: [1].to_yaml).prev.should eq Chapter.find_by(chapter_no: [0].to_yaml)
        Chapter.find_by(chapter_no: [1].to_yaml).next.should eq Chapter.find_by(chapter_no: [1,2].to_yaml)
        Chapter.find_by(chapter_no: [1,2].to_yaml).prev.should eq Chapter.find_by(chapter_no: [1].to_yaml)
        Chapter.find_by(chapter_no: [1,2].to_yaml).next.should eq Chapter.find_by(chapter_no: [1,2,3].to_yaml)
        Chapter.find_by(chapter_no: [1,2,3].to_yaml).prev.should eq Chapter.find_by(chapter_no: [1,2].to_yaml)
        Chapter.find_by(chapter_no: [1,2,3].to_yaml).next.should eq Chapter.find_by(chapter_no: [2].to_yaml)
        Chapter.find_by(chapter_no: [2].to_yaml).prev.should eq Chapter.find_by(chapter_no: [1,2,3].to_yaml)
        Chapter.find_by(chapter_no: [2].to_yaml).next.should eq Chapter.find_by(chapter_no: [3].to_yaml)
        Chapter.find_by(chapter_no: [3].to_yaml).prev.should eq Chapter.find_by(chapter_no: [2].to_yaml)
        Chapter.find_by(chapter_no: [3].to_yaml).next.should eq Chapter.find_by(chapter_no: [20].to_yaml)
        Chapter.find_by(chapter_no: [20].to_yaml).prev.should eq Chapter.find_by(chapter_no: [3].to_yaml)
        Chapter.find_by(chapter_no: [20].to_yaml).next.should eq nil
      end
      it 'proper first' do
        Chapter.first_chapter.should eq Chapter.find_by(chapter_no: [1].to_yaml)
      end
    end
  end
end
