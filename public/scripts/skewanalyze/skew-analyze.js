

self.addEventListener('message', function (ev) {

	var genome = ev.data.lines,
		speed = ev.data.speed,
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
		dp_num = Math.round((i_len * 7) / 100);


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

			l++;
		}
	};


	var post = function () {
		self.postMessage({
			data: datap,
			min: min,
			max: max,
			length: l,
			progress: Math.round(l / (i_len * 7) * 10)
		});
	};

	var snclose = function () {

		self.postMessage({ data: datap, min: min, max: max, length: l, done: true });

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