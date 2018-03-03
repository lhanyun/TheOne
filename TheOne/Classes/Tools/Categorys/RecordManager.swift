//
//  RecordManager.swift
//  TheOne
//
//  Created by lala on 2017/12/14.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import Foundation
import AVFoundation
import FreeStreamer

protocol RecordManagerDelegate:NSObjectProtocol {
    
    //必选方法
    func recordManagerD(_ path: String, _ time:TimeInterval)
    
    func recordManagerVolumeMeters(_ value: Double)
}

class RecordManager: NSObject {
    
    //单例  闭包
    static let sharedInstance:RecordManager = {
        
        let instance = RecordManager()
        
        return instance;
    }()
    
    var recorder: AVAudioRecorder?
    var player: AVPlayer?
    var index: Int = 0
    var pathStr: String = ""
    var timer:Timer?
    
    var delegate: RecordManagerDelegate?

    var file_path: String = ""

    //开始录音
    func beginRecord() {
        let session = AVAudioSession.sharedInstance()
        //设置session类型
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let err{
            print("设置类型失败:\(err.localizedDescription)")
        }
        //设置session动作
        do {
            try session.setActive(true)
        } catch let err {
            print("初始化动作失败:\(err.localizedDescription)")
        }
        
        //录音设置，注意，后面需要转换成NSNumber，如果不转换，你会发现，无法录制音频文件，我猜测是因为底层还是用OC写的原因
        let recordSetting: [String: Any] = [AVSampleRateKey: NSNumber(value: 16000),//采样率
            AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM),//音频格式
            AVLinearPCMBitDepthKey: NSNumber(value: 16),//采样位数
            AVNumberOfChannelsKey: NSNumber(value: 2),//通道数
            AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.min.rawValue)//录音质量
        ]
        //开始录音
        do {
            
            var time = Date().timeIntervalSince1970
            time = time * 100
            file_path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].appending("/\(Int(time)).caf")
            
            let url = URL(fileURLWithPath: file_path)
            
            recorder = try AVAudioRecorder(url: url, settings: recordSetting)
            recorder!.prepareToRecord()
            recorder!.record()
            recorder!.isMeteringEnabled = true
            print("开始录音")
            
            timer = Timer(timeInterval: 0.05, target: self, selector: #selector(volumeMeters), userInfo: nil, repeats: true)
            RunLoop.main.add(timer!, forMode:RunLoopMode.commonModes)
            
        } catch let err {
            print("录音失败:\(err.localizedDescription)")
        }
    }


    //结束录音
    func stopRecord() {
        if let recorder = self.recorder {
            
            if recorder.isRecording {
                print("正在录音，马上结束它，文件保存到了：\(file_path)")
            }else {
                print("没有录音，但是依然结束它")
            }

            pathStr = file_path
            
            guard let delegate = delegate else { return }
            delegate.recordManagerD(pathStr, recorder.currentTime)
            
            recorder.stop()
            self.recorder = nil
            
            if timer != nil {
                timer = nil
            }
            
        }else {
            print("没有初始化")
        }
    }


    //播放
    func play(path: String = "") {
        
        let str = (path.count == 0) ? pathStr : path
        print(str)
        
        guard let url = URL(string: str) else {
            log.debug("网络音频获取失败")
            return
        }
        //"http://127.0.0.1:8888/images/2018-02-03/123123.mp3"
//        let au = FSAudioStream(url: url)
//        au?.volume = 1.0
//        au?.play()
        player = AVPlayer(url: url)

        player!.play()
    }
    
    func pausePlay() {
        
        guard let player = self.player else { return }
        
        player.pause()
    }
    
    @objc fileprivate func volumeMeters() {
        
        guard let recorder = self.recorder else { return }
        
        recorder.updateMeters()

        var value = pow(10, 0.05*(recorder.peakPower(forChannel: 0)))

        if (value < 0) {
            value = 0
        } else if (value > 1){
            value = 1
        }
        
        guard let delegate = delegate else { return }
        delegate.recordManagerVolumeMeters(Double(value))

    }
}

