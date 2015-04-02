
mainWorker = new Worker('./build/traverser.js')
filterWorker = new Worker('./build/filter-worker.js')
traverserWorker = new Worker('./build/traverser-worker.js')



end = (data) ->
	console.log data

mainWorker.addEventListener 'message', (ev) ->

	message = ev.data.message
	data = ev.data.data

	switch message

		when 'traverse-init' then traverserWorker.postMessage
			message: 'traverse-init'
			data: data
		when 'traverse' then traverserWorker.postMessage
			message: 'traverse'
			data: data 
		when 'walk' then traverserWorker.postMessage
			message: 'walk'
			data: data
		when 'request-filter-return' then filterWorker.postMessage
			message: 'filter-return'


is_ended = 0
done_count = 0
last_kmers = 0
interval_check = setInterval (->
	if is_ended is 0 then done_count++ else done_count = 0
	if done_count > 20

		console.log 'almost done'

		last_kmers++
		if last_kmers is 1
			is_ended = 0
			done_count = 0
			traverserWorker.postMessage
				message: 'walk'
				data:
					times: data.k
		else if last_kmers is 2
			console.log 'absolutly done'
			window.clearInterval interval_check
			filterWorker.postMessage message: 'filter-return'

), 100

percent = 0
perinterval = setInterval (->
	val = Math.round((percent / data.dna_length) * 100)
	console.log val, "%"

	if val is 100 then window.clearInterval perinterval

), 1000

filterWorker.addEventListener 'message', (ev) ->

	message = ev.data.message
	data = ev.data.data

	switch message

		when 'filter-return' then end data
		when 'filtered-one' then is_ended--



traverserWorker.addEventListener 'message', (ev) ->

	message = ev.data.message
	data = ev.data.data

	switch message
		when 'filter-push'
			is_ended++
			# bullshit
			percent += 0.5
			# end of bullshti
			filterWorker.postMessage
				message: 'filter-push'
				data: data
		when 'filter-init' then filterWorker.postMessage
			message: 'filter-init'
			data: data

window.go1 = ->
	traverserWorker.postMessage	
		message: 'walk'
		data:
			times: 9
window.go2 = ->
	filterWorker.postMessage
		message: 'filter-return'
window.go3 = ->
	clearInterval x


data =
	window_size: 500
	mutation_threshold: 2
	k: 9
	DNA:
		line_length: 70
		lines: [
			"CGCAGGTTGAGTTCCTGTTCCCGATAGATCCGATAAACCCGCTTATGATTCCAGAGCTGTCCCTGCACAT",
			"TGCGCAGATACAGGAAACACAGACCAAATCCCCATCTCCTGTGAGCCTGGGTCAGTCCCACCAGAAGAGC",
			"GGCAATCCTGTCGTTCTCCGCTGCCAGTCGCGGACGATAGCGAAAGCAGGTCTCGGATATCCCAAAAATC",
			"CGACAGGCCAGCGCAATGCTGACCCCATGATGCGCCACAGCTTGTGCGGCCAGTTCCCGGCGCTGGGCTG",
			"GCCGCTTCATTTTTTTCCAAGGGCTTCCTTCAGGATATCCGTCTGCATGCTCAAATCCGCATACATGCGC",
			"TTCAGCCGACGGTTCTCCTCTTCCAAAGCCTTCATCTGACTGATCATCGAAGCATCCATGCCGCCATATT",
			"TCGCGCGCCACCGGTAAAACGTGGCGTTGCTGATCCCATGCTCCCGACACAGGTCAGGAACCGGGACACC",
			"GCCCTCAGCCTGGCGGATCACACCCATGATCTGGGCGTCAGTAAAGCGATCACTCTTCATCAGAATCTCC",
			"TCAATTCTTACGCTGAGAAAATTCTCATTCAAAAGTCACTCTTTTTATGGGGGGATTACCCGCTGTCTGG",
			"AACAGGTTATGGAGTGGCGCGGCAGGCCAGAAGCCATCCGAATGGATAATGGCCCTGAATATGTCAGTCA",
			"CATGGCGGACAGGCTTTTGGATGGACGCGCTTTTCGGCTCCTGAACATCCTGGATGAGTTCAATCGTGAA"]


dna_length = data.DNA.line_length * (data.DNA.lines.length - 1) + data.DNA.lines[data.DNA.lines.length - 1].length
data.dna_length = dna_length

mainWorker.postMessage data
