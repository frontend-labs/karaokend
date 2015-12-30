define(['backbone',
		'underscore',
		'views/modules/childrens/GalleryRow',
		'models/collections/YTSongs'
		'models/collections/foundedSongs'
		'models/collections/Songs'
		], (Backbone, _, galleryRow, YTSongs, FoundedSongs, Songs) ->

	# Creamos la vista principal que contendrá nuestras vistas hijas
	GalleryView = Backbone.View.extend({
		el: 'body',
		collection: null,
		dom: {},
		catchDom: () ->
			this.dom.txtSearchSong = this.$('#search-field', this.$el)
			return
		,
		initialize: () ->
			# _.bindAll(this) hace que las funciones apunten siempre al "this" del objeto principal
			_.bindAll(this, 'render', 'newSongFounded')
			# Asignamos a la variable "collection" una instancia de nuestra Colección
			this.collection = new FoundedSongs()
			this.collectionSong = new Songs()
			# Ejecutamos la funcion 'addSong' cuando escuchamos el evento 'add' en la colección
			this.listenTo(this.collection, 'add', this.addSong)
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
			view = new galleryRow({model: modelo, collection: this.collectionSong})
			this.$el.find("tbody").append(view.render().el)
			componentHandler.upgradeDom()
			return
		,
		cleanResults: () ->
			this.$el.find("tbody").html("")
			return
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
		dealFoundedSongs: (list) ->
			that = @
			getThumbnail = (path, alternativePath)->
				return  if path then path else alternativePath

			list.map (item)->
				that.newSongFounded({
					id: item.id.videoId
					id_provider: "youtube"
					title: item.snippet.title
					hash: item.id.videoId
					votes: 0
					thumbnail: getThumbnail(item.snippet.thumbnails.medium.url, item.snippet.thumbnails.default.url)
				})
				return
		,
		searchVideo: (e) ->
			that = @
			if e.keyCode is 13
				val = this.dom.txtSearchSong.val()
				collectionSearcher = new YTSongs()
				collectionSearcher.fetch({
					data:
						"q": this.dom.txtSearchSong.val()
					,
					success:(collection, data)->
						that.cleanResults()
						that.dealFoundedSongs( data.items )
						return
				})
				return false
			return true
		events: {
			"keydown #search-field": "searchVideo"
		}

	})

	return GalleryView
)
