//
//  TOUserViewController.swift
//  TheOne
//
//  Created by lala on 2017/11/17.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import FileKit

class TOUserViewController: TOBaseViewController {

    let dataSource: [String] = ["任务日历","生成日报","消息设置","主题选择","关于软件","建议与评价","清除缓存","退出登入"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "个人中心"
        
//        _ = getCacheSizeWithFilePath()
    }

    override func initUI() {
        super.initUI()
        super.initTableView()

        //注册cell
        tableView.register(cellType: TOUserSettingCell.self)
        tableView.register(cellType: TOSettingTableViewCell.self)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(chooseTheme), name: NSNotification.Name(rawValue: CHOOSETHEME), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(chooseTheme), name: NSNotification.Name(rawValue: UPDATEUSERINFO), object: nil)
    }
    
    @objc fileprivate func chooseTheme() {
        view.backgroundColor = BASE_COLOR
        tableView.backgroundColor = BASE_COLOR
        tableView.reloadData()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension TOUserViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? 1 : dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(for: indexPath) as TOSettingTableViewCell
            
            cell.introduction.text = Tools().userInfo.userModule
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(for: indexPath) as TOUserSettingCell
            
            cell.leftLabel.text = dataSource[indexPath.row]
            cell.accessoryType = .disclosureIndicator
            cell.textField.isEnabled = false
            cell.textField.textAlignment = .right
            
            if indexPath.row == 6 {
                cell.textField.text = getCacheSizeWithFilePath()
            } else {
                cell.textField.text = ""
            }
            
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //取消选择
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            
            show(TOUserInfoViewController(), sender: nil)
            
        } else {
            
            var targetVC: TOBaseViewController? = nil
            
            if indexPath.row == 0 {
                //任务日历
                targetVC = TOTaskCalendarViewController()
                
            } else if indexPath.row == 1 {
                //生成日报
                targetVC = TOTaskDailyViewController()
                
            } else if indexPath.row == 2 {
                //消息提醒设置
                targetVC = TORemindSettingViewController()
                
            } else if indexPath.row == 3 {
                //主题选择
                targetVC = TOThemeViewController()
                
            } else if indexPath.row == 4 {
                //关于软件
                targetVC = TOAboutViewController()
                
            } else if indexPath.row == 5 {
                //建议与评价
                targetVC = TOEvaluateViewController()
                
            } else if indexPath.row == 6 {
                //清除缓存
                let alert = UIAlertController(title: "是否清除APP缓存", message: "", preferredStyle: .alert)
                
                let cancleAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                
                let sureAction = UIAlertAction(title: "果断清除", style: .destructive, handler: {[weak self] (action) in
                    self?.clearCacheWithFilePath()
                    self?.tableView.reloadData()
                })
                
                alert.addAction(cancleAction)
                alert.addAction(sureAction)
                
                present(alert, animated: true, completion: nil)
                
            } else { //退出
                
                let alert = UIAlertController(title: "是否退出当前账号", message: "", preferredStyle: .alert)
                
                let cancleAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                
                let sureAction = UIAlertAction(title: "残忍退出", style: .destructive, handler: { (action) in
                    
                    //发送退出通知
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: LOGOUT), object: nil)
                })
                
                alert.addAction(cancleAction)
                alert.addAction(sureAction)
                
                present(alert, animated: true, completion: nil)
            }
            
            guard let VC = targetVC else { return }
            
            show(VC, sender: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return indexPath.section == 0 ? 80 : 44
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //设置accessoryType视图的背景颜色
        for view in cell.subviews {
            if view.isKind(of: UIButton.self) {
                
                view.backgroundColor = BASE_COLOR
            }
        }
    }
}

//缓存处理
extension TOUserViewController {
    
    //获取缓存大小
    func getCacheSizeWithFilePath() -> String {
        
        // 获取“path”文件夹下的所有文件
        let path = Path.userHome.rawValue
        
        let subPathArr: [String] = FileManager.default.subpaths(atPath: path)!
        
        var filePath: String = ""
        var totleSize = 0.0
        
        for subPath in subPathArr {

            // 1. 拼接每一个文件的全路径
            filePath = path + "/" + subPath

            // 2. 是否是文件夹，默认不是
            var isDirectory: ObjCBool = false

            // 3. 判断文件是否存在
            let isExist = FileManager.default.fileExists(atPath: filePath)
            FileManager.default.fileExists(atPath: filePath, isDirectory: &isDirectory)


            // 4. 以上判断目的是忽略不需要计算的文件
            if !isExist || isDirectory.boolValue || filePath.contains(".DS")  || filePath.contains(".json") || filePath.contains("projectFiles") {
                // 过滤: 1. 文件夹不存在  2. 过滤文件夹  3. 隐藏文件
                continue;
            }

            // 5. 指定路径，获取这个路径的属性
            let dict = try? FileManager.default.attributesOfItem(atPath: filePath)

            /**
             attributesOfItemAtPath: 文件夹路径
             该方法只能获取文件的属性, 无法获取文件夹属性, 所以也是需要遍历文件夹的每一个文件的原因
             */

            // 6. 获取每一个文件的大小
            let a = dict![FileAttributeKey.size] as! Int
            
            let size: Double = Double(a)

            // 7. 计算总大小
            totleSize += size
        }

        //8. 将文件夹大小转换为 M/KB/B
        var totleStr = ""

        if totleSize > 1000 * 1000 {
            totleStr = "\((totleSize / 1000.00)/1000.00) M"

        }else if (totleSize > 1000){
            totleStr = "\(totleSize / 1000.00) KB"

        }else{
            totleStr = "\(totleSize / 1.00) B"
        }

        return totleStr
    }
    
    func clearCacheWithFilePath() {
        
        //拿到path路径的下一级目录的子文件夹
        // 获取“path”文件夹下的所有文件
        let path = Path.userHome.rawValue
        
        let subPathArr: [String] = FileManager.default.subpaths(atPath: path)!

        var filePath = ""

        for subPath in subPathArr {
            
            // 1. 拼接每一个文件的全路径
            filePath = path + "/" + subPath
            
            // 2. 是否是文件夹，默认不是
            var isDirectory: ObjCBool = false
            
            // 3. 判断文件是否存在
            let isExist = FileManager.default.fileExists(atPath: filePath)
            FileManager.default.fileExists(atPath: filePath, isDirectory: &isDirectory)
            
            // 4. 以上判断目的是忽略不需要计算的文件
            if !isExist || isDirectory.boolValue || filePath.contains(".DS")  || filePath.contains(".json") || filePath.contains("projectFiles") {
                // 过滤: 1. 文件夹不存在  2. 过滤文件夹  3. 隐藏文件
                continue;
            }
            
            //删除子文件夹
            try? FileManager.default.removeItem(atPath: filePath)
            
        }
        
    }
}
