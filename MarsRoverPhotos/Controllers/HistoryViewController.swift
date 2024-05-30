//
//  HistoryViewController.swift
//  MarsRoverPhotos
//
//  Created by Alina Bondarchuk on 29.05.2024.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var navBackView: UIView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private var savedFilters: [Filter] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBackView.addShadow()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FilterVIewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "FilterVIewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        setupCustomNavBar()
        fetchSavedFilters()
        emptyView.isHidden = !savedFilters.isEmpty
    }
    
    private func setupCustomNavBar() {
        let titleLabel = UILabel()
        titleLabel.text = "History"
        titleLabel.textColor = .black
        titleLabel.font = Constants.largeTitle
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        navigationItem.titleView = titleLabel
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: navigationItem.titleView!.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: navigationItem.titleView!.centerYAnchor)
        ])
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "Left")?.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(popToPrevious)
        )
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    @objc private func popToPrevious() {
        navigationController?.popViewController(animated: true)
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedFilters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilterVIewCell") as? FilterVIewCell else {
            fatalError("Wrong Reusable Cell")
        }
        cell.selectionStyle = .none
        
        let filter = savedFilters[indexPath.row]
        let cameraName = CameraType(rawValue: filter.camera ?? "")?.cameraFullName
        
        cell.updateCell(rover: filter.rover ?? "",
                        camera: cameraName ?? "",
                        date: filter.date?.toString() ?? "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 4.8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filter = savedFilters[indexPath.row]
        Alerts().showConfirmationSheet(controller: self, filter: filter, deleteAction: { [weak self] in
            self?.deleteFilter(filter: filter)
        }, useAction: { [weak self] in
            self?.applyFilter(filter: filter)
        })
    }
}

extension HistoryViewController {
    
    private func fetchSavedFilters() {
        let context = PersistenceService.shared.context
        let fetchRequest: NSFetchRequest<Filter> = Filter.fetchRequest()
        
        do {
            savedFilters = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Failed to fetch filters: \(error)")
        }
    }
    
    private func deleteFilter(filter: Filter) {
        let context = PersistenceService.shared.context
        context.delete(filter)
        PersistenceService.shared.saveContext()
        
        fetchSavedFilters()
    }
    
    private func applyFilter(filter: Filter) {
        guard let homeVC = navigationController?.viewControllers.first(where: { $0 is HomeViewController }) as? HomeViewController else {
            return
        }
        
        if let cameraType = CameraType(rawValue: filter.camera ?? ""),
           let roverType = RoverType.allCases.first(where: { $0.roverName == filter.rover }),
           let date = filter.date {
            homeVC.selectedCameraData = cameraType
            homeVC.selectedRoverData = roverType
            homeVC.currentDateTime = date
            homeVC.resetAndFetchData()
        }
        
        navigationController?.popToViewController(homeVC, animated: true)
    }
}
