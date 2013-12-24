class CreateRabbits < ActiveRecord::Migration
  def up
    create_table :rabbits do |r|
      r.string :name, :required => true
      r.text :description
      r.integer :age
      r.string :color
      r.timestamps
    end
  end

  def down
    drop_table :rabbits
  end
end
