class RemovePaperclipFields < ActiveRecord::Migration
  def change
    change_table :messages do |t|
      t.remove :file_file_name
      t.remove :file_content_type
      t.remove :file_file_size
      t.remove :file_updated_at
      t.text :file_contents
      t.string :file_extension
    end
  end
end
