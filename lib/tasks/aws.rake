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

# AWS account setup
namespace :aws do
  desc "Cloud Auditor AWS Accounts Setup - Import them from aws.yml file"
  task :acct_import => :environment do |task, args|
    puts banner
    puts "Import AWS Accounts from aws.yml file ..."
    create_time = Time.now
    aws_yml = Rails.root.join('config','aws.yml')
    aws_conf = YAML.load(File.read(aws_yml))[::Rails.env] || 'development'
    db = Sequel.sqlite(YAML.load(File.read(File.join(::Rails.root, 'config', 'database.yml')))[::Rails.env] || 'development')
    aws = db[:aws_accounts]
    aws_conf.each do |key,val|
      acct_id = aws_conf[key]["acct_id"]
      name = aws_conf[key]["name"]
      desc = aws_conf[key]["desc"]
      email = aws_conf[key]["email"] ? aws_conf[key]["email"] : ""
      record = aws.where(:acct_id => aws_conf[key]["acct_id"].to_s)
      new_record = {acct_id: acct_id, name: name, desc: desc, contact: email, created_at: create_time, updated_at: create_time }
      unless record.empty?
        puts "Update database record: #{record}"
        record.update(name: name, desc: desc, contact: email)
      else
        puts "Insert database record: #{new_record}"
        aws.insert(new_record)
      end
    end
    db = nil
    puts "Task completed. "
  end


  desc "AWS Accounts Report Directories Setup - Run Through cloud-auditor docker only"
  task :create_rpt_dirs => :environment do |task, args|
    puts banner
    puts "AWS Accounts Report Directories Setup - Run Through cloud-auditor docker only ..."
    aws_yml = Rails.root.join('config','aws.yml')
    aws_conf = YAML.load(File.read(aws_yml))[::Rails.env] || 'development'
    rpt_dir = '/cloud-auditor/private/'
    aws_conf.each do |key,val|
      acct_id = aws_conf[key]["acct_id"].to_s
      scout_rpt_dir = rpt_dir + 'aws_scout/' + acct_id + '/'
      prow_rpt_dir = rpt_dir + 'aws_prow/' + acct_id + '/'
      Dir.mkdir(scout_rpt_dir) unless File.exists?(scout_rpt_dir)
      Dir.mkdir(prow_rpt_dir) unless File.exists?(prow_rpt_dir)
    end
    puts "Task completed. "
  end
end
