#--
# cloud-auditor
#
# A  Ruby application for enterprise cloud security audit
#
# Developed by Sam Li, <yang.li@owasp.org>. 2020-2021
#
#++


class DocsController < ActionController::Base
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:show_aws_scout, :show_aws_prow]


  def show_aws_scout
    file_path = Rails.root.join('private', 'aws_scout', params[:file].to_s)
    file_path = file_path.to_s + '.' + params[:extension0].to_s if params[:extension0]
    file_path = file_path.to_s + '.' + params[:extension1].to_s if params[:extension1]
    if request.format.js?
      file_path += '.js'
      send_file(file_path, type: 'application/javascript', disposition: 'inline', status: 200, x_sendfile: true)
    else
      send_file(file_path, disposition: 'inline', status: 200, x_sendfile: true)
    end
  end

  def show_aws_prow
    file_path = Rails.root.join('private', 'aws_prow', params[:file].to_s)
    file_path = file_path.to_s + '.' + params[:extension0].to_s if params[:extension0]
    if request.format.js?
      file_path += '.js'
      send_file(file_path, type: 'application/javascript', disposition: 'inline', status: 200, x_sendfile: true)
    else
      send_file(file_path, disposition: 'inline', status: 200, x_sendfile: true)
    end
  end

end
