define(['backbone', 'localstorage', 'models/Song'], (Backbone, LocalStorage, Song) ->

	# Creamos una colección de Autores
	FoundedSongs = Backbone.Collection.extend({
        model: Song,
        localStorage: new LocalStorage('founded-songs'),
        selected: ->
            return this.where({selected: true})
	})

	return FoundedSongs
)
