class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      # t.string :email
      t.string :phone
      # t.string :password_digest
      # t.string :remember_digest
      t.integer :role, null: false, default: 0
      # t.string :activation_digest
      # t.boolean :actived, null: false, default: false
      # t.datetime :actived_at

      t.timestamps
    end
  end
end
