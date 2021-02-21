class CreateRanks < ActiveRecord::Migration[6.0]
  def change
    create_table :ranks do |t|
      t.string(:rank_code, limit: 2, unique: true, null: false)

      t.timestamps
    end
  end
end
