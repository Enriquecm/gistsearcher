//
//  GSGistFileTableViewCell.swift
//  GistSearcher
//
//  Created by Enrique Melgarejo on 27/04/17.
//  Copyright © 2017 Choynowski. All rights reserved.
//

import UIKit

class GSGistFileTableViewCell: UITableViewCell {

    static let identifier = "GSGistFileTableViewCell"
    
    // MARK: Outlets
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var labelHeaderTitle: UILabel!
    
    @IBOutlet weak var viewGutter: OKSGutteredCodeView!
    
    // MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGutter()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        labelHeaderTitle.text = ""
        viewGutter.setText("")
    }
    
    fileprivate func setupGutter() {
        viewGutter.setGutterBackgroundColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
        viewGutter.textView.isEditable = false

        // ECM Note: Now, this delegate is not necessary
        // viewGutter.delegate = self
    }

    func configure(withFile gistFile: GSFile?) {
        guard let file = gistFile else { return }
        
        labelHeaderTitle.text = file.name
        viewGutter.setText(file.content ?? "Fail to load content.")
    }
}

//MARK: CodeViewDelegate Methods
extension GSGistFileTableViewCell: CodeViewDelegate {
    
    func textUpdated(_ text: String) {
        debugPrint(text)
    }
    
    func keyboardWillAppear(_ notification: Notification) {
        debugPrint("Keyboard appeared")
    }
    
    func keyboardWillHide(_ notification: Notification) {
        debugPrint("Keyboard hide")
    }
}
