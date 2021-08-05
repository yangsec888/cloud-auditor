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

# Update Prowler report data; to be exected via host cronjob
# Assumptions: a) aws.ymal definition for aws account; b) aws configure profile setup complete
namespace :prowler do
  desc "Refresh Scout Suites AWS Reports task"
  task :refresh_aws, [:aws_name] => :environment do |task,args|
    puts banner
    puts "Refresh AWS report data  ..."
    audit_time = Time.now
    aws_yml = Rails.root.join('config','aws.yml')
    aws_conf = YAML.load(File.read(aws_yml))[::Rails.env] || 'development'
    rpt_root = "/cloud-auditor/private/aws_prow/"

    #rpt_dir = rpt_root.join(aws_conf[args.aws_name]["acct_id"].to_s).to_s
    rpt_dir = rpt_root + aws_conf[args.aws_name]["acct_id"].to_s + '/'
    #Dir.mkdir(rpt_dir) unless File.exists?(rpt_dir)
    rpt_file = rpt_dir + "/" + "aws-auditor.html"
    cmd0 = "aws sso login --profile " + args.aws_name
    puts "Setup SSO CLI Programatic Access with CMD: #{cmd0}"
    system(cmd0)
    prow_path = '/cloud-auditor/private/aws_prow/' + aws_conf[args.aws_name]["acct_id"].to_s
    prow_file = prow_path  + '/' + 'aws-auditor'
    cmd1 = "docker exec -it prowler " + "./prowler -p " + args.aws_name + " -g cislevel1 " + \
      " -d " + prow_path + " -o " + prow_file + " -M html,json"

    puts "Start prowler CIS audit with CMD: #{cmd1}"
    system(cmd1)
    # update db record timestamp
    db = Sequel.sqlite(YAML.load(File.read(File.join(::Rails.root, 'config', 'database.yml')))[::Rails.env] || 'development')
    aws = db[:aws_accounts]
    aws.where(:acct_id => aws_conf[args.aws_name]["acct_id"].to_s).update(prow_audit_time: audit_time)
    db = nil

    puts "Task completed. "
  end

end
