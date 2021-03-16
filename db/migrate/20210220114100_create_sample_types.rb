class CreateSampleTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :sample_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
