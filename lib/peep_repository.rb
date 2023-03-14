require_relative 'peep'
require 'pg'

class PeepRepository
  def all_with_maker_username
    sql = 'SELECT p.content, p.created_at, m.username AS maker_username FROM peeps p JOIN makers m ON p.maker_id = m.id ORDER BY p.created_at DESC;'
    result_set = DatabaseConnection.exec_params(sql, [])

    peeps = []
    result_set.each do |row|
      peep = Peep.new
      peep.content = row['content']
      peep.created_at = row['created_at']
      peep.maker_username = row['maker_username']
      peeps << peep
    end

    return peeps
  end
  
  def find(id)
    sql = 'SELECT * FROM peeps WHERE id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [id])
  
    return nil if result_set.ntuples == 0
  
    Peep.new(
      id: result_set[0]['id'].to_i,
      content: result_set[0]['content'],
      created_at: result_set[0]['created_at'],
      maker_id: result_set[0]['maker_id'].to_i
    )
  end
  
  def create(peep)
    puts "Creating new peep: #{peep.inspect}"
    sql = 'INSERT INTO peeps (content, created_at, maker_id) VALUES ($1, $2, $3);'
    result_set = DatabaseConnection.exec_params(sql, [peep.content, peep.created_at, peep.maker_id])
    puts "Result of INSERT query: #{result_set.inspect}"
    return peep
  end
  
  def all
    sql = 'SELECT p.id, p.content, p.created_at, p.maker_id, m.username as maker_username FROM peeps p JOIN makers m ON p.maker_id = m.id ORDER BY p.created_at DESC;'
    result_set = DatabaseConnection.exec_params(sql, [])
    result_set.map do |row|
      Peep.new(
        id: row['id'].to_i,
        content: row['content'],
        created_at: row['created_at'],
        maker_id: row['maker_id'].to_i,
        maker_username: row['maker_username']
      )
    end
  end
  
  def get_maker_username(maker_id)
    sql = 'SELECT username FROM makers WHERE id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [maker_id])
  
    return nil if result_set.ntuples == 0
  
    return result_set[0]['username']
  end
end
