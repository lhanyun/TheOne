//
//  TOWebReadFileController.swift
//  TheOne
//
//  Created by lala on 2018/2/24.
//  Copyright © 2018年 ZLZK. All rights reserved.
//

import UIKit
import QuickLook

class TOWebReadFileController: TOBaseViewController {
    
    var filePath: String = ""

    fileprivate lazy var webView: UIWebView = {
        
       let web = UIWebView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        web.delegate = self
        web.scalesPageToFit = true
        view.addSubview(web)
        web.snp.makeConstraints { (make) in
            
            make.top.equalTo(navigationBar.snp.bottom)
            make.right.left.bottom.equalTo(view)
        }
        return web
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDocument(web: webView)

        guard let path = filePath.split(separator: "/").last?.split(separator: ".").first else {
            return
        }
        title = String(path)
        
    }
    
}

extension TOWebReadFileController: UIWebViewDelegate {
    
    func loadDocument(web: UIWebView) {
        
        let url = URL(fileURLWithPath: filePath)
        
        let request = URLRequest(url: url)

        web.loadRequest(request)
    }
    
}
