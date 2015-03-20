
express = require 'express'
router = express.Router()

GenBank = require '../modules/genome-download'

genBank = new GenBank()


router.get /^(?:\/(?=$))?$/i, (req, res) ->

	genBank.initialize -> genBank.connect -> @getListing (folders) ->

		res.json(folders)

		@exit()


router.get /^\/([^\\/]+?)(?:\/(?=$))?$/i, (req, res) ->
	id = req.params['0']
	genBank.initialize -> genBank.connect -> @getGenome id, (data) ->

		@exit()

		if not data
			res.status 404
			res.send 'not found!'
		else
			res.send(data)








module.exports = router