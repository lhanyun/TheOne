//
//  TOChatViewController.swift
//  TheOne
//
//  Created by lala on 2017/11/17.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import EaseUI
import AVFoundation
import FontAwesomeKit

class TOChatViewController: TOBaseViewController {
    
    fileprivate let segmentedView: UISegmentedControl = {
        let segmentedView = UISegmentedControl(items: ["成员","会话"])
        segmentedView.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        segmentedView.selectedSegmentIndex = 0
        segmentedView.tintColor = UIColor.flatWhite
        return segmentedView
    }()
    
    fileprivate let scrollView: UIScrollView = {
       
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: IPHONE_WIDTH, height: IPHONE_HEIGHT))
        scrollView.contentSize = CGSize(width: IPHONE_WIDTH * 2, height: IPHONE_HEIGHT - StatusBarHeight - CGFloat(NavibarH) - CGFloat(TabBarHeight))
        scrollView.backgroundColor = UIColor.flatGray
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.alwaysBounceVertical = false
        scrollView.scrollsToTop = false
//        scrollView.isScrollEnabled = false
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        EMClient.shared().groupManager.add(self, delegateQueue: nil)
        
        segmentedView.addTarget(self, action: #selector(segmentedViewSelector), for: .valueChanged)
        navItem.titleView = segmentedView
        
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.snp.makeConstraints { (make) in
            
            make.top.equalTo(navigationBar.snp.bottom)
            make.right.left.equalTo(view)
            make.bottom.equalTo(view).offset(-TabBarHeight)
            
        }    
        
        let memberVC = TOMemberViewController()
        memberVC.view.frame = CGRect(x: 0.0, y: 0.0, width: Double(IPHONE_WIDTH), height: Double(scrollView.frame.height))
        addChildViewController(memberVC)
        scrollView.addSubview(memberVC.view)
        
        let conversationVC = TOConversationListViewController()
        conversationVC.view.frame = CGRect(x: Double(IPHONE_WIDTH), y: 0.0, width: Double(IPHONE_WIDTH), height: Double(scrollView.frame.height))
        addChildViewController(conversationVC)
        scrollView.addSubview(conversationVC.view)
        
        //添加创建群组聊天按钮
        let btn = UIButton(type: .system)
        let leftIcon = FAKIonIcons.plusRoundIcon(withSize: 26)
        btn.setAttributedTitle(leftIcon?.attributedString(), for: .normal)
        btn.addTarget(self, action: #selector(creatGroupChat), for: .touchUpInside)
        navItem.rightBarButtonItem = UIBarButtonItem(customView: btn)

    }
    
    @objc fileprivate func segmentedViewSelector(segment: UISegmentedControl) {
        
        scrollView.contentOffset = (segment.selectedSegmentIndex == 0) ? CGPoint(x: 0, y: 0) : CGPoint(x: IPHONE_WIDTH, y: 0)
    }
    
    //创建群组
    @objc fileprivate func creatGroupChat() {
        
        let alertController = UIAlertController(title: "创建群组", message: "填写群名称", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        let okAction = UIAlertAction(title: "确认", style: .default) { (alter) in
            let name = alertController.textFields?.first
            if let nameText = name?.text {
                
                let storyBoard = UIStoryboard.init(name: "Project", bundle: Bundle.main)
                let VC = storyBoard.instantiateViewController(withIdentifier: "TOChooseMemberViewController") as! TOChooseMemberViewController
                VC.postValueBlock = {[weak self] (arr) in
                    
                    self?.creatGroupChatBlock(nameText, arr)
                }
                self.showDetailViewController(VC, sender: nil)
            }
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "请输入群名称"
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let index:Int = Int(scrollView.contentOffset.x/IPHONE_WIDTH)
        
        segmentedView.selectedSegmentIndex = index
    }
    
    //选择完群成员后，回调
    fileprivate func creatGroupChatBlock(_ groupName: String, _ members: [UserInfo]) {
        
        var error:EMError? = nil
        let setting = EMGroupOptions()
        setting.maxUsersCount = 200
        setting.isInviteNeedConfirm = false //邀请群成员时，是否需要发送邀请通知.若NO，被邀请的人自动加入群组
        setting.style = EMGroupStylePrivateMemberCanInvite// 创建不同类型的群组，这里需要才传入不同的类型
        let group = EMClient.shared().groupManager.createGroup(withSubject: groupName, description: groupName, invitees: ["11111","22222","33333"], message: "邀请您加入群组", setting: setting, error: &error)
        
        if error == nil {
            log.debug("创建成功\(group?.groupId ?? "")")
            
            let chatVC = EaseMessageViewController(conversationChatter: group?.groupId, conversationType: EMConversationTypeGroupChat)
            
            show(chatVC!, sender: nil)
        }
        
    }

}

extension TOChatViewController: EMGroupManagerDelegate {
    
    func didJoin(_ aGroup: EMGroup!, inviter aInviter: String!, message aMessage: String!) {
        
        print(aInviter + "invite you to group" + aGroup.subject)
    }
    
    func groupInvitationDidAccept(_ aGroup: EMGroup!, invitee aInvitee: String!) {
        
        TipHUD.sharedInstance.showTips(aInvitee + "已同意群组" + aGroup.subject)
        print(aInvitee + "已同意群组" + aGroup.subject)
    }
    

}
