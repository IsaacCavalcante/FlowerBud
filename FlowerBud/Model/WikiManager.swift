//
//  WikiManager.swift
//  FlowerBud
//
//  Created by Isaac Cavalcante on 31/03/21.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol WikiManagerDelegate {
    func updateWikiInformation(_ wikiManager: WikiManager, wikiJson: JSON?)
    func didFailWithError(error: WikiManagerError)
}

enum WikiManagerError: Error {
    case couldntDoRequest
    case errorToConvertToJSON
}

struct WikiManager{
    var delegate: WikiManagerDelegate?
    
    func fetchRequest (searchFor text: String? = "", usingLanguage language: String = K.Languages.en) {
        let parameters: [String: String] =
            [
                "format": "json",
                "action": "query",
                "prop": "extracts|pageimages",
                "exintro": "",
                "explaintext": "",
                "titles": text!,
                "indexpageids": "",
                "redirects": "1",
            ]
        let urlString = { () -> String in
            switch language {
            case K.Languages.en:
                return K.Url.WIKI_URL_EN
            case K.Languages.pt:
                return K.Url.WIKI_URL_PT
            default:
                return K.Url.WIKI_URL_EN
            }
        }
        performRequest(url: urlString(), parameters: parameters)
        
    }
    
    private func performRequest (url: String, parameters: [String:String]) {
        
        AF.request(url, method: .get, parameters: parameters).response { (response) in
        
            switch response.result {
            case .failure(_):
                self.delegate?.didFailWithError(error: WikiManagerError.couldntDoRequest)
            case .success(let value):
                let json = parseJSON(value)
                delegate?.updateWikiInformation(self, wikiJson: json)
            }
        }
    }
    
    
    
    private func parseJSON(_ wikiResult: Data?) -> JSON? {
        do {
            let json: JSON = try JSON(data: wikiResult!)
            return json
        } catch {
            self.delegate?.didFailWithError(error: WikiManagerError.errorToConvertToJSON)
        }
        return nil
    }
}
