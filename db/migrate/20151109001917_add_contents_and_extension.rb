class AddContentsAndExtension < ActiveRecord::Migration
  def change
    change_table :messages do |t|
      t.text :file_contents
      t.string :file_extension
    end
  end
end
