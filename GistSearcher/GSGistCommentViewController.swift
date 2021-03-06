//
//  GSGistCommentViewController.swift
//  GistSearcher
//
//  Created by Enrique Melgarejo on 21/04/17.
//  Copyright © 2017 Choynowski. All rights reserved.
//

import UIKit

class GSGistCommentViewController: UIViewController {

    // MARK: Properties
    fileprivate let viewModel = GSGistCommentViewModel()
    var gistID: String?
    
    
    // MARK: Outlets
    @IBOutlet weak var barButtonSave: UIBarButtonItem!
    @IBOutlet weak var barButtonCancel: UIBarButtonItem!
    @IBOutlet weak var constraintTextViewBottom: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        regiterNotifications()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    
    fileprivate func regiterNotifications() {
        // Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }

    fileprivate func setupUI() {
        textView.inputAccessoryView = MXKeyboardToolbar(viewWith: textView)
        textView.delegate = self
    }
    
    
    // MARK: Actions
    @IBAction func barButtonSavePressed(_ sender: UIBarButtonItem) {
        saveComment()
    }
    
    @IBAction func barButtonCancelPressed(_ sender: UIBarButtonItem) {
        if textView.text.isEmpty {
           dismiss(animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "You haven't finished your comment yet", message: "Do you want to leave without finishing?", preferredStyle: .alert)
            let action = UIAlertAction(title: "Discart comment", style: .destructive, handler: { [weak self] (alertAction) in
                self?.dismiss(animated: true, completion: nil)
            })
            let action2 = UIAlertAction(title: "Stay in this page", style: .default)
            
            alertController.addAction(action)
            alertController.addAction(action2)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension GSGistCommentViewController {
    
    fileprivate func checkUserInformation() -> Bool {
        
        if GSUserCoordinator.shared.hasCredentials() {
            return true
        } else {
            
            var textFieldLogin: UITextField?
            var textFieldPassword: UITextField?
            let passwordPrompt = UIAlertController(title: "Sign in to comment", message: "You need to enter your login and password to comment this Gist.", preferredStyle: .alert)
            passwordPrompt.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            passwordPrompt.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] action in
                GSUserCoordinator.shared.saveUser(login: textFieldLogin?.text, andPassword: textFieldPassword?.text)
                self?.saveComment()
            }))
            
            passwordPrompt.addTextField(configurationHandler: { (textField: UITextField) in
                textField.placeholder = "Login"
                textFieldLogin = textField
            })
            
            passwordPrompt.addTextField(configurationHandler: { (textField: UITextField) in
                textField.placeholder = "Password"
                textField.isSecureTextEntry = true
                textFieldPassword = textField
            })
            
            
            self.present(passwordPrompt, animated: true, completion: nil)
            
            return false
        }
    }
    
    fileprivate func saveComment() {
        guard checkUserInformation() else { return }
        
        setupUIForLoading()
        viewModel.saveComment(comment: textView.text, forGistID: gistID) { [weak self] (comment, error) in
            
            DispatchQueue.main.async {
                self?.setupUIForNotLoadgin()
                
                if error != nil {
                    
                    let alertController = UIAlertController(title: "Fail to save the comment", message: "Please, try again", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default)
                    let action2 = UIAlertAction(title: "Clear user credentials", style: .destructive) { alertAction in
                        GSUserCoordinator.shared.clear()
                    }
                    alertController.addAction(action)
                    alertController.addAction(action2)
                    self?.present(alertController, animated: true, completion: nil)
                } else {
                    
                    self?.performSegue(withIdentifier: GSSegueIdentifier.unwindGoToGist, sender: nil)
                }
            }
        }
    }
    
    fileprivate func setupUIForLoading() {
        view.endEditing(true)
        barButtonSave.isEnabled = false
        barButtonCancel.isEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.alpha = 0.6
        
        activityIndicator.startAnimating()
    }
    
    fileprivate func setupUIForNotLoadgin() {
        barButtonSave.isEnabled = true
        barButtonCancel.isEnabled = true
        textView.isEditable = true
        textView.isSelectable = true
        textView.alpha = 1.0
        
        activityIndicator.stopAnimating()
    }
    
    func keyboardWillShow(_ sender: Notification) {
        if let userInfo = sender.userInfo,
            let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            constraintTextViewBottom.constant = keyboardSize.height
            
            UIView.animate(withDuration: 0.3) {
                self.textView.layoutIfNeeded()
            }
        }
    }
    
    func keyboardWillHide(_ sender: Notification) {
        constraintTextViewBottom.constant = 0.0
        
        UIView.animate(withDuration: 0.3) {
            self.textView.layoutIfNeeded()
        }
    }
}

extension GSGistCommentViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        barButtonSave.isEnabled = !textView.text.isEmpty
    }
}
