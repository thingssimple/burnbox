class AddFileExtensionToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :file_extension, :string, :null => true
  end
end
