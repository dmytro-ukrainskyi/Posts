//
//  DateFormatter + Extensions.swift
//  Posts
//
//  Created by Dmytro Ukrainskyi on 02.09.2023.
//

import Foundation

extension DateFormatter {
    
    static let defaultFormatter = {
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: LocaleConstants.defaultLocale)
        formatter.dateFormat = "d MMMM yyyy"
        
        return formatter
    }()
    
}
