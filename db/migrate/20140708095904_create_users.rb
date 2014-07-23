class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider, limit: 64
      t.string :uid, limit: 64
      t.string :name, limit: 256
      t.string :oauth_token, limit: 256
      t.string :image_url, limit: 1024
      t.string :email, limit: 256
      t.datetime :oauth_expires_at

      t.timestamps
    end
    add_index :users, :uid
    add_index :users, :oauth_token
    add_index :users, :email
  end
end
