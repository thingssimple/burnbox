class RemoveFileUpdatedAtFromMessages < ActiveRecord::Migration
  def change
    remove_column :messages, :file_updated_at, :datetime
  end
end
