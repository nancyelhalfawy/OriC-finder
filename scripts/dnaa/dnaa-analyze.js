
importScript('dnaa-algorithms.js');

function getDnaA(text) {
	

}


self.addEventListener('message', function (ev) {

	var dna = ev.data,
		dna_length = dna.length,
		origins = dna.origins,
		genome = dna.genome,
		window_size = dna.window_size,
		split_window = Math.ceil(window_size / 2);


	/*
		origin:
			bp_index: 188500
			diff: 0.03063157894736843
			isf_index: 1885
			k1: -0.023684210526315797
			k2: 0.006947368421052632
			type: "minimum"
	*/

	function getDna(pos) {

		var start_rest = pos.start % 70,
			end_rest = pos.end % 70,

			start_row = (pos.start - start_rest) / 70,
			end_row = (pos.end - end_rest) / 70,

			text = genome[start_row].substr(start_rest);

		for (var i = start_row + 1; i < end_row; i++) {
			text += genome[i];
		}

		text += genome[end_row].substr(0, end_rest);

		return text;
	}

	var data = [];


	for (var i = 0; i < origins.length; i++) {
		var start = origins[i].bp_index - split_window,
			end = origins[i].bp_index + split_window;

		var string = getDNA({
			start: start,
			end: end
		});

		data.push({
			DnaA: getDnaA(string)
			start: start,
			end: end
		});

	}


	return data;





});