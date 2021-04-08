//
//  LanguageAssistentSingleton.swift
//  FlowerBud
//
//  Created by Isaac Cavalcante on 01/04/21.
//

import Foundation
import MLKitTranslate

class LanguageAssistentSingleton {
    
    var options: TranslatorOptions?
    var englishPortugueseTranslator:Translator?
    
    var conditions: ModelDownloadConditions?

    static var shared: LanguageAssistentSingleton = {
        let instance = LanguageAssistentSingleton()
        
        instance.conditions = ModelDownloadConditions(
            allowsCellularAccess: false,
            allowsBackgroundDownloading: true
        )
        
        instance.options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .portuguese)
        
        instance.englishPortugueseTranslator = Translator.translator(options: instance.options!)
        
        

        // ... configure the instance
        // ...
        return instance
    }()
    private init() {}
    
    func someBusinessLogic() -> String {
        // ...
        return "Result of the 'someBusinessLogic' call"
    }
}
