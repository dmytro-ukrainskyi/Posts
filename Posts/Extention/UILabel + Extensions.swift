//
//  UILabel + Extensions.swift
//  Posts
//
//  Created by Dmytro Ukrainskyi on 03.09.2023.
//

import UIKit

extension UILabel {
    
    var isTruncated: Bool {
        guard let text, let font else { return false }
        
        layoutIfNeeded()
        
        let textRect = text.boundingRect(
            with: CGSize(width: bounds.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        )
        
        return textRect.size.height > bounds.size.height
    }
    
}
