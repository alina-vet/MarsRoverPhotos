//
//  SplashViewController.swift
//  MarsRoverPhotos
//
//  Created by Alina Bondarchuk on 28.05.2024.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {

    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var lottieAnimationView: UIView!
    
    private var animationView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLottieAnimation()
        configureLogoView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.changeRootViewController()
            self.animationView?.stop()
            self.animationView?.removeFromSuperview()
        }
    }

    private func setupLottieAnimation() {
        
        animationView = .init(name: "loader")
        
        animationView!.frame = CGRect(origin: CGPoint(x: view.frame.minX,
                                                      y: view.frame.midY),
                                      size: CGSize(width: view.frame.width,
                                                   height: view.frame.height / 2))
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 0.4
        
        view.addSubview(animationView!)
        animationView!.play()
    }
    
    private func configureLogoView() {
        logoView.layer.cornerRadius = 30
        logoView.layer.borderColor = UIColor.black.cgColor
        logoView.layer.borderWidth = 1
        logoView.addShadow(offset: CGSize(width: 0, height: 20),
                               color: .black,
                               radius: 55,
                               opacity: 0.1)
    }
    
    private func changeRootViewController() {
        let sb = UIStoryboard(name: Constants.mainScreen, bundle: nil)
        let vc = sb.instantiateInitialViewController()
        UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController = vc
    }
}
