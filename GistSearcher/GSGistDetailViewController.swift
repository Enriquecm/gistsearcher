//
//  GSGistDetailViewController.swift
//  GistSearcher
//
//  Created by Enrique Melgarejo on 21/04/17.
//  Copyright © 2017 Choynowski. All rights reserved.
//

import UIKit

class GSGistDetailViewController: UIViewController {

    var gistURL: URL?
    
    fileprivate var viewModel = GSGistDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupGist()
    }

    fileprivate func setupUI() {
        
    }
    
    fileprivate func setupGist() {
        
        viewModel.process(gistURL: gistURL)
    }
}
