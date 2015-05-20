

_ = require 'underscore'



namespace = (start_point, string) ->
	ns = string.split('')
	b = global.tree
	
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
	
reverseComplement = (string) ->

	complements =
		"A": "T"
		"T": "A"
		"G": "C"
		"C": "G"

	ns = ""
	ns = complements[i] + ns for i in string
	ns

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



class Traverser

	constructor: (@sequence, @start_point, threshold = 1, @reverse_complement = false) ->

		@paths = []

		@distance_traveled = 0
		base_tollerance = threshold + 1

		@commander_id = global.traverseCommander.listen @walk, @

		for bp, subpath of global.tree.branches
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
		lower = maxspts < @start_point - global.input.window_size

		# (maxspts >= @start_point) or 
		upper = @start_point < global.input.k
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

		if @distance_traveled >= global.input.k - 1
			@end()


	validatePaths: ->
		deletion = []
		for path, index in @paths when path.tollerance <= 0
			path.delete = true

		@paths = _.reject @paths, (ob) -> !!ob.delete



	end: ->

		# filter.push @
		@self.postMessage
			message: 'filter-push'
			data: 
				paths: @paths
				reverse_complement: @reverse_complement
				sequence: @sequence
				start_point: @start_point


		global.traverseCommander.dismiss @commander_id





global = {}

class Algorithms
	
	constructor: (@global, self) ->
		global = @global
		@Traverser::self = self

	Traverser: Traverser
	EventListener: EventListener
	namespace: namespace
	reverseComplement: reverseComplement



module.exports = Algorithms



