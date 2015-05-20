
path = require 'path'

module.exports = do -> class Menu extends Backbone.View

	el: '#main-menu'

	setRouter: (@router) ->
		@router.on 'route', (name) =>
			if _.has(@menu_links, name)
				@$el.find(".active-menu").removeClass('active-menu')
				@$el.find("##{name} a").addClass('active-menu')
				$('.main-app-header .page-header').html @menu_links[name]



	menu_links: {}

	render: ->

		levels = ['first', 'second', 'third']

		dataLoop = (o, base_el, level) =>

			for key, val of o when _.has(o, key)

				href = val['href']

				icon = if not val['icon'] then "" else val['icon']

				el = $("<li id='#{key}'><a href='##{href}'><i class='fa #{icon}'></i>#{val['title']}</a></li>")
				base_el.append el

				if _.has(val, "menu-items")

					el.addClass 'has-children'

					el.find('a').append($('<span class="fa arrow"></span>')).attr('href', 'no-link')

					nbel = $('<ul class="nav nav-' + levels[level] + '-level collapse"></ul>')
					el.append nbel

					dataLoop val['menu-items'], nbel, level + 1

				else
					@menu_links[key] = val['title']


		dataLoop @data, @$el, 1

		@$el.metisMenu();

		@restrictLinks()

	restrictLinks: ->
		@$el.delegate("a", "click", (evt) ->
			# Get the anchor href and protcol
			href = $(this).attr("href")
			protocol =  "#{this.protocol}//"

			# Ensure the protocol is not part of URL, meaning its relative.
			# Stop the event bubbling to ensure the link will not cause a page refresh.
			if href.slice(protocol.length) != protocol
				evt.preventDefault()

			# Note by using Backbone.history.navigate, router events will not be
			# triggered.  If this is a problem, change this to navigate on your
			# router.
			if href isnt 'no-link'
				Backbone.history.navigate(href.replace(/\#/g, ''), true)
		)


	create: (@data) -> @render()
