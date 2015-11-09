class RemovePaperclipFields < ActiveRecord::Migration
  def change
    remove_attachment :messages, :file
    change_table :messages do |t|
      t.text :file_contents
      t.string :file_extension
    end
  end
end
