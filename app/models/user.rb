class User < ActiveRecord::Base
  
  def self.create_with_omniauth(id, name)
    create! do |user|
      user.uid = id
      user.name = name
    end
  end

end
