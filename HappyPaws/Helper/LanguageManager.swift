//
//  LanguageManager.swift
//  HappyPaws
//
//  Created by nino on 1/31/25.
//

import Foundation
import SwiftUI


class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    private let userDefaultsKey = "selectedLanguage"
    
    @Published var currentLanguage: String {
        didSet {
            UserDefaults.standard.set(currentLanguage, forKey: userDefaultsKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    private init() {
        self.currentLanguage = UserDefaults.standard.string(forKey: userDefaultsKey) ?? "en"
    }
    
    func setLanguage(_ language: String) {
        currentLanguage = language
    }
    
    func localizedString(forKey key: String) -> String {
        let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") ?? ""
        let bundle = Bundle(path: path)
        return bundle?.localizedString(forKey: key, value: nil, table: nil) ?? key
    }
}
