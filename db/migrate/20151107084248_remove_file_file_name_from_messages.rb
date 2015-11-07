class RemoveFileFileNameFromMessages < ActiveRecord::Migration
  def change
    remove_column :messages, :file_file_name, :string
  end
end
