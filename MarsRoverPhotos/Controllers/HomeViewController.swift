//
//  HomeViewController.swift
//  MarsRoverPhotos
//
//  Created by Alina Bondarchuk on 28.05.2024.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var customNavigationView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var roverButton: RoundedButton!
    @IBOutlet weak var cameraButton: RoundedButton!
    @IBOutlet weak var historyButton: RoundedButton!
    @IBOutlet weak var emptyView: UIView!
    
    private var activityIndicator: UIActivityIndicatorView!
    private var loadViewModel = NetworkViewModel()
    
    var selectedCameraData: CameraType = .all {
        didSet {
            cameraButton.setTitle(selectedCameraData.rawValue, for: .normal)
        }
    }
    var selectedRoverData: RoverType = .all {
        didSet {
            roverButton.setTitle(selectedRoverData.roverName, for: .normal)
        }
    }
    var currentDateTime = Date() {
        didSet {
            dateLabel.text = currentDateTime.toString()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentDateTime = Date()
        customNavigationView.addShadow()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CardViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "CardViewCell")
        
        configureActivityIndicator()
        
        loadViewModel.onDataChanged = { [weak self] in
            self?.tableView.reloadData()
            self?.activityIndicator.stopAnimating()
            
            if let photos = self?.loadViewModel.photos {
                self?.emptyView.isHidden = !photos.isEmpty
            }
        }
        
        activityIndicator.startAnimating()
        loadViewModel.fetchPhotos(rover: selectedRoverData,
                                  camera: selectedCameraData,
                                  date: currentDateTime)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func filterRoverTapped(_ sender: UIButton) {
        let vc = CustomBottomSheet()
        vc.modalPresentationStyle = .overCurrentContext
        vc.dataType = .rover
        vc.saveAction = { selectedData in
            self.selectedRoverData = selectedData as! RoverType
            self.resetAndFetchData()
        }
        self.present(vc, animated: false)
    }
    
    @IBAction func filterCameraTapped(_ sender: UIButton) {
        let vc = CustomBottomSheet()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.dataType = .camera
        vc.saveAction = { selectedData in
            self.selectedCameraData = selectedData as! CameraType
            self.resetAndFetchData()
        }
        self.present(vc, animated: false)
    }
    
    @IBAction func filterDateTapped(_ sender: UIButton) {
        let vc = DateOverlayPopUp()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.saveAction = { selectedDate in
            self.currentDateTime = selectedDate
            self.resetAndFetchData()
        }
        self.present(vc, animated: false)
    }
    
    @IBAction func saveFilterTapped(_ sender: UIButton) {
        Alerts().showSaveAlert(controller: self, camera: selectedCameraData, rover: selectedRoverData, date: currentDateTime)
    }
    
    func resetAndFetchData() {
        emptyView.isHidden = true
        activityIndicator.startAnimating()
        loadViewModel.resetAndFetchData(rover: selectedRoverData, camera: selectedCameraData, date: currentDateTime)
    }
    
    private func configureActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .gray
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadViewModel.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardViewCell") as? CardViewCell else {
            fatalError("Wrong Reusable Cell")
        }
        cell.selectionStyle = .none
        
        let photo = loadViewModel.photos[indexPath.row]
        cell.updateCell(rover: photo.rover.name,
                        camera: photo.camera.fullName,
                        date: photo.earthDate.convertDateString()!)
        cell.cellImageView.loadImage(imageString: photo.imgSrc)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photo = loadViewModel.photos[indexPath.row]
        if let viewController = storyboard?.instantiateViewController(identifier: "PhotoViewController") as? PhotoViewController {
            viewController.modalTransitionStyle = .crossDissolve
            viewController.modalPresentationStyle = .overCurrentContext
            viewController.imageURLString = photo.imgSrc
            self.present(viewController, animated: true) {
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    tableView.deselectRow(at: selectedIndexPath, animated: true)
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if !loadViewModel.isLoading && offsetY > contentHeight - scrollView.frame.height {
            loadViewModel.currentPage += 1
            loadViewModel.fetchPhotos(rover: selectedRoverData, camera: selectedCameraData, date: currentDateTime)
        }
    }
}
