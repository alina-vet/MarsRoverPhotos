//
//  CustomBottomSheet.swift
//  MarsRoverPhotos
//
//  Created by Alina Bondarchuk on 28.05.2024.
//

import UIKit

class CustomBottomSheet: UIViewController {
    
    var dataType: DataType = .camera
    var saveAction: ((Any) -> Void)?
    
    var cameraData: [CameraType] = CameraType.allCases
    var roverData: [RoverType] = RoverType.allCases
    
    var selectedRowIndex: Int = 0
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = dataType.typeString
        label.font = Constants.title2
        label.textColor = .black
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
        let spacer = UIView()
        let stackView = UIStackView(arrangedSubviews: [navBarStackView, pickerView])
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 50
        view.addShadow(offset: CGSize(width: 0,
                                      height: -4),
                       color: .black,
                       radius: 12,
                       opacity: 0.2)
        return view
    }()
    
    lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    let defaultHeight: CGFloat = 300
    
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }
    
    @objc func handleCloseAction() {
        animateDismissView()
    }
    
    @objc func handleSaveAction() {
        let selectedData: Any
        switch dataType {
        case .camera:
            selectedData = cameraData[selectedRowIndex]
        case .rover:
            selectedData = roverData[selectedRowIndex]
        case .date:
            selectedData = Date()
        }
        saveAction?(selectedData)
        animateDismissView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animatePresentContainer()
    }
    
    func setupView() {
        view.backgroundColor = .clear
    }
    
    func setupConstraints() {
        
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
            contentStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            contentStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
        ])
        
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
    
    func animatePresentContainer() {
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func animateDismissView() {
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.dismiss(animated: true)
        }
    }
}

extension CustomBottomSheet: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataType == .camera ? cameraData.count : roverData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view as? UILabel { label = v }
        label.font = Constants.title
        label.textColor = .black
        label.text =  dataType == .camera ? cameraData[row].cameraFullName : roverData[row].roverName
        label.textAlignment = .center
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRowIndex = row
    }
}
