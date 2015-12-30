define(['backbone', 'models/Song'], (Backbone, Song) ->

	# Creamos una colección de Canciones
	Songs = Backbone.Collection.extend({
        model: Song,
        url: () ->
			return 'http://karaokend.frontendlabs.io:8000/songs'
	})

	return Songs
)
