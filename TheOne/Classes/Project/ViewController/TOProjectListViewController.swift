//
//  TOProjectListViewController.swift
//  TheOne
//
//  Created by lala on 2017/11/13.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import RxDataSources
import MJRefresh
import FontAwesomeKit
import ChameleonFramework
import ObjectMapper
import pop

class TOProjectListViewController: TOBaseViewController {

    let viewModel = ProjectListViewModel()

    let dataSource = TOProjectListViewController.configureDataSource()
    
    var vmOutput : ProjectListViewModel.ProjectListOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "项目列表"
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshList), name: NSNotification.Name(rawValue: "RefreshProjectList"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        animateTable()
    }

    override func initUI() {
        super.initUI()
        super.initTableView()
        
        setTableView()
        
        settingNoting()
    }
    
    @objc fileprivate func refreshList() {
        tableView.mj_header.beginRefreshing()
    }
    
    deinit {
        
        log.debug("项目列表销毁")
        
        NotificationCenter.default.removeObserver(self)
    }
}

extension TOProjectListViewController {
    
    fileprivate func setTableView() {
        
        //注册cell
        tableView.register(cellType: TOProjectListCell.self)
        
        tableView.estimatedRowHeight = 146
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
                self?.saveProjectID(indexpath: indexPath)
                self?.pushMainVC()
            })
            .disposed(by: rx.disposeBag)
        
        let vmInput = ProjectListViewModel.ProjectListInput()
        let vmOutput = viewModel.transform(input: vmInput)
        
        vmOutput.sections.asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        
        vmOutput.refreshStatus.asObservable()
            .subscribe(onNext: {[weak self] status in
                switch status {
                    case .beingHeaderRefresh:
                        self?.tableView.mj_header.beginRefreshing()
                    case .endHeaderRefresh:
                        self?.tableView.mj_header.endRefreshing()
                    case .beingFooterRefresh:
                        self?.tableView.mj_footer.beginRefreshing()
                    case .endFooterRefresh:
                        self?.tableView.mj_footer.endRefreshing()
                    case .noMoreData:
                        self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                    default:
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
    }
    
    fileprivate func settingNoting() {
        
        let btn = UIButton(type: .system)
        let leftIcon = FAKIonIcons.plusRoundIcon(withSize: 26)
        btn.setAttributedTitle(leftIcon?.attributedString(), for: .normal)
        
        btn.addTarget(self, action: #selector(addProject), for: .touchUpInside)
    
        navItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
    
        tableView.mj_header.beginRefreshing()
    }
    
    @objc func addProject() {
        
        let projectSB = UIStoryboard(name: "Project", bundle:nil)
        let vc = projectSB.instantiateViewController(withIdentifier: "TOAddProjectViewController")
        vc.title = "添加项目"
        
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

// MARK: - tableView 及 空白页 代理方法
extension TOProjectListViewController {

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let readed = UITableViewRowAction(style: .normal, title: "详情") { [weak self]
            action, index in
        
            self?.saveProjectID(indexpath: indexPath)
            self?.performSegue(withIdentifier: "ToDetail", sender: index)
        }
        readed.backgroundColor = FlatYellow()
        
        let delete = UITableViewRowAction(style: .normal, title: "删除") {
            action, index in
            
//            self.viewModel.models.value.remove(at: index.row)
            self.viewModel.deleteListItem(index.row)
        }
        delete.backgroundColor = FlatRed()
        
        return [delete, readed]
        
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TOProjectListCell
        let scaleAnimation = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
        
        scaleAnimation?.duration = 0.1
        scaleAnimation?.toValue = NSValue(cgPoint: CGPoint(x: 0.9, y: 0.9))
        cell.bgView.pop_add(scaleAnimation, forKey: "scalingUp")
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TOProjectListCell
        let sprintAnimation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
        sprintAnimation?.toValue = NSValue(cgPoint: CGPoint(x: 1, y: 1))
        sprintAnimation?.velocity = NSValue(cgPoint: CGPoint(x: 2, y: 2))
        sprintAnimation?.springBounciness = 20.0
        cell.bgView.pop_add(sprintAnimation, forKey: "springAnimation")
    }
    
    //接收空白页点击事件
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        tableView.mj_header.beginRefreshing()
    }
}

extension TOProjectListViewController {
    
    class func configureDataSource() -> RxTableViewSectionedReloadDataSource<ProjectListSection> {
        
        let dataSource = RxTableViewSectionedReloadDataSource<ProjectListSection>(configureCell: { ds, tv, ip, item in
            
            let cell = tv.dequeueReusableCell(for: ip) as TOProjectListCell
            
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
    
    fileprivate func pushMainVC() {
        
        UIView.transition(with: UIApplication.shared.keyWindow!,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
                            
                                UIApplication.shared.keyWindow?.rootViewController = TOMainViewController()
                        },
                          completion: nil)
        
    }
    
    //保存项目ID
    fileprivate func saveProjectID(indexpath: IndexPath) {
        
        Tools().updataUserInfo([
            "projectId": viewModel.models.value[indexpath.row].projectId,
            "projectModules": viewModel.models.value[indexpath.row].projectModules,
            "userModule": viewModel.models.value[indexpath.row].userModule])
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        guard let index = (sender as? IndexPath)?.row else {
//            log.debug("项目列表未传projectId")
//            return
//        }
//
//        let vc = segue.destination as! TOProjectDetailViewController
//        
//        vc.projectId = self.viewModel.models.value[index].projectId
        
    }
    
}
