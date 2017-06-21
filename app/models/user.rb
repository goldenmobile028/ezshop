class User < ApplicationRecord

  def by_json
    {userId: self.id.to_s, email: self.email, token: self.auth_token,
      social: self.social == nil ? "" : self.social}
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

end
