

$ = require 'jquery'
_ = require 'underscore'
hbs = require 'hbs'


Backbone = require 'backbone'



do -> # Globalize

	window.Backbone = Backbone
	Backbone.$ = window.$ = window.jQuery = $


require 'bootstrap'
util = require './util.coffee'

# require '../lib/bootstrap/js/plugins/morris/raphael.min.js'
# require '../lib/bootstrap/js/plugins/morris/morris.min.js'
# require '../lib/bootstrap/js/plugins/morris/morris-data.js'


__templates = require('../build/templates.js')(hbs.handlebars)
templates = {}

for namespace, tmpl of __templates

	util.createNamespace templates, namespace, tmpl



class Page extends Backbone.Model

	defaults:
		dynamic: false

	initialize: () ->

		@set 'dynamic', typeof @get('view') isnt 'undefined'

		if @get 'dynamic' then @view = new (@get('view'))


class Pages extends Backbone.Collection


	model: Page

	initialize: () ->
		# console.log arguments



class App extends Backbone.View

	el: '#dynamic-pages'

	initialize: (settings) ->
		@titleEl = @$('#page-title')
		@contentEl = @$('#page-content')


	setTitle: (title) ->
		@titleEl.html title

	setContent: (content) ->
		@contentEl.html content

	activateMenuItem: (el) ->
		$('#main-navigation li.marked-active').removeClass('marked-active')
		$('#main-navigation').find(el).addClass('marked-active')

	render: (page_name) ->

		page = @collection.findWhere({ name: page_name })


		@setTitle page.get('name')
		if page.get('menu-item') then @activateMenuItem page.get('menu-item')

		if page.get 'dynamic'
			page.view.setElement @contentEl
			page.view.templates = page.get('template')
			page.view.trigger('load')
		else
			@setContent page.get('template')



class Router extends Backbone.Router

	initialize: ->

		if window.location.hostname is 'localhost' or window.location.hostname is '127.0.0.1'

			state = 'local'

		else

			state = 'remote'


		pages = new Pages([

			{
				name: 'home'
				template: templates.home.info
				'menu-item': '#menu-home'
			}

			{
				name: 'selectdna'
				template: templates.selectdna
				view: require './selectdna/logic.coffee'
				'menu-item': '#menu-selectdna'
			}

			{
				name: 'skewanalyze'
				template: templates.skewanalyze
				view: require './skewanalyze/logic.coffee'
				'menu-item': '#menu-skew'
			}

		])

		@app = new App
			collection: pages



	routes:

		'': 'home'
		'skewanalyze': 'skewanalyze'
		'selectdna': 'selectdna'
		'selectdna-:collapse': 'nothing'
		# 'selectdna/download/:id': 'download...'
		# 'selectdna/select/:id': 'download...'

	nothing: ->
		return false

	home: ->
		@app.render 'home'

	selectdna: ->
		@app.render 'selectdna'


	skewanalyze: ->

		@app.render 'skewanalyze'







do ->

	window.router = new Router()


	Backbone.history.start({ pushState: true, root: '/' })

	$(document).on 'click', 'a:not([data-bypass])', do (router) -> (evt) ->

		href = $(this).attr('href')
		protocol = this.protocol + '//'

		if href is 'no-nav'
			evt.preventDefault()
			return false

		if href.slice(protocol.length) isnt protocol
			evt.preventDefault()
			router.navigate(href, true)




