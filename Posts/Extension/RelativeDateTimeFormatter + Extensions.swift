//
//  RelativeDateTimeFormatter + Extensions.swift
//  Posts
//
//  Created by Dmytro Ukrainskyi on 02.09.2023.
//

import Foundation

extension RelativeDateTimeFormatter {
    
    static let defaultFormatter = {
        let formatter = RelativeDateTimeFormatter()
        
        formatter.unitsStyle = .full
        formatter.locale = Locale(identifier: LocaleConstants.defaultLocale)
        
        return formatter
    }()
    
}
