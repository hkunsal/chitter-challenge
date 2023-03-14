class Maker
  attr_accessor :id, :username, :password, :name, :email

  def initialize(id: nil, username:, password:, name:, email:)
    @id = id
    @username = username
    @password = password
    @name = name
    @email = email
  end
end
