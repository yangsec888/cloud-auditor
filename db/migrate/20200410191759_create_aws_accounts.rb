class CreateAwsAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :aws_accounts do |t|
      t.integer :acct_id
      t.string :name
      t.string :desc
      t.string :bus_unit
      t.string :contact
      t.datetime :audit_time

      t.timestamps
    end
  end
end
