//
//  TOMemberViewController.swift
//  TheOne
//
//  Created by lala on 2017/11/30.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import ChameleonFramework
import EaseUI

class TOMemberViewController: TOBaseViewController {
    
    fileprivate let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "搜索成员"
        searchBar.frame = CGRect(x: 0.0, y: NavibarH + Double(TabBarHeight), width: Double(IPHONE_WIDTH), height: 56.0)
        return searchBar
    }()
    
    var isShowAll: String = "1"
    
    fileprivate let dataSource = TOMemberViewController.configureDataSource()
    
    fileprivate var vmOutput : MemberViewModel.MemberListOutput?
    
    fileprivate var searchBarText: Observable<String> {
        return searchBar.rx.text.orEmpty
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
    
    fileprivate let viewModel = MemberViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        
        viewModelOutput()
        
        NotificationCenter.default.addObserver(self, selector: #selector(chooseTheme), name: NSNotification.Name(rawValue: CHOOSETHEME), object: nil)
    }
    
    override func initUI() {
        super.initUI()
        super.initTableView()
        
        //searchBar约束
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.top.right.left.equalTo(view)
            make.height.equalTo(56)
        }
        
        //移除自定义导航栏
        navigationBar.removeFromSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.backgroundColor = FlatWhite()
    }
    
    @objc fileprivate func chooseTheme() {
        view.backgroundColor = BASE_COLOR
        tableView.backgroundColor = BASE_COLOR
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        log.debug("成员列表被销毁")
    }
    
}

extension TOMemberViewController {
    
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
                
                self?.setSearchBarDefualt()
                
                let chatVC = EaseMessageViewController(conversationChatter: "22222", conversationType: EMConversationTypeChat)
                
                self?.show(chatVC!, sender: nil)
                
            })
            .disposed(by: rx.disposeBag)
        
    }
    
    fileprivate func viewModelOutput() {
        
        let vmInput = MemberViewModel.MemberListInput(text: searchBarText, Id: Tools().userInfo.projectId, show: isShowAll)
        let vmOutput = viewModel.transform(input: vmInput)
        
        vmOutput.sections.asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        
        vmOutput.refreshStatus.asObservable()
            .subscribe(onNext: { status in

            })
            .disposed(by: rx.disposeBag)
        
        vmOutput.requestCommond.onNext(true)
        
    }
    
}

extension TOMemberViewController {
    
    class func configureDataSource() -> RxTableViewSectionedReloadDataSource<MemberListSection> {
        
        let dataSource = RxTableViewSectionedReloadDataSource<MemberListSection>(configureCell: { ds, tv, ip, item in
            
            let cell = tv.dequeueReusableCell(for: ip) as TOMemberCell
            
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

//MARK: - UISearchBarDelegate
extension TOMemberViewController: UISearchBarDelegate {
    
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
