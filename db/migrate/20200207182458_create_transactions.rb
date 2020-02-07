class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.string :kind
      t.string :title
      t.decimal :value
      t.string :group

      t.timestamps
    end
  end
end
