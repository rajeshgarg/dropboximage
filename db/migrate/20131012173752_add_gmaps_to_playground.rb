class AddGmapsToPlayground < ActiveRecord::Migration
  def change
    add_column :images, :gmaps, :boolean
  end
end
