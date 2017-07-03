class User < ApplicationRecord

  def by_json
    {userId: self.id.to_s, email: self.email, token: self.auth_token,
      social: self.social == nil ? "" : self.social}
  end

  # def generate_token(column)
  #   begin
  #     self[column] = SecureRandom.hex(10)
  #   end while User.exists?(column => self[column])
  # end

  def generate_token
    self.auth_token = loop do
      random_token = SecureRandom.hex(10)
      break random_token unless User.exists?(auth_token: random_token)
    end
  end

end
