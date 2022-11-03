//
//  String+Localized.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import Foundation

extension String {
    
    func localized(comment: String = "") -> String {
        NSLocalizedString(self, bundle: Bundle.main, comment: comment)
    }
    
    func localizedWithFormat(comment: String = "", _ arguments: CVarArg...) -> String {
        String(format: localized(comment: comment), locale: .current, arguments: arguments )
    }
    
}
