require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  include Rack::Test::Methods

  def app
    Application.new
  end

  describe 'GET /' do
    it 'returns the index page' do
      response = get('/')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Welcome to Chitter!</h1>')
    end
  end

  describe 'GET /peeps' do
    it 'returns a list of peeps' do
      response = get('/peeps')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>List of Peeps</h1>')
    end
  end

  describe 'GET /signup' do
    it 'returns the sign-up page' do
      response = get('/signup')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Sign up for Chitter!</h1>')
    end
  end

  describe 'POST /signup' do
    context 'when valid information is submitted' do
      it 'creates a new maker and redirects to the login page' do
        response = post('/signup', { username: 'johndoe', password: 'password', name: 'John Doe', email: 'johndoe@example.com' })

        expect(response.body).to include('<h1>Log in to Chitter!</h1>')
      end
    end

    context 'when invalid information is submitted' do
      it 'does not create a new maker and returns an error message' do
        response = post('/signup', { username: 'sammorgan', password: 'password', name: 'Sam Morgan', email: 'sammorgan@gmail.com' })
        expect(response.status).to eq(200)
        expect(response.body).to include('Username already exists')
      end
    end
  end

  describe 'GET /login' do
    it 'returns the login page' do
      response = get('/login')
      expect(response.status).to eq(200)
      expect(response.body).to include('Log in to Chitter')
    end
  end

  describe 'POST /login' do
    context 'when valid login credentials are submitted' do
      it 'logs in the maker and redirects to the new peep page' do
        response = post('/login', username: 'sammorgan', password: 'sam123')
        
        expect(response.status).to eq(200)
        expect(response.body).to include('Send your peep!')
      end
    end

    context 'when invalid login credentials are submitted' do
      it 'does not log in the maker and returns an error message' do
        response = post('/login', username: 'sammorgan', password: 'wrongpassword')
        expect(response.status).to eq(200)
        expect(response.body).to include('Incorrect username or password!')
      end
    end
  end
end
