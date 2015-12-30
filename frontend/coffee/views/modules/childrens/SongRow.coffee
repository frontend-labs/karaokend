define(['backbone', 'underscore'], (Backbone, _) ->

	SongRow = Backbone.View.extend({
		# Creamos la vista hija "galleryRow" para cada autor
		tagName: 'li'
		model : null,
		collection: null,
		events: {
			"click .remove": "removeSong"
		},
		template : $('#tplSongRow').html(),
		dom: {},
		catchDom: () ->
			this.dom.txtName = this.$el.find('input')
			#console.log('catchDom')
			return
		initialize: () ->
			_.bindAll(this, 'render', 'removeSong')
			# Nos podemos a escuchar desde la vista hija actual cuando ocurra un evento "change" en el modelo y lanzamos la función "render" de la vista hija actual
			this.listenTo(this.model, 'add', this.render)
			# Nos podemos a escuchar desde la vista hija actual cuando ocurra un evento "destroy" en el modelo y lanzamos la función "remove" de la vista hija actual
			this.listenTo(this.model, 'destroy', this.remove)
			return
		,
		render : () ->
			compiled_template = _.template(this.template)
			# Traemos los datos del modelo(this.model.toJSON()) a su vista(this.$el) correspondiente
			this.setElement(compiled_template(this.model.toJSON()))
			# Retornamos this para poder usar el elemento generado
			return this
		,
		removeSong: () ->
			# Removemos el modelo seleccionado desde su colección correspondiente
			console.log 'elimino este modelo'
			this.collection.remove(this.model)
			return
	})

	return SongRow

)
