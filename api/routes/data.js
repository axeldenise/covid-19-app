/*
** FANGORN PROJECT, 2020
** Covid-19
** File description:
** [file description here]
*/

const express = require('express')
const router = express.Router()
const covid = require('../controllers/data.js')

router.get('/data', (req, res) => {
	covid.getCovidData(req, res)
});

module.exports = router