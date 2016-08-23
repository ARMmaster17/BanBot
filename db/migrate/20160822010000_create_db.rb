class CreateDb < ActiveRecord::Migration
  def up
    create_table :chats do |t|
  	  t.integer :bot_id
      t.integer :group_id
      t.string :admin_username
    end
    create_table :badwords do |t|
      t.integer :group_id
      t.string :word
    end
    create_table :users do |t|
      t.string :username
      t.string :hashed_password
      t.string :followed_groups
      t.string :user_token
    end
  end
  def down
    drop_table :chats
    drop_table :badwords
    drop_table :users
  end
end
