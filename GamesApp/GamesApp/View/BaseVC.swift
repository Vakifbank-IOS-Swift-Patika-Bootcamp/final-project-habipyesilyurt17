//
//  BaseVC.swift
//  GamesApp
//
//  Created by Habip Yeşilyurt on 11.12.2022.
//

import UIKit
import MaterialActivityIndicator

class BaseVC: UIViewController {
    let indicator = MaterialActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureActivityIndicatorView()
    }
    
    private func configureActivityIndicatorView() {
        view.addSubview(indicator)
        configureActivityIndicatorViewConstraints()
    }
    
    private func configureActivityIndicatorViewConstraints() {
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
