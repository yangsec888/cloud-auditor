#--
# cloud-auditor
#
# A  Ruby application for enterprise cloud security audit
#
# Developed by Sam Li, <yang.li@owasp.org>. 2020-2021
#
#++


class YmlSettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only

  def index
    @tree = []
    @tree << { 'id' => 'config_root', 'text' => 'YAML Configuration Files',
               'children' => [], 'icon' => 'glyphicon glyphicon-list',
               'state' => { 'opened' => true } }
    files = Dir.glob(Rails.root.join('config') + '*.yml')
    files.each do |file|
      @tree[0]['children'] << { 'id' => file,
                                'text' => file.split('/')[-1].gsub('.yml', ''),
                                'icon' => 'glyphicon glyphicon-file' }
    end
    #render @tree.inspect
    respond_to do |format|
      format.html
      format.json { render json: @tree }
    end
  end

  def load_file
    white_list = Dir.glob(Rails.root.join('config') + '*.yml')
    data = ''
    if white_list.include?(params[:path])
      file = File.open(params[:path], 'r')
      file.each_line { |line| data += line }
      file.close
      render plain: data
    else
      render plain: "Error loading file: #{params[:path]}"
    end
  end

  def save_file
    white_list = Dir.glob(Rails.root.join('config') + '*.yml')
    if white_list.include?(params[:file_path])
      file = File.open(params[:file_path], 'r')
      @restore = ''
      file.each_line { |line| @restore += line }
      file.close
      file = File.open(params[:file_path], 'w+')
      file.write(params[:file_content])
      file.close
      YAML.load_file(params[:file_path])
      render json: { message: 'Saving successed.' }
    else
      render json: { message: 'Problem loading file. ' }
    end
  rescue Psych::SyntaxError
    if white_list.include?(params[:file_path])
      file = File.open(params[:file_path], 'w+')
      file.write(@restore)
      file.close
    end
    render json: { message: 'Saving failed, please check YAML file format again.' }
  end

end
