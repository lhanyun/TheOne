//
//  TOUserInfoViewController.swift
//  TheOne
//
//  Created by lala on 2018/1/8.
//  Copyright © 2018年 ZLZK. All rights reserved.
//

import UIKit
import Photos
import ZLPhotoBrowser
import FontAwesomeKit

class TOUserInfoViewController: TOBaseViewController {

    let dataSource: [String] = ["总任务数","被赞总数","参与的项目个数"]
    
    var model: UserModel? {
        didSet {
            tableView.reloadData()
        }
    }
    
    //tableView HeaderView
    lazy var headerView = TOUserInfoHeaderView.userInfoHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "用户信息"
        
        UserInfoViewModel().getUserInfo(VC: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUserInfo), name: NSNotification.Name(rawValue: UPDATEUSERINFO), object: nil)
    }
    
    @objc fileprivate func updateUserInfo() {
        headerView.module.text = Tools().userInfo.userModule
    }
    
    override func initUI() {
        super.initUI()
        super.initTableView()
        
        //注册cell
        tableView.register(cellType: TOUserInfoCell.self)
        tableView.register(cellType: TOUserInfoChatCell.self)
        
        tableView.tableHeaderView = tableViewHeaderView()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        navItem.rightBarButtonItem = UIBarButtonItem(title: "编辑", selector: #selector(editUserInfo), target: self, isBack: false)
    }
    
    //编辑用户信息
    @objc fileprivate func editUserInfo() {
        show(TOUserSettingViewController(), sender: nil)
    }
    
    //设置tableView头视图
    fileprivate func tableViewHeaderView() -> TOUserInfoHeaderView {
        
        headerView.postValueBlock = { [weak self] (index) in
            
            if index == 0 {
                self?.show(TOUserSettingViewController(), sender: nil)
            } else if index == 1 {
                
                let a = self?.getPas()
                a?.showPreview(animated: true)
            }
            
        }
        
        headerView.frame = CGRect(x: 0, y: 0, width: IPHONE_WIDTH, height: 154)
        
        return headerView
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension TOUserInfoViewController {
    
    func getPas() -> ZLPhotoActionSheet {
        
        let actionSheet = ZLPhotoActionSheet()
        
        //以下参数为自定义参数，均可不设置，有默认值
        actionSheet.configuration.allowSelectVideo = true
        
        //    actionSheet.configuration.allowForceTouch = self.allowForceTouchSwitch.isOn;
        actionSheet.configuration.allowEditImage = true
        actionSheet.configuration.allowEditVideo = false
        
        //设置相册内部显示拍照按钮
        actionSheet.configuration.allowTakePhotoInLibrary = true
        //设置在内部拍照按钮上实时显示相机俘获画面
        actionSheet.configuration.showCaptureImageOnTakePhotoBtn = true
        
        //    //设置照片最大预览数
        //    actionSheet.configuration.maxPreviewCount = self.previewTextField.text.integerValue;
        //    //设置照片最大选择数
            actionSheet.configuration.maxSelectCount = 1
        //    //设置允许选择的视频最大时长
        //    actionSheet.configuration.maxVideoDuration = self.maxVideoDurationTextField.text.integerValue;
        //    //设置照片cell弧度
        //    actionSheet.configuration.cellCornerRadio = self.cornerRadioTextField.text.floatValue;
        //单选模式是否显示选择按钮
        actionSheet.configuration.showSelectBtn = false
        //是否在选择图片后直接进入编辑界面
        actionSheet.configuration.editAfterSelectThumbnailImage = true
        //是否保存编辑后的图片
        actionSheet.configuration.saveNewImageAfterEdit = true
        
        //是否使用系统相机
        actionSheet.configuration.useSystemCamera = true
        actionSheet.configuration.allowRecordVideo = false
        
        // - required
        //如果调用的方法没有传sender，则该属性必须提前赋值
        actionSheet.sender = self;
        
        actionSheet.cancleBlock = {
            
        }
        
        actionSheet.selectImageBlock = {[weak self] images, assets, isOriginal in
            
            let options = PHImageRequestOptions()
            options.version = .current
            options.deliveryMode = .highQualityFormat
            options.isSynchronous = true
            
            guard let asset = assets.first else {
                log.debug("更改头像，图片资源获取失败")
                return
            }
            
            PHImageManager.default().requestImageData(for: asset, options: options, resultHandler: { (data, dataUTI, orientation, info) in
                
                guard let data = data else { return }
                
                let assetResources = PHAssetResource.assetResources(for: asset)
                
                    assetResources.forEach({ (assetRes) in
                        
                        if assetRes.type == .photo {
                            AddTaskViewModel().uploadImg(data: data, fileName: assetRes.originalFilename.lowercased(),fileType: "HeaderImg", uploadProgress: { (p) in
                                
                            }, complete: {[weak self] (result, urlString) in
                                 self?.headerView.headerImg.cz_setImage(urlString: urlString, placeholderImage: nil, isAvatar: true)
                                
                                //更新用户头像
                                Tools().updataUserInfo(["userIcon": urlString])
                                
                                //更改头像通知
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: CHANGEHEADERIMG), object: nil)
                            })
                        }
                        
                    })
            })

        }
        
        return actionSheet;
    }
    
}

extension TOUserInfoViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return section == 0 ? 1 : (dataSource.count + 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(for: indexPath) as TOUserInfoCell
            
            cell.leftLabel.text = "当前项目概况"
            cell.accessoryType = .disclosureIndicator
            
            return cell
            
        } else {
            
            if indexPath.row != dataSource.count {
                
                let cell = tableView.dequeueReusableCell(for: indexPath) as TOUserInfoCell
                
                cell.leftLabel.text = dataSource[indexPath.row]
                
                if indexPath.row == 0 {
                    cell.rightLabel.text = model?.taskNum
                } else if indexPath.row == 1 {
                    cell.rightLabel.text = model?.praiseNum
                } else if indexPath.row == 2 {
                    cell.rightLabel.text = model?.projectNum
                }
                
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCell(for: indexPath) as TOUserInfoChatCell
                
                cell.model = model
                
                return cell
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            
            show(TOPresentProjectDViewController(), sender: nil)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return indexPath.row == dataSource.count ? 246 : 44
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            //设置accessoryType视图的背景颜色
            for view in cell.subviews {
                if view.isKind(of: UIButton.self) {
                    view.backgroundColor = BASE_COLOR
                }
            }
        }
        
    }
}
