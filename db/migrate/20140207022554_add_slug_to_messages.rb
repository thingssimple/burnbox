class AddSlugToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :slug, :string, unique: true
  end
end
