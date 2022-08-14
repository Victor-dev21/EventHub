class AddCategoryIdToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :category_id, :string
  end
end
