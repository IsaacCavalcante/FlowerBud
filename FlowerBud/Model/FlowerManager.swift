//
//  FlowerManager.swift
//  FlowerBud
//
//  Created by Isaac Cavalcante on 01/04/21.
//

import Foundation
import SwiftyJSON

protocol FlowerManagerDelegate {
    func updateFlowerInformation(_ flowerManager: FlowerManager, flowerInformation: String, flowerImageUrl: String)
    func didFailWithError(error: Error)
}

class FlowerManager: WikiManagerDelegate {
    var delegate: FlowerManagerDelegate?
    private var wikiManager = WikiManager()
    
    internal func updateWikiInformation(_ wikiManager: WikiManager, wikiJson: JSON?) {
        
        if let pageid = wikiJson?["query"]["pageids"][0].stringValue,
           let flowerDescription = wikiJson?["query"]["pages"][pageid]["extract"].stringValue,
           let flowerImageUrl =  wikiJson?["query"]["pages"][pageid]["thumbnail"]["source"].stringValue {
            delegate?.updateFlowerInformation(self, flowerInformation: flowerDescription, flowerImageUrl: flowerImageUrl)
        }
        
    }
    
    internal func didFailWithError(error: WikiManagerError) {
        
    }
    
    func getFlowerInformation(flowerName: String, language: String = K.Languages.en) {
        wikiManager.delegate = self
        self.wikiManager.fetchRequest(searchFor: flowerName, usingLanguage: language)
    }
}
