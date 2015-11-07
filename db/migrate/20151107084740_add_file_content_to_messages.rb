class AddFileContentToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :file_content, :text, :null => true
  end
end
