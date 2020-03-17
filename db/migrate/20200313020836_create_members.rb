class CreateMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :members do |t|
      t.string :mbrname
      t.string :email
      t.integer :mbrsu

      t.timestamps
    end
  end
end
