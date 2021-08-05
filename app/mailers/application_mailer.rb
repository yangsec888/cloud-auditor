#--
# cloud-auditor
#
# A  Ruby application for enterprise cloud security audit
#
# Developed by Sam Li, <yang.li@owasp.org>. 2020-2021
#
#++

class ApplicationMailer < ActionMailer::Base
  default from: 'yangsec888@github.com'
  layout 'mailer'
end
