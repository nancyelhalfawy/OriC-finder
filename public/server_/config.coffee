
module.exports = (app) ->


	app.pages.browserifyLoad
		'home': require '../pages_/home/main.coffee'
		'select': require '../pages_/select/main.coffee'
		'gc': require '../pages_/gc/main.coffee'
		'dnaa': require '../pages_/dnaa/main.coffee'
		'links': require '../pages_/links/main.coffee'

	app.router.setRootURL 'OriC-finder/'

	app.menu.create
		"home":
			"title": "Home"
			"icon": "fa-home"
			"href": ''
		"select":
			"title": "Select DNA"
			"icon": "fa-list-alt"
			"href": '/select/'
		"analyze":
			"title": "Analyze"
			"icon": "fa-flask"
			"href": "no-link"
			"menu-items":
				"gc":
					"title": "GC Skew"
					"icon": "fa-bar-chart-o"
					"href": "/gc-skew/"
				"dnaa":
					"title": "DnaA boxes"
					"icon": "fa-spinner"
					"href": "/dnaa/"
		"links":
			"title": "Links"
			"icon": "fa-external-link"
			"href": "/links/"



	app.router.start {
		'': -> app.pages.render('home')
		'select/': -> app.pages.render('select')
		'select/:bacteria': (bacteria) -> app.pages.render('select', bacteria)
		'gc-skew/': -> app.pages.render('gc')
		'dnaa/': -> app.pages.render('dnaa')
		'links/': -> app.pages.render('links')
	}

