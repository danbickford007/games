class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :players
      t.integer :score

      t.timestamps
    end
  end
end
