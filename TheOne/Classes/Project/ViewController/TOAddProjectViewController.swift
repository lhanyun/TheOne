//
//  TOAddProjectViewController.swift
//  TheOne
//
//  Created by lala on 2017/11/18.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import FontAwesomeKit
import pop

class TOAddProjectViewController: TOBaseViewController {
    
    fileprivate let sectionOne = [["项目名称","请填写项目名称"],["开始日期","选择开始日期"],["预计结束日期","选择接结束日期"]]
    
    //时间节点头视图是否被选择
    fileprivate var nodeSelected: Bool = false
    //项目成员头视图是否被选择
    fileprivate var memberSelected: Bool = false
    //项目模块头视图是否被选择
    fileprivate var moduleSelected: Bool = false
    
    fileprivate var timeStamp: String {
        return String(Int(Date().timeIntervalSince1970))
    }
    
    var projectId: String = ""
    
    //成员
    var members:[UserInfo] = []
    
    var dataSource: [String: Any] = ["projectName": "",
                                     "startTime": "",
                                     "endTime": "",
                                     "timeNode": [],
                                     "members": [],
                                     "modules": [],
                                     "projectNotice": "",
                                     "projectId": ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "添加项目"
    }
    
    override func initUI() {
        super.initUI()
        
        tableViewSet()
        
        navItem.rightBarButtonItem = UIBarButtonItem(title: "提交", selector: #selector(submit), target: self, isBack: false)
    }
    
    func tableViewSet() {

        tableView = UITableView(frame: view.bounds, style: .grouped)

        view.insertSubview(tableView, belowSubview: navigationBar)

        tableView.contentInset = UIEdgeInsets(top: CGFloat(NavibarH) + StatusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        tableView.delegate = self
        tableView.dataSource = self


        //注册cell
        tableView.register(cellType: TOProjectDetailTableViewCell.self)
        tableView.register(cellType: TOTimeNodeCell.self)
        tableView.register(cellType: TOMemberCell.self)
        tableView.register(cellType: TONoticeCell.self)
        tableView.register(cellType: TOUserInfoCell.self)

        tableView.rx.itemSelected
            .subscribe(onNext: {[weak self] indexPath in

                self?.tableView.deselectRow(at: indexPath, animated: true)
                
                if indexPath.section == 0 {
                    self?.pushVC(indexPath)
                } else if indexPath.section == 2 {
                    self?.setMemberRole(indexPath)
                }
                
            })
            .disposed(by: rx.disposeBag)
    }

    deinit {
        log.debug("添加项目销毁")
    }
    
    //提交项目
    @objc fileprivate func submit() {
        AddProjectViewModel().submitProject(self, dataSource)
    }

}

extension TOAddProjectViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
        case 0:
            return 3
        case 1:
            guard let timeNode = dataSource["timeNode"] as? [[String: String]] else { return 0 }

            return nodeSelected ? timeNode.count : 0
        case 2:

            return memberSelected ? members.count : 0
        case 3:
            guard let module = dataSource["modules"] as? [String] else { return 0 }
            
            return moduleSelected ? module.count : 0
        case 4:
            return 1
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {

            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TOProjectDetailTableViewCell.self)
                
                cell.leftLabel.text = sectionOne[indexPath.row][0]
                cell.rightView.placeholder = sectionOne[indexPath.row][1]
                
                //projectName是否可编辑
                cell.rightView.isEnabled = true
                
                cell.rightView.delegate = self
                
                cell.rightView.text = (self.dataSource["projectName"] as? String) ?? ""
                
                return cell
            } else  {
                
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TOProjectDetailTableViewCell.self)
                
                cell.leftLabel.text = sectionOne[indexPath.row][0]
                cell.rightView.placeholder = sectionOne[indexPath.row][1]
                
                cell.rightView.isEnabled = false
                
                cell.rightView.text = (indexPath.row == 1) ? (self.dataSource["startTime"] as! String) : (self.dataSource["endTime"] as! String)
                
