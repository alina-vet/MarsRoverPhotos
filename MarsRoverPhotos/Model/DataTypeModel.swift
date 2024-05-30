//
//  DataTypeModel.swift
//  MarsRoverPhotos
//
//  Created by Alina Bondarchuk on 28.05.2024.
//

import UIKit

enum DataType {
    case rover
    case camera
    case date
}

extension DataType {
    var typeString: String {
        switch self {
        case .rover:
            "Rover"
        case .camera:
            "Camera"
        case .date:
            "Date"
        }
    }
}

enum CameraType: String, CaseIterable {
    case all, Fhaz, Rhaz, Mast, Chemcam, Mahli, Mardi, Navcam, Pancam, Minites
}

extension CameraType {
    var cameraFullName: String {
        switch self {
        case .all:
            "All"
        case .Fhaz:
            "Front Hazard Avoidance Camera"
        case .Rhaz:
            "Rear Hazard Avoidance Camera"
        case .Mast:
            "Mast Camera"
        case .Chemcam:
            "Chemistry and Camera Complex"
        case .Mahli:
            "Mars Hand Lens Imager"
        case .Mardi:
            "Mars Descent Imager"
        case .Navcam:
            "Navigation Camera"
        case .Pancam:
            "Panoramic Camera"
        case .Minites:
            "Miniature Thermal Emission Spectrometer"
        }
    }
}

enum RoverType: CaseIterable {
    case all
    case curiosity
    case opportunity
    case spirit
    case perseverance
}

extension RoverType {
    var roverName: String {
        switch self {
        case .all:
            "All"
        case .curiosity:
            "Curiosity"
        case .opportunity:
            "Opportunity"
        case .spirit:
            "Spirit"
        case .perseverance:
            "Perseverance"
        }
    }
}
