class ChangeAwsAccounts < ActiveRecord::Migration[5.2]
  def change
    change_column :aws_accounts, :acct_id, :string 
  end
end
