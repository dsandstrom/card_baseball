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

  def location
    @location ||= build_location
  end

  private

    def build_location
      if city && simple_time_zone
        "#{city} (#{simple_time_zone})"
      elsif city
        city
      else
        simple_time_zone
      end
    end
end
