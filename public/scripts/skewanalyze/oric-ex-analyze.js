

function clearAreas (areas, ws) {

	if ( ! areas.length ) return false;

	var prev = areas[0];

	var i = 1;
	while ( i < areas.length ) {

		a = areas[i];

		if (a.type === prev.type && prev.bp_index + ws > a.bp_index) {
			areas.splice(i, 1);
		} else {
			i++;
		}

		prev = a;

	}

	return areas;

}


function calculateOrigins (tangents, window_size, inclanation_sample_frequency, threshold) {
	/*/

	What this should do:

	/*/

	console.log(threshold);

	var split_window = Math.ceil(window_size / 2),
		samples_length = Math.floor(split_window / inclanation_sample_frequency);


	// MAY BE SUBJECT TO CHANGE, CHANGE THE VALUES OF overlap_multipl
	// old default was 3
	var overlap_multipl = 5;
	for (var i = 0; i < overlap_multipl * samples_length; i++) {
		tangents.push(tangents[i]);
	}


	var data = [];

	var approx_areas = [];

	var diff_map = [];

	for (var i = samples_length, len = tangents.length - samples_length; i < len; i++) {

		var ks1 = 0;
		for (var c = -1 * samples_length; c < 0; c++) { // window

			// 4 - 4 = 0
			// 4 - 3 = 1
			// 4 - 2 = 2
			// 4 - 1 = 3

			var tn = tangents[i + c]
			ks1 += tn.k

		}
		var average_k1 = ks1 / samples_length;


		// when c >= 0 second sample window

		var ks2 = 0;
		for (var c = 0; c < samples_length; c++) { // window
			// 4 - 0 = 4
			// 4 + 1 = 5
			// 4 + 2 = 6
			// 4 + 3 = 7


			var tn = tangents[i + c]
			ks2 += tn.k

		}
		var average_k2 = ks2 / samples_length;

		var minimum = (average_k2 > 0 && average_k1 < 0),
			maximum = (average_k2 < 0 && average_k1 > 0);

		if ( minimum || maximum ) {

			// var diff = Math.PI - (Math.abs(Math.atan(average_k2)) + Math.abs(Math.atan(average_k1)));
			// diff_map.push({
			// 	diff: diff,
			// 	isf_index: i
			// });

			var diff = Math.abs(average_k2 - average_k1);

			if (diff > threshold) {
				approx_areas.push({
					isf_index: i,
					bp_index: i * inclanation_sample_frequency,
					diff: diff,
					k1: average_k1,
					k2: average_k2,
					type: minimum ? "minimum" : "maximum"
				});
			}
			
		}

	}




	return clearAreas(approx_areas, window_size);

}