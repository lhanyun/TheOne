//
//  TOFileDownloadCell.swift
//  TheOne
//
//  Created by lala on 2018/2/23.
//  Copyright © 2018年 ZLZK. All rights reserved.
//

import UIKit
import Alamofire
import FileKit

class TOFileDownloadCell: TOTableViewCell {
    
    var url: String = "" {
        didSet {
            
            guard let str = url.split(separator: "/").last else {
                return
            }
            
            title.text = String(str)
        }
    }

    @IBOutlet weak var downloadBtn: UIButton!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    var isComplete: Bool = true
    
    //下载文件的保存路径（
    var destination:DownloadRequest.DownloadFileDestination!
    //用于停止下载时，保存已下载的部分
    var cancelledData: Data?
    //下载请求对象
    var downloadRequest: DownloadRequest!
    
    @IBAction func buttonAct(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            sender.setTitle("暂停", for: .normal)
            
            if isComplete {
                isComplete = false
                downloadFileTest()
            } else {
                goOnDownload()
            }

        } else {
            sender.setTitle("继续下载", for: .normal)
            
            self.downloadRequest?.cancel()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func downloadFileTest() {
        
        //设置下载路径。保存到用户文档目录，文件名不变，如果有同名文件则会覆盖
        self.destination = { _, response in
            
            let projectFiles = Path.userDocuments + "projectFiles"
            
            if !projectFiles.exists {
                do {
                    try projectFiles.createDirectory()
                } catch {
                    log.debug("创建文件夹失败")
                }
            }
            
            let documentsURL = FileManager.default.urls(for: .documentDirectory,
                                                        in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("projectFiles/" + response.suggestedFilename!)
            //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        //开始下载
        let strUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        self.downloadRequest =  Alamofire.download(
            strUrl!, to: destination)
        
        self.downloadRequest.downloadProgress(queue: DispatchQueue.main,
                                              closure: downloadProgress) //下载进度
        self.downloadRequest.responseData(completionHandler: downloadResponse) //下载停止响应
    }
    
    //暂停后继续下载
    func goOnDownload() {
        
        if let cancelledData = self.cancelledData {
            self.downloadRequest = Alamofire.download(resumingWith: cancelledData,
                                                      to: destination)
            self.downloadRequest.downloadProgress(queue: DispatchQueue.main,
                                                  closure: downloadProgress) //下载进度
            self.downloadRequest.responseData(completionHandler: downloadResponse) //下载停止
        }
    }
    
    //下载过程中改变进度
    func downloadProgress(progress: Progress) {
        //进度条更新
        self.progressView.setProgress(Float(progress.fractionCompleted), animated:true)
        print("当前进度：\(progress.fractionCompleted*100)%")
        
        if progress.fractionCompleted == 1.0 {
            
            downloadBtn.setTitle("下载完成", for: .normal)
            downloadBtn.isEnabled = false
            
            //发送下载完成通知
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: DOWNLOADCOMPLETED), object: nil)
        }
    }
    
    //下载停止响应（不管成功或者失败）
    func downloadResponse(response: DownloadResponse<Data>) {
        switch response.result {
        case .success(let data):
            //self.image = UIImage(data: data)
            print("文件下载完毕: \(response)")
        case .failure:
            self.cancelledData = response.resumeData //意外终止的话，把已下载的数据储存起来
        }
    }
}
