require 'peep'
require 'peep_repository'

def reset_peeps_table
  seed_sql = File.read('spec/seeds/tables_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter_test' })
  connection.exec(seed_sql)
end

describe PeepRepository do
  before(:each) do 
    reset_peeps_table
  end

  it "lists all peeps" do
    repo = PeepRepository.new
    peeps = repo.all
    
    expect(peeps.length).to eq(3)
    expect(peeps.first.content).to eq('Hi dudes and dudettes!')
    expect(peeps.first.created_at).to eq('2022-09-18')
  end

  it "finds a peep" do
    repo = PeepRepository.new

    peep = repo.find(2)

    expect(peep.id).to eq(2)
    expect(peep.content).to eq('Great day ahead')
    expect(peep.created_at).to eq('2022-03-10')
  end

  it "creates a peep" do
    repo = PeepRepository.new

    new_peep = Peep.new
    new_peep.content = 'Hello World!'
    new_peep.created_at = '2023-02-18'
    new_peep.maker_id = 2
    repo.create(new_peep)

    peeps = repo.all

    expect(peeps.first.content).to eq('Hello World!')
    expect(peeps.first.created_at).to eq('2023-02-18')
    expect(peeps.first.maker_id).to eq(2)
  end
end
