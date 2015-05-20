window.underscore = window._ = _ = require 'underscore'
window.Backbone = Backbone = require 'backbone'
window.jQuery = window.$ = Backbone.$ = require 'jquery'

hbs = require 'hbs'

require './lib/backbone-deep-model.min.js'
require 'bootstrap'
require './lib/metris.jquery.js'





util = require './util.coffee'
__templates = require('../build/templates.js')(hbs.handlebars)
templates = {}

for namespace, tmpl of __templates

	util.createNamespace templates, namespace, tmpl









$(window).bind "load resize", () ->
	if $(@).width() < 768
		$('div.sidebar-collapse').addClass('collapse')
	else
		$('div.sidebar-collapse').removeClass('collapse')


config = require './config.coffee'

Router = require('./js/router.coffee')
Pages = require('./js/pages.coffee')
Menu = require('./js/menu.coffee')

router = new Router()
menu = new Menu()
pages = new Pages()

pages.setTemplates templates
menu.setRouter router

config
	router: router
	pages: pages
	menu: menu


