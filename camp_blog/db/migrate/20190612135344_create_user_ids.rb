class CreateUserIds < ActiveRecord::Migration[5.2]
  def change
    create_table :user_ids do |t|
      t.string :email
      t.string :password

      t.timestamps
    end
  end
end
