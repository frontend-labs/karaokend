define(['backbone'], (Backbone) ->
	# Creamos un modelo de Backbone
	Song = Backbone.Model.extend({
		# Defino los atributos por defecto del modelo
		defaults : {
			id            : 0
			id_provider   : 1
			title         : 'jon doe video'
			hash          : '!'
			duration      : '00:00'
			votes         : '0'
			thumbnail     : false
		}
	})

	return Song
)
