class CreateCaberRelations < ActiveRecord::Migration[7.2]
  def change
    create_table :caber_relations do |t|
      t.references :subject, polymorphic: true, null: true
      t.string :permission
      t.references :object, polymorphic: true, null: false

      t.timestamps
    end
  end
end
