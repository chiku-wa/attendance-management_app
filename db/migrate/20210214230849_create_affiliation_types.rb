class CreateAffiliationTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :affiliation_types do |t|
      t.string(:affiliation_type_name, null: false, unique: true, limit: 10)

      t.timestamps
    end
  end
end
