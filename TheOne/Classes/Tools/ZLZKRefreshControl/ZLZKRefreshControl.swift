//
//  ZLZKRefreshControl.swift
//  Swift_Equipment
//
//  Created by lala on 2017/4/28.
//  Copyright © 2017年 lala. All rights reserved.
//

import UIKit

fileprivate let ZLZKRefreshOffset:CGFloat = 60

/// 刷新状态
///
/// - Normal: 普通状态，什么都不做
/// - Pulling: 超过临界点，如果放手，开始刷新
/// - WillRefresh: 用户超过临界点，并且放手
enum ZLZKRefreshState {
    case Normal
    case Pulling
    case WillRefresh
}

class ZLZKRefreshControl: UIControl {
    
    ///开始刷新
    func beginRefreshing() {
        //        XClog.debug("开始刷新")
        
        //判断父视图
        guard let sv = scrollView else {
            return
        }
        
        /// 判断是否正在刷新，如果正在刷新，直接返回
        if refreshView.refreshState == .WillRefresh {
            return
        }
        
        //设置刷新视图状态
        refreshView.refreshState = .WillRefresh
        
        //调整表格间距
        var inset = sv.contentInset
        inset.top += ZLZKRefreshOffset
        
        sv.contentInset = inset
    }
    
    ///结束刷新
    func endRefreshing() {
        //        XClog.debug("结束刷新")
        
        guard let sv = scrollView else {
            return
        }
        
        //判断状态 ， 是否正在刷新，如果不是，直接返回
        if refreshView.refreshState != .WillRefresh {
            return
        }
        
        //恢复表格视图的 contentInset
        var inset = sv.contentInset
        inset.top -= ZLZKRefreshOffset
        
        sv.contentInset = inset
        
        //恢复属性视图状态
        refreshView.refreshState = .Normal
    }
    
    fileprivate weak var scrollView: UIScrollView?
    
    fileprivate lazy var refreshView: ZLZKRefreshView = ZLZKRefreshView.refreshView()
    
    // MARK: - 构造函数
    init() {
        super.init(frame: CGRect())
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    /// addSubview 方法会调用
    ///
    /// - Parameter newSuperview: 父视图
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        //判断父视图类型
        guard let sv = newSuperview as? UIScrollView else {
            return
        }
        
        //记录父视图
        scrollView = sv
        
        //KVO 监听父视图的 contentoffset
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    //所有下拉刷新框架都是监听父视图的 contentOffset
    override func removeFromSuperview() {
        //superview 还存在
        
        //移除 KVO，不移除会崩溃
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        
        super.removeFromSuperview() 
        //superview 不存在
    }
    
    //所有 KVO 方法会统一调用此方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        //在每个方法用scrollView之前都要守护一下，因为scrollView是弱引用，随时都可能为nil
        guard let sv = scrollView else {
            return
        }
        
        //初始高度就应该为 0 
        let height = -(sv.contentInset.top + sv.contentOffset.y)
        
        if height < 0 {
            return
        }
        
        
        self.frame = CGRect(x: 0, y: -height, width: UIScreen.main.bounds.width, height: height)
        
        /// 临界点判断只需要一次
        if sv.isDragging {
            
            if height < ZLZKRefreshOffset && refreshView.refreshState == .Pulling {

                refreshView.refreshState = .Normal
                
            }else if height > ZLZKRefreshOffset && refreshView.refreshState == .Normal{
                
                refreshView.refreshState = .Pulling
                
            }

            
        } else {
            
            if refreshView.refreshState == .Pulling {
                
                beginRefreshing()
                
                // 发送刷新数据时间
                sendActions(for: .valueChanged)
            }
        
        }
    }
    
    
}

extension ZLZKRefreshControl {
    
    fileprivate func setupUI() {
        
        backgroundColor = superview?.backgroundColor
        
//        clipsToBounds = true
        /// 添加刷新视图
        addSubview(refreshView)
        
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.width))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.height))
        
    }
    
}
