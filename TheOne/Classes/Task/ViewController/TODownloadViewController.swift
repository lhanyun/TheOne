//
//  TODownloadViewController.swift
//  TheOne
//
//  Created by lala on 2018/2/23.
//  Copyright © 2018年 ZLZK. All rights reserved.
//

import UIKit
import FileKit

class TODownloadViewController: TOBaseViewController {
    
    let documentsURL = Path.userDocuments + "projectFiles"

    var model: UpdateFileModel? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var fileArray: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "项目文档"
        
        getLocationFile()
        
        FileDownloadViewModel().getProjectFiles(self)
        
        navItem.rightBarButtonItem = UIBarButtonItem(title: "导入文档", selector: #selector(importFile), target: self, isBack: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(downloadOver), name: NSNotification.Name(rawValue: DOWNLOADCOMPLETED), object: nil)
    }

    override func initUI() {
        super.initUI()
        super.initTableView()
        
        //注册cell
        tableView.register(cellType: TOFileDownloadCell.self)
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    @objc fileprivate func downloadOver() {
        getLocationFile()
        
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    @objc fileprivate func importFile() {
        show(TOImportFileController(), sender: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        log.debug("\(#function)")
    }
}

extension TODownloadViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return fileArray.count
        }
        return model?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(for: indexPath) as TOFileDownloadCell
        
        if indexPath.section == 0 {
            cell.downloadBtn.isHidden = true
            cell.progressView.isHidden = true
            cell.title.text = fileArray[indexPath.row]
        } else {
            cell.url = model?.data[indexPath.row] ?? ""
            cell.downloadBtn.isHidden = false
            cell.progressView.isHidden = false
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            
            let vc = TOReadFileViewController()
            vc.filePath = (documentsURL.rawValue + "/" + fileArray[indexPath.row])

            show(vc, sender: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return section == 0 ? "本地文档" : "远程文档"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }

}

extension TODownloadViewController {
    
    //获取本地文档
    func getLocationFile() {

        if !documentsURL.exists {
            do {
                try documentsURL.createDirectory()
            } catch {
                log.debug("创建文件夹失败")
            }
        }
        
        //获取目录下所有文件
        fileArray = FileManager.default.subpaths(atPath: documentsURL.rawValue)?.filter({ (str) -> Bool in
            return str.contains(".txt") || str.contains(".doc") || str.contains(".pdf") || str.contains(".xls") || str.contains(".pdf")
        }) ?? []
    }
    
}


