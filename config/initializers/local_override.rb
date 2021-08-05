# Provide the alternative local databae authentication, in additional to LDAP: https://gist.github.com/r00k/906356
require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class LocalOverride < Authenticatable
      def valid?
        true
      end

      def init_local_admin
        local_admin_yml = Rails.root.join('config', 'local_admin.yml')
        @local_admin = YAML.load_file(local_admin_yml)[Rails.env]
      end

      # authenticate admin user from configuration file or local user table from the database
      def authenticate!
        unless params[:user].nil?
          init_local_admin
          my_username = params[:user][:username].strip
          my_password = params[:user][:password].strip
          user = User.find_by_username(my_username)
          if my_username == @local_admin["username"] && my_password == @local_admin["password"]
             # Local admin authentication
            if user.nil?
              user= User.new(:username => @local_admin["username"], :email=>@local_admin["email"], :password => @local_admin["password"], \
                :password_confirmation => @local_admin["password"], :role => 0)
              user.save!
            end
            user = User.find_by_username(my_username)
            success!(user)
          elsif user && user.valid_password?(my_password)               # Local user database authentication
            success!(user)
          else
            fail("User name or password invalid ")
          end
        else
          fail
        end
      end

    end
  end
end

Warden::Strategies.add(:local_override, Devise::Strategies::LocalOverride)
