
require 'sinatra'
require 'sqlite3'
require 'awesome_print'

 set :port, 8080
  set :bind, '0.0.0.0'
  

before do 
 
  
  # connect to the cars_test database
  @db = SQLite3::Database.open "test.db"
  @db.results_as_hash = true
    
  # create the "cars" table in the database
  @db.execute "CREATE TABLE IF NOT EXISTS Cars(Id INTEGER PRIMARY KEY autoincrement, 
        Name TEXT, Price INT)"

end



get '/' do

 
  @cars = @db.execute "SELECT * FROM Cars LIMIT 5"
  
  ap @cars
  
  erb :index
  
  
end

post '/insert' do
  
  
  price = params["price"].to_i
  name = params["name"]

  @db.execute "insert into cars (name, price) values ('#{name}', #{price})"

	redirect '/'
  
end

#get '/delete' do 

get '/:id' do
  
  this_id = params[:id].to_i
  @car = @db.execute "select * from cars where id = '#{params[:id]}'"
  #ap @car 
	
	@title = "Edit car ##{params[:id]}"
	erb :edit
end


post '/:id' do

  
  # get the id for the name we're changing in the database
  this_id = params[:id]
  price = params[:price]
  name = params[:name]

  @db.execute "update  cars set name = '#{name}', price = '#{price}' where id = '#{this_id}'"

  redirect '/'
end
  
get '/:id/delete' do
  this_id = params[:id]
	@car = @db.execute "select * from cars where id = '#{this_id}'"
	@title = "Confirm deletion of note ##{params[:id]}"
	erb :delete
end

delete '/:id' do
	this_id = params[:id]
  
  @db.execute "delete from cars where id = '#{this_id}'"

	redirect '/'
end
