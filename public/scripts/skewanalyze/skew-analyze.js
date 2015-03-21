
importScripts('oric-ex-analyze.js');

self.addEventListener('message', function (ev) {

	var genome = ev.data.lines,
		speed = ev.data.speed,
		bp_length = ev.data.bp_length,
		window_size = ev.data.window_size,
		threshold = ev.data.threshold,
		inclanation_sample_frequency = ev.data.inclanation_sample_frequency,

		buffer = 0,
		min = {
			val: 0,
			index: []
		},
		max = {
			val: 0,
			index: []
		},

		l = 0,
		data = [],
		datap = [],
		i = 0,
		i_len = genome.length - 1,

		dp_num = Math.round((i_len * 7) / 100),

		last_tanget,
		x1 = 0,
		y1 = 0,
		x2 = 0,
		y2 = 0,
		inclanation = 0,
		tangents_first = {
			x2: 0,
			y2: 0
		},
		tangents = [];


	var inner = function (i) {
		var c = 0,
			c_len = genome[i].length;

		for (; c < c_len; c++) {

			if (genome[i][c] === 'G') {
				buffer++;
			} else if (genome[i][c] === 'C') {
				buffer--;
			}

			if (buffer < min.val) {
				min.val = buffer;
				min.index = [];
			}

			if (buffer === min.val) {
				min.index.push(l);
			}

			if (buffer > max.val) {
				max.val = buffer;
				max.index = [];
			}

			if (buffer === max.val) {
				max.index.push(l);
			}

			data.push([l, buffer]);
			if (l % 1000 === 0) {
				datap.push([l, buffer]);
			}


			if (l > 0 && l % inclanation_sample_frequency === 0) {

				last_tanget = tangents.length === 0 ? tangents_first : tangents[tangents.length - 1];

				x1 = last_tanget.x2;
				y1 = last_tanget.y2;
				x2 = l;
				y2 = buffer;

				inclanation = (y2 - y1) / (x2 - x1);

				tangents.push({
					k: inclanation,
					x1: x1,
					y1: y1,
					x2: x2,
					y2: y2
				});
			}

			l++;
		}
	};


	var post = function () {
		self.postMessage({
			data: datap,
			min: min,
			max: max,
			length: l,
			progress: Math.round(l / bp_length * 100)
		});
	};

	var snclose = function () {

		self.postMessage({
			data: datap,
			min: min,
			max: max,
			length: l,
			done: true,
			window_size: window_size,
			origins: calculateOrigins(tangents, window_size, inclanation_sample_frequency, threshold)
		});

		self.close();

	};

	if (speed === 'uncapped') {

		for (; i < i_len; i++) {

			inner(i);

			if (i % dp_num === 0) {
				post();
			}
		}

		snclose();

	} else {

		speed = Number(speed);

		var id = setInterval( function () {

			if (i < i_len) {

				if (i % speed === 0) {
					post();
				}

				inner(i);

				i++;

			} else {

				clearInterval(id);

				snclose();

			}


		}, 1000 / speed );
	}

	// setInterval(f, 1000)

});