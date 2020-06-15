//
//  CovidData.swift
//  Covid-19-DataViz
//
//  Created by Axel on 22/04/2020.
//  Copyright © 2020 Fangorn. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CovidData {

    private var data : JSON = []
    private var isoCountry : [[String]] = []

    init() {
        self.fetchData()
        let tmpData = readDataFromCSV(fileName: "isoCountry", fileType: "csv")
        if tmpData != nil {
            self.isoCountry = self.parseCsv(data: tmpData!)
        }
    }
    
    private func fetchData() {
        AF.request(K.baseUrl + "covid/data").responseJSON { response in
            switch response.result {
                case .success(let value):
                    self.data = JSON(value)
                
                case .failure(let error):
                    print(error)
            }
        }
    }

    public func getCountryData(id : String) -> JSON? {
        var countryRegion : String?

        for item in self.isoCountry {
            if item[0] == id {
                countryRegion = item[1]
            }
        }

        if countryRegion != nil {
            for i in 0...self.data.count {
                if self.data[i]["Country_Region"].string == countryRegion {
                    return self.data[i]
                }
            }
        }
        return nil
    }

    public func getAllData() -> JSON {
        return self.data
    }

    func readDataFromCSV(fileName: String, fileType: String) -> String? {
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType) else { return nil }
        do {
            let contents : String = try String(contentsOfFile: filepath, encoding: .utf8)
            return contents
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
    }
    
    public func parseCsv(data: String) -> [[String]] {
        var result : [[String]] = []
        let rows = data.components(separatedBy: "\r\n")
        for row in rows {
            let columns = row.components(separatedBy: ";")
            result.append(columns)
        }
        return result
    }
}
