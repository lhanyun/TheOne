//
//  TOTaskCalendarView.swift
//  TheOne
//
//  Created by lala on 2018/2/23.
//  Copyright © 2018年 ZLZK. All rights reserved.
//

import UIKit
import pop

class TOTaskCalendarView: UIView {

    @IBOutlet weak var bgView: UIVisualEffectView!
    @IBOutlet weak var tableView: UITableView!
    
    var targetVC: TOBaseViewController?
    
    var models: [TaskListModel] = []
    
    class func newTOTaskCalendarView(VC: TOBaseViewController) -> TOTaskCalendarView {
        
        let nib = UINib(nibName: "TOTaskCalendarView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! TOTaskCalendarView
        
        v.targetVC = VC
        
        //设置UI界面
        v.initUI()
        
        v.setAnimation()
        
        return v
    }
    
    func initUI() {
        
        //设置tableView
        tableView.layer.cornerRadius = 8
        tableView.layer.masksToBounds = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        
        tableView.register(cellType: TOTaskListCell.self)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeView))
        bgView.addGestureRecognizer(tap)
        
        frame = (targetVC?.view.bounds)!
    }
    
    //移除视图
    @objc fileprivate func closeView() {
        removeFromSuperview()
    }
    
    //设置出现时的动画
    fileprivate func setAnimation() {
        
        let sprintAnimation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
        sprintAnimation?.toValue = NSValue(cgPoint: CGPoint(x: 1, y: 1))
        sprintAnimation?.fromValue = NSValue(cgPoint: CGPoint(x: 0.5, y: 0.5))
        sprintAnimation?.velocity = NSValue(cgPoint: CGPoint(x: 2, y: 2))
        sprintAnimation?.springBounciness = 20.0
        tableView.pop_add(sprintAnimation, forKey: "springAnimation")
    }
}

// MARK: - UITableViewDelegate UITableViewDataSource
extension TOTaskCalendarView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(for: indexPath) as TOTaskListCell
        
        //禁用cell点击变灰的效果
        cell.selectionStyle = .none
        
        cell.model = models[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = TOTaskDetailViewController()
        
        vc.taskId = models[indexPath.row].taskId
        
        targetVC?.show(vc, sender: nil)
    }
}
