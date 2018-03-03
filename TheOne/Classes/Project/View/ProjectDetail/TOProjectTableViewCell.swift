//
//  TOProjectTableViewCell.swift
//  TheOne
//
//  Created by lala on 2017/12/5.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit

class TOProjectTableViewCell: TOTableViewCell {
    
    var model: ProjectInfoModel? {
        didSet {
            
            guard let taskOverNum = model?.taskOverNum,
                let taskNum = model?.taskNum,
                let taskBugOverNum = model?.taskBugOverNum,
                let taskBugNum = model?.taskBugNum
            else {
                log.debug("任务与bug图表未拿到数据")
                return
            }
            
            taskSurplus.progress = CGFloat(taskOverNum)/CGFloat(taskNum)
            bugOver.progress = CGFloat(taskBugOverNum)/CGFloat(taskBugNum)
            
            taskSurplusLabel.text = "\(taskOverNum)/\(taskNum)"
            bugOverLabel.text = "\(taskBugOverNum)/\(taskBugNum)"
            
            guard let taskNorNum = model?.taskNorNum,
                let taskppNum = model?.taskppNum,
                let taskppOverNum = model?.taskppOverNum,
                let taskNorOverNum = model?.taskNorOverNum
                else {
                    log.debug("项目饼形图表未拿到值")
                    return
            }
            chatView.setDataCount(4, value: [Double(taskNorNum),Double(taskppNum),Double(taskppOverNum),Double(taskNorOverNum)])
        }
    }
    
    var infoModel: UserModel? {
        didSet {
            
            guard let taskOverNum = infoModel?.taskOverNum,
                let ton = Int(taskOverNum),
                let taskNum = infoModel?.taskNum,
                let tn = Int(taskNum),
                let taskBugOverNum = infoModel?.taskBugOverNum,
                let tbon = Int(taskBugOverNum),
                let taskBugNum = infoModel?.taskBugNum,
                let tbn = Int(taskBugOverNum)
                else {
                    log.debug("任务与bug图表未拿到数据")
                    return
            }
            
            taskSurplus.progress = CGFloat(ton)/CGFloat(tn)
            bugOver.progress = CGFloat(tbon)/CGFloat(tbn)
            
            taskSurplusLabel.text = "\(taskOverNum)/\(taskNum)"
            bugOverLabel.text = "\(taskBugOverNum)/\(taskBugNum)"
            
            guard let taskNorNum = infoModel?.taskNorNum,
                let n = Double(taskNorNum),
                let taskppNum = infoModel?.taskppNum,
                let pp = Double(taskppNum),
                let taskppOverNum = infoModel?.taskppOverNum,
                let ppo = Double(taskppOverNum),
                let taskNorOverNum = infoModel?.taskNorOverNum,
                let no = Double(taskNorOverNum)
                else {
                    log.debug("项目饼形图表未拿到值")
                    return
            }
            chatView.setDataCount(4, value: [n,pp,ppo,no])
        }
    }

    @IBOutlet weak var taskSurplus: ProgressLine!
    
    @IBOutlet weak var bugOver: ProgressLine!
    
    @IBOutlet weak var chatView: TOProjectProgressView!
    
    @IBOutlet weak var taskSurplusLabel: UILabel!
    
    @IBOutlet weak var bugOverLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        viewWithTag(10)?.frame = CGRect(x: <#T##Int#>, y: <#T##Int#>, width: <#T##Int#>, height: <#T##Int#>)
        viewWithTag(1)?.setNeedsDisplay()
    }

    
    
}
