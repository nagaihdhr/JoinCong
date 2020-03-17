class CreateAttends < ActiveRecord::Migration[6.0]
  def change
    create_table :attends do |t|
      t.references :member, null: false, foreign_key: true
      t.integer :status
      t.integer :mbrsutoday

      t.timestamps
    end
  end
end
