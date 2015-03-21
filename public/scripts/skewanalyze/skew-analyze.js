

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
		i = 0,
		i_len = genome.length - 1;


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

			l++;
		}
	};

	if (speed === 'uncapped') {

		for (; i < i_len; i++) {

			inner(i);

			if (i % 500 === 0) {
				self.postMessage({ data: data, min: min, max: max, length: l });
			}
		}

	} else {

		speed = Number(speed);

		setInterval( function () {

			inner(i);

			i++;

			if (i % speed === 0) {
				self.postMessage({ data: data, min: min, max: max, length: l });
			}

		}, 1000 / speed );
	}

	self.postMessage({ data: data, min: min, max: max, length: l });

	self.close();
	// setInterval(f, 1000)

});