
require 'sinatra'
require 'json'
require 'mysql'
require 'yaml'

config = YAML.load_file('config/local.yml')
mysql = config['mysql']

con = Mysql.new mysql['server'], mysql['user'], mysql['pass'], mysql['db']

configure do
  set :port, 9494
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
						   WHERE s.id_provider = p.id")

    n_rows = rs.num_rows

	rs.each_hash { |row|
		newRow = {
			"id" => "#{row['id']}",
			"title" => "#{row['title'].force_encoding("UTF-8")}",
			"url"=> "#{row['url']}",
			"preview"=> "#{row['preview']}",
			"duration"=> "#{row['duration']}",
			"votes"=> "#{row['votes']}",
			"date"=> "#{row['date']}"
		}
		newArray.push(newRow)
	}

	newArray.to_json

end


put "/songs/:id" do

	flag = true
	newRow = {}
	id = 0

	# puts "#{params[:id]}"
	# puts "#{params[:title]}"


	params.each do |k, v|
		case k
		when "splat", "captures"
			break
		when "id"
			id = v
		else
			puts "#{k}: #{v}"
		end
	end

	puts id

	""

    # rs = con.query("")

	# path = 'public/json/authors.json'
	# file = File.read(path)
	# array = JSON.parse(file)
	# req = JSON.parse(request.body.read)

	# array.each do |row|
	# 	if row["id"] == "#{params[:id]}"
	# 		row["name"] = "#{req['name']}"
	# 		newArray.push(row)
	# 		flag = false
	# 	else
	# 		#puts row
	# 		newArray.push(row)
	# 	end
	# end


	# if flag
	# 	puts "no entro!!!!"
	# 	newRow = {"id" => "#{params[:id]}", "name"=> "#{req['name']}", "photo" => "#{req['photo']}", "twitter" => "#{req['twitter']}", "url" => "#{req['url']}" }
	# 	puts newRow
	# 	newArray.push(newRow)
	# end

	# File.write(path, newArray.to_json)

	# json = {:data => { :id => "#{params[:id]}" }, "msg" => "Actualizado correctamente", :status => "1"}
	# response.push(json)

	# response.to_json




end


delete "/authors/:id" do

	array = []
	newArray = []
	response = []

	json = {}
	path = 'public/json/authors.json'

	file = File.read(path)
	array = JSON.parse(file)

	array.each do |row|
		if row["id"] == "#{params[:id]}"
			puts "se eliminara"
		else
			newArray.push(row)
		end
	end

	File.write(path, newArray.to_json)

	json = {:data => { :id => "#{params[:id]}" }, "msg" => "Eliminado correctamente", :status => "1"}
	response.push(json)

	response.to_json
end
