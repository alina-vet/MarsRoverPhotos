//
//  ImageLoader.swift
//  MarsRoverPhotos
//
//  Created by Alina Bondarchuk on 28.05.2024.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    public func loadImage(imageString: String) {
        
        if let cachedImage = imageCache.object(forKey: imageString as NSString) {
            self.image = cachedImage
            return
        }
        
        let urlImage = URL(string: imageString)
        guard let url = urlImage else {
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let downloadedImage = UIImage(data: data) else {
                return
            }
            
            imageCache.setObject(downloadedImage, forKey: imageString as NSString)
            
            DispatchQueue.main.async {
                self.image = downloadedImage
            }
        }.resume()
    }
}
