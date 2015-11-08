class AddFileTypeToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :file_type, :string, :null => true
  end
end
