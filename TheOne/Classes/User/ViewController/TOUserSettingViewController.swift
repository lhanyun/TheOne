//
//  TOUserSettingViewController.swift
//  TheOne
//
//  Created by lala on 2018/1/8.
//  Copyright © 2018年 ZLZK. All rights reserved.
//

import UIKit

class TOUserSettingViewController: TOBaseViewController {

    fileprivate let dataSource: [String] = ["昵称","当前项目标签","电话","邮箱","负责模块"]
    
    fileprivate let projectModules = Tools().userInfo.projectModules.split(separator: ",").map {
        String($0)
    }
    
    var editData: [String: String] = [
        "projectId": Tools().userInfo.projectId,
                                      "index": "1",
                                      "nickName": Tools().userInfo.userNickName,
                                      "role": "",
                                      "phoneNum": Tools().userInfo.userPhone,
                                      "eMail": Tools().userInfo.userEmail,
                                      "module": Tools().userInfo.userModule] {
        didSet {
            if navItem.rightBarButtonItem == nil {
                navItem.rightBarButtonItem = UIBarButtonItem(title: "完成", selector: #selector(overEdit), target: self, isBack: false)
            }
        }
    }
    
    var role: String? {
        didSet {
            let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! TOUserInfoCell
            cell.rightLabel.text = role
            
            editData["role"] = role
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "用户信息修改"
        
        //获取角色信息
        UserSettingViewModel().userInfoEdit(projectId: Tools().userInfo.projectId, index: "0", nickName: "", role: "", phoneNum: "", eMail: "", module: "", VC: self)
    }
    
    @objc fileprivate func overEdit() {
        
        //从cell上获取module的值
        let cell = tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as! TOUserSettingModuleCell
        
        let module = cell.moduleArr.joined(separator: ",")
        
        //提交编辑信息
        UserSettingViewModel().userInfoEdit(
            projectId: Tools().userInfo.projectId,
                                            index: "1",
                                            nickName: editData["nickName"] ?? "",
                                            role: editData["role"] ?? "",
                                            phoneNum: editData["phoneNum"] ?? "",
                                            eMail: editData["eMail"] ?? "",
                                            module: module,
                                            VC: self)
    }
    
    override func initUI() {
        super.initUI()
        super.initTableView()
        
        //注册cell
        tableView.register(cellType: TOUserInfoCell.self)
        tableView.register(cellType: TOUserSettingModuleCell.self)
        
        tableView.dataSource = self
        tableView.delegate = self
    }

}

extension TOUserSettingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 4 {
            
            let cell = tableView.dequeueReusableCell(for: indexPath) as TOUserSettingModuleCell
            
            let module = Tools().userInfo.userModule.split(separator: ",")
            
            if Tools().userInfo.userModule.count != 0  {
                if module.count == 0{
                    cell.module = Tools().userInfo.userModule
                } else {
                    module.forEach({ (title) in
                        cell.module = String(title)
                    })
                }
            }

            return cell
        }
            
        let cell = tableView.dequeueReusableCell(for: indexPath) as TOUserInfoCell
        
        cell.leftLabel.text = dataSource[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        
        if indexPath.row == 0 {
            cell.rightLabel.text = Tools().userInfo.userNickName
        } else if indexPath.row == 1 {
            cell.rightLabel.text = Tools().userInfo.userRole
        } else if indexPath.row == 2 {
            cell.rightLabel.text = Tools().userInfo.userPhone
        } else if indexPath.row == 3 {
            cell.rightLabel.text = Tools().userInfo.userEmail
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row != 1 && indexPath.row != 4 {
            
            let title = "请输入\(dataSource[indexPath.row])"
            
            TOAlterView.newTOAlterView(targetVC: self, title: title, indexPath: indexPath)
            
        } else {
            
            showPickerView(indexPath)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return indexPath.row == 4 ? 70 : 44
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

extension TOUserSettingViewController: TOAlterViewDelegate, TOPickerViewDelegate {
    
    func alterViewDidInPut(_ content: String, _ indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! TOUserInfoCell
        cell.rightLabel.text = content
        
        if indexPath.row == 0 {
            editData["nickName"] = content
        }else if indexPath.row == 2 {
            editData["phoneNum"] = content
        } else if indexPath.row == 3 {
            editData["eMail"] = content
        }
    }
    
    fileprivate func showPickerView(_ indexPath: IndexPath) {
        
        var pickerViewData: [String] = []
        var pickerViewTitile: String = ""
        
        switch indexPath.row {
        case 1:
            pickerViewData = ["iOS","Android","后台","web", "项目经理"]
            pickerViewTitile = "请选择标签"
        case 4:
            pickerViewData = projectModules
            pickerViewTitile = "请选择模块"
        default:
            break
        }
        
        TOPicker.newTOPickerView(targetVC: self, dataSource: pickerViewData, title: pickerViewTitile, indexPath: indexPath)
    }
    
    func pickerViewDidSelect(_ index: Int, _ content: String, _ indexPath: IndexPath) {

        if indexPath.row == 1 {
            
            let cell = tableView.cellForRow(at: indexPath) as! TOUserInfoCell
            cell.rightLabel.text = content
            editData["role"] = content
            
        } else if indexPath.row == 4 {
            
            let cell = tableView.cellForRow(at: indexPath) as! TOUserSettingModuleCell
            cell.module = content
            editData["module"] = cell.moduleArr.joined(separator: ",")
        }
        
    }
}
