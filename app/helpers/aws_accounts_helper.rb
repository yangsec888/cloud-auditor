#--
# cloud-auditor
#
# A  Ruby application for enterprise cloud security audit
#
# Developed by Sam Li, <yang.li@owasp.org>. 2020-2021
#
#++

module AwsAccountsHelper
  def aws_sortable(column, title=nil, format=nil)
    title ||= column.titleize
    css_class = if column != aws_sort_column
                    nil
                elsif aws_sort_direction == 'asc'
                    'glyphicon glyphicon-chevron-up'
                else
                    'glyphicon glyphicon-chevron-down'
                end
    direction = column == aws_sort_column && aws_sort_direction == 'asc' ? 'desc' : 'asc'
    link_to "#{title} <span class='#{css_class}'></span>".html_safe, sort: column, direction: direction, format: format
  end

  # list known AWS Scoutsuite reports in .js format
  def aws_scout_js_rpts
    rpt_root = Rails.root.join('private','aws_scout')
    aws_accts = Dir.children(rpt_root)
    scout_rpts = aws_accts.map do |acct|
      rpt_root.join(acct, "scoutsuite-results", "scoutsuite_results_aws-auditor.js")
    end
  end

  # convert AWS Scoutsuite js file path to AWS acct
  def js_rpts_2_acct(rpt)
    return rpt.split('/')[-3]
  end

  # convert AWS Scoutsuite js file path to AWS acct name
  def js_rpts_2_acct_name(rpt)
    acct = rpt.split('/')[-3]
    aws_yml = Rails.root.join('config','aws.yml')
    aws_conf = YAML.load(File.read(aws_yml))[::Rails.env] || 'development'
    aws_conf.each do |k,v|
      if v['acct_id'] == acct
        return k
      end
    end
  end

  # Load entries from a text file and return an array
  def file_2_list(f,lc=true)
    puts "Loading records from file: #{f}" if @verbose
    begin
      list=Array.new
      file = File.open(f, "r")
      file.each_line do |line|
        line=line.chomp.strip
        next if line.nil?
        next if line.empty?
        next if line =~ /^\s*#/
        line=line.downcase if lc==true
        list.push(line.chomp.strip)
      end
      file.close
      return list
    rescue => ee
      puts "Exception on method #{__method__} for file #{f}: #{ee}" if @verbose
      return nil
    end
  end

private

  def aws_sort_column
    AwsAccount.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

  def aws_sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
