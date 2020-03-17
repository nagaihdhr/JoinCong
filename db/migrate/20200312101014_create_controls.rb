class CreateControls < ActiveRecord::Migration[6.0]
  def change
    create_table :controls do |t|
      t.string :congname
      t.date :curdate
      t.string :message

      t.timestamps
    end
  end
end
