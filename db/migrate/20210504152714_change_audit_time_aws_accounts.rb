class ChangeAuditTimeAwsAccounts < ActiveRecord::Migration[5.2]
  def change
    rename_column :aws_accounts, :audit_time, :scout_audit_time
    add_column :aws_accounts, :prow_audit_time, :datetime

  end
end
