JSFtp = require 'jsftp'
_ = require 'underscore'
mkdirp = require 'mkdirp'

ftp = new JSFtp
	host: 'ftp.ncbi.nlm.nih.gov'
	# pass: 'noobtoothfairy@gmail.com'

fs = require 'fs'
async = require 'async'
carrier = require 'carrier'


class Genomes
	constructor: (@ftp = ftp) -> @

	initialize: (cb) ->

		mkdirp "public/cache/gen-db/", =>

			fs.readFile 'public/cache/gen-db/listing.json', 'utf8', (err, data) =>

				if err
					@folders = {}
				else
					try
						@folders = JSON.parse(data)
					catch e
						# ...
					

				cb.call @


	connect: (cb) ->

		@ftp.auth null, null, =>


			cb.call @

	updateListingCache: ->
		fs.writeFile 'public/cache/gen-db/listing.json', JSON.stringify(@folders), (err) ->

	getFolder: (id) ->
		_(@folders).findWhere({ id: id })


	downloadListing: (callback) => # update the cache for the listing.json


		@ftp.ls 'genomes/Bacteria', do (callback) => (err, files) =>

			@folders = _.chain(files).where({type: 1}).map( (fldr) ->

				name_frags = _(fldr.name.split('_')).filter (frg) ->
					frg.match(/[0-9]/) is null and frg.match(/[A-Z]{2,}/) is null


				name = name_frags.join ' '
				name = name.replace(/^\s+|\s+$/g, '')

				return {
					name: name
					id: fldr.name
					searched: false
				}

			).value()

			@updateListingCache()

			callback.call @, @folders

	downloadGenome: (id, cb) => # update the cache by adding search: true

		console.log 'downloading ' + id

		if @folders is {}
			return @downloadListing do -> (id, cb) ->
				@downloadGenome(id, cb)

		folder = @getFolder id

		if not folder then return cb(false)
		if folder.searched then return cb(id + "/" + folder.genomeFNA)

		@ftp.ls "genomes/Bacteria/#{id}", (err, folder_files) =>

			fna = _(folder_files).find (fff) -> fff.name and fff.name.split('.')[1] is 'fna'
			fna = fna?.name

			result = if fna then fna else false

			folder.remoteFNA = fna
			folder.localFNA = "dna.fna"
			folder.localJSON = "dna.json"
			folder.fnaPath = id + "/" + folder.localFNA
			folder.jsonPath = id + "/" + folder.localJSON
			folder.searched = true

			@updateListingCache()

			if result
				fpath = "public/cache/gen-db/#{id}/"
				mkdirp fpath, =>
					ftp.get "genomes/Bacteria/#{id}/#{folder.remoteFNA}", fpath + folder.localFNA, (err) =>
						@fnaToJSON id, cb
			else 
				cb.call @, result

	fnaToJSON: (id, callback) ->

		fpath = "public/cache/gen-db/#{id}/"

		input = fpath + 'dna.fna'
		output = fpath + 'dna.json'

		lines = fs.readFileSync(input).toString().split('\n')
		len = lines.length - 1 # last line is empty
		last_line_i = len - 1
		last_line = lines[last_line_i]

		console.log lines.length

		infoString = (line) ->

			info = line.split('|')
			description = info[info.length - 1].replace(/^\s+|\s+$/g, '')
			"{\"description\": \"#{description}\", \"lines\": [\n"


		editLine = (line) -> "\"#{line}\""
		editLineEnding = ",\n"

		outLine = =>
			bp_len = last_line.replace(/\s/g, "").length + (last_line_i - 1) * 70

			folder_text = (JSON.stringify @getFolder(id)).substr 1
			"], \"lines_length\": #{last_line_i}, \"bp_length\": #{bp_len}, #{folder_text}"

		fs.appendFileSync output, infoString(lines[0])

		for index in [1...last_line_i]
			line = lines[index]
			fs.appendFileSync output, editLine(line) + editLineEnding

		fs.appendFileSync output, editLine(last_line)

		fs.appendFileSync output, outLine()


		callback.call @, id



	getListing: (cb) => # download if not cached or use the cache and return it

		if _.isEmpty(@folders) 
			return @downloadListing do (cb) -> ->
				@getListing cb


		fs.readFile 'public/cache/gen-db/listing.json', 'utf8', (err, data) =>
			cb.call @, JSON.parse(data)


	getGenome: (id, cb) => # download if not cached or use the cache and return it

		if _.isEmpty(@folders) then return @downloadListing do (id, cb) -> ->
			@getGenome id, cb

		folder = @getFolder id

		if not folder.searched then return @downloadGenome id, do (id, cb) -> ->
			@getGenome id, cb

		fs.readFile "public/cache/gen-db/#{folder.jsonPath}", 'utf8', (err, data) =>
			cb.call @, data


	cleanseCache: ->
		bacteria = _(@folders).reject (fldr) ->
			fldr.genome is false or fldr.searched is false

		@updateListingCache()


	exit: ->

		@ftp.raw.quit ->


module.exports = Genomes

