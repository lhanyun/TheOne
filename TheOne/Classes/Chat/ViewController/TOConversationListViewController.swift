//
//  TOConversationListViewController.swift
//  TheOne
//
//  Created by lala on 2017/12/25.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import EaseUI

class TOConversationListViewController: EaseConversationListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        showRefreshFooter = true
        showRefreshHeader = true
        
        delegate = self
        dataSource = self
        
        //首次进入加载数据
        tableViewDidTriggerHeaderRefresh()
        
        EMClient.shared().chatManager.add(self, delegateQueue: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(chooseTheme), name: NSNotification.Name(rawValue: CHOOSETHEME), object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
        //刷新列表数据
//        tableViewDidTriggerHeaderRefresh()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc fileprivate func chooseTheme() {
        view.backgroundColor = BASE_COLOR
        tableView.backgroundColor = BASE_COLOR
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        log.debug("会话列表被销毁")
    }
}

extension TOConversationListViewController: EaseConversationListViewControllerDelegate, EaseConversationListViewControllerDataSource
{
    
    func conversationListViewController(_ conversationListViewController: EaseConversationListViewController!, modelFor conversation: EMConversation!) -> IConversationModel! {

        let model = EaseConversationModel(conversation: conversation)

        //设置会话title
        if model?.conversation.type == EMConversationTypeGroupChat {
            
            var error: EMError? = nil
            let group = EMClient.shared().groupManager.getGroupSpecificationFromServer(withId: conversation.conversationId, error: &error)
            model?.title = group?.subject
            
        } else {
            
            model?.title = conversation.conversationId
            
        }
        
        return model;
        
    }
    
    func conversationListViewController(_ conversationListViewController: EaseConversationListViewController!, didSelect conversationModel: IConversationModel!) {
        
        //样例展示为根据conversationModel，进入不同的会话ViewController
        if conversationModel != nil {
            let conversation = conversationModel.conversation;
            if conversation != nil {
                
                let chatController = TOMessageViewController(conversationChatter: conversation?.conversationId, conversationType: (conversation?.type)!)
                
                chatController?.title = conversationModel.title;
                
                show(chatController!, sender: nil)
                
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setupUnreadMessageCount"), object: nil)
            
            tableView.reloadData()
        }
    }
    
    //收到
    override func messagesDidReceive(_ aMessages: [Any]!) {
        
        tableViewDidTriggerHeaderRefresh()
    }
}