                return cell
            }

        } else if indexPath.section == 1 { //时间节点

            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TOTimeNodeCell.self) as TOTimeNodeCell
            
            cell.timeBtn.tag = indexPath.row + 1
            cell.timeBtn.addTarget(self, action: #selector(buttonAct), for: .touchUpInside)
            
            cell.textView.tag = indexPath.row + 100
            cell.textView.delegate = self
            
            cell.personBtn.tag = indexPath.row + 1000
            cell.personBtn.addTarget(self, action: #selector(buttonAct), for: .touchUpInside)
            
            cell.cancelBtn.tag = indexPath.row + 10000
            cell.cancelBtn.addTarget(self, action: #selector(buttonAct), for: .touchUpInside)

            guard let timeNode = dataSource["timeNode"] as? [[String: String]] else {
                return cell
            }
            
            if (timeNode[indexPath.row]["time"])?.count != 0 {
                cell.timeBtn.setTitle(timeNode[indexPath.row]["time"], for: .normal)
            } else {
                cell.timeBtn.setTitle("选择时间", for: .normal)
            }
            
            if (timeNode[indexPath.row]["affiliatedPerson"])?.count != 0 {
                cell.personBtn.setTitle(timeNode[indexPath.row]["affiliatedPerson"], for: .normal)
            } else {
                cell.personBtn.setTitle("请选择关联人", for: .normal)
            }
            
            cell.textView.text = timeNode[indexPath.row]["content"]

            return cell

        } else if indexPath.section == 2 {

            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TOMemberCell.self)
            
            cell.model = members[indexPath.row]
            
            return cell
        }  else if indexPath.section == 3 {
            
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TOUserInfoCell.self)
            
            guard let module = dataSource["modules"] as? [String] else {
                return cell
            }
            
            cell.leftLabel.text = module[indexPath.row]
            
            return cell
            
        } else {

            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TONoticeCell.self)
            
            cell.notice?
                .subscribe(onNext: {[weak self] element in
                    self?.dataSource["projectNotice"] = element
                })
                .disposed(by: rx.disposeBag)
            
            cell.textView.text = dataSource["projectNotice"] as! String
            
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if section == 0 || section == 4 {
            return UIView()
        }

        let headerView = SectionHearderView.hearderView()
        headerView.tag = (section + 20)

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
        
        headerView.addTarget(self, action: #selector(showCell(_:)), for: .touchUpInside)

        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        if section == 0 || section == 4 {
            return UIView()
        }

        let footerView = AddItemView.footerView()
        
//        footerView.isSelected = memberSelected

        footerView.tag = (section + 10)
        
        switch section {
        case 1:
            footerView.isSelected = nodeSelected
            footerView.contectText = "添加新的节点 "
        case 2:
            footerView.isSelected = memberSelected
            footerView.contectText = "添加新的成员 "
        case 3:
            footerView.isSelected = moduleSelected
            footerView.contectText = "添加新的项目模块 "
        default:
            break
        }
        
        footerView.addTarget(self, action: #selector(insertTimeNodeCell), for: .touchUpInside)

        return footerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return (section == 0 || section == 4) ? 0 : 44
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

        return (section == 0 || section == 4) ? 0 : 44
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch indexPath.section {
        case 0, 3:
            return 44
        case 1:
            return 210
        case 2:
            return 64
        case 4:
            return 188
        default:
            return 0
        }

    }

}

extension TOAddProjectViewController {
    
