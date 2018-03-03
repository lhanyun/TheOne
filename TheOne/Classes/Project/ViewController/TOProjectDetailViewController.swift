//
//  TOProjectDetailViewController.swift
//  TheOne
//
//  Created by lala on 2017/11/14.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit

class TOProjectDetailViewController: TOBaseViewController {

    fileprivate let sectionOne = ["项目名称","开始日期","预计结束日期"]
    
    //时间节点头视图是否被选择
    fileprivate var nodeSelected: Bool = false
    //项目成员头视图是否被选择
    fileprivate var memberSelected: Bool = false
    //项目模块头视图是否被选择
    fileprivate var moduleSelected: Bool = false
    
    var projectId:String = Tools().userInfo.projectId
    
    var model:ProjectInfoModel? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navItem.rightBarButtonItem = UIBarButtonItem(title: "编辑", selector: #selector(pushEditVC), target: self, isBack: false)
        
        refreshList()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshList), name: NSNotification.Name(rawValue: "RefreshProjectList"), object: nil)
        
    }

    
    override func initUI() {
        super.initUI()
        super.initTableView()
        
        setTableView()
        
        title = "项目详情"
        
    }
    
    //编辑项目
    @objc fileprivate func pushEditVC() {
        
        if model?.userId == Tools().userInfo.id {
            performSegue(withIdentifier: "ToAddProject", sender: nil)
        } else {
            TipHUD.sharedInstance.showTips("只有此项目的创建者才有权限编辑")
        }
        
    }
    
    @objc fileprivate func refreshList() {
        //请求数据
        projectId.count != 0 ? ProjectDetailViewModel().getData(self, projectId) : (log.debug("projectId为nil"))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! TOAddProjectViewController
        vc.title = "编辑项目"
        
        guard let model = self.model else {
            return
        }
        
        var timenodes:[[String: String]] = []
        for timenode in model.timeNode {
            let node = timenode.toJSON()
            timenodes.append(node as! [String : String])
        }
        
        var members:[[String:String]] = []
        for member in model.members {
            members.append(["userId": "\(member.id)", "role": member.userRole])
        }
        
        vc.members = model.members
        
        vc.dataSource = [
            "projectName": model.projectName,
            "startTime": model.createTime,
            "endTime": model.endTime,
            "timeNode": timenodes,
            "members": members,
            "projectNotice": model.projectNotice,
            "projectId": model.projectId,
            "modules": model.modules
        ]
        
    }

}

extension TOProjectDetailViewController {
    
    fileprivate func setTableView() {
        
        //注册cell
        tableView.register(cellType: TOProjectDetailTableViewCell.self)
        tableView.register(cellType: TOTimeNodeCell.self)
        tableView.register(cellType: TOMemberCell.self)
        tableView.register(cellType: TOUserInfoCell.self)
        tableView.register(cellType: TOProjectTableViewCell.self)
        tableView.register(cellType: TONoticeCell.self)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension TOProjectDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
        case 0:
            return 3
        case 1:
            
            if !nodeSelected {
                return 0
            }
            
            return model?.timeNode.count ?? 0
        case 2:
            
            if !memberSelected {
                return 0
            }
            
            return model?.members.count ?? 0
        case 3:
            
            if !moduleSelected {
                return 0
            }
            
            return model?.modules.count ?? 0
        case 4:
            return 1
        case 5:
            return 1
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TOProjectDetailTableViewCell.self)
            
            cell.leftLabel.text = sectionOne[indexPath.row]
            
            switch indexPath.row {
            case 0:
                cell.rightView.text = model?.projectName
            case 1:
                cell.rightView.text = model?.createTime
            case 2:
                cell.rightView.text = model?.endTime
            default:
                cell.rightView.text = ""
            }
            
            return cell
            
        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TOTimeNodeCell.self)
            
            cell.isEdit = false
            cell.model = model?.timeNode[indexPath.row]
            
            return cell
            
        } else if indexPath.section == 2 {
            
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TOMemberCell.self)
            
            cell.model = model?.members[indexPath.row]
            
            return cell
            
        } else if indexPath.section == 3 {
            
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TOUserInfoCell.self)
            
            cell.leftLabel.text = model?.modules[indexPath.row]
            
            return cell
            
        } else if indexPath.section == 4 {
            
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TOProjectTableViewCell.self)
            
            cell.model = model
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TONoticeCell.self)
            
            cell.textView.text = model?.projectNotice
            cell.textView.isEditable = false
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 44
        case 1:
            return 210
        case 2:
            return 64
        case 3:
            return 44
        case 4:
            return 540
        case 5:
            return 188
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 || section == 4 {
            return UIView()
        }
        
        let headerView = SectionHearderView.hearderView()
        
        switch section {
        case 1:
            headerView.isSelected = nodeSelected
            headerView.leftLabel.text = "时间节点 "
        case 2:
            headerView.isSelected = memberSelected
            headerView.leftLabel.text = "项目成员 "
        case 3:
            headerView.isSelected = moduleSelected
            headerView.leftLabel.text = "项目模块 "
        default:
            break
        }
        
        headerView.tag = (section + 20)
        
        headerView.addTarget(self, action: #selector(showCell(_:)), for: .touchUpInside)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return (section == 0 || section == 4 || section == 5) ? 0 : 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //控制显示和隐藏 时间节点/成员 cell
    @objc fileprivate func showCell(_ btn: UIControl) {
        
        if btn.tag == 21 {
            
            nodeSelected = !nodeSelected
            tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
            
        } else if btn.tag == 22 {
            memberSelected = !memberSelected
            tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
        } else {
            moduleSelected = !moduleSelected
            tableView.reloadSections(IndexSet(integer: 3), with: .automatic)
        }
        
    }
}
