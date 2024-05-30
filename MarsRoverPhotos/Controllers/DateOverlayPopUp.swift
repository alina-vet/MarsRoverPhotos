//
//  DateOverlayPopUp.swift
//  MarsRoverPhotos
//
//  Created by Alina Bondarchuk on 28.05.2024.
//

import UIKit

class DateOverlayPopUp: UIViewController {
    
    var selectedRowIndex: Int = 0
    var saveAction: ((Date) -> Void)?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Camera"
        label.textColor = .black
        label.font = Constants.title2
        label.minimumScaleFactor = 0.2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero,
                                            size: CGSize(width: 44,
                                                         height: 44)))
        button.setBackgroundImage(UIImage(named: "Close"), for: .normal)
        button.addTarget(self, action: #selector(handleCloseAction), for: .touchUpInside)
        return button
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero,
                                            size: CGSize(width: 44,
                                                         height: 44)))
        button.setBackgroundImage(UIImage(named: "Tick"), for: .normal)
        button.addTarget(self, action: #selector(handleSaveAction), for: .touchUpInside)
        return button
    }()
    
    lazy var navBarStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [closeButton, titleLabel, saveButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        return stackView
    }()
    
    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [navBarStackView, pickerView])
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 50
        view.clipsToBounds = true
        return view
    }()
    
    lazy var pickerView: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.maximumDate = Date()
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        return picker
    }()
    
    let maxDimmedAlpha: CGFloat = 0.6
    lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        return view
    }()
    
    let defaultHeight: CGFloat = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
    }
    
    @objc func handleCloseAction() {
        animateDismissView()
    }
    
    @objc func handleSaveAction() {
        let selectedDate = pickerView.date
        saveAction?(selectedDate)
        animateDismissView()
    }
    
    func setupConstraints() {
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 312 / 353),
            
            contentStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
            contentStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            contentStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
        ])
    }
    
    func animatePresentContainer() {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func animateShowDimmedView() {
        containerView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        containerView.alpha = 0
        dimmedView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
            self.containerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.containerView.alpha = 1
        }
    }
    
    func animateDismissView() {
        dimmedView.alpha = maxDimmedAlpha
        
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.containerView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
