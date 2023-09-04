//
//  UIImageView + Extensions.swift
//  Posts
//
//  Created by Dmytro Ukrainskyi on 02.09.2023.
//

import UIKit

extension UIImageView {
    
    func setImageFrom(url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    self.setPlaceholderImage()
                }
                
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                DispatchQueue.main.async {
                    self.setPlaceholderImage()
                }
                
                return
            }
            
            guard let data, let downloadedImage = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self.setPlaceholderImage()
                }
                return
            }
            
            DispatchQueue.main.async {
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
