class CreateMissions < ActiveRecord::Migration
  def change
    create_table :missions do |t|
      t.string :name
      t.text :description
      t.integer :hours
      t.integer :xp
      t.references :user
      t.references :rank
      t.boolean :finished
      t.boolean :won
      t.timestamps
    end
    add_index :missions, :user_id
    add_index :missions, :rank_id
  end
end
