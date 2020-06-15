//
//  ViewController.swift
//  Covid-19-DataViz
//
//  Created by Axel on 20/04/2020.
//  Copyright © 2020 Fangorn. All rights reserved.
//

import UIKit
import Macaw

class ChooseMapViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let reuseIdentifier = "mapCell"
    let items = ["America", "Europe", "Africa", "Asia"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection
        section: Int) -> Int {
        return self.items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MapCollectionViewCell
        
        cell.ContinentName.text = self.items[indexPath.item]
        cell.SVGMap.fileName = self.items[indexPath.item]
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        return cell
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let currentSize : CGRect = collectionView.bounds
        return CGSize(width: (currentSize.width / 2) - 15, height: 270)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            guard let destination = segue.destination as? ShowMapViewController else { return }
            guard let cell = sender as? MapCollectionViewCell else { return }
            guard let indexpath = self.collectionView.indexPath(for: cell) else { return }
            
            let continent = items[indexpath.item]
            destination.continent = continent
        }
    }

}

