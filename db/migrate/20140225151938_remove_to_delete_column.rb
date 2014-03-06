class RemoveToDeleteColumn < ActiveRecord::Migration
  def change
    remove_column :messages, :to_delete
  end
end
