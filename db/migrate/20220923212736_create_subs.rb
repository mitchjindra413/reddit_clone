class CreateSubs < ActiveRecord::Migration[7.0]
  def change
    create_table :subs do |t|
      t.string :title, null: false, index: true, unique: true
      t.string :description
      t.references :moderator, null: false, foreign_key: {to_table: :users}
      t.timestamps
    end
  end
end
