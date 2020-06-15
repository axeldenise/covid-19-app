//
//  ShowMapViewController.swift
//  Covid-19-DataViz
//
//  Created by Axel on 20/04/2020.
//  Copyright © 2020 Fangorn. All rights reserved.
//

import UIKit
import Macaw
import SWXMLHash
import SwiftyJSON

class ShowMapViewController: UIViewController {

    @IBOutlet weak var currentShowedMap: SVGView!
    var continent : String?
    var lastTouched: String = ""
    var basicColor: Fill?
    let covidData = CovidData()
    
    @IBOutlet weak var displayCountryName: UILabel!
    
    private var pathArray = [String]()
    @IBOutlet weak var displayRecovered: UITextField!
    @IBOutlet weak var displayActive: UITextField!
    @IBOutlet weak var displayConfirmed: UITextField!
    @IBOutlet weak var displayDeath: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let nameMap = continent else { return }
        currentShowedMap.fileName = nameMap
        
        guard let url = Bundle.main.url(forResource: nameMap, withExtension: "svg") else { return }
        if let xmlString = try? String(contentsOf: url) {
            let xml = SWXMLHash.parse(xmlString)
            enumerate(indexer: xml, level: 0)
            
            for case let element in pathArray {
                self.registerForSelection(nodeTag: element)
            }
        }
    }
    
    private func enumerate(indexer: XMLIndexer, level: Int) {
        for child in indexer.children {
            if let element = child.element {
                if let idAttribute = element.attribute(by: "id") {
                    let text = idAttribute.text
                    pathArray.append(text)
                }
            }
            enumerate(indexer: child, level: level + 1)
        }
    }

    private func changeCountryStat(countryData : JSON) {
        guard let Confirmed = countryData["Confirmed"].int else { return }
        guard let Active = countryData["Active"].int else { return }
        guard let Deaths = countryData["Deaths"].int else { return }
        guard let Recovered = countryData["Recovered"].int else { return }
        guard let CountryName = countryData["Country_Region"].string else { return }
    
        displayCountryName.text = CountryName
        
        displayRecovered.text = String(Recovered)
        displayActive.text = String(Active)
        displayConfirmed.text = String(Confirmed)
        displayDeath.text = String(Deaths)
    }
    
    private func registerForSelection(nodeTag: String) {
        currentShowedMap.node.nodeBy(tag: nodeTag)?.onTouchPressed({ (touch) in
            if (self.lastTouched != "") {
                let nodeShape = self.currentShowedMap.node.nodeBy(tag: self.lastTouched) as! Shape
                nodeShape.fill = self.basicColor
            }
            self.lastTouched = nodeTag
            let nodeShape = self.currentShowedMap.node.nodeBy(tag: nodeTag) as! Shape
            let info = self.covidData.getCountryData(id: nodeTag)
            self.basicColor = nodeShape.fill
            nodeShape.fill = Color.rgb(r: 8, g: 142, b: 200)
            
            if info != nil {
                self.changeCountryStat(countryData: info!)
            }
        })
    }
}
