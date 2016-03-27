class RemoveResetFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :reset_at
  end
end
