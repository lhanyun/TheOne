//
//  TOBaseViewController.swift
//  TheOne
//
//  Created by lala on 2017/10/29.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import ChameleonFramework
import RxSwift
import RxCocoa
import NSObject_Rx
import RxDataSources
import DZNEmptyDataSet
import FontAwesomeKit
import Alamofire
import ARCGPathFromString

class TOBaseViewController: UIViewController {
    
    //自定义UINavigationBar
    var navigationBar: TONavigationBar = TONavigationBar(frame: CGRect(x: 0.0, y: Double(StatusBarHeight), width: Double(IPHONE_WIDTH), height: NavibarH))
    
    //定义UINavigationBar上的item
    var navItem: UINavigationItem = UINavigationItem()
    
    var tableView: UITableView = UITableView()
    
    var noDataStr: String = "没有数据了！" {
        didSet {
            //刷新空白页内容
            tableView.reloadEmptyDataSet()
        }
    }

    //用户是否登入
    var userLogon:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }
    
    func initUI() {
        
        //适配iOS11 ScrollView视图
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        initNavigationBar()
        
        view.backgroundColor = BASE_COLOR
    }
    
    //重写self.title
    override var title: String? {
        didSet {
            navItem.title = title
        }
    }
    
}

// MARK: - 设置UI
extension TOBaseViewController {

    fileprivate func initNavigationBar() {
        
        view.addSubview(navigationBar)
        
        navigationBar.items = [navItem]
    }
    
    // 设置TableView   将initTableView作为对子类的开放方法更方便子类的自定义UI
    func initTableView() {
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        
        tableView.backgroundColor = BASE_COLOR
        
        // 设置内容缩进
        tableView.contentInset = UIEdgeInsets(top: CGFloat(NavibarH) + StatusBarHeight, left: 0, bottom: 0, right: 0)
        
        view.insertSubview(tableView, belowSubview: navigationBar)

        tableView.tableFooterView = UIView()
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        //进入新页面时，初始化isbool
        isFirstTime = true
    }

}

// MARK: - 空白页代理
extension TOBaseViewController: UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    //空白页标题  此处选用字体图标
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        if !(NetworkReachabilityManager()?.isReachable)! { //无网络
            
            guard let unlink = FAKFontAwesome.unlinkIcon(withSize: fontImgSize) else {
                return NSMutableAttributedString(string: "")
            }
            
            return unlink.attributedString()
            
        } else if isFirstTime {
            
            guard let superpowers = FAKFontAwesome.superpowersIcon(withSize: fontImgSize) else {
                return NSMutableAttributedString(string: "")
            }

            return superpowers.attributedString()
            
        } else if isError {
            
            guard let noNewLine = FAKIonIcons.eyeDisabledIcon(withSize: fontImgSize) else {
                return NSMutableAttributedString(string: "")
            }
            
            return noNewLine.attributedString()
            
        } else { //无数据
            
            guard let sad = FAKIonIcons.sadOutlineIcon(withSize: fontImgSize) else {
                return NSMutableAttributedString(string: "")
            }
            
            return sad.attributedString()
        }

    }
    
    //空白页详情文字
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        if isFirstTime {
            
            return NSMutableAttributedString(string: "努力加载中...")
        }
        
        return NSMutableAttributedString(string: "")
    }
    
    //添加点击文字按钮
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        
        if !(NetworkReachabilityManager()?.isReachable)! {
            
            let name = "检查网络后，请点击重试哦~"
            
            let attStr = NSMutableAttributedString(string: name)
            
            attStr.addAttribute(.foregroundColor, value: FlatBlue(), range: NSMakeRange(7, 4))
            
            return attStr
            
        } else if isFirstTime {
            
            return NSMutableAttributedString(string: "")
            
        } else if isError {
            
            let name = "网络不给力，请点击重试哦~"
            
            let attStr = NSMutableAttributedString(string: name)
            
            attStr.addAttribute(.foregroundColor, value: FlatBlue(), range: NSMakeRange(7, 4))
            
            return attStr
            
        } else {
            
            let attStr = NSMutableAttributedString(string: noDataStr)
            
//            attStr.addAttribute(.foregroundColor, value: FlatBlue(), range: NSMakeRange(5, 2))
            
            return attStr
        }
        
        
    }
    
    func emptyDataSetDidAppear(_ scrollView: UIScrollView!) {
        
        for view in scrollView.subviews {
            if view.isKind(of: NSClassFromString("DZNEmptyDataSetView")!) {
                
                guard let label = view.subviews[0].subviews[0] as? UILabel else {
                    return
                }
                
                if isFirstTime {
                    label.layer.add(rotation(dur: 3.0), forKey: "move-layer")
                } else {
                    label.layer.removeAllAnimations()
                }
            }
        }
 
    }
}


/*
 guard let superpowers = FAKFontAwesome.superpowersIcon(withSize: fontImgSize) else {
 return
 }
 
 superpowers.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: FlatBlue())
 
 let path = UIBezierPath(for: superpowers.attributedString())
 let shapeLayer = CAShapeLayer()
 shapeLayer.path = path?.cgPath
 //            shapeLayer.bounds = CGPath.boundingBox(shapeLayer.path!)
 // 几何反转
 shapeLayer.isGeometryFlipped = true
 
 // 一些颜色的填充
 shapeLayer.fillColor = UIColor.clear.cgColor
 shapeLayer.strokeColor = UIColor.cyan.cgColor
 
 // 设定layer位置
 shapeLayer.position = scrollView.center;
 scrollView.layer.addSublayer(shapeLayer)
 
 shapeLayer.strokeEnd = 0.5
 */
