//
//  String+Base64.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import Foundation

extension String {

    var base64Decoded: String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        
        return String(data: data, encoding: .utf8)
    }
    
    var base64Encoded: String {
        Data(utf8).base64EncodedString()
    }
    
}
