# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :registerable, :lockable, :timeoutable,  and :omniauthable
  devise :confirmable, :database_authenticatable, :recoverable, :rememberable,
         :trackable, :validatable

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

  def password?
    @password_ = encrypted_password.present? if @password_.nil?
    @password_
  end

  protected

    # https://github.com/heartcombo/devise/wiki/How-To:-Email-only-sign-up
    # override to be able to create without a password
    # or to allow sign in with github only
    def password_required?
      if @password_required_.nil?
        @password_required_ = confirmed? ? super : false
      end
      @password_required_
    end

  private

    def build_location
      if city.present?
        if simple_time_zone
          "#{city} (#{simple_time_zone})"
        else
          city
        end
      else
        simple_time_zone
      end
    end
end
