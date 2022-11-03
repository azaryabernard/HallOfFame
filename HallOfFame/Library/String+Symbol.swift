//
//  String+Symbol.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import UIKit

extension String {
    
    func symbol(pointSize: CGFloat, weight: UIImage.SymbolWeight = .regular) -> UIImage? {
        UIImage(systemName: self)?.withSymbolConfiguration(pointSize: pointSize, weight: weight)
    }
    
    func symbol(font: UIFont) -> UIImage? {
        UIImage(systemName: self)?.withSymbolConfiguration(font: font)
    }
    
    func symbol(textStyle: UIFont.TextStyle) -> UIImage? {
        UIImage(systemName: self)?.withSymbolConfiguration(textStyle: textStyle)
    }
    
    func symbol(weight: UIImage.SymbolWeight) -> UIImage? {
        UIImage(systemName: self)?.withSymbolConfiguration(weight: weight)
    }
    
    var symbol: UIImage? {
        UIImage(systemName: self)
    }
    
}
