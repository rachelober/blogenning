class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.string :name
      t.references :user
      t.references :round
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :entries
  end
end
