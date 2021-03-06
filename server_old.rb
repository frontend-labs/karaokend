
require 'sinatra'
require 'json'
require 'mysql'
require 'yaml'

config = YAML.load_file('config/local.yml')
mysql = config['mysql']


con = Mysql.new mysql['server'], mysql['user'], mysql['pass'], mysql['db']

configure do
  set :port, 9494
  # set :bind, 'localhost'
  # set :public_folder, 'public/'
  set :bind, 'karaokend.frontendlabs.io'
  set :public_folder, '/var/www/karaokend.frontendlabs.io/public/'
end

before do
	content_type :json
	headers 'Access-Control-Allow-Origin' => '*',
			'Access-Control-Allow-Methods' => ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
			'Access-Control-Allow-Headers' => 'X-Requested-With, X-Prototype-Version',
			'Access-Control-Max-Age' => '1728000'

end


get "/" do
  redirect '/index.html'
end

# GET METHOD
get '/songs' do
	newArray = []
	newRow= {}

    rs = con.query("SELECT s.id,
						   s.title,
				           s.duration,
				           REPLACE( p.url,  '__hash__', s.hash ) AS url,
				           REPLACE( p.preview,  '__hash__', s.hash ) AS preview,
				           s.date,
						   s.votes
						   FROM song AS s
						   INNER JOIN provider AS p
						   WHERE s.id_provider = p.id ORDER BY s.date DESC")

    n_rows = rs.num_rows

	rs.each_hash { |row|
		newRow = {
			"id" => "#{row['id']}",

			"title" => "#{row['title'].force_encoding("ISO-8859-1").encode("UTF-8")}",
			"url"=> "#{row['url'].force_encoding("ISO-8859-1").encode("UTF-8")}",
			"preview"=> "#{row['preview'].force_encoding("ISO-8859-1").encode("UTF-8")}",
			"duration"=> "#{row['duration']}",
			"votes"=> "#{row['votes']}",
			"date"=> "#{row['date']}"
		}
		newArray.push(newRow)
	}

	puts newArray


	newArray.to_json

end


put "/songs/:id" do


	request.body.rewind
	request_payload = JSON.parse request.body.read

	flag = true
	newRow = {}
	id = 0
	mainQuery = 'UPDATE song SET '
	setQuery = ''
	query = ''
	whereQuery = 'WHERE id = '
	response = []
	json = {}

	headQuery = ''
	bodyQuery = ""

	id = "#{params[:id]}".to_s
	puts "id: "
	puts "#{params[:id]}"


	if id.to_s == "0"
		current_time = Time.now.getutc
		time = current_time.getlocal("-05:00")

		id_provider = request_payload['id_provider'].to_s
		title = request_payload['title']
		hash = request_payload['hash'] 
		duration = request_payload['duration'] 
		date = time.to_s.slice(0, time.to_s.length - 6)
		votes = '0'

		puts id_provider
		puts title
		puts hash
		puts duration
		
		puts " - - - - - - - -"

		bodyQuery = "INSERT INTO song (id, id_provider, title, hash, duration, date, votes) VALUES (NULL, '" + id_provider + "', '" + title + "', '" + hash + "', '" + duration + "', '" + date + "', '" + votes + "')"
		puts "_ _ _ xx _ _ _ _"
		puts bodyQuery
		puts "_ _ _ xx _ _ _ _"
		rs = con.query(bodyQuery)
		puts con.affected_rows
		if con.affected_rows > 0
			json = {:data => {}, "msg" => "Registro insertado correctamente", :status => "1"}
		else
			json = {:data => {}, "msg" => "El registro no fue insertado", :status => "0"}
		end
		response.push(json)
		response.to_json

		#puts bodyQuery
		#curl --data "id_provider=1&title=algo&hash=xxx&duration=9:70" http://localhost:9494/songs
	else
		whereQuery = whereQuery + id
		params.each do |k, v|
			case k
			when "splat", "captures"
				break
			else
				setQuery = setQuery + k + "= '"  + v + "', "
				puts "#{k}: #{v}"
			end
		end
		query = mainQuery + setQuery.slice(0, setQuery.length - 2) + " " + whereQuery
		rs = con.query(query)
		puts con.affected_rows
		if con.affected_rows > 0
			json = {:data => { :id => "#{params[:id]}" }, "msg" => "Actualizado correctamente", :status => "1"}
		else
			json = {:data => { :id => "#{params[:id]}" }, "msg" => "El registro no fue actualizado", :status => "0"}
		end
		response.push(json)
		response.to_json

		#curl -X PUT -d title='Jarabe De Palo - Me Gusta Como Erez' -d hash='hAxiPFE6pqM' localhost:9494/songs/1
	end
end





post '/songs' do

query = ''
setQuery = ''
headQuery = ''
bodyQuery = ""
response = []

current_time = Time.now.getutc
time = current_time.getlocal("-05:00")

id_provider = "#{params[:id_provider]}"
title = "#{params[:title]}"
hash = "#{params[:hash]}"
duration = "#{params[:duration]}"
date = time.to_s.slice(0, time.to_s.length - 6)
votes = '0'

bodyQuery = "INSERT INTO song (id, id_provider, title, hash, duration, date, votes) VALUES (NULL, '" + id_provider + "', '" + title + "', '" + hash + "', '" + duration + "', '" + date + "', '" + votes + "')"
rs = con.query(bodyQuery)
puts con.affected_rows
if con.affected_rows > 0
	json = {:data => {}, "msg" => "Registro insertado correctamente", :status => "1"}
else
	json = {:data => {}, "msg" => "El registro no fue insertado", :status => "0"}
end
response.push(json)
response.to_json

#puts bodyQuery
#curl --data "id_provider=1&title=algo&hash=xxx&duration=9:70" http://localhost:9494/songs


end



delete "/songs/:id" do

	response = []
	query = []
	json = {}

	id = "#{params[:id]}"

	query = "DELETE FROM song WHERE id = " + id

	rs = con.query(query)

	puts con.affected_rows


	if con.affected_rows > 0
		json = {:data => { :id => "#{params[:id]}" }, "msg" => "Eliminado correctamente", :status => "1"}
	else
		json = {:data => {}, "msg" => "El registro no fue eliminado", :status => "0"}
	end

	response.push(json)
	response.to_json

end


