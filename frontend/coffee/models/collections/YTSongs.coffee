define(['backbone'], (Backbone) ->

	key = "AIzaSyD8U5MqBgY-h1yLpFuUCMgwWMJzt9w_pRU"

	# Creamos una colección de Youtube Song's
	YTSongs = Backbone.Collection.extend({
		url: () ->
			feedUrl = "https://www.googleapis.com/youtube/v3/search/?part=snippet,contentDetails&type=video&key=#{key}"
			return feedUrl
	})

	return YTSongs

)
