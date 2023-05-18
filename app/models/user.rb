# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :rememberable,
         :trackable, :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :daily_goals, class_name: 'Goals::Daily', dependent: :destroy
  has_many :days_of_week_goals, class_name: 'Goals::DaysOfWeek', dependent: :destroy
  has_many :times_per_week_goals, class_name: 'Goals::TimesPerWeek', dependent: :destroy
  has_many :task_lists, dependent: :destroy
  has_many :tasks, dependent: :destroy

  def self.from_omniauth(auth)
    # TODO: if we ever want multiple oauth providers, this logic will have to change to support same email
    # across multiple providers
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end
end
