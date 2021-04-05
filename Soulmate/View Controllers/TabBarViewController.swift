//
//  TabBarViewController.swift
//  Hiking
//
//  Created by Will Lam on 4/11/2020.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    var currentTab = -1 // 3rd tab

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLoadingIndicator()
                
        loadingIndicator.isAnimating = true
        self.view.isUserInteractionEnabled = false
        
        self.view.mask = UIView(frame: self.view.frame)
        self.view.mask?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loadingIndicator.isAnimating = false
            self.view.isUserInteractionEnabled = true
            self.view.mask = nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if currentTab == -1 {           // First launch the app
            currentTab = 2
            self.selectedIndex = currentTab
        }
    }
    
    
    // MARK: - setupLoadingIndicator
    private func setupLoadingIndicator() {
        overrideUserInterfaceStyle = .light
        self.view.backgroundColor = .white
        self.view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: self.view.centerXAnchor),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: self.view.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 50),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
    }
    
    // MARK: - Properties
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.red, .green, .blue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
}


