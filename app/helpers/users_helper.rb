#--
# cloud-auditor
#
# A  Ruby application for enterprise cloud security audit
#
# Developed by Sam Li, <yang.li@owasp.org>. 2020-2021
#
#++


module UsersHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = if column != sort_column
                    nil
                elsif sort_direction == 'asc'
                    'glyphicon glyphicon-chevron-up'
                else
                    'glyphicon glyphicon-chevron-down'
                end
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to "#{title} <span class='#{css_class}'></span>".html_safe, sort: column, direction: direction
  end


end
