class CreateRounds < ActiveRecord::Migration
  def self.up
    create_table :rounds do |t|
      t.datetime :start_date
      t.datetime :due_date

      t.timestamps
    end
  end

  def self.down
    drop_table :rounds
  end
end
