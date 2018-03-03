//
//  TOReadFileViewController.swift
//  TheOne
//
//  Created by lala on 2018/2/24.
//  Copyright © 2018年 ZLZK. All rights reserved.
//

import UIKit
import QuickLook

class TOReadFileViewController: QLPreviewController {

    var filePath: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        dataSource = self
        currentPreviewItemIndex = 0
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: self, action: #selector(popVC))
    }
    
    @objc fileprivate func popVC() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        UIView.animate(withDuration: 0.2, animations: {
            self.navigationController?.navigationBar.alpha = 0
        }) { (isbool) in
            
            self.navigationController?.navigationBar.isHidden = true
            self.navigationController?.navigationBar.alpha = 1
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.alpha = 1
    }
    
    deinit {
        log.debug("文件浏览控制器销毁")
    }
}

extension TOReadFileViewController: QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        
        return URL(fileURLWithPath: filePath) as QLPreviewItem
    }
    
    func previewControllerDidDismiss(_ controller: QLPreviewController) {
        
        
    }
}
