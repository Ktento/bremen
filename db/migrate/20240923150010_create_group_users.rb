class CreateGroupUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :group_users do |t|
      t.references :user, null: false, foreign_key: true  # user_idを外部キーとして設定
      t.references :group, null: false, foreign_key: true  # group_idも外部キーとして設定

      t.timestamps
    end
    add_index :group_users, [:user_id, :group_id], unique: true
  end
end