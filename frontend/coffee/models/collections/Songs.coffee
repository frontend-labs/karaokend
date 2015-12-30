define(['backbone', 'models/Song'], (Backbone, Song) ->

	# Creamos una colección de Canciones
	Songs = Backbone.Collection.extend({
		model: Song,
		url: () ->
			return domain + ':' + port + '/songs'
	})

	return Songs
)
