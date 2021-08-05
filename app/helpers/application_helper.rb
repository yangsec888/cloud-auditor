#--
# cloud-auditor
#
# A  Ruby application for enterprise cloud security audit
#
# Developed by Sam Li, <yang.li@owasp.org>. 2020-2021
#
#++

module ApplicationHelper
  def full_title(page_title)
    base_title = "PRH Cloud Auditor"
    if page_title.empty?
       base_title
    else
       "#{base_title} | #{page_title}"
    end
  end

  def banner()
    art = "
    ____ _                 _      _             _ _ _
   / ___| | ___  _   _  __| |    / \  _   _  __| (_) |_ ___  _ __
  | |   | |/ _ \| | | |/ _` |   / _ \| | | |/ _` | | __/ _ \| '__|
  | |___| | (_) | |_| | (_| |  / ___ \ |_| | (_| | | || (_) | |
   \____|_|\___/ \__,_|\__,_| /_/   \_\__,_|\__,_|_|\__\___/|_|
                                                                  
    "
    uri = "https://auditor/"
    string = "-"*80 + "\n" + art + "\n" + "URL: " + uri + "\nDesigned and developed by: Sam Li" + "\nEmail: yang.li@owasp.org\n"  + "-"*80
  end

private
  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "username"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end


end
