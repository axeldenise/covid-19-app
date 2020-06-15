//
//  DataTableViewController.swift
//  Covid-19-DataViz
//
//  Created by Axel on 21/04/2020.
//  Copyright © 2020 Fangorn. All rights reserved.
//

import UIKit
import SwiftyJSON

class DataTableViewController: UITableViewController {

    let reuseIdentifier = "dataCell"
    var items : JSON = []

    let covidData = CovidData()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        items = covidData.getAllData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as! DataTableViewCell

        guard let Confirmed = items[indexPath.section]["Confirmed"].int else { return cell }
        guard let Active = items[indexPath.section]["Active"].int else { return cell }
        guard let Deaths = items[indexPath.section]["Deaths"].int else { return cell }
        guard let Recovered = items[indexPath.section]["Recovered"].int else { return cell }
        guard let CountryName = items[indexPath.section]["Country_Region"].string else { return cell }
        
        cell.Confirmed.text = String(Confirmed)
        cell.Active.text = String(Active)
        cell.Death.text = String(Deaths)
        cell.Recovered.text = String(Recovered)
        cell.CountryName.text = CountryName

        return cell
    }
}
