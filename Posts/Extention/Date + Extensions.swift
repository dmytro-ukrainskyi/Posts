//
//  Date + Extensions.swift
//  Posts
//
//  Created by Dmytro Ukrainskyi on 01.09.2023.
//

import Foundation

extension Date {
    
    func timeAgo() -> String {
        if #available(iOS 15.0, *) {
            let locale = Locale(identifier: LocaleConstants.defaultLocale)
            
            return self.formatted(
                    .relative(presentation: .numeric)
                    .locale(locale))
        } else {
            return RelativeDateTimeFormatter
                .defaultFormatter
                .localizedString(for: self, relativeTo: Date())
        }
    }
    
    func formatted() -> String {
        return DateFormatter
            .defaultFormatter
            .string(from: self)
    }
    
}
