#--
# cloud-auditor
#
# A  Ruby application for enterprise cloud security audit
#
# Developed by Sam Li, <yang.li@owasp.org>. 2020-2021
#
#++

class ApplicationResponder < ActionController::Responder
  include Responders::FlashResponder
  include Responders::HttpCacheResponder

  # Redirects resources to the collection path (index action) instead
  # of the resource path (show action) for POST/PUT/DELETE requests.
  # include Responders::CollectionResponder
end
