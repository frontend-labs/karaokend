define(['backbone',
		'underscore',
		'views/modules/childrens/SongRow',
		'models/collections/Songs'
		], (Backbone, _, SongRow, Songs) ->

	# Creamos la vista principal que contendrá nuestras vistas hijas
	SongLists = Backbone.View.extend({
		el: '.list',
		collection: null,
		dom: {},
		catchDom: () ->
			return
		,
		initialize: () ->
			# _.bindAll(this) hace que las funciones apunten siempre al "this" del objeto principal
			_.bindAll(this, 'render', 'newSongFounded')
			# Asignamos a la variable "collection" una instancia de nuestra Colección
			this.collection = new Songs()
			this.collection.fetch()

			# Ejecutamos la funcion 'addSong' cuando escuchamos el evento 'add' en la colección
			this.listenTo(this.collection, 'add', this.addSong)
			this.listenTo(this.collection, 'remove', this.removeSong)
			this.catchDom()
			return
		,
		# Función "render" de la vista
		render: () ->
			# Aqui renderizo la vista principal, la cargo con datos si deseo, en este caso no la necesito
			return
		,
		# Función "addSong" para adicionar la cancion
		addSong: (modelo) ->
			# Aqui renderizo la vista principal, la cargo con datos si deseo, en este caso no la necesito
			view = new SongRow({model: modelo, collection: this.collection})
			this.$el.find(".list").append(view.render().el)

			return
		,
		removeSong: (modelo) ->
			modelo.destroy()
			return
		,
		newSongFounded: (songFounded) ->
			songData = {
				id: songFounded.id
				id_provider: songFounded.id_provider
				title: songFounded.title
				hash: songFounded.hash
				duration: songFounded.duration
				votes: songFounded.votes
				thumbnail: songFounded.thumbnail
			}
			this.collection.create(songData)
			return
		,
		events: {
		}

	})

	return SongLists
)
