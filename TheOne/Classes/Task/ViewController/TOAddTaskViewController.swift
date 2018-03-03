//
//  TOAddTaskViewController.swift
//  TheOne
//
//  Created by lala on 2017/12/13.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import ChameleonFramework
import Photos
import AssetsLibrary
import ZLPhotoBrowser

class TOAddTaskViewController: TOBaseViewController {
    
    fileprivate let model:TaskDetailModel? = nil
    
    fileprivate let projectModules = Tools().userInfo.projectModules.split(separator: ",").map {
        String($0)
    }
    
    fileprivate let sectionOne = ["任务内容","所属模块","标签","优先级","所属平台","创建时间","截止时间","发起人","执行人"]
    
    let recoder = RecordManager.sharedInstance
    
    fileprivate var taskId:String? = ""
    
    //进入页面后执行一次处理照片和音频的方法
    var isbool: Bool = true
    
    var photoUrls: [URL] = []
    var voiceUrls: [String] = []
    
    fileprivate let storyBoard = UIStoryboard.init(name: "Project", bundle: Bundle.main)
    
    //音量视图
    let imgView:UIImageView = {
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        imgView.center = CGPoint(x: IPHONE_WIDTH/2, y: IPHONE_HEIGHT/2)
        return imgView
    }()
    
    //数据源
    var dataSource: [String: String] = [
                                                 "taskContent": "",
                                                 "module": "",
                                                 "label": "",
                                                 "priority": "",
                                                 "startTime": "",
                                                 "cutoffTime": "",
                                                 "startPerson": "",
                                                 "executePerson": "",
                                                 "platform": "",
                                                 "describeTask": "",
                                                 "photos": "",
                                                 "taskId": "",
                                                 "voices": "",
                                                 "projectId": Tools().userInfo.projectId]
    
    //录音数组
    var audios: [String] = [] {
        didSet {
            
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! TOAddTaskCell
            cell.auidos = audios
            
        }
    }
    
    //照片、视频 数组
    var photos: [UIImage] = [] {
        didSet {
            
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! TOAddTaskCell
            cell.photos = photos
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navItem.rightBarButtonItem = UIBarButtonItem(title: "完成", selector: #selector(overAdd), target: self, isBack: false)
        recoder.delegate = self
    }
    
    override func initUI() {
        super.initUI()
        super.initTableView()
        
        setTableView()
    }
    
    @objc fileprivate func overAdd() {
        
        let urlString = photoUrls.map {
            $0.absoluteString
        }
        
        dataSource["photos"] = urlString.joined(separator: ",")
        
        dataSource["voices"] = audios.joined(separator: ",")
        
        AddTaskViewModel().submitTask(self, dataSource)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isbool {
            isbool = false
            setPhotosAndVoices()
        }
    }
    
    //处理相片和音频
    func setPhotosAndVoices() {
        
        if let photoArr = dataSource["photos"]?.split(separator: ",") {
            
            photoUrls = photoArr.map {
                URL(string: String($0))!
            }
            
            for url in photoUrls {
                
                SDWebImageManager.shared().downloadImage(with: url, options: SDWebImageOptions(rawValue: 0), progress: { (receivedSize, expectedSize) in
                    
                }, completed: {[weak self] (image, error, cacheType, finished, imageUrl) in
                    
                    guard let image = image else {
                        log.debug("获取任务图片失败")
                        return
                    }
                    
                    self?.photos.append(image)
                })
            }
        }
        
        if let voiceArr = dataSource["voices"]?.split(separator: ",") {
            for str in voiceArr {
                audios.append(String(str))
            }
        }
    }
    
    deinit {
    
        log.debug("添加任务控制器销毁")
    }
    
}

extension TOAddTaskViewController {
    
    fileprivate func setTableView() {
        
        //注册cell
        tableView.register(cellType: TODetailNormalCell.self)
        tableView.register(cellType: TOAddTaskCell.self)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
    }
}

//MARK: - TOPickerViewDelegate
extension TOAddTaskViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return sectionOne.count
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TODetailNormalCell.self)
            
            cell.leftLabel.text = sectionOne[indexPath.row]
            
            cell.accessoryType = .disclosureIndicator
            
