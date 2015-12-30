define(['backbone'], (Backbone) ->
	# Creamos un modelo de Backbone
	Song = Backbone.Model.extend({
		# Defino los atributos por defecto del modelo
		defaults : {
			id_provider   : 1
			title         : 'jon doe video'
			url           : ''
			hash          : '!'
			duration      : '00:00'
			votes         : '0'
			thumbnail     : false
			date		  : ''
			selected	  : false
		},
		toggle : ->
			this.save({selected: !this.get("selected")})
			return
	})

	return Song
)

