# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  provider         :string(64)
#  uid              :string(64)
#  name             :string(256)
#  oauth_token      :string(256)
#  image_url        :string(1024)
#  email            :string(256)
#  oauth_expires_at :datetime
#  created_at       :datetime
#  updated_at       :datetime
#  admin            :boolean          default(FALSE)
#

class User < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  
  def self.from_omniauth(auth, existing_user=nil)
    user = nil
    users_by_uid = where(auth.slice(:provider, :uid))
    if users_by_uid.exists? 
      user = users_by_uid.first.tap {|u| user=u}
    else
      user = existing_user || users_by_uid.first_or_initialize.tap {|u| user=u}
    end
    user.provider = auth.provider
    user.uid = auth.uid
    user.name = auth.info.name
    user.oauth_token = auth.credentials.token
    user.oauth_expires_at = Time.at(auth.credentials.expires_at) if auth.credentials.expires
    user.image_url = auth.info.image
    user.email = auth.info.email
    
    user.save!
    user
  end

end
