#--
# cloud-auditor
#
# A  Ruby application for enterprise cloud security audit
#
# Developed by Sam Li, <yang.li@owasp.org>. 2020-2021
#
#++

class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable, :database_authenticatable, # :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :timeoutable, :authentication_keys => [:username]
         attr_accessor :login
         # for client side validations
         validates :username, :password, presence: true
         validates_format_of :username, :with => /\A[a-z]+[0-9]*\z/i, :allow_blank => true, :message => "Your ID should contain letters and numbers only."
         validates_length_of :password, :minimum => 8, :allow_blank => true

         # refer to the smaple at: https://github.com/RailsApps/rails-devise-roles
         enum role: {user: 100, bronze: 50, silver: 40, gold: 30, platinum: 20, admin: 0 }
         after_initialize :set_default_role, :if => :new_record?

         def set_default_role
           self.role ||= :user
         end

         def self.find_first_by_auth_conditions(warden_conditions)
           conditions = warden_conditions.dup
           if login = conditions.delete(:login)
             where(conditions).where(["lower(username) = :value ", { :value => login.downcase }]).first
           else
             if conditions[:username].nil?
               where(conditions).first
             else
               where(username: conditions[:username]).first
             end
           end
         end

         def ldap_before_save
           #
           self.department = Devise::LDAP::Adapter.get_ldap_param(self.username,"department").first
           self.name = Devise::LDAP::Adapter.get_ldap_param(self.username,"name").first
           self.email = Devise::LDAP::Adapter.get_ldap_param(self.username,"mail").first
           self.employee_number = Devise::LDAP::Adapter.get_ldap_param(self.username,"employeeNumber").first
           self.employee_type = Devise::LDAP::Adapter.get_ldap_param(self.username,"employeeType").first
           self.dn = Devise::LDAP::Adapter.get_dn(self.username)
=begin
           # Assign user role based on user department
           case  dptm
           when "Human Resources"
             self.role = :hr
           when "Finance"
             self.role = :fa
           else
             self.role = :user
           end
           Rails.logger.debug ("Assign user role to #{self.username}: #{self.role}")
=end
         end
         scope :department, -> (department) { where department: department}

end
