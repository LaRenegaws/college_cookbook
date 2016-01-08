class ChangeUserEmailType < ActiveRecord::Migration
  def self.up
    change_column :recipes, :user_email, :string
  end
 
  def self.down
    change_column :recipes, :user_email, :integer
  end
end
