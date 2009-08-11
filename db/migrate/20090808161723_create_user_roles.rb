class CreateUserRoles < ActiveRecord::Migration
  def self.up
    create_table :user_roles do |t|
      t.string :name
      t.integer :permissions
      t.string :color

      t.timestamps
    end
  end

  def self.down
    drop_table :user_roles
  end
end
