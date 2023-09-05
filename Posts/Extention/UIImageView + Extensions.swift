//
//  UIImageView + Extensions.swift
//  Posts
//
//  Created by Dmytro Ukrainskyi on 02.09.2023.
//

import UIKit

extension UIImageView {
    
    /// Instead of this method SDWebImage/Kingfisher could be used if needed.
    func setImageFrom(url: URL) {
        let activityIndicator = UIActivityIndicatorView()
        
        addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        activityIndicator.startAnimating()

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                    self.setPlaceholderImage()
                }
                
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                    self.setPlaceholderImage()
                }
                
                return
            }
            
            guard let data, let downloadedImage = UIImage(data: data) else {
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                    self.setPlaceholderImage()
                }
                return
            }
            
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                self.image = downloadedImage
            }
        }
        
        task.resume()
    }
    
    func setPlaceholderImage() {
        let placeholderImage = UIImage(systemName: SystemImages.photo)
        self.image = placeholderImage
    }
    
}
