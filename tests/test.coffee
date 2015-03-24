

DNA = "CGGACTCGACAGATGTGAAGAACGACAATGTGAAGACTCGACACGACAGAGTGAAGAGAAGAGGAAACATTGTAA"
# DNA = "ATTA"

reverseComplement = (string) ->
	complements =
		"a": "t"
		"t": "a"
		"g": "c"
		"c": "g"

	string = string.toLowerCase()

	newString = ""

	for i in string
		newString = newString = complements[i] + newString

	newString.toUpperCase()

hammingDistance = (q1, q2) ->
	dist = 0
	for val, i in q1
		if val isnt q2[i] then dist++
	return dist


f = (dna, k, t) ->

	mers = {}

	for i in [0...dna.length-k]

		str = dna.substr i, k
		if not mers[str] then mers[str] = 1 else mers[str]++


	return mers




class Tree

	tree: {}
	kmers: {}
	linear_tree: []

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
						mers.push (v + key)

		traverse @tree, ""
		return mers

			

	extend: (name, index) ->

		ns = name.split('')
		o = @tree

		i = 0
		len = ns.length

		if not @kmers.hasOwnProperty len then @kmers[len] = {}
		if not @kmers[len].hasOwnProperty name then @kmers[len][name] = 0

		@kmers[len][name]++

		for i in [0...len]

			bob = 
				num: 1
				level: len
				bp_indexes: [index + i]

			if not @linear_tree[i] then @linear_tree[i] = {}

			if (i is len-1) and o[ns[i]]

				o[ns[i]].num++
				o[ns[i]].bp_indexes.push index + i

				@linear_tree[i][ns[i]].num = o[ns[i]].num
				@linear_tree[i][ns[i]].bp_indexes = o[ns[i]].bp_indexes


			else if o[ns[i]]
				o = o[ns[i]]
			else

				o = o[ns[i]] = bob

				@linear_tree[i][ns[i]] = bob


		return o



	add: (str) ->
		for i in [0...str.length]
			p = str.substr i, str.length
			@extend p, i

	grow: ->
		for i in [1..@DNA.length]
			p = @DNA.substr 0, i
			@add p
	


tree = new Tree(DNA)
tree.grow()
# console.log f(DNA, 9)
t = tree.getTree()

console.log tree.linear_tree
console.log t






