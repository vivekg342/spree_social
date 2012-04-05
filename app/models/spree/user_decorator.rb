Spree::User.class_eval do
  has_many :user_authentications

  devise :omniauthable

  def apply_omniauth(omniauth)
    if omniauth['provider'] == 'facebook'
      ['email', 'first_name', 'last_name'].each do |attr|
        self.send("#{attr}=", omniauth['info'][attr])
      end
    end
    user_authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end

  def password_required?
    (user_authentications.empty? || !password.blank?) && super
  end
end
