//
//  String+Ext.swift
//  MarsRoverPhotos
//
//  Created by Alina Bondarchuk on 28.05.2024.
//

import Foundation

extension String {
    func convertDateString(fromFormat: String = "yyyy-MM-dd", toFormat: String = "MMMM dd, yyyy") -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        guard let date = dateFormatter.date(from: self) else {
            return nil
        }
        
        return date.toString(format: toFormat)
    }
}
