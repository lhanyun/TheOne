//
//  TOTaskViewController.swift
//  TheOne
//
//  Created by lala on 2017/11/17.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import MJRefresh
import ChameleonFramework
import FontAwesomeKit
import pop

class TOTaskViewController: TOBaseViewController {

    fileprivate var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "编号/执行人/内容/时间"
        searchBar.frame = CGRect(x: 0.0, y: NavibarH + Double(TabBarHeight), width: Double(IPHONE_WIDTH), height: 56.0)
        return searchBar
    }()
    
    // 项目相关选项
    let composeView = JBWComposeView()
    
    //排序View
    var fitlerView: TOFitlerView?
    
    //排序与筛选参数
    var sortIndex: Int = 0
    var labelIndex: Int = 0
    var forMeIndex: Int = 1
    
    fileprivate let dataSource = TOTaskViewController.configureDataSource()
    
    fileprivate var vmOutput : TaskListViewModel.TaskListOutput?
    
    fileprivate var searchBarText: Observable<String> {
        return searchBar.rx.text.orEmpty
//            .throttle(0.3, scheduler: MainScheduler.instance)
//            .distinctUntilChanged()
            .distinctUntilChanged()
            .debounce(0.51, scheduler: MainScheduler.instance)
    }
    
    fileprivate let viewModel = TaskListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationItem()
        
        NotificationCenter.default.addObserver(self, selector: #selector(chooseTheme), name: NSNotification.Name(rawValue: CHOOSETHEME), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshList), name: NSNotification.Name(rawValue: "RefreshTaskList"), object: nil)
    }
    
    override func initUI() {
        super.initUI()
        super.initTableView()
 
        //searchBar约束
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            
            make.top.equalTo(navigationBar.snp.bottom)
            make.right.left.equalTo(view)
            make.height.equalTo(56)
            
        }
        
        searchBar.delegate = self
        setTableView()
        
        viewModelOutput()
        
        floatButtonInit()
    }
    
    //设置悬浮按钮
    fileprivate func floatButtonInit() {

        let btn = TOFloatButton(frame: CGRect(x: IPHONE_WIDTH - 60, y: IPHONE_HEIGHT - 110, width: 60, height: 60))

        view.addSubview(btn)
  
        btn.delegate = self
    }
    
    @objc fileprivate func chooseTheme() {
        view.backgroundColor = BASE_COLOR
        tableView.backgroundColor = BASE_COLOR
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.backgroundColor = FlatWhite()
        
        animateTable()
    }
    
    @objc fileprivate func refreshList() {
        tableView.mj_header.beginRefreshing()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension TOTaskViewController {
    
    fileprivate func setTableView() {
        
        //注册cell
        tableView.register(cellType: TOTaskListCell.self)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom)
            make.right.left.bottom.equalTo(view)
        }
        
        tableView.estimatedRowHeight = 168
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        
        //绑定协议
        tableView.rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)
        
        //点击cell
        tableView.rx
            .itemSelected
            .subscribe(onNext: {[weak self] indexPath in
                
                self?.tableView.deselectRow(at: indexPath, animated: true)
                
                self?.setSearchBarDefualt()
                
                let vc = TOTaskDetailViewController()
                
                vc.taskId = self?.viewModel.models.value[indexPath.row].taskId ?? ""
                
                self?.show(vc, sender: nil)
            })
            .disposed(by: rx.disposeBag)

    }
    
    fileprivate func viewModelOutput() {
        
        let vmInput = TaskListViewModel.TaskListInput(text: searchBarText, projectid: Tools().userInfo.projectId, targetVC: self)
        let vmOutput = viewModel.transform(input: vmInput)
        
        vmOutput.sections.asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        
        vmOutput.refreshStatus.asObservable()
            .subscribe(onNext: {[weak self] status in

                switch status {
                case .noMoreData:
                    self?.noDataStr = "未找到相关任务"
                    self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                case .beingHeaderRefresh:
                    self?.tableView.mj_header.beginRefreshing()
                case .endHeaderRefresh:
                    self?.tableView.mj_header.endRefreshing()
                case .beingFooterRefresh:
                    self?.tableView.mj_footer.beginRefreshing()
                case .endFooterRefresh:
                    self?.tableView.mj_footer.endRefreshing()
                case .none:
                    break
                }
            })
            .disposed(by: rx.disposeBag)
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            vmOutput.requestCommond.onNext(true)
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            vmOutput.requestCommond.onNext(false)
        })
        
        tableView.mj_footer.isAutomaticallyHidden = true
        
        tableView.mj_header.beginRefreshing()
    }
    
    //接收空白页点击事件
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        tableView.mj_header.beginRefreshing()
    }
}

