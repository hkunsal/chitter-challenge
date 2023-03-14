require_relative 'maker'
require 'pg'

class MakerRepository
  def all
    makers = []

    sql = 'SELECT id, username, password, name, email FROM makers;'
    result_set = DatabaseConnection.exec_params(sql, [])

    result_set.each do |record|
      maker = Maker.new(
        id: record['id'].to_i,
        username: record['username'],
        password: record['password'],
        name: record['name'],
        email: record['email']
      )

      makers << maker
    end

    return makers
  end

  def find(id)
    sql = 'SELECT * FROM makers WHERE id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [id])

    return nil if result_set.ntuples.zero?

    Maker.new(
      id: result_set[0]['id'].to_i,
      username: result_set[0]['username'],
      password: result_set[0]['password'],
      name: result_set[0]['name'],
      email: result_set[0]['email']
    )
  end

  def create(maker)
    if maker.id
      # Maker already exists, update instead of creating
      sql = 'UPDATE makers SET username = $2, password = $3, name = $4, email = $5 WHERE id = $1;'
      result_set = DatabaseConnection.exec_params(sql, [maker.id, maker.username, maker.password, maker.name, maker.email])
    else
      # Create new maker
      sql = 'INSERT INTO makers (username, password, name, email) VALUES ($1, $2, $3, $4) RETURNING id;'
      result_set = DatabaseConnection.exec_params(sql, [maker.username, maker.password, maker.name, maker.email])
      maker.id = result_set[0]['id'].to_i
    end

    return maker
  end

  def find_by_username(username)
    sql = 'SELECT * FROM makers WHERE username = $1;'
    result_set = DatabaseConnection.exec_params(sql, [username])

    return nil if result_set.ntuples.zero?

    Maker.new(
      id: result_set[0]['id'].to_i,
      username: result_set[0]['username'],
      password: result_set[0]['password'],
      name: result_set[0]['name'],
      email: result_set[0]['email']
    )
  end

  def find_username_by_id(maker_id)
    sql = 'SELECT username FROM makers WHERE id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [maker_id])

    if result_set.ntuples > 0
      return result_set[0]['username']
    else
      return nil
    end
  end

  def authenticate(username, password)
    maker = find_by_username(username)
    if maker && maker.password == password
      return maker
    else
      return false
    end
  end
end
