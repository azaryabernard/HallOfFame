//
//  UIImage+Placeholder.swift
//  HallOfFame
//
//  Created by Andreas Pfurtscheller on 03.11.21.
//

import Foundation
import UIKit

extension UIImage {
    
    public convenience init?(
        image: UIImage?,
        width: CGFloat,
        height: CGFloat,
        scale: CGFloat = 0.5,
        backgroundColor: UIColor = .systemGray5,
        burnRate: CGFloat = 0.4
    ) {
        self.init(
            image: image,
            size: CGSize(width: width, height: height),
            scale: scale,
            backgroundColor: backgroundColor,
            burnRate: burnRate
        )
    }
    
    public convenience init?(
        image: UIImage?,
        size: CGSize,
        scale: CGFloat = 0.5,
        backgroundColor: UIColor = .systemGray5,
        burnRate: CGFloat = 0.4
    ) {
        guard size != .zero else { return nil }
        
        let rect = CGRect(origin: .zero, size: size)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        backgroundColor.setFill()
        UIRectFill(rect)
        
        if let image = image {
            let imageHeight = size.height * scale
            let imageWidth = imageHeight * image.size.width / image.size.height
            let imageRect = CGRect(
                origin: CGPoint(x: (size.width - imageWidth) * 0.5, y: (size.height - imageHeight) * 0.5),
                size: CGSize(width: imageWidth, height: imageHeight)
            )
            image.draw(in: imageRect, blendMode: .darken, alpha: burnRate)
        }
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = result?.cgImage else { return nil }
        
        self.init(cgImage: cgImage)
    }
    
    public convenience init?(
        _ text: String,
        size: CGSize,
        backgroundColor: UIColor = .black,
        foregroundColor: UIColor = .white
    ) {
        guard size != .zero else { return nil }
        
        let rect = CGRect(origin: .zero, size: size)
                
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        backgroundColor.setFill()
        UIRectFill(rect)
                
        (text as NSString).draw(in: rect, withAttributes: [
            .font: UIFont.systemFont(ofSize: size.height / 3, weight: .regular),
            .foregroundColor: foregroundColor
        ])
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = result?.cgImage else { return nil }
        
        self.init(cgImage: cgImage)
    }
}
