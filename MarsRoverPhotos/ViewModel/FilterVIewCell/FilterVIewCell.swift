//
//  FilterVIewCell.swift
//  MarsRoverPhotos
//
//  Created by Alina Bondarchuk on 29.05.2024.
//

import UIKit

class FilterVIewCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var roverLabel: UILabel!
    @IBOutlet weak var cameraLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    private let roverTitle = "Rover:  "
    private let cameraTitle = "Camera:  "
    private let dateTitle = "Date:  "

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func commonInit() {
        backView.layer.cornerRadius = 30
        backView.addShadow(offset: CGSize(width: 0, height: 3),
                               color: .black,
                               radius: 16,
                               opacity: 0.08)
    }
    
    func updateCell(rover: String, camera: String, date: String) {
        roverLabel.halfTextColorChange(title: roverTitle, text: rover)
        cameraLabel.halfTextColorChange(title: cameraTitle, text: camera)
        dateLabel.halfTextColorChange(title: dateTitle, text: date)
    }
}
