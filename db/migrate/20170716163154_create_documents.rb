class CreateDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :documents do |t|
      t.string :doc_name
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
