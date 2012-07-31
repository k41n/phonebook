class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name, limit: 100
      t.timestamps
    end
  end
end
