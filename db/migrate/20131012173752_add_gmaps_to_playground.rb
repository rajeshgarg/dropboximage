class AddGmapsToPlayground < ActiveRecord::Migration
  def change
    add_column :images, :gmaps, :boolean
    add_attachment :images, :picture
  end
end