    //插入时间节点单元格
    @objc fileprivate func insertTimeNodeCell(_ btn: UIControl) {
        
        if btn.tag == 11 {
            
            (tableView.viewWithTag(21) as? UIControl)?.isSelected = true
            nodeSelected = true
            
            let cellItme = ["time": "", "content": "", "affiliatedPerson": ""]
            
            guard let timeNode = dataSource["timeNode"] as? [[String: String]] else {
                return
            }
            
            var timeNodes = timeNode
            
            timeNodes.append(cellItme)
            
            dataSource["timeNode"] = timeNodes
            
            tableView.reloadData()
            
        } else if btn.tag == 12 {
            
            (tableView.viewWithTag(22) as? UIControl)?.isSelected = true
            memberSelected = true
            
            performSegue(withIdentifier: "ChooseMember", sender: IndexPath(row: 0, section: 2))
            
            tableView.reloadData()

        } else { //添加项目模块
            
            let alert = UIAlertController(title: "添加项目模块", message: "", preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "填写项目模块名称"
            })
            
            let cancleAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            let sureAction = UIAlertAction(title: "确认", style: .destructive, handler: {[weak self] (action) in
                
                guard let modules = self?.dataSource["modules"] as? [String],
                let str = alert.textFields?.first?.text else {
                    log.debug("参数错误")
                    return
                }
                
                var mTmp = modules
                
                guard let arr = try? modules.filter({ (moduleName) -> Bool in
                    return moduleName == str
                }) else {
                    return
                }

                arr.count > 0 ? {return}() : mTmp.append(str)
                
                self?.dataSource["modules"] = mTmp
                
                self?.moduleSelected = true
                
                self?.tableView.reloadData()
            })
            
            alert.addAction(cancleAction)
            alert.addAction(sureAction)
            
            present(alert, animated: true, completion: nil)
        }

//FIXME:待解决tableView插入cell动画
//        let indexpath = NSIndexPath(row: timeNodes.count - 1, section: 1)
//        tableView.beginUpdates()
//        tableView.insertRows(at: [indexpath as IndexPath], with: .automatic)
//        tableView.endUpdates()
        
    }
    
    //控制显示和隐藏 时间节点/成员 cell
    @objc fileprivate func showCell(_ btn: UIControl) {
        
        if btn.tag == 21 {
            
            nodeSelected = !nodeSelected
//            tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
            tableView.reloadData()
            
        } else if btn.tag == 22 {
            memberSelected = !memberSelected
            tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
        } else {
            moduleSelected = !moduleSelected
            tableView.reloadSections(IndexSet(integer: 3), with: .automatic)
        }
        
    }
    
    //选择项目开始时间与结束时间
    @objc fileprivate func pushVC(_ indexpath: IndexPath) {
        
        indexpath.row != 0 ? performSegue(withIdentifier: "ToCalendar", sender: indexpath) : ()
        
    }
    
    //添加成员角色
    @objc fileprivate func setMemberRole(_ indexpath: IndexPath) {
        
        guard let member = dataSource["members"] as? [[String: String]] else {
            return
        }
        var tmp = member
        
        let alert = UIAlertController(title: "添加成员角色", message: "", preferredStyle: .actionSheet)
        
        let cancleAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        for string in ["iOS前端","web前端","Android前端","后台"] {
            
            let action = UIAlertAction(title: string, style: .default) { [weak self] (action) in
                
                tmp[indexpath.row]["role"] = string
                self?.dataSource["members"] = tmp
                
                let cell = self?.tableView.cellForRow(at: indexpath) as! TOMemberCell
                
                cell.userRole.text = string
            }
            
            alert.addAction(action)
        }
        alert.addAction(cancleAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //时间节点 - 时间选择
    @objc fileprivate func buttonAct(btn: UIButton) {
        
        if btn.tag < 1000 { //选择时间
            
            let indexPath = IndexPath(row: btn.tag - 1, section: 1)
            performSegue(withIdentifier: "ToCalendar", sender: indexPath)
            
        } else if btn.tag < 10000 { //选择关联人
            
            let indexPath = IndexPath(row: btn.tag - 1000, section: 1)
            performSegue(withIdentifier: "ChooseMember", sender: indexPath)
            
        } else { //删除
            
            let index = btn.tag - 10000
            
            guard let timeNode = dataSource["timeNode"] as? [[String: String]] else {
                return
            }
            var timeNodes = timeNode
            
            timeNodes.remove(at: index)
            
            dataSource["timeNode"] = timeNodes
            
            tableView.reloadData()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexpath:IndexPath = sender as! IndexPath
        
        if indexpath.section == 2 {
            
            let vc = segue.destination as! TOChooseMemberViewController
            
            vc.selectCell = members
            
            vc.isShowAll = "0"
            
            vc.postValueBlock = {[weak self] array in

                var memberArr:[[String: String]] = []
                for member in array {
                    memberArr.append(["userId": "\(member.id)", "role": ""])
                }
                
                self?.members = array
                
                self?.dataSource["members"] = memberArr
                
                self?.memberSelected = true
                
                self?.tableView.reloadData()
                
            }
            
            return
        }
        
        if (segue.destination as! TOBaseViewController).isKind(of: TOCalendarViewController.self) {
            let vc = segue.destination as! TOCalendarViewController
            
            vc.transitioningDelegate = self
            
            vc.modalPresentationStyle = .custom
            
            vc.indexPath = indexpath
            
            //处理传值逻辑
            viewControllerbyValue(vc, indexpath)
            
        } else {
            
            let vc = segue.destination as! TOChooseMemberViewController
            
            //不允许多选
            vc.allowsMultipleSelection = false
            
            vc.isShowAll = "0"
            
            vc.postValueBlock = {[weak self] users in
                
                let userInfo = users[0]
                
                let cell = self?.tableView.cellForRow(at: indexpath) as! TOTimeNodeCell
                cell.personBtn.setTitle(userInfo.userName, for: .normal)
                
                guard let timeNode = self?.dataSource["timeNode"] as? [[String: String]] else {
                    return
                }
                var timeNodes = timeNode
                
                timeNodes[indexpath.row]["affiliatedPerson"] = userInfo.userName
                timeNodes[indexpath.row]["createTime"] = self?.timeStamp
                
                self?.dataSource["timeNode"] = timeNodes
            }
        }
        

    }
    
    fileprivate func viewControllerbyValue(_ vc: TOCalendarViewController, _ indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            let cell1 = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! TOProjectDetailTableViewCell
            let cell2 = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! TOProjectDetailTableViewCell
            
            vc.startTime = cell1.rightView.text!
            vc.endTime = cell2.rightView.text!
            
            vc.postValueBlock = {[weak self] time in
                
                let cell = self?.tableView.cellForRow(at: indexPath) as! TOProjectDetailTableViewCell
                cell.rightView.text = time
                
                indexPath.row == 1 ? (self?.dataSource["startTime"] = time) : (self?.dataSource["endTime"] = time)
            }
            
        } else { //时间节点
            
            vc.postValueBlock = {[weak self] time in
                
                let cell = self?.tableView.cellForRow(at: indexPath) as! TOTimeNodeCell
                cell.timeBtn.setTitle(time, for: .normal)
                
                guard let timeNode = self?.dataSource["timeNode"] as? [[String: String]] else {
                    return
                }
                var timeNodes = timeNode
                
                timeNodes[indexPath.row]["time"] = time
                timeNodes[indexPath.row]["createTime"] = self?.timeStamp
                
                self?.dataSource["timeNode"] = timeNodes
            }
            
        }
    }
    
}

extension TOAddProjectViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentingAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissingAnimator()
    }
}

extension TOAddProjectViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        dataSource["projectName"] = textField.text
    }
    
    //时间节点 - 内容赋值
    func textViewDidEndEditing(_ textView: UITextView) {
        
        let row = textView.tag - 100
        
        guard let timeNode = dataSource["timeNode"] as? [[String: String]] else {
            return
        }
        var timeNodes = timeNode
        
        timeNodes[row]["content"] = textView.text
        timeNodes[row]["createTime"] = timeStamp
        
        dataSource["timeNode"] = timeNodes
    }
}
