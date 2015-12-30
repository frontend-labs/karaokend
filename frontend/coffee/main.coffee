
#domain = 'http://localhost'
domain = 'http://karaokend.frontendlabs.io'
port = '9494'

loc = window.location.href.split("/")
items = loc.length
current_page = loc[items-1]

require.config({
	baseUrl: 'static/js/',
	paths: {
		jquery: 'libs/jquery/dist/jquery.min',
		underscore: 'libs/underscore/underscore',
		backbone: 'libs/backbone/backbone',
		localstorage: 'libs/backbone.localStorage/backbone.localStorage',
		text: 'libs/text/text'
	},
	shim: {
		underscore: {
			exports: '_'
		},
		backbone: {
			deps: ["underscore", "jquery"],
			exports: "Backbone"
		}
	}
})


require(['jquery', 'underscore', 'backbone', 'text'], ($, _, Backbone, text) ->

	_.templateSettings = { interpolate : /\{\{(.+?)\}\}/g }

	require(['static/js/views/modules/GalleryView.js', 'static/js/views/modules/SongLists.js'],
		(GalleryView, SongLists) ->
			#Creamos una instancia de nuestra galería principal
			if current_page is "index.html"
				new GalleryView()
			else
				new SongLists()
			return
	)
	return
)

