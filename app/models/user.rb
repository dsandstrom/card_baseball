# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :registerable, :confirmable, :lockable, :timeoutable,  and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable,
         :validatable

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :time_zone,
            presence: true,
            inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) }

  has_many :teams

  # CLASS

  def self.admins
    where(admin_role: true)
  end

  # INSTANCE

  def admin?
    @admin ||= admin_role == true
  end

  def simple_time_zone
    @simple_time_zone ||= time_zone&.gsub(/\s\(US & Canada\)/, '')
  end
end
