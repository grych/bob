class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.string :file_name, limit: 1024
      t.string :url, limit: 1024
      t.string :title, limit: 1024
      t.integer :chapter_id
      t.string :chapter_no, limit: 1024
      t.datetime :file_updated_at
      t.timestamps
    end
    add_index :chapters, :url, unique: true
    add_index :chapters, :chapter_no, unique: true
    add_index :chapters, :chapter_id
    add_index :chapters, :file_updated_at
  end
end
