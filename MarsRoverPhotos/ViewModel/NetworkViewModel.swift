//
//  NetworkViewModel.swift
//  MarsRoverPhotos
//
//  Created by Alina Bondarchuk on 28.05.2024.
//

import Foundation

class NetworkViewModel {
    var photos: [Photo] = []
    var currentPage: Int = 1
    var isLoading: Bool = false
    var currentRoverIndex: Int = 0
    
    var onDataChanged: (() -> Void)?
    
    func fetchPhotos(rover: RoverType, camera: CameraType, date: Date) {
        guard !isLoading else { return }
        isLoading = true
        
        let rovers: [RoverType] = [.curiosity, .opportunity, .spirit, .perseverance]
        
        var roverName = ""
        if rover == .all {
            if currentRoverIndex >= rovers.count {
                isLoading = false
                return
            }
            roverName = rovers[currentRoverIndex].roverName.lowercased()
        } else {
            roverName = rover.roverName.lowercased()
        }
        
        let cameraName = camera == .all ? "" : camera.rawValue.lowercased()
        let dateString = date.toAPIString()
        
        var urlString = "https://api.nasa.gov/mars-photos/api/v1/rovers/"
        urlString += "\(roverName)/photos?earth_date=\(dateString)"
        
        if !cameraName.isEmpty {
            urlString += "&camera=\(cameraName)"
        }
        
        urlString += "&page=\(currentPage)&api_key=\(Constants.apiKey)"
        
        guard let url = URL(string: urlString) else {
            self.isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            defer { self?.isLoading = false }
            
            if let error = error {
                print("Network Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let result = try JSONDecoder().decode([String: [Photo]].self, from: data)
                if let fetchedPhotos = result["photos"] {
                    self?.photos.append(contentsOf: fetchedPhotos)
                    self?.currentPage += 1
                    DispatchQueue.main.async {
                        self?.onDataChanged?()
                    }
                }
            } catch {
                print("Failed to decode JSON: \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Received JSON string: \(jsonString)")
                }
            }
            
            if let currentPage = self?.currentPage, 
                let photos = self?.photos, currentPage > 1 || photos.isEmpty {
                self?.currentRoverIndex += 1
                self?.currentPage = 1
            }
        }.resume()
    }
    
    func resetAndFetchData(rover: RoverType, camera: CameraType, date: Date) {
        photos.removeAll()
        currentPage = 1
        currentRoverIndex = 0
        onDataChanged?()
        fetchPhotos(rover: rover, camera: camera, date: date)
    }
}
