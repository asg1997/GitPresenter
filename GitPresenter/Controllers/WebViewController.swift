//
//  WebViewController.swift
//  GitPresenter
//
//  Created by Максим on 07.08.2021.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    var repoUrl: URL? 
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let repoUrl = repoUrl else { return }
        webView.load(URLRequest(url: repoUrl))
        
    }
    

  
    @IBAction func shareTapped(_ sender: UIBarButtonItem) {
        guard let repoUrl = repoUrl else { return }
        let ac = UIActivityViewController(activityItems: [repoUrl], applicationActivities: nil)
        present(ac, animated: true, completion: nil)
    }
    
}
