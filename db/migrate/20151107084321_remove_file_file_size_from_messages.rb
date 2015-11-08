class RemoveFileFileSizeFromMessages < ActiveRecord::Migration
  def change
    remove_column :messages, :file_file_size, :integer
  end
end
