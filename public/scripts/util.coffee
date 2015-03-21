
_ = require 'underscore'



createNamespace = (container, name, val) ->

	ns = name.split('.')
	o = container || window

	i = 0
	len = ns.length

	for i in [0...len]
		v = if (i is len-1 and val) then val else {}
		o = o[ns[i]] = o[ns[i]] || v


	return o

getNamespace = (container, name) ->

	ns = name.split('.')
	o = container || window

	i = 0
	len = ns.length

	for i in [0...len]
		o = o[ns[i]]

	return o

resetLocalStorage = (saves) ->
	s = {}
	for i in saves
		s[i] = window.localStorage.getItem i

	window.localStorage.clear()

	for key, val of s
		window.localStorage.setItem key, val

saveDNA = (dna) ->


	s = window.localStorage

	id = s.getItem 'dna-id'
	base = "DNA:#{dna.id}"


	resetLocalStorage ['dna-id', "DNA:#{id}:meta"]


	s.setItem "#{base}:meta", JSON.stringify _.omit(dna, 'lines')



	if dna.lines_length < 12000

		for l, i in dna.lines
			s.setItem "#{base}:line:#{i}", l

getDNA = (id) ->


	s = window.localStorage

	base = "DNA:#{dna.id}:"

	dna = JSON.parse s.getItem("#{base}:meta")
	dna.lines = []

	for i in [0...dna.lines_length]
		content = s.getItem "#{base}:line:#{i}"
		dna.lines.push content

	return dna


getSelectedDNAMeta = ->

	id = window.localStorage.getItem 'dna-id'

	if id
		dna = window.localStorage.getItem "DNA:#{id}:meta"
		if dna
			return JSON.parse dna

	return false


storage =

	db: {}

	get: (what) ->
		getNamespace @db, what
	set: (what) ->
		createNamespace @db, what

module.exports = {

	getNamespace: getNamespace
	createNamespace: createNamespace
	localStorage:
		saveDNA: saveDNA
		getDNA: getDNA
	getSelectedDNAMeta: getSelectedDNAMeta
	storage: storage
	
	getOrdinal: (n) ->
		s = ["th","st","nd","rd"]
		v = n % 100
		n+(s[(v-20)%10]||s[v]||s[0])
}