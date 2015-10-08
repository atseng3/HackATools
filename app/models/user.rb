class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:twitter]
  
  has_many :reviews, dependent: :destroy

  has_many :watchlists
  has_many :watchlist_products, :through => :watchlists, source: :product

  def self.from_omniauth(auth)
	  user = where(provider: auth.provider, uid: auth.uid).first_or_create
    user.update(
      provider: auth.provider,
      uid: auth.uid,
      name: auth.info.name,
      profile_image: auth.info.image,
      token: auth.credentials.token,
      secret: auth.credentials.secret,
      # email: auth.info.email
      email: '',
      password: Devise.friendly_token[0,20]
    )
    user
	end
end