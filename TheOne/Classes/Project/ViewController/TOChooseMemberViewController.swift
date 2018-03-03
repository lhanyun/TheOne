//
//  TOChooseMemberViewController.swift
//  TheOne
//
//  Created by lala on 2017/11/30.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxDataSources
import ChameleonFramework

typealias chooseMemberBlock = ([UserInfo]) -> Void
class TOChooseMemberViewController: TOBaseViewController {
    
    var postValueBlock:chooseMemberBlock?
    
    //是否允许多选
    var allowsMultipleSelection: Bool = true

    @IBOutlet weak var searchBarTop: NSLayoutConstraint!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var isShowAll:String = "1"
    
    fileprivate let dataSource = TOChooseMemberViewController.configureDataSource()
    
    fileprivate var vmOutput : ChooseMemberViewModel.MemberListOutput?
    
    //第一次进入，显示被选中cell
    fileprivate var isShowSelect: Bool = true
    
    //被选中的cell
    var selectCell : [UserInfo] = [UserInfo]() {
        didSet {
            navItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    fileprivate var searchBarText: Observable<String> {
        return searchBar.rx.text.orEmpty
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
    
    fileprivate let viewModel = ChooseMemberViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "选择成员"
        
        navItem.rightBarButtonItem?.isEnabled = false

        setTableView()
        
        viewModelOutput()
    }

    override func initUI() {
        super.initUI()
        super.initTableView()
        
        searchBarTop.constant = CGFloat(NavibarH)
        searchBar.barTintColor = FlatWhite()
        
        navItem.rightBarButtonItem = UIBarButtonItem(title: "完成", selector: #selector(overChoose), target: self, isBack: false)
        navItem.rightBarButtonItem?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
  
        searchBar.backgroundColor = FlatWhite()
    }
    
    @objc fileprivate func overChoose() {

        guard let postValueBlock = postValueBlock else { return }
        postValueBlock(selectCell)
        
        guard (navigationController?.viewControllers.count) != nil else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        navigationController?.popViewController(animated: true)
        
    }

}

extension TOChooseMemberViewController {
    
    fileprivate func setTableView() {
        
        //注册cell
        tableView.register(cellType: TOMemberCell.self)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom)
            make.right.left.bottom.equalTo(view)
        }
        
        //绑定协议
        tableView.rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)
        
        //点击cell
        tableView.rx
            .itemSelected
            .subscribe(onNext: {[weak self] indexPath in

                //是否允许多选
                if !((self?.allowsMultipleSelection)!) {
                    for indexpath in (self?.tableView.indexPathsForSelectedRows ?? []) {
                        
                        self?.tableView.deselectRow(at: indexpath, animated: true)
                        
                        guard let model = self?.viewModel.models.value[indexPath.row] else {
                            return
                        }
                        self?.selectCell = self?.selectCell.filter({ (modeler) -> Bool in
                            
                            return model.userName != modeler.userName
                        }) ?? []
                    }
                }
                
                self?.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                
                self?.setSearchBarDefualt()
                
                guard let model = self?.viewModel.models.value[indexPath.row] else {
                    return
                }
                
                self?.selectCell.append(model)

            })
            .disposed(by: rx.disposeBag)
        
        tableView.rx.itemDeselected
            .subscribe(onNext: {[weak self] indexPath in
                
                guard let model = self?.viewModel.models.value[indexPath.row] else {
                    return
                }
                self?.selectCell = self?.selectCell.filter({ (modeler) -> Bool in
                    
                    return model.userName != modeler.userName
                }) ?? []
                
            })
            .disposed(by: rx.disposeBag)
        
        tableView.isEditing = true
        tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    fileprivate func viewModelOutput() {
        
        let vmInput = ChooseMemberViewModel.MemberListInput(text: searchBarText, Id: Tools().userInfo.projectId, show: isShowAll)
        let vmOutput = viewModel.transform(input: vmInput)
        
        vmOutput.sections.asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        
        vmOutput.refreshStatus.asObservable()
            .subscribe(onNext: {[weak self] status in
                
                switch status {
                case .noMoreData:
                    self?.noDataStr = "未能找到成员，请重新输入"
                case .error:
                    self?.noDataStr = "请检查网络"
                case .none:
                    self?.noDataStr = ""
                }
                
            })
            .disposed(by: rx.disposeBag)
        
        vmOutput.requestCommond.onNext(true)
        
    }
    
}

extension TOChooseMemberViewController {
    
    class func configureDataSource() -> RxTableViewSectionedReloadDataSource<MemberListSection> {
        
        let dataSource = RxTableViewSectionedReloadDataSource<MemberListSection>(configureCell: { ds, tv, ip, item in
            
            let cell = tv.dequeueReusableCell(for: ip) as TOMemberCell
            
            cell.isShowRole = false
            cell.model = item
            
            return cell
        })
        
        dataSource.canEditRowAtIndexPath = { (ds, ip) in
            return true
        }
        
        return dataSource
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        setSearchBarDefualt()
    }
    
    
}

extension TOChooseMemberViewController {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if isShowSelect {

            if (viewModel.models.value.count - 1) == indexPath.row {
                isShowSelect = false
            }
            
            for selectModel in selectCell {
                
                if selectModel.id == viewModel.models.value[indexPath.row].id {
                    tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                }
                
            }
        }
        
    }

}

//MARK: - UISearchBarDelegate
extension TOChooseMemberViewController: UISearchBarDelegate {
    
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
