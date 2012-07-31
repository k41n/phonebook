class CreatePhoneNumbers < ActiveRecord::Migration
  def change
    create_table :phone_numbers do |t|
      t.string :number, limit: 20
      t.references :person
      t.timestamps
    end
  end
end
