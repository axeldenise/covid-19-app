/*
** FANGORN PROJECT, 2020
** Area	
** File description:
** Index de l'API
*/

//Chargement des composantes principales de l'API
const express = require('express')
const bodyParser = require('body-parser')
const cors = require('cors')
const covidData = require('./controllers/data.js')
const app = express()

//Definition du port sur lequel l'API écoute
const port = 8080

//Chargement des objets contenant les différentes routes
const covid = require('./routes/data.js')

//Chargement Controlleur
var covidControlleur = require('./controllers/data.js')

app.use(bodyParser.json())
app.use(cors())

//Definition des principales routes
app.use('/covid', covid)

covidData.fetchCovidData()
var inter = setInterval(covidData.fetchCovidData, 3600000)

app.listen(port)

module.exports = app