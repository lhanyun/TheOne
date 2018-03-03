//
//  TOPresentProjectDViewController.swift
//  TheOne
//
//  Created by lala on 2018/1/8.
//  Copyright © 2018年 ZLZK. All rights reserved.
//

import UIKit

class TOPresentProjectDViewController: TOBaseViewController {

    let dataSource: [String] = ["负责模块","被赞数"]
    
    var model: UserModel? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "所在项目的个人概况"
        
        UserInfoViewModel().getUserCurrentInfo(VC: self)
    }
    
    override func initUI() {
        super.initUI()
        super.initTableView()
        
        //注册cell
        tableView.register(cellType: TOUserInfoCell.self)
        tableView.register(cellType: TOProjectTableViewCell.self)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    fileprivate func tableViewHeaderView() -> TOUserInfoHeaderView {
        
        let v = TOUserInfoHeaderView.userInfoHeaderView()
        
        v.postValueBlock = { [weak self] (index) in
            
            if index == 0 {
                self?.show(TOUserSettingViewController(), sender: nil)
            } else if index == 1 {
                
            }
            
        }
        
        v.frame = CGRect(x: 0, y: 0, width: IPHONE_WIDTH, height: 154)
        
        return v
    }
}

extension TOPresentProjectDViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return dataSource.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row != dataSource.count {
            
            let cell = tableView.dequeueReusableCell(for: indexPath) as TOUserInfoCell
            
            cell.leftLabel.text = dataSource[indexPath.row]
            
            if indexPath.row == 0 {
                cell.rightLabel.text = Tools().userInfo.userModule
            } else {
                cell.rightLabel.text = model?.praiseNum
            }
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(for: indexPath) as TOProjectTableViewCell
            
            cell.infoModel = model
            
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return indexPath.row == dataSource.count ? 600 : 44
    }

}