            var rightLabel: String = " "
            switch indexPath.row {
            case 0:
                rightLabel = dataSource["taskContent"] ?? " "
            case 1:
                rightLabel = dataSource["module"] ?? " "
            case 2:
                let label = dataSource["label"] ?? " "
                if label == "0" {
                    rightLabel = "任务"
                } else if label == "1" {
                    rightLabel = "BUG"
                } else {
                    rightLabel = " "
                }
            case 3:
                rightLabel = dataSource["priority"] ?? " "
            case 4:
                rightLabel = dataSource["platform"] ?? " "
            case 5:
                rightLabel = dataSource["startTime"] ?? " "
            case 6:
                rightLabel = dataSource["cutoffTime"] ?? " "
            case 7:
                rightLabel = dataSource["startPerson"] ?? " "
            case 8:
                rightLabel = dataSource["executePerson"] ?? " "
            default: ()
            }
            
            if rightLabel.count == 0 {
                rightLabel = " "
            }
            
            cell.rightLabel.text = rightLabel
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TOAddTaskCell.self)

            cell.auidoBtn.addTarget(self, action: #selector(buttonTouchUpInside(btn:)), for: .touchUpInside)
            cell.auidoBtn.addTarget(self, action: #selector(buttonTouchDown(btn:)), for: .touchDown)

            cell.photoBtn.addTarget(self, action: #selector(buttonTouchUpInside(btn:)), for: .touchUpInside)

            // 删除/预览 按钮
            cell.postValueBlock = {[weak self] (btnTag, type) in
                
                if type == "show" {
                    
                    guard let photoUrls = self?.photoUrls else { return }
                    
                    if photoUrls.count > 0 {
                        
                        //photos 接收对象 PHAsset / UIImage / NSURL(网络图片/视频url 或 本地图片/视频url)
                        self?.getPas().previewPhotos(photoUrls, index: btnTag, hideToolBar: false, complete: { (result) in
                            
                            //移除被删除项（两个数组挑出不同项）
                            if result.count != photoUrls.count {
                                
                                let filterPredicate_same = NSPredicate(format: "NOT (SELF IN %@)", result)
                                
                                let arr = (photoUrls as NSArray).filtered(using: filterPredicate_same)

                                arr.forEach({ (a) in
                                    
                                    let aIndex = (photoUrls as NSArray).index(of: a)
                                    self?.photoUrls.remove(at: aIndex)
                                    self?.photos.remove(at: aIndex)
                                })
                            }
                            
                        })
                    }
                    
                } else  {
                    if btnTag < 10 {
                        self?.audios.remove(at: btnTag - 1)
                    } else {
                        self?.photos.remove(at: btnTag - 10)
                        self?.photoUrls.remove(at: btnTag - 10)
                    }
                }

            }
            
            cell.notice?
                .subscribe(onNext: {[weak self] element in
                    self?.dataSource["describeTask"] = element
                })
                .disposed(by: rx.disposeBag)
            
            cell.textView.text = dataSource["describeTask"]
            
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.section == 1) ? 272 : 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return UIView()
        } else {
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: IPHONE_WIDTH, height: 44))
            
            label.text = "  备注"
            
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = FlatBlack()
            label.textAlignment = .center
            
            return label
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return (section == 0) ? 0 : 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            
            switch indexPath.row {
            case 0:
                TOAlterView.newTOAlterView(targetVC: self, indexPath: indexPath)
            case 1, 2, 3, 4:
                showPickerView(indexPath.row, "请选择", indexPath)
            case 5, 6:
                
                let vc = storyBoard.instantiateViewController(withIdentifier: "TOCalendarViewController") as! TOCalendarViewController
                
                vc.transitioningDelegate = self
                vc.postValueBlock = {[weak self] time in
                    
                    let cell = self?.tableView.cellForRow(at: indexPath) as! TODetailNormalCell
                    cell.rightLabel.text = time
                    
                    indexPath.row == 5 ? (self?.dataSource["startTime"] = time) : (self?.dataSource["cutoffTime"] = time)
                }

                vc.modalPresentationStyle = .custom
                
                self.present(vc, animated: true, completion: nil)
                
            case 7, 8:
                
                let vc = storyBoard.instantiateViewController(withIdentifier: "TOChooseMemberViewController") as! TOChooseMemberViewController
                
                vc.isShowAll = "1"
                vc.allowsMultipleSelection = false
                
                vc.postValueBlock = {[weak self] users in
                    
                    let userInfo = users[0]
                    
                    let cell = self?.tableView.cellForRow(at: indexPath) as! TODetailNormalCell
                    
                    cell.rightLabel.text = userInfo.userName
                    
                    indexPath.row == 7 ? (self?.dataSource["startPerson"] = userInfo.userName) : (self?.dataSource["executePerson"] = userInfo.userName)
                    
                }
                
                show(vc, sender: nil)
                
               
            default:
                return
            }
        } else {
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //设置accessoryType视图的背景颜色
        for view in cell.subviews {
            if view.isKind(of: UIButton.self) {
                view.backgroundColor = BASE_COLOR
            }
        }
    }
}

