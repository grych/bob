class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :comment_id
      t.integer :chapter_id
      t.string  :comment_dom, limit: 255
      t.text    :text
      t.timestamps
    end
    add_index :comments, :user_id
    add_index :comments, :comment_id
    add_index :comments, :chapter_id
    add_index :comments, :comment_dom
    add_index :comments, [:chapter_id, :comment_dom]
    add_index :comments, [:user_id, :chapter_id, :comment_dom]
  end
end
