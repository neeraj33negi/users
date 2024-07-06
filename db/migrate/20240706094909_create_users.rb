class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, index: true, unique: true
      t.json :campaigns_list
      t.timestamp :deleted_at, index: true

      t.timestamps
    end
  end
end
