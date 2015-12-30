define(['backbone', 'underscore'], (Backbone, _) ->

	galleryRow = Backbone.View.extend({
		# Creamos la vista hija "galleryRow" para cada autor
		model : null,
		collection: null,
		events: {
			"change .mdl-checkbox__input": "selectSong"
		},
		template : $('#tplSong').html(),
		initialize: () ->
			_.bindAll(this, 'render', 'selectSong')
			# Nos podemos a escuchar desde la vista hija actual cuando ocurra un evento "destroy" en el modelo y lanzamos la función "remove" de la vista hija actual
			this.listenTo(this.model, 'destroy', this.remove)
			return
		,
		render : () ->
			compiled_template = _.template(this.template)
			# Traemos los datos del modelo(this.model.toJSON()) a su vista(this.$el) correspondiente
			this.setElement(compiled_template(this.model.toJSON()))
			console.log "render!"
			# Retornamos this para poder usar el elemento generado
			return this
		,
		selectSong: () ->
			data = this.model.toJSON()
			data.id = 0
			this.collection.create(data)
			return
	})

	return galleryRow

)
