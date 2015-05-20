
class LinksView extends Backbone.View

	rendered: false 

	render: (sandbox) ->

		if not @rendered
			@$el.html('Welcome to the LINKS page!');
			@rendered = true




class Links extends Backbone.Model

	id: 'links'

	initialize: ->

		@view = new LinksView()

		@on 'render', @render, @

	render: (sandbox) ->

		@view.setElement sandbox.element
		@view.render(sandbox)

		# console.log sandbox.element, sandbox.global, sandbox.args


module.exports = new Links()



