define(['backbone', 'models/Song'], (Backbone, Song) ->

	# Creamos una colección de Canciones
	Songs = Backbone.Collection.extend({
		model: Song,
		url: () ->
<<<<<<< HEAD
			# return 'http://karaokend.frontendlabs.io:8000/songs'
			return domain + ':' + port + '/songs'
=======
			return 'http://localhost:9494/songs'
>>>>>>> ef5aa85d7b3eae7f83b7511f1a517843bd159615
	})

	return Songs
)
