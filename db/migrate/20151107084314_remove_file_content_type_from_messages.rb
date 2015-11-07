class RemoveFileContentTypeFromMessages < ActiveRecord::Migration
  def change
    remove_column :messages, :file_content_type, :string
  end
end
