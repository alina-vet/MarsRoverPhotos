//
//  CardViewCell.swift
//  MarsRoverPhotos
//
//  Created by Alina Bondarchuk on 28.05.2024.
//

import UIKit

class CardViewCell: UITableViewCell {
    
    @IBOutlet weak var cellBackView: UIView!
    @IBOutlet weak var cellImageView: UIImageView!
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
        cellBackView.layer.cornerRadius = 30
        cellBackView.addShadow(offset: CGSize(width: 0, height: 3),
                               color: .black,
                               radius: 16,
                               opacity: 0.08)
        cellImageView.layer.cornerRadius = 20
    }
    
    func updateCell(rover: String, camera: String, date: String) {
        roverLabel.halfTextColorChange(title: roverTitle, text: rover)
        cameraLabel.halfTextColorChange(title: cameraTitle, text: camera)
        dateLabel.halfTextColorChange(title: dateTitle, text: date)
    }
}
