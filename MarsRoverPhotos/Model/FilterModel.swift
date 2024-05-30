//
//  FilterModel.swift
//  MarsRoverPhotos
//
//  Created by Alina Bondarchuk on 29.05.2024.
//

import Foundation

struct FilterModel {
    
    private var filter: Filter
    
    init(filter: Filter) {
        self.filter = filter
    }
    
    var id: UUID {
        filter.id ?? UUID()
    }
    
    var camera: String {
        filter.camera ?? ""
    }
    
    var rover: String {
        filter.rover ?? ""
    }
    
    var date: Date {
        filter.date ?? Date()
    }
}
