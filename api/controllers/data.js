/*
** FANGORN PROJECT, 2020
** Covid-19
** File description:
** [file description here]
*/

const csv = require('csv-parser')
const fs = require('fs')
const githubContent = require('github-content')
const gc = new githubContent({
	owner: 'CSSEGISandData',
	repo: 'COVID-19',
	branch: 'master'
})

class CovidData {
	
	constructor() {
		this.downloadFile = {
			status: false,
			fileNotFound: true
		}
		this.covidData = []
		this.resultCovidData = []
		this.countDay = 0
	}

	getFileName(date) {
		const month = date.getMonth() + 1
		const fullDate = ('0' + month).slice(-2) + '-' + ('0' + date.getDate()).slice(-2) + '-' + date.getFullYear()
		const fileName = fullDate + '.csv'
		return fileName
	}

	addData(data) {
		let i = 0

		for (i = 0; i < this.resultCovidData.length; i++) {
			if (this.resultCovidData[i].Country_Region == data.Country_Region) {
				this.resultCovidData[i].Confirmed += data.Confirmed
				this.resultCovidData[i].Deaths += data.Deaths
				this.resultCovidData[i].Recovered += data.Recovered
				this.resultCovidData[i].Active += data.Active
				return
			}
		}
		this.resultCovidData.push(data)
		return
	}

	async download_file(date) {
		const fileName = this.getFileName(date)
		this.downloadFile.status = false

		return new Promise(async (resolve) => {
			gc.file(['csse_covid_19_data/csse_covid_19_daily_reports/' + fileName], async (err, result) => {
				if (err) {
					this.downloadFile.status = false
				} else {
					const all_data = result.contents.toString()
					if (all_data == '404: Not Found') {
						this.downloadFile.status = false
						this.downloadFile.fileNotFound = true
					} else {
						try {
							await fs.writeFileSync('data.csv', all_data)
							this.downloadFile.status = true
						} catch (err) {
							console.error(err)
							this.downloadFile.status = false
						}
					}
				}
				resolve()
			})
		})
	}

	sortData(array, key) {
		return array.sort((a, b) =>
		{
			const x = a[key]
			const y = b[key]
			return ((x < y) ? -1 : ((x > y) ? 1 : 0))
		})
	}

	parse_file() {
		fs.createReadStream('data.csv')
			.pipe(csv())
			.on('data', (data) => {
				data.size = 5
				data.latitude = parseFloat(data.latitude)
				data.longitude = parseFloat(data.longitude)
				data.Confirmed = parseInt(data.Confirmed)
				data.Active = parseInt(data.Active)
				data.Deaths = parseInt(data.Deaths)
				data.Recovered = parseInt(data.Recovered)
				this.addData(data)
			})
			.on('end', () => {
				const newResult = this.sortData(this.resultCovidData, 'Confirmed')
				this.covidData = newResult.slice()
				this.covidData.reverse()
			})
	}

	async fetchCovidData(date = undefined) {
		if (date == undefined) {
			date = new Date()
			this.resultCovidData = []
			this.countDay = 0
		}
		await this.download_file(date)
		if (this.downloadFile.status == true) {
			this.parse_file()
		} else if (this.downloadFile.status == false && this.downloadFile.fileNotFound == true && this.countDay < 5) {
			date.setHours(date.getHours() - 24)
			this.countDay += 1
			this.fetchCovidData(date)
		}
	}

	async getCovidData(req, res) {
		if (this.covidData) {
			res.status(200).json(this.covidData)
		} else {
			res.status(404).send('Not Found')
		}
	}
}

module.exports = new CovidData()