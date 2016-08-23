class CreateDb < ActiveRecord::Migration
  def up
    drop_table :chats
    drop_table :badwords
    create_table :chats do |t|
  	  t.string :bot_id
      t.string :group_id
      t.string :admin_username
    end
    create_table :badwords do |t|
      t.string :group_id
      t.string :word
    end
  end
  def down
    drop_table :chats
    drop_table :badwords
    create_table :chats do |t|
  	  t.integer :bot_id
      t.integer :group_id
      t.string :admin_username
    end
    create_table :badwords do |t|
      t.integer :group_id
      t.string :word
    end
  end
end