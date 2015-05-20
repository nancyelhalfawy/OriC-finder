
class HomeView extends Backbone.View

	rendered: false 

	render: (sandbox) ->

		if not @rendered
			@$el.html('Welcome to the home page!');
			@rendered = true




class Home extends Backbone.Model

	id: 'home'

	initialize: ->

		@view = new HomeView()

		@on 'render', @render, @

	render: (sandbox) ->

		@view.setElement sandbox.element
		@view.render(sandbox)

		# console.log sandbox.element, sandbox.global, sandbox.args


module.exports = new Home()



