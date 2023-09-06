//
//  UILabel + Extensions.swift
//  Posts
//
//  Created by Dmytro Ukrainskyi on 03.09.2023.
//

import UIKit

extension UILabel {
    
    func fits(numberOfLines: Int, withWidth width: CGFloat) -> Bool {
        guard let text, let font else { return false }
                
        let textRect = text.boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )
        
        return textRect.height <= font.lineHeight * CGFloat(numberOfLines)
    }
    
}
