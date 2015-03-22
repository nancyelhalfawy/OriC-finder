var getMostFreq, patternMatching, reverseComplement, uniq;

uniq = function(a) {
	var objs, prims;
	prims = {
		"boolean": {},
		"number": {},
		"string": {}
	};
	objs = [];
	return a.filter(function(item) {
		var type;
		type = typeof item;
		if (type in prims) {
			if (prims[type].hasOwnProperty(item)) {
				return false;
			} else {
				return prims[type][item] = true;
			}
		} else {
			if (objs.indexOf(item) >= 0) {
				return false;
			} else {
				return objs.push(item);
			}
		}
	});
};

getMostFreq = function(text, k) {
	var counts, i, item, j, key, keys, largest, ref, val, values;
	counts = {};
	for (i = j = 0, ref = text.length; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
		val = text.substr(i, k);
		counts[val] = counts[val] ? counts[val] + 1 : 1;
	}
	values = ((function() {
		var results;
		results = [];
		for (key in counts) {
			val = counts[key];
			results.push({
				val: val,
				key: key
			});
		}
		return results;
	})()).sort(function(a, b) {
		return a.val - b.val;
	});
	largest = values.filter(function(el) {
		return el.val === values[values.length - 1].val;
	});
	return keys = (function() {
		var l, len, results;
		results = [];
		for (l = 0, len = largest.length; l < len; l++) {
			item = largest[l];
			results.push(item.key);
		}
		return results;
	})();
};

reverseComplement = function(string) {
	var complements, i, j, len, newString;
	complements = {
		"a": "t",
		"t": "a",
		"g": "c",
		"c": "g"
	};
	string = string.toLowerCase();
	newString = "";
	for (j = 0, len = string.length; j < len; j++) {
		i = string[j];
		newString = newString = complements[i] + newString;
	}
	return newString.toUpperCase();
};

patternMatching = function(text, pattern) {
	var index, indexes, offset, run;
	indexes = [];
	run = true;
	index = text.indexOf(pattern);
	offset = 0;
	while (index > -1) {
		indexes.push(index + offset);
		text = text.substr(index + 1);
		offset += index + 1;
		index = text.indexOf(pattern);
	}
	return indexes;
};