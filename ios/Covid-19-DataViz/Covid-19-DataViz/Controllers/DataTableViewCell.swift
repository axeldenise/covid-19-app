//
//  DataTableViewCell.swift
//  Covid-19-DataViz
//
//  Created by Axel on 21/04/2020.
//  Copyright © 2020 Fangorn. All rights reserved.
//

import UIKit

class DataTableViewCell: UITableViewCell {

    @IBOutlet weak var Confirmed: UITextField!
    @IBOutlet weak var Active: UITextField!
    @IBOutlet weak var Death: UITextField!
    @IBOutlet weak var Recovered: UITextField!
    @IBOutlet weak var CountryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
