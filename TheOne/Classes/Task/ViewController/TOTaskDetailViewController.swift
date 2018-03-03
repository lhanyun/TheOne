//
//  TOTaskDetailViewController.swift
//  TheOne
//
//  Created by lala on 2017/12/12.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import ChameleonFramework

class TOTaskDetailViewController: TOBaseViewController {
    
    var model:TaskDetailInfoModel? {
        didSet {
            tableView.reloadData()
            setBottomButton()
        }
    }
    
    fileprivate let sectionOne = ["任务内容","所属模块","标签","优先级","所属平台","创建时间","截止时间","发起人","执行人"]
    
    var taskId:String = ""
    
    var bottomView: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: IPHONE_HEIGHT - 44, width: IPHONE_WIDTH, height: 44))
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name(rawValue: "RefreshTaskList"), object: nil)
    }
    
    @objc fileprivate func refreshData() {
        TaskDetailViewModel().getData(self, taskId)
    }
    
    override func initUI() {
        super.initUI()
        super.initTableView()
        
        setTableView()
        
        title = "任务详情"
    }
    
    @objc fileprivate func pushEditVC() {
        
        let vc = TOAddTaskViewController()
        
        vc.title = "编辑任务"
        
        let dic: [String: String] = [
            "taskContent": model?.taskTitle ?? "",
            "module": model?.taskModule ?? "",
            "label": model?.taskLabel ?? "",
            "priority": model?.taskPriority ?? "",
            "startTime": model?.taskStartTime ?? "",
            "cutoffTime": model?.taskOverTime ?? "",
            "startPerson": model?.taskStartperson ?? "",
            "executePerson": model?.taskExecuteperson ?? "",
            "platform": model?.taskPlatform ?? "",
            "describeTask": model?.taskDescribe ?? "",
            "photos": model?.taskPhotos ?? "",
            "taskId": taskId,
            "voices": model?.taskVoices ?? "",
            "projectId": Tools().userInfo.projectId]
        
        vc.dataSource = dic
        
        show(vc, sender: nil)
    }
    
}

extension TOTaskDetailViewController {
    
    fileprivate func setTableView() {
        
        //注册cell
        tableView.register(cellType: TODetailNormalCell.self)
        tableView.register(cellType: TODetailRemarkCell.self)
        tableView.register(cellType: TODetailRecordCell.self)
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.contentInset = UIEdgeInsets(top: CGFloat(NavibarH) + StatusBarHeight, left: 0, bottom: 44, right: 0)
    }
    
    //创建底部button
    fileprivate func setBottomButton() {
        
        if Tools().userInfo.userName == model?.taskStartperson {
            navItem.rightBarButtonItem = UIBarButtonItem(title: "编辑", selector: #selector(pushEditVC), target: self, isBack: false)
        }
        
        bottomView.removeFromSuperview()
        
        view.addSubview(bottomView)
        
        bottomView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(44)
            make.left.right.bottom.equalTo(self.view)
        }
        
        var status = model?.taskStatus
        var title = ""
        navItem.rightBarButtonItem?.isEnabled = true
        
        if status == "6" || status == "1" {
            title = "激活"
            status = "4"
        } else if status == "2" || status == "3"  || status == "4" {
            title = "提交完成"
            status = "5"
        } else if status == "5" {
            title = "正在审批"
            status = "-1"
            navItem.rightBarButtonItem?.isEnabled = false
        }
        
        if (Tools().userInfo.userName == model?.taskStartperson && status != "6"  && status != "4") {
            
            let closeBtn = UIButton(type: .custom)
            closeBtn.frame = CGRect(x: 0, y: 0, width: IPHONE_WIDTH/2, height: 44)
            closeBtn.tag = 6
            closeBtn.backgroundColor = UIColor.flatRed
            closeBtn.setTitle("关闭", for: .normal)
            bottomView.addSubview(closeBtn)
            closeBtn.addTarget(self, action: #selector(bottomBtnAct), for: .touchUpInside)
            
            guard let tag = Int(status!) else {
                log.debug("status转tag失败")
                return
            }
            let actBtn = UIButton(type: .custom)
            actBtn.frame = CGRect(x: IPHONE_WIDTH/2, y: 0, width: IPHONE_WIDTH/2, height: 44)
            actBtn.tag = tag
            actBtn.backgroundColor = UIColor.flatYellow
            actBtn.setTitle(title, for: .normal)
            bottomView.addSubview(actBtn)
            actBtn.addTarget(self, action: #selector(bottomBtnAct), for: .touchUpInside)
            
        } else {
            
            guard let status = status,
                let tag = Int(status) else {
                log.debug("status转tag失败")
                return
            }
            let actBtn = UIButton(type: .custom)
            actBtn.frame = CGRect(x: 0, y: 0, width: IPHONE_WIDTH, height: 44)
            actBtn.tag = tag
            actBtn.backgroundColor = UIColor.flatYellow
            actBtn.setTitle(title, for: .normal)
            bottomView.addSubview(actBtn)
            actBtn.addTarget(self, action: #selector(bottomBtnAct), for: .touchUpInside)
        }
        
    }
    
    @objc fileprivate func bottomBtnAct(sender: UIButton) {
        
        //正在审批的任务，不作处理
        if sender.tag == -1 {
            return
        }
        
        TaskListViewModel().chooseTaskStatus(taskId: taskId, status: "\(sender.tag)", VC: self)
    }
}

extension TOTaskDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return sectionOne.count
        case 1:
            return 1
        case 2:
            return model?.record.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TODetailNormalCell.self)
            
            cell.leftLabel.text = sectionOne[indexPath.row]
            
            var rightLabel: String = ""
            switch indexPath.row {
            case 0:
                rightLabel = model?.taskTitle ?? " "
            case 1:
                rightLabel = model?.taskModule ?? " "
            case 2:
                let label = model?.taskLabel ?? " "
                if label == "0" {
                    rightLabel = "任务"
                } else if label == "1" {
                    rightLabel = "BUG"
                } else {
                    rightLabel = " "
                }
            case 3:
                rightLabel = model?.taskPriority ?? " "
            case 4:
                rightLabel = model?.taskPlatform ?? " "
            case 5:
                rightLabel = model?.taskStartTime ?? " "
            case 6:
                rightLabel = model?.taskOverTime ?? " "
            case 7:
                rightLabel = model?.taskStartperson ?? " "
            case 8:
                rightLabel = model?.taskExecuteperson ?? " "
            default: ()
            }
            
            if rightLabel.count == 0 {
                rightLabel = " "
            }
            
            cell.rightLabel.text = rightLabel
            
            return cell
            
        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TODetailRemarkCell.self)
            
            cell.vc = self
            cell.describeTask.text = model?.taskDescribe
            cell.photos = model?.taskPhotos.split(separator: ",").map { String($0) }
            cell.audios = model?.taskVoices.split(separator: ",").map { String($0) }
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TODetailRecordCell.self)
            
            cell.model = model?.record[indexPath.row]
            
            if indexPath.row == 0 {
                cell.lineTop.constant = cell.frame.height/2
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 44
        } else if indexPath.section == 1 {
            return 215
        } else {
            return 64
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return UIView()
        } else {
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: IPHONE_WIDTH, height: 44))
            
            label.text = (section == 1) ? "  备注" : "  操作记录"

            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = FlatBlack()
            label.textAlignment = .center
            
            return label
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return (section == 0) ? 0 : 44
    }
}
