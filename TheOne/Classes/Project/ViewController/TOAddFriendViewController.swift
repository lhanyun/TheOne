//
//  TOAddFriendViewController.swift
//  TheOne
//
//  Created by lala on 2017/12/7.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import ChameleonFramework

class TOAddFriendViewController: TOBaseViewController {

    @IBOutlet weak var searchBarTop: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    
    fileprivate let dataSource = TOChooseMemberViewController.configureDataSource()
    
    fileprivate var vmOutput : AddFriendViewModel.MemberListOutput?
    
    fileprivate var searchBarText: Observable<String> {
        return searchBar.rx.text.orEmpty
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
    
    fileprivate let viewModel = AddFriendViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
        
        viewModelOutput()
    }
    
    override func initUI() {
        super.initUI()
        super.initTableView()
        
        searchBarTop.constant = CGFloat(NavibarH)
        searchBar.barTintColor = FlatWhite()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.backgroundColor = FlatWhite()
    }
    
}

extension TOAddFriendViewController {
    
    fileprivate func setTableView() {
        
        //注册cell
        tableView.register(cellType: TOChooseMemberCell.self)
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
                
                self?.setSearchBarDefualt()
                
                
                
            })
            .disposed(by: rx.disposeBag)
        
    }
    
    fileprivate func viewModelOutput() {
        
        let vmInput = AddFriendViewModel.MemberListInput(text: searchBarText, Id: Tools().userInfo.projectId, show: "0")
        let vmOutput = viewModel.transform(input: vmInput)
        
        vmOutput.sections.asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        
//        vmOutput.refreshStatus.asObservable()
//            .subscribe(onNext: { status in
//
//            })
//           .disposed(by: rx.disposeBag)
        
        vmOutput.requestCommond.onNext(true)
        
    }
    
}

extension TOAddFriendViewController {
    
    class func configureDataSource() -> RxTableViewSectionedReloadDataSource<MemberListSection> {
        
        let dataSource = RxTableViewSectionedReloadDataSource<MemberListSection>(configureCell: { ds, tv, ip, item in
            
            let cell = tv.dequeueReusableCell(for: ip) as TOChooseMemberCell
            
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

//MARK: - UISearchBarDelegate
extension TOAddFriendViewController: UISearchBarDelegate {
    
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

    