//MARK: - 导航栏按钮设置
extension TOTaskViewController {
    
    fileprivate func setNavigationItem() {
        
        let btn1 = PaperButton(origin: CGPoint(x: 0, y: 0))
        btn1?.addTarget(self, action: #selector(showComposeView), for: .touchUpInside)
        let composeBtn = UIBarButtonItem(customView: btn1!)
        
        let btn2 = UIButton(type: .system)
        let leftIcon = FAKFontAwesome.calendarIcon(withSize: 22)
        btn2.setAttributedTitle(leftIcon?.attributedString(), for: .normal)
        btn2.addTarget(self, action: #selector(showTaskCalendar), for: .touchUpInside)
        let calendarBtn = UIBarButtonItem(customView: btn2)
        
        let btn3 = UIButton(type: .system)
        btn3.addTarget(self, action: #selector(showFiltrateView), for: .touchUpInside)
        btn3.setTitle("筛选", for: .normal)
        let filtrateItem = UIBarButtonItem(customView: btn3)
        
        
        navItem.leftBarButtonItem = composeBtn
        navItem.rightBarButtonItems = [filtrateItem, calendarBtn]
    }
    
    @objc fileprivate func showComposeView(btn: PaperButton) {
        btn.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            btn.isEnabled = true
        }
        
        btn.isSelected = !btn.isSelected
        
        btn.isSelected ? composeView.show(targetVC: self) : composeView.hiddenView()
        
        composeView.postValueBlock = {
            btn.restoreDefaultSettings()
            btn.isSelected = false
        }
    }
    
    //跳转日历  查看任务日历
    @objc fileprivate func showTaskCalendar() {
        
        show(TOTaskCalendarViewController(), sender: nil)
    }
    
    //筛选
    @objc fileprivate func showFiltrateView(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        
        if btn.isSelected {
            
            fitlerView = TOFitlerView.newTOFitlerView(sortIndex: sortIndex, labelIndex: labelIndex, forMeIndex: forMeIndex)
            view.addSubview(fitlerView!)
            
            fitlerView?.snp.makeConstraints { (make) in
                
                make.top.equalTo(navigationBar.snp.bottom)
                make.right.left.equalTo(view)
                make.bottom.equalTo(view).offset(TabBarHeight)
                
            }
            
            fitlerView?.fitlerView.transform = CGAffineTransform(translationX: 0, y: -300)
            UIView.animate(withDuration: 0.3, animations: {
                self.fitlerView?.fitlerView.transform = CGAffineTransform(translationX: 0, y: 0)
            })
            
            fitlerView?.postValueBlock = {[weak self] (sortIndex, labelIndex, forMeIndex, isbool) in
                
                self?.fitlerView?.fitlerView.transform = CGAffineTransform(translationX: 0, y: 0)
                UIView.animate(withDuration: 0.3, animations: {
                    self?.fitlerView?.fitlerView.transform = CGAffineTransform(translationX: 0, y: -300)
                }, completion: { (_) in
                    self?.fitlerView?.removeFromSuperview()
                })
                
                btn.isSelected = false
                
                if isbool {
                    
                    self?.sortIndex = sortIndex - 10
                    self?.labelIndex = labelIndex - 20
                    self?.forMeIndex = forMeIndex
                    
                    self?.tableView.mj_header.beginRefreshing()
                }
            }
            
        } else {
            
            guard let fitlerView = fitlerView else { return }
            
            fitlerView.fitlerView.transform = CGAffineTransform(translationX: 0, y: 0)
            UIView.animate(withDuration: 0.3, animations: {
                fitlerView.fitlerView.transform = CGAffineTransform(translationX: 0, y: -300)
            }, completion: { (_) in
                fitlerView.removeFromSuperview()
            })
            
        }
        
        
    }
}

//MARK: - TabelViewDelegate
extension TOTaskViewController {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        var status = viewModel.models.value[indexPath.row].status
        let taskId = viewModel.models.value[indexPath.row].taskId
        var title = ""
        
        if status == "6" || status == "1" {
            title = "激活"
            status = "4"
        } else if status == "2" || status == "3"  || status == "4" {
            title = "提交完成"
            status = "5"
        } else if status == "5" {
            title = "正在审批"
            status = ""
        }
        
        let readed = UITableViewRowAction(style: .normal, title: title) {[weak self]
            action, index in
            
            //待审批状态
            if status.count == 0 {
                return
            }

            self?.viewModel.chooseTaskStatus(taskId: taskId, status: status, VC: self!)
        }
        readed.backgroundColor = FlatYellow()
        
        let colse = UITableViewRowAction(style: .normal, title: "关闭") {[weak self]
            action, index in
            
            self?.viewModel.chooseTaskStatus(taskId: taskId, status: "6", VC: self!)
        }
        colse.backgroundColor = FlatRed()
        
        let praise = UITableViewRowAction(style: .normal, title: "赞") {[weak self] (action, index) in
            
            let projectId = Tools().userInfo.projectId
            let userName = self?.viewModel.models.value[index.row].executePerson ?? ""
            
            self?.viewModel.doPraise(taskId: taskId, projectId: projectId, praise: "1", userName: userName, VC: self!)
        }
        praise.backgroundColor = UIColor.flatBlue
        
        let unpraise = UITableViewRowAction(style: .normal, title: "踩") {[weak self] (action, index) in
            let projectId = Tools().userInfo.projectId
            let userName = self?.viewModel.models.value[index.row].executePerson ?? ""
            
            self?.viewModel.doPraise(taskId: taskId, projectId: projectId, praise: "0", userName: userName, VC: self!)
        }
        unpraise.backgroundColor = UIColor.flatGray
        
        let creater = viewModel.models.value[indexPath.row].creater
        
        if Tools().userInfo.userName == creater {
            if viewModel.models.value[indexPath.row].status != "6" {
                return [readed, colse]
            } else {
                return [readed, praise, unpraise]
            }
        } else {
            return [readed]
        }
        
//        return (Tools().userInfo.userName == creater && viewModel.models.value[indexPath.row].status != "6") ? [readed, colse, praise, unpraise] : [readed]
//        
    }
    
    class func configureDataSource() -> RxTableViewSectionedReloadDataSource<TaskListSection> {
        
        let dataSource = RxTableViewSectionedReloadDataSource<TaskListSection>(configureCell: { ds, tv, ip, item in
            
            let cell = tv.dequeueReusableCell(for: ip) as TOTaskListCell
            
            //禁用cell点击变灰的效果
            cell.selectionStyle = .none
            
            cell.model = item
            
            return cell
        })
        
        dataSource.canEditRowAtIndexPath = { (ds, ip) in
            return true
        }
        
        dataSource.canMoveRowAtIndexPath = { (_, _) in
            return true
        }
        
        return dataSource
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        setSearchBarDefualt()
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! TOTaskListCell
        let scaleAnimation = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
        
        scaleAnimation?.duration = 0.1
        scaleAnimation?.toValue = NSValue(cgPoint: CGPoint(x: 0.9, y: 0.9))
        cell.bgView.pop_add(scaleAnimation, forKey: "scalingUp")
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! TOTaskListCell
        let sprintAnimation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
        sprintAnimation?.toValue = NSValue(cgPoint: CGPoint(x: 1, y: 1))
        sprintAnimation?.velocity = NSValue(cgPoint: CGPoint(x: 2, y: 2))
        sprintAnimation?.springBounciness = 20.0
        cell.bgView.pop_add(sprintAnimation, forKey: "springAnimation")
    }
}

//MARK: - UISearchBarDelegate
extension TOTaskViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        
        setSearchBarDefualt()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        setSearchBarDefualt()
    }
    
    fileprivate func setSearchBarDefualt() {
        searchBar.resignFirstResponder()
        
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

extension TOTaskViewController: TOFloatButtonDelegate {
    
    //添加任务
    func btnTouchUpInside(_ sender: UIButton) {
        
        let vc = TOAddTaskViewController()
        
        vc.title = "添加任务"
        
        show(vc, sender: nil)
    }

    //tableView动画
    fileprivate func animateTable() {
        
        let cells = tableView.visibleCells
        
        let tableHeight: CGFloat = tableView.bounds.height
        
        for (index, cell) in cells.enumerated() {
            
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
            
            UIView.animate(withDuration: 1.0, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
        }
    }
}

