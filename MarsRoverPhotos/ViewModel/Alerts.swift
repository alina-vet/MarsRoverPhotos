//
//  Alerts.swift
//  MarsRoverPhotos
//
//  Created by Alina Bondarchuk on 29.05.2024.
//

import UIKit

class Alerts: NSObject {
    
    func showSaveAlert(controller: UIViewController, camera: CameraType, rover: RoverType, date: Date) {
        let alert = UIAlertController(title: "Save Filters", 
                                      message: "The current filters and the date you have chosen can be saved to the filter history.",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Save", 
                                      style: .cancel,
                                      handler: { _ in
            self.saveFilters(camera: camera, rover: rover, date: date)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        alert.view.layer.cornerRadius = 30
        alert.view.clipsToBounds = true
        
        controller.present(alert, animated: true)
    }
    
    func showConfirmationSheet(controller: UIViewController, filter: Filter, deleteAction: @escaping () -> Void, useAction: @escaping () -> Void) {
        let alert = UIAlertController(title: "Menu Filter", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Use", style: .default, handler: { _ in
            useAction()
        }))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            deleteAction()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.view.layer.cornerRadius = 30
        alert.view.clipsToBounds = true
        
        controller.present(alert, animated: true)
    }
    
    private func saveFilters(camera: CameraType, rover: RoverType, date: Date) {
        let context = PersistenceService.shared.context
        let filter = Filter(context: context)
        filter.id = UUID()
        filter.camera = camera.rawValue
        filter.rover = rover.roverName
        filter.date = date
        
        PersistenceService.shared.saveContext()
    }
}
