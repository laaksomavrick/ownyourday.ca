# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable,
         :rememberable,
         :trackable, :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :goals, dependent: :destroy

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
