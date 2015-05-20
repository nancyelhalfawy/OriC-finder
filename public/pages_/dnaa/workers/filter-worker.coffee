
_ = require 'underscore'


global = {}

class CandidateFilter

	max_candidates: []

	constructor: -> 
		_.bind @clean, @
		@

	max: 0

	push: (traverser) ->

		if traverser.paths.length >= @max
					
			candidate = @createCandidate traverser

			if candidate.sequences.length > @max
				@max++
				@max_candidates = _.filter @max_candidates, (candidate) ->
					candidate.rank >= @max


			# if candidate.rank is 3 then debugger
			@max_candidates.push candidate

	createCandidate: (traverser) ->

		candidate =
			reverse_complement: traverser.reverse_complement


		candidate.sequences = @ftptcs traverser
		candidate.rank = candidate.sequences.length

		return candidate

	fromTraverserPathToCandidateSequence: (args...)->
		@ftptcs args...

	ftptcs: (traverser) ->

		sequences = [{ seq: traverser.sequence, spt: traverser.start_point }]

		for path in traverser.paths
			for spt, i in path.spts
				spt = spt - global.input.k
				if spt < traverser.start_point - global.input.window_size then continue
				sequence =
					seq: path.stroll.join("")
					spt: spt
				sequences.push sequence

		sequences.sort (a, b) ->
			a.spt - b.spt

		sequences = @groupOverlaps sequences

		return sequences

	groupOverlaps: (sequences) ->
		groups = []
		gindex = 0
		for sequence, i in sequences by -1 when i > 0
			if sequences[i-1].spt > sequence.spt - global.input.k
				if not groups[gindex] then groups.push([])
				groups[gindex] = groups[gindex].concat [sequence, sequences[i-1]]
			else
				groups[gindex] = _.uniq(groups[gindex])
				# gindex++
				groups[gindex++] = [sequence]

		return groups




	clean: =>
		# debugger
		@max_candidates = _.reject @max_candidates, (candidate) =>
			candidate.rank < @max




filter = new CandidateFilter()


done = (self) ->

	filter.clean()

	self.postMessage
		message: 'filter-return'
		data:
			candidates: filter.max_candidates


module.exports = (self) -> self.addEventListener 'message', (ev) ->

	data = ev.data.data
	message = ev.data.message

	switch message
		when 'filter-init'
			global.input = data.input
			@max_filter = global.input.dna_length * 2 - global.input.k * 2

		when 'filter-push'
			filter.push data

			self.postMessage message: 'filtered-one'

		when 'filter-return' then done(self)




