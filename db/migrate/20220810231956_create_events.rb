class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :event_name
      t.integer :user_id
      t.integer :location_id
    end
  end
end
