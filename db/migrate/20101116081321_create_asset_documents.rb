class CreateAssetDocuments < ActiveRecord::Migration
  def self.up
    create_table :asset_documents do |t|
      t.string :name
      t.text :path
      t.integer :asset_id

      t.timestamps
    end
  end

  def self.down
    drop_table :asset_documents
  end
end
