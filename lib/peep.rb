class Peep
  attr_accessor :id, :content, :created_at, :maker_id, :maker_username

  def initialize(id: nil, content: nil, created_at: nil, maker_id: nil, maker_username: nil)
    @id = id
    @content = content
    @created_at = created_at
    @maker_id = maker_id
    @maker_username = maker_username
  end
end
