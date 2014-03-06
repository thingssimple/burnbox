class AddDeleteToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :to_delete, :boolean, default: false
  end
end
