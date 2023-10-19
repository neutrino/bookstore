class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :title
      t.integer :year_published
      t.text :authors
      t.text :description
      t.string :genre
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
