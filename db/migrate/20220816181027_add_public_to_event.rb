class AddPublicToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :public, :boolean, default: false
  end
end
