//
//  PhotoViewController.swift
//  MarsRoverPhotos
//
//  Created by Alina Bondarchuk on 28.05.2024.
//

import UIKit

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var zoomImageView: UIImageView!
    
    var imageURLString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let imageURLString = imageURLString {
            zoomImageView.loadImage(imageString: imageURLString)
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 5
    }
}

extension PhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomImageView
    }
}
