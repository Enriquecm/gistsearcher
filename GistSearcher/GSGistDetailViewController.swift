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
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var labelHeaderTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var viewFooter: UIView!
    @IBOutlet weak var buttonFooter: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    fileprivate var viewModel = GSGistDetailViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gistURL = URL(string: "https://gist.github.com/KDCinfo/0435e4ce4112ce8880e48a9c8bb0e612")
        
        setupUI()
        setupGist()
        setupTableView()
    }
    
    fileprivate func setupUI() {
        // TODO:
    }
    
    fileprivate func setupTableView() {
        tableView.dataSource = self
    }
    
    fileprivate func setupGist() {
        setupUIForLoading()
        viewModel.process(gistURL: gistURL) { [weak self] (gist, error) in
            DispatchQueue.main.async {
                self?.setupUIForNotLoadgin()
                if error != nil {
                    self?.failedToGetGist()
                } else {
                    self?.setupButtonAndHeader()
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    fileprivate func failedToGetGist() {
        let alertController = UIAlertController(title: "Fail to open Gist", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Try again", style: .default, handler: { [weak self] (alertAction) in
            self?.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    //MARK: Actions
    @IBAction func buttonFooterPressed(_ sender: UIButton) {
        if let comments = viewModel.gist?.commentsCount, comments > 0 {
            // TODO: See all comments
            
        } else {
            // New Comment
            
        }
        performSegue(withIdentifier: GSSegueIdentifier.createComment, sender: viewModel.gist?.gistID)
    }
    
    
    // MARK: Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == GSSegueIdentifier.createComment {
    
            let navigation = segue.destination as? UINavigationController
            let destination = navigation?.viewControllers.first as? GSGistCommentViewController
            destination?.gistID = sender as? String
        }
    }
}

extension GSGistDetailViewController {
    
    fileprivate func setupUIForLoading() {
        buttonFooter.isEnabled = false
        buttonFooter.alpha = 0.5
        labelHeaderTitle.text = "Loading..."
        activityIndicator.startAnimating()
    }
    
    fileprivate func setupUIForNotLoadgin() {
        buttonFooter.isEnabled = true
        buttonFooter.alpha = 1.0
        activityIndicator.stopAnimating()
    }
    
    fileprivate func setupButtonAndHeader() {
        labelHeaderTitle.text = viewModel.gist?.ownerUser
        if let comments = viewModel.gist?.commentsCount, comments > 0 {
            buttonFooter.setTitle("Comments (\(comments))", for: .normal)
        } else {
            buttonFooter.setTitle("New Comment", for: .normal)
        }
    }
}

extension GSGistDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.gistFiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: GSGistFileTableViewCell.identifier, for: indexPath)
        
        if let gistFileCell = cell as? GSGistFileTableViewCell {
            let file = viewModel.gistFiles[indexPath.row]
            gistFileCell.configure(withFile: file)
        }
        
        return cell
    }
}
