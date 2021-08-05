#--
# cloud-auditor
#
# A  Ruby application for enterprise cloud security audit
#
# Developed by Sam Li, <yang.li@owasp.org>. 2020-2021
#
#++
require 'ipaddr'

class AwsAccountsController < ApplicationController
  include AwsAccountsHelper
  before_action :authenticate_user!, except: [:index]
  before_action :set_aws_account, only: [:show, :edit, :update, :destroy]

  # GET /aws_accounts
  # GET /aws_accounts.json
  def index
    @aws_accounts = AwsAccount.order(aws_sort_column + " " + aws_sort_direction)
    @format = params[:format] ? params[:format] : "aws_scout"
  end

  # GET /aws_accounts/1
  # GET /aws_accounts/1.json
  def show
  end

  # GET /aws_accounts/new
  def new
    redirect_back :fallback_location => root_path, alert: 'Access denied' unless admin_only
    @aws_account = AwsAccount.new
  end

  # GET /aws_accounts/1/edit
  def edit
    redirect_back :fallback_location => root_path, alert: 'Access denied' unless admin_only
  end

  # POST /aws_accounts
  # POST /aws_accounts.json
  def create
    redirect_back :fallback_location => root_path, alert: 'Access denied' unless admin_only
    @aws_account = AwsAccount.new(aws_account_params)
    respond_to do |format|
      if @aws_account.save
        format.html { redirect_to @aws_account, notice: 'Aws account was successfully created.' }
        format.json { render :show, status: :created, location: @aws_account }
      else
        format.html { render :new }
        format.json { render json: @aws_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /aws_accounts/1
  # PATCH/PUT /aws_accounts/1.json
  def update
    redirect_back :fallback_location => root_path, alert: 'Access denied' unless admin_only
    respond_to do |format|
      if @aws_account.update(aws_account_params)
        format.html { redirect_to @aws_account, notice: 'Aws account was successfully updated.' }
        format.json { render :show, status: :ok, location: @aws_account }
      else
        format.html { render :edit }
        format.json { render json: @aws_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /aws_accounts/1
  # DELETE /aws_accounts/1.json
  def destroy
    redirect_back :fallback_location => root_path, alert: 'Access denied' unless admin_only
    @aws_account.destroy
    respond_to do |format|
      format.html { redirect_to aws_accounts_url, notice: 'Aws account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # CIDR Asset Search
  def search_results
    @results=Array.new
    @keyword = params[:keyword].strip()
    key_net = IPAddr.new(@keyword)
    scout_rpts = aws_scout_js_rpts
    rpts = scout_rpts.map do |js_rpt|
      next unless File.exist?(js_rpt.to_s)
      aws_acct = js_rpts_2_acct(js_rpt.to_s)
      aws_acct_name = js_rpts_2_acct_name(js_rpt.to_s)
      asset_hash = JSON.parse(file_2_list(js_rpt.to_s)[1])
      #logger.debug "JSON report: #{asset_hash}"
      asset_hash["services"]["vpc"]["regions"].each do |reg,val1|
        #logger.debug "\nRegion: #{reg}, Vpcs: #{val1["vpcs"]}"
        val1["vpcs"].each do |vpc_id,val2|
          #logger.debug "\nvpc_id: #{vpc_id}, subnets: #{val2["subnets"]} "
          val2["subnets"].each do |subnet_id,val3|
            target_net = IPAddr.new(val3['cidrblock'])
            if target_net.include?(key_net)
              logger.debug "\nFound in js file: #{js_rpt}"
              logger.debug "\nsubnet_id: #{subnet_id}, cidr_block: #{val3["cidrblock"]}"
              logger.debug "key: #{key_net.to_range}, target: #{target_net.to_range}"
              @results.push({"aws_acct"=>aws_acct, "aws_acct_name"=>aws_acct_name, "reg"=>reg, "vpc_id"=>vpc_id, "subnet_id"=>subnet_id, "subnet_name"=> val3["name"], "cidrblock"=> val3["cidrblock"]})
            end
          end
        end
      end
    end
  rescue IPAddr::InvalidAddressError
    redirect_back :fallback_location => root_path, :alert => "Invalid CIDR format!"
  rescue Exception
    redirect_back :fallback_location => root_path, :alert => "Sorry for the error. Please contact your administrator. "
  end

  # AWS Security Policy Search, example ELBSecurityPolicy-TLS-1-2-2017-01 under ELB objects
  def search_ssl_policy_results
    @results=Array.new
    @keyword = params[:keyword].strip()
    scout_rpts = aws_scout_js_rpts
    rpts = scout_rpts.map do |js_rpt|
      next unless File.exist?(js_rpt.to_s)
      aws_acct = js_rpts_2_acct(js_rpt.to_s)
      aws_acct_name = js_rpts_2_acct_name(js_rpt.to_s)
      asset_hash = JSON.parse(file_2_list(js_rpt.to_s)[1])
      #logger.debug "JSON report: #{asset_hash}"
      asset_hash["services"]["elbv2"]["regions"].each do |reg,val1|
        #logger.debug "\nRegion: #{reg}, Vpcs: #{val1["vpcs"]}"
        val1["vpcs"].each do |vpc_id,val2|
          #logger.debug "\nvpc_id: #{vpc_id}, subnets: #{val2["lbs"]} "
          val2["lbs"].each do |lbs_id,val3|
            #target_listeners = val3['listeners']
            #logger.debug "\nlbs_id: #{lbs_id}, listeners: #{target_listeners} "
            val3['listeners'].each do |port,val4|
              next unless val4.key?('sslpolicy')
              if val4['sslpolicy'].include?(@keyword.downcase)
                logger.debug "\nFound in js file: #{js_rpt}"
                logger.debug "AWS Account Name: #{aws_acct_name}"
                logger.debug "lbs_id: #{lbs_id}, \nlistener: #{val3["listeners"][port]}"
                #logger.debug "key: #{key_net.to_range}, target: #{target_net.to_range}"
                @results.push({"aws_acct"=>aws_acct, "aws_acct_name"=>aws_acct_name, "reg"=>reg, "vpc_id"=>vpc_id, \
                  "lbs_id"=>lbs_id, "listener_port" => port, "policy"=> val3["listeners"][port]["sslpolicy"]})
              end
            end
          end
        end
      end
    end
  #rescue Exception
  #  redirect_back :fallback_location => root_path, :alert => "Sorry for the error. Please contact your administrator. "
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_aws_account
      @aws_account = AwsAccount.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def aws_account_params
      params.require(:aws_account).permit(:id, :acct_id, :name, :desc, :bus_unit, :contact, :audit_time)
    end


end
