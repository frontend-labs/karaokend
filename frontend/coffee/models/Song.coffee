define(['backbone'], (Backbone) ->
	# Creamos un modelo de Backbone
	Song = Backbone.Model.extend({
		# Defino los atributos por defecto del modelo
		defaults : {
			id          : 0
			id_provider : 1
			title       : 'jon doe video'
			hash        : '0.jpg'
			duration    : '00:00'
			votes       : '0'
		},
		# Pseudo constructor del modelo, se ejecuta cuando un modelo es instanciado
		initialize : () ->
			# Nos ponemos a escuchar el evento 'change:name' del modelo
			this.on('change:name', () ->
				console.log('se cambio el name a: ' + this.get('name'))
				return
			)
			return
		,
		# Agregamos al modelo funciones de manipulación de sus atributos
		setName : (newName) ->
			# Seteamos el atributo name desde un argumento llamado newName
			this.set({'name' : newName})
			return
	})

	return Song
)
