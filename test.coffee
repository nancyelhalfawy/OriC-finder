

DNA = "CGGACTCGACAGATGTGAAGAACGACAATGTGAAGACTCGACACGACAGAGTGAAGAGAAGAGGAAACATTGTAA"
# DNA = "ATTA"


class Tree

	tree: {}
	kmers: {}

	constructor: (@DNA) -> @

	getTree: -> @tree

	getKmers: (k) ->

		mers = []
		traverse = (b, v) ->
			for key, val of b
				if key isnt 'num' and key isnt 'level'
					if val.level < k
						traverse val, v + key
					else
						mers.push v + key

		traverse @tree, ""
		return mers

			

	extend: (name) ->

		ns = name.split('')
		o = @tree

		i = 0
		len = ns.length

		if not @kmers.hasOwnProperty len then @kmers[len] = {}
		if not @kmers[len].hasOwnProperty name then @kmers[len][name] = 0

		@kmers[len][name]++


		for i in [0...len]

			if (i is len-1)
				if not o[ns[i]] then o[ns[i]] = {num: 1, level: len}
			else
				if o[ns[i]]
					o[ns[i]].num++
					o = o[ns[i]]
				else
					o = o[ns[i]] = {num: 1, level: len}

		return o



	add: (str) ->
		for i in [0...str.length]
			p = str.substr i, str.length
			@extend p

	grow: ->
		for i in [1..@DNA.length]
			p = @DNA.substr 0, i
			@add p
	


tree = new Tree(DNA)
tree.grow()
console.log tree.getKmers(50)
# console.log tree.tree






