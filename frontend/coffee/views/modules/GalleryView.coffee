
define(['backbone', 'underscore', 'views/modules/childrens/GalleryRow', 'models/collections/YTSongs'], (Backbone, _, galleryRow, YTSongs) ->

	# Creamos la vista principal que contendrá nuestras vistas hijas
	GalleryView = Backbone.View.extend({
		el: 'body',
		collection: null,
		dom: {},
		catchDom: () ->
			this.dom.frmAuthor = this.$('#frmAuthor', this.$el)
			this.dom.txtId = this.$('#id', this.dom.frmAuthor)
			this.dom.txtName = this.$('#name', this.dom.frmAuthor)
			this.dom.txtPhoto = this.$('#photo', this.dom.frmAuthor)
			this.dom.txtTwitter = this.$('#twitter', this.dom.frmAuthor)
			this.dom.txtUrl = this.$('#url', this.dom.frmAuthor)
			this.dom.txtSearchSong = this.$('#search-field', this.$el)

			#console.log('catchDom')
			return
		initialize: () ->
			# _.bindAll(this) hace que las funciones apunten siempre al "this" del objeto principal
			_.bindAll(this, 'render', 'newAuthor')

			# Asignamos a la variable "collection" una instancia de nuestra Colección
			this.collection = new YTSongs()

			# Ejecutamos la funcion 'addAuthor' cuando escuchamos el evento 'add' en la colección
			this.listenTo(this.collection, 'add', this.addSong)
			# Ejecutamos la funcion 'removeAuthor' cuando escuchamos el evento 'remove' en la colección
			# this.listenTo(this.collection, 'remove', this.removeAuthor)

			this.catchDom()
			return
		,
		# Función "render" de la vista
		render: () ->
			# Aqui renderizo la vista principal, la cargo con datos si deseo, en este caso no la necesito
			return
		,
		addSong: () ->
			# Aqui renderizo la vista principal, la cargo con datos si deseo, en este caso no la necesito
			view = new galleryRow({model: modelo, collection: this.collection})
			this.$el.find("tbody").append(view.render().el)
			return

		newAuthor: (e) ->
			authorData = {
				id: this.dom.txtId.val()
				name: this.dom.txtName.val()
				photo: this.dom.txtPhoto.val()
				twitter: this.dom.txtTwitter.val()
				url: this.dom.txtUrl.val()
			}
			#console.log(this.collection)
			this.collection.create(authorData)
			return
		,
		searchVideo: (e) ->
			if e.keyCode is 13
				val = this.dom.txtSearchSong.val()
				#this.collection.fetch({data:{"q": this.dom.txtSearchSong.val()}})
				this.addSong()
				return false
			return true
		,
		events: {
			"click #btnSubmit": "newAuthor"
			"keydown #search-field": "searchVideo"
		}

	})

	return GalleryView
)
