//
//  UITableView + Extensions.swift
//  Posts
//
//  Created by Dmytro Ukrainskyi on 05.09.2023.
//

import UIKit

extension UITableView {
    
    func showActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        backgroundView = activityIndicator
    }
    
    func hideActivityIndicator() {
        backgroundView = nil
    }
    
}
