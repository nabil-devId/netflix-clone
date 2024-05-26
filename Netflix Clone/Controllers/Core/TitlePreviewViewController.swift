//
//  TitlePreviewViewController.swift
//  Netflix Clone
//
//  Created by Ahmad Nabil on 26/05/24.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let webkit = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