//MARK: - TOPickerViewDelegate、TOAlterViewDelegate
extension TOAddTaskViewController: TOPickerViewDelegate, TOAlterViewDelegate {
    
    //输入任务内容
    func alterViewDidInPut(_ content: String, _ indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! TODetailNormalCell
        cell.rightLabel.text = content
        
        dataSource["taskContent"] = content
        
        tableView.reloadData()
    }
    
    fileprivate func showPickerView(_ dataIndex: Int, _ pickerViewTitile: String, _ indexPath: IndexPath) {
        
        var pickerViewData: [String] = []
        switch dataIndex {
        case 1:
            pickerViewData = projectModules
        case 2:
            pickerViewData = ["任务","BUG"]
        case 3:
            pickerViewData = ["1","2","3","4"]
        case 4:
            pickerViewData = ["iOS","Android","后台","web"]
        default:
            break
        }
        
        TOPicker.newTOPickerView(targetVC: self, dataSource: pickerViewData, title: pickerViewTitile, indexPath: indexPath)
    }
    
    func pickerViewDidSelect(_ index: Int, _ content: String, _ indexPath: IndexPath) {
    
        let cell = tableView.cellForRow(at: indexPath) as! TODetailNormalCell
        
        cell.rightLabel.text = content
        
        switch indexPath.row {
        case 1:
            dataSource["module"] = content
        case 2:
            if content == "任务" {
                dataSource["label"] = "0"
            } else {
                dataSource["label"] = "1"
            }
        case 3:
            dataSource["priority"] = content
        case 4:
            dataSource["platform"] = content
        default:
            break
        }

    }
}

//MARK: - UIViewControllerTransitioningDelegate
extension TOAddTaskViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentingAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissingAnimator()
    }
}

//照片、视频、语音
extension TOAddTaskViewController: RecordManagerDelegate {
    
    @objc fileprivate func buttonTouchUpInside(btn: UIButton) {
        
        if btn.tag == 100 {
            
            let a = self.getPas()
            a.showPreview(animated: true)
            
        } else  {//结束录音
            imgView.removeFromSuperview()
            recoder.stopRecord()
        }
        
    }
    
    //开始录音
    @objc fileprivate func buttonTouchDown(btn: UIButton) {
        recoder.beginRecord()
    }
    
    func recordManagerD(_ path: String, _ time: TimeInterval) {

        if time < TimeInterval(1.0) {
            TipHUD.sharedInstance.showTips("本次录音太短")
            return
        }
        
        let mp3Path = path.replacingOccurrences(of: ".caf", with: ".mp3")

        //caf转MP3
        ConvertAudioFile.conventToMp3(withCafFilePath: path, mp3FilePath: mp3Path, sampleRate: 16000) {[weak self] (result) in
            
            if result {
                
                self?.uploadAudio(mp3Path)
            }
            
        }

    }
    
    func recordManagerVolumeMeters(_ value: Double) {
        
        var no = 0
        
        if (value > 0.0 && value <= 0.14) {
            no = 1
        } else if (value <= 0.28) {
            no = 2
        } else if (value <= 0.42) {
            no = 3
        } else if (value <= 0.56) {
            no = 4
        } else if (value <= 0.7) {
            no = 5
        } else if (value <= 0.84) {
            no = 6
        } else {
            no = 7;
        }
        
        imgView.image = UIImage(named: "mic_\(no)")
        view.addSubview(imgView)
    }
    
    //上传音频文件
    func uploadAudio(_ path: String) {
        
        let filePathArr = path.split(separator: "/").map { String($0) }
        
        guard let data = try? NSData.init(contentsOfFile: path) as Data else {
            log.debug("音频转data失败")
            return
        }
        
        AddTaskViewModel().uploadImg(data: data, fileName: filePathArr.last ?? ".mp3", uploadProgress: { (p) in
            
        }) {[weak self] (result, url) in
            self?.audios.append(url)
        }
    }
}

