class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :title
      t.text :description
      t.integer :user_email
      t.string :user_name

      t.timestamps null: false
    end
  end
end
