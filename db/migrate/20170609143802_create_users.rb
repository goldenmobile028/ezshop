class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password
      t.string :encrypted_password
      t.integer :user_type
      t.string :social
      t.string :auth_token
      t.string :password_token

      t.timestamps
    end
  end
end
