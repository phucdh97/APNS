//
//  APNSViewController.swift
//  Component
//
//  Created by Do Huu Phuc on 19/01/2023.
//

import UIKit
import UserNotifications

class APNSViewController: UIViewController {
    
    private var textView: UILabel?
    public var curText: String = "Default text"
   
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        let textV = UILabel(frame: CGRect(x: 50, y: 100, width: 300, height: 400))
        textV.backgroundColor = .blue
        textV.textColor = .white
        textV.text = curText
        textV.font = .systemFont(ofSize: 16, weight: .medium)
        textV.contentMode = .center
        textView = textV
        self.view.addSubview(textV)
    }
    
    public func updateText(text: String) {
        curText = text
        textView?.text = text
    }
}
