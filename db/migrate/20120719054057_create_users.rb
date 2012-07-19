class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :name
      t.string  :password_digest
      t.integer :bankroll, :default => "2000"
      t.string  :remember_token
            
      t.timestamps
    end
    add_index  :users, :remember_token
  end
end
