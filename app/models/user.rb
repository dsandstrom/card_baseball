# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :registerable, :confirmable, :lockable, :timeoutable,  and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable,
         :validatable

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  has_many :teams
end
