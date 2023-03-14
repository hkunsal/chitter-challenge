require 'maker'
require 'maker_repository'
require 'spec_helper'

def reset_makers_table
  seed_sql = File.read('spec/seeds/tables_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter_test' })
  connection.exec(seed_sql)
end

describe MakerRepository do
  before(:each) do 
    reset_makers_table
  end

  it "lists all makers" do
    repo = MakerRepository.new
    makers = repo.all

    expect(makers.length).to eq(3)
    expect(makers.first.username).to eq('sammorgan')
    expect(makers.first.password).to eq('sam123')
  end

  it "finds one maker" do
    repo = MakerRepository.new

    maker = repo.find(3)

    expect(maker.id).to eq(3)
    expect(maker.username).to eq('dianap')
    expect(maker.name).to eq('Diana Pascal')
  end
  
  it "creates a new maker" do
    repo = MakerRepository.new
  
    new_maker = Maker.new(
      username: 'anniedrey',
      password: 'annie789',
      name: 'Annie Dreyfus',
      email: 'a_dreyfus@gmail.com'
    )
    repo.create(new_maker)
  
    makers = repo.all
  
    expect(makers.length).to eq(4)
    expect(makers.last.username).to eq('anniedrey')
    expect(makers.last.email).to eq('a_dreyfus@gmail.com')
  end
end
