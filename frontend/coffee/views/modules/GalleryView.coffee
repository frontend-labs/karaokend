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
			this.listenTo(this.collection, 'add', this.addSongFounded)
			this.catchDom()
			return
		,
		# Función "render" de la vista
		render: () ->
			# Aqui renderizo la vista principal, la cargo con datos si deseo, en este caso no la necesito
			return
		,
		# Función "addSongFounded" para adicionar la cancion visual
		addSongFounded: (modelo) ->
			# Aqui renderizo la vista principal, la cargo con datos si deseo, en este caso no la necesito
			view = new galleryRow({model: modelo, collection: this.collectionSong})
			this.$el.find("tbody").append(view.render().el)
			componentHandler.upgradeDom()
			return
		,
		cleanResults: () ->
			this.collection.reset()
			this.$el.find("tbody").html("")
			return
		,
		newSongFounded: (songFounded) ->
			songData = {
				id_provider: songFounded.id_provider
				title: songFounded.title
				hash: songFounded.hash
				votes: songFounded.votes
				duration: songFounded.duration
				thumbnail: songFounded.thumbnail
			}
			this.collection.create(songData)
			return
		,
		dealFoundedSongs: (list) ->
			that = @

			fn = {
				getThumbnail = (path, alternativePath)->
					return  if path then path else alternativePath

				formatDuration : (duration)->
					match = duration.match(/PT(\d+H)?(\d+M)?(\d+S)?/)
					r = []
					if match[1]
						r.push parseInt(match[1])

					r.push((parseInt(match[2]) || 0))
					r.push(fn.zeroAdd((parseInt(match[3]) || 0)))

					return r.join(':')

				zeroAdd: (n)->
					return if n<10 then "0#{n}" else n
			}

			list.map (item)->
				that.newSongFounded({
					id_provider: 1
					title: item.snippet.title
					hash: item.id.videoId
					votes: 0
					thumbnail: fn.getThumbnail(item.snippet.thumbnails.medium.url, item.snippet.thumbnails.default.url)
					duration: fn.formatDuration(item.contentDetails.duration)
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
