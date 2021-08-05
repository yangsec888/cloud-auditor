#--
# cloud-auditor
#
# A  Ruby application for enterprise cloud security audit
#
# Developed by Sam Li, <yang.li@owasp.org>. 2020-2021
#
#++

require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper
require 'yaml'
require 'sequel'

# Update Scout report data.
# Assumptions: a) aws.ymal definition for aws account; b) aws configure profile setup complete
namespace :scout do
  desc "Refresh Scout Suites AWS Reports task"
  task :refresh_aws, [:aws_name] => :environment do |task, args|
    puts banner
    puts "Refresh AWS report data on #{args.aws_name}..."
    scout_root = Rails.root.join("./../","ScoutSuite")
    aws_yml = Rails.root.join('config','aws.yml')
    aws_conf = YAML.load(File.read(aws_yml))[::Rails.env] || 'development'
    rpt_root = "/cloud-auditor/private/aws_scout/"
    rpt_dir = rpt_root + aws_conf[args.aws_name]["acct_id"].to_s
#    cmd = "ulimit -n 1024; cd #{scout_root.to_s}; python scout.py aws -p " + args.aws_name + \
#      " --report-name aws-auditor --report-dir " + rpt_dir + " --report-name aws-auditor " + " --no-browser -f"
    cmd = "docker exec -it scoutsuite" + " python scout.py aws -p " + args.aws_name + \
      " --report-name aws-auditor --report-dir " + rpt_dir + " --report-name aws-auditor " + " --no-browser -f"
    puts "Execute CMD: #{cmd}"
    system(cmd)
    audit_time = Time.now
    db = Sequel.sqlite(YAML.load(File.read(File.join(::Rails.root, 'config', 'database.yml')))[::Rails.env] || 'development')
    aws = db[:aws_accounts]
    aws.where(:acct_id => aws_conf[args.aws_name]["acct_id"].to_s).update(scout_audit_time: audit_time)
    db = nil

    puts "Task completed. "
  end

end
