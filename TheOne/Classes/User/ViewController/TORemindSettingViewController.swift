//
//  TORemindSettingViewController.swift
//  TheOne
//
//  Created by lala on 2018/1/10.
//  Copyright © 2018年 ZLZK. All rights reserved.
//

import UIKit

class TORemindSettingViewController: TOBaseViewController {

    let dataSource: [[String]] = [["声音","震动"],["闪烁","震动"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "提醒设置"
    }
    
    override func initUI() {
        super.initUI()
        super.initTableView()
        
        //注册cell
        tableView.register(cellType: TORemindSettingCell.self)
        
        tableView.dataSource = self
        tableView.delegate = self
    }

}

extension TORemindSettingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(for: indexPath) as TORemindSettingCell
        cell.leftLabel.text = dataSource[indexPath.section][indexPath.row]
        
        cell.postValueBlock = { (isOn) in
            print(isOn)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            show(TOPresentProjectDViewController(), sender: nil)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: IPHONE_WIDTH, height: 40))
        label.text = (section == 0) ? "  本地消息提醒" : "  任务即将到期提醒"
        return label
    }
    
}
