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
  end

  erb :index
end

get '/recipes/:id' do
  @id = params[:id]
  db_connection do |conn|
    results = conn.exec_params('SELECT recipes.id AS id, recipes.name AS name,
     recipes.instructions AS instructions, recipes.description AS description,
     ingredients.name AS ingredients, ingredients.recipe_id AS recipe_id
     FROM recipes
     JOIN ingredients ON recipes.id = ingredients.recipe_id
     WHERE recipes.id = $1', [@id])
    @recipes_id = results.to_a
  end
  erb :show
end
