require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'pg'

def db_connection
  begin
    connection = PG.connect(dbname: 'recipes')

    yield(connection)

  ensure
    connection.close
  end
end

get '/recipes' do
  db_connection do |conn|
    results = conn.exec('SELECT id, name FROM recipes ORDER BY name')
    @recipes = results.to_a
    #binding.pry
  end

erb :index
end
