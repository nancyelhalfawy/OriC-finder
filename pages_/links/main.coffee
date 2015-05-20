
class LinksView extends Backbone.View

	rendered: false 

	render: (sandbox) ->

		if not @rendered
			@$el.html("""
				<p><a href="http://www.ncbi.nlm.nih.gov/genbank/">GenBank</a></p>
				<p><a href="http://en.wikipedia.org/wiki/GC_skew">GC Skew explanation</a></p>
				<p><a href="http://en.wikipedia.org/wiki/Prokaryotic_DNA_replication">Prokaryotic DNA replication explanation</a></p>

			""");
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



