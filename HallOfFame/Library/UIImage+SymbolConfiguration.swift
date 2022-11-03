//
//  UIImage+SymbolConfiguration.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import UIKit

extension UIImage {
    
    func withSymbolConfiguration(font: UIFont, scale: SymbolScale = .default) -> UIImage {
        withConfiguration(SymbolConfiguration(font: font, scale: scale))
    }
    
    func withSymbolConfiguration(
        pointSize: CGFloat,
        weight: SymbolWeight = .regular,
        scale: SymbolScale = .default
    ) -> UIImage {
        withConfiguration(SymbolConfiguration(pointSize: pointSize, weight: weight, scale: scale))
    }
    
    func withSymbolConfiguration(textStyle: UIFont.TextStyle, scale: SymbolScale = .default) -> UIImage {
        withConfiguration(SymbolConfiguration(textStyle: textStyle, scale: scale))
    }
    
    func withSymbolConfiguration(weight: SymbolWeight) -> UIImage {
        withConfiguration(SymbolConfiguration(weight: weight))
    }
    
}
