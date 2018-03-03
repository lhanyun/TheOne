//
//  TOimportFileController.swift
//  TheOne
//
//  Created by lala on 2018/2/24.
//  Copyright © 2018年 ZLZK. All rights reserved.
//

import UIKit
import GCDWebServer
import FileKit

class TOImportFileController: TOBaseViewController {

    fileprivate lazy var showIpLabel: UILabel = {
        
        let l = UILabel(frame: CGRect(x: 0, y: 0, width: IPHONE_WIDTH, height: 200))
        l.center = view.center
        l.textColor = UIColor.flatGray
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 13)
        l.numberOfLines = 0
        view.addSubview(l)
        
        return l
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        
        let l = UILabel(frame: CGRect(x: 0, y: 20, width: IPHONE_WIDTH, height: 200))
        l.textColor = UIColor.flatBlack
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 17)
        l.numberOfLines = 0
        view.addSubview(l)
        
        return l
    }()
    
    var fileArray: [String] = []
    
    let documentsPath = Path.userDocuments
    
    var _webServer: GCDWebUploader?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "在线导入文档"
        
        titleLabel.text = "请确认手机和PC在同一局域网内"
    }

    override func initUI() {
        super.initUI()
        super.initTableView()
        
        //注册cell
        tableView.register(cellType: TOFileDownloadCell.self)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.emptyDataSetSource = nil
        tableView.emptyDataSetDelegate = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setWebServer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        _webServer?.stop()
        _webServer = nil
    }
    
    fileprivate func setWebServer() {
        
        _webServer = GCDWebUploader(uploadDirectory: documentsPath.rawValue)
        
        _webServer?.delegate = self
        _webServer?.allowHiddenItems = true
        
        // 限制文件上传类型
        _webServer?.allowedFileExtensions = ["doc", "docx", "xls", "xlsx", "txt", "pdf"]
        // 设置网页标题
        _webServer?.title = "上传/下载项目文档";
        // 设置展示在网页上的文字(开场白)
        _webServer?.prologue = "欢迎使用TheOne的WIFI管理平台"
        // 设置展示在网页上的文字(收场白)
        _webServer?.epilogue = "theone制作"
        
        if _webServer?.start() ?? false {
            showIpLabel.isHidden = false
            showIpLabel.text = "请在网页输入这个地址  http://\(SJXCSMIPHelper.deviceIPAdress() ?? ""):\(_webServer?.port ?? 80)/"
        } else {
            showIpLabel.text = "GCDWebServer not running!"
        }
    }
}

extension TOImportFileController: GCDWebUploaderDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(for: indexPath) as TOFileDownloadCell
        
        cell.url = fileArray[indexPath.row]
        cell.progressView.isHidden = true
        cell.downloadBtn.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = TOReadFileViewController()
        vc.filePath = fileArray[indexPath.row]
        vc.navigationController?.navigationBar.isHidden = false
        show(vc, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    func webUploader(_ uploader: GCDWebUploader, didUploadFileAtPath path: String) {
        
        showIpLabel.isHidden = true
        
        titleLabel.isHidden = true
        
        fileArray.append(path)
        
        tableView.reloadData()
    }
    
    func webUploader(_ uploader: GCDWebUploader, didDeleteItemAtPath path: String) {
        
    }
}
