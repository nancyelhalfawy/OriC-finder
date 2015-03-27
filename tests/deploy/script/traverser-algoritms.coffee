


namespace = (start_point, string) ->
	ns = string.split('')
	b = tree
	
	for p, index in ns
		if b.branches.hasOwnProperty p
			b = b.branches[p]
		else
			b.branches[p] = 
				spts: []
				branches: {}
				value: p
			b = b.branches[p]

		spts = index + start_point
		b.maxspts = spts
		b.spts.push spts
	
	return tree[ns[0]]

class EventListener

	funcs: []

	listen: (f, context = null) ->
		@funcs.push { func: f, context: context }
		return @funcs.length - 1

	dismiss: (i) ->
		@funcs[i] = false

	walk: (n = 1) ->
		for i in [0...n]
			for f in @funcs when f
				f.func.call f.context


reverseComplement = (string) ->

	complements =
		"A": "T"
		"T": "A"
		"G": "C"
		"C": "G"

	ns = ""
	ns = complements[i] + ns for i in string
	ns




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
				spt = spt - k
				if spt < traverser.start_point - input.window_size then continue
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
			if sequences[i-1].spt > sequence.spt - k
				if not groups[gindex] then groups.push([])
				groups[gindex] = groups[gindex].concat [sequence, sequences[i-1]]
			else
				groups[gindex] = _.uniq(groups[gindex])
				# gindex++
				groups[gindex++] = [sequence]

		return groups




	clean: =>
		# debugger
		console.log @max
		@max_candidates = _.reject @max_candidates, (candidate) =>
			candidate.rank < @max




class Traverser

	constructor: (@sequence, @start_point, threshold = 1, @reverse_complement = false) ->

		@paths = []

		@distance_traveled = 0
		base_tollerance = threshold + 1

		@commander_id = traverseCommander.listen @walk, @

		for bp, subpath of tree.branches
			# if @isOutOfRange subpath.maxspts then continue

			@spawn
				tollerance: if @isTollerated bp then base_tollerance else base_tollerance - 1
				subpath: subpath.branches
				bp: bp
				spts: subpath.spts
				stroll: [bp]

		# if @start_point is 2 then debugger


	isOutOfRange: (maxspts, stroll) ->
		# consider removing " and maxspts < @start_point - @distance_traveled" or changing
		# it is suposed to eliminate intersecting sequence matching
		lower = maxspts < @start_point - input.window_size

		# (maxspts >= @start_point) or 
		upper = @start_point < k
		# debugger
		# if @commander_id is 354 then debugger
		# if not upper and not lower then debugger
		lower or upper

	isTollerated: (bp) ->
		@sequence[@distance_traveled] is bp

	spawn: (ob) ->
		@paths.push ob


	walk: ->

		@distance_traveled++

		deletion = []

		for path, index in @paths

			path.delete = true

			for bp, subpath of path.subpath #spawn the sub branches
				if @isOutOfRange subpath.maxspts, path.stroll.join('') then continue
				ts = 
					tollerance: if @isTollerated bp then path.tollerance else path.tollerance - 1
					subpath: subpath.branches
					bp: bp
					spts: subpath.spts
					stroll: path.stroll.concat(bp)
				@spawn ts


		@paths = _.reject @paths, (ob) -> !!ob.delete

		@validatePaths()

		if @distance_traveled >= k - 1
			@end()


	validatePaths: ->
		deletion = []
		for path, index in @paths when path.tollerance <= 0
			path.delete = true

		@paths = _.reject @paths, (ob) -> !!ob.delete



	end: ->
		filter.push @

		traverseCommander.dismiss @commander_id


	