extension TOAddTaskViewController {
    
    func getPas() -> ZLPhotoActionSheet {

        let actionSheet = ZLPhotoActionSheet()

        //以下参数为自定义参数，均可不设置，有默认值
        actionSheet.configuration.allowSelectVideo = true

    //    actionSheet.configuration.allowForceTouch = self.allowForceTouchSwitch.isOn;
        actionSheet.configuration.allowEditImage = true
        actionSheet.configuration.allowEditVideo = true
        
        //设置相册内部显示拍照按钮
        actionSheet.configuration.allowTakePhotoInLibrary = true
        //设置在内部拍照按钮上实时显示相机俘获画面
        actionSheet.configuration.showCaptureImageOnTakePhotoBtn = true

    //    //设置照片最大预览数
    //    actionSheet.configuration.maxPreviewCount = self.previewTextField.text.integerValue;
    //    //设置照片最大选择数
    //    actionSheet.configuration.maxSelectCount = self.maxSelCountTextField.text.integerValue;
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
        actionSheet.configuration.useSystemCamera = false
        actionSheet.configuration.sessionPreset = .preset1920x1080
        actionSheet.configuration.exportVideoType = .mp4
        actionSheet.configuration.allowRecordVideo = true
        
        // - required
        //如果调用的方法没有传sender，则该属性必须提前赋值
        actionSheet.sender = self;
        
        actionSheet.cancleBlock = {
            
        }
        
        actionSheet.selectImageBlock = {[weak self] images, assets, isOriginal in
            
            guard let images = images else { return }
            
//            self?.photos = images
            
            self?.handleMediaArr(assets: assets, images: images)
        }
    
        return actionSheet;
    }
    
    //处理资源数组，确定是新增还是删除
    func handleMediaArr(assets: [PHAsset], images: [UIImage]) {
        
        let arr = assets.map {
            PHAssetResource.assetResources(for: $0)
        }
        
        for (index, assetResources) in arr.enumerated() {
            assetResources.forEach({ (assetRes) in
                
                self.PHAssetResourceToData(assetRes, assets[index], index, images)
                
            })
        }

    }
    
    //将提供的资源，转成data
    func PHAssetResourceToData(_ assetRes: PHAssetResource, _ asset: PHAsset, _ index: Int, _ images: [UIImage]) {
    
        var arr:[TOPhotoModel] = []
        
        if assetRes.type == .video {
            
            let options = PHVideoRequestOptions()
            options.version = .current
            options.deliveryMode = .highQualityFormat
            
            PHImageManager.default().requestAVAsset(forVideo: asset, options: options, resultHandler: { (avAsset, audio, info) in
                
                guard let av = avAsset as? AVURLAsset,
                    let data = try? NSData(contentsOf: av.url) as Data else {
                        log.debug("视频获取失败")
                        return
                }
                
                AddTaskViewModel().uploadImg(data: data, fileName: assetRes.originalFilename.lowercased(), uploadProgress: { (p) in
                    
                }, complete: {[weak self] (result, urlString) in
                    
                    guard let url = URL(string: urlString) else {
                        log.debug("视频路径转URL失败")
                        return
                    }
                    
                    self?.photoUrls.append(url)
                    
                    self?.photos.append(images[index])
                })
                
            })
            
        } else if assetRes.type == .photo {
            
            let options = PHImageRequestOptions()
            options.version = .current
            options.deliveryMode = .highQualityFormat
            options.isSynchronous = true
            
            PHImageManager.default().requestImageData(for: asset, options: options, resultHandler: { (data, dataUTI, orientation, info) in
                
                guard let data = data else { return }
                
                let model = TOPhotoModel()
                model.data = NSData.init(data: data) as Data
                model.originalFilename = assetRes.originalFilename.lowercased()
                
                arr.append(model)
                
                AddTaskViewModel().uploadImg(data: data, fileName: assetRes.originalFilename.lowercased(), uploadProgress: { (p) in
                    
                    }, complete: {[weak self] (result, urlString) in
                        
                        guard let url = URL(string: urlString) else {
                            log.debug("图片路径转URL失败")
                            return
                        }
                        
                        self?.photoUrls.append(url)
                        
                        self?.photos.append(images[index])
                })
            })
        }
        
    }
}

extension TOAddTaskViewController {
    
}
