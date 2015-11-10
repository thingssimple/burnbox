class DropSlugs < ActiveRecord::Migration
  def change
    Message.destroy_all("slug IS NOT NULL")
    remove_column :messages, :slug
  end
end
