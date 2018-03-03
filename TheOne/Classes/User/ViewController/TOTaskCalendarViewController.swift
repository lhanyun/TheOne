//
//  TOTaskCalendarViewController.swift
//  TheOne
//
//  Created by lala on 2018/1/9.
//  Copyright © 2018年 ZLZK. All rights reserved.
//

import UIKit
import FSCalendar
import pop

class TOTaskCalendarViewController: TOBaseViewController {

    @IBOutlet weak var calendarViewTop: NSLayoutConstraint!
    @IBOutlet weak var calendarView: FSCalendar!

    //根据时间分好组的颜色数组
    var datesWithColor: [[UIColor]] = []
    
    //根据时间分好组的model数组
    var dataSource: [[TaskListModel]] = []
    
    var timeDic: [String: Int] = [:]
    
    var forMe: String = "0"
    
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    fileprivate let viewModel = TaskListViewModel()
    
    var models: [TaskListModel]? {
        didSet {
            
            dataSource.removeAll()
            timeDic.removeAll()
            datesWithColor.removeAll()
            
            var tempArr: [String] = []
            models?.forEach({ (model) in
                tempArr.append(model.startTime)
            })
            
            var tempDic: [String: String] = [:]
            tempArr.forEach { (time) in
                tempDic[time] = time
            }
            
            //将数据去重放入数组
            let datesWithEvent = tempDic.keys.map({
                String($0)
            })

            for (index, time) in datesWithEvent.enumerated() {
                
                var colors: [UIColor] = []
                var datas: [TaskListModel] = []
                models?.forEach({ (model) in
                    if time == model.startTime {
                        
                        if model.status == "6" {
                            
                            colors.append(UIColor.flatLime)
                        } else {
                            
                            if model.postpone == "1" {
                                colors.append(UIColor.flatOrange)
                            } else {
                                colors.append(UIColor.flatSkyBlue)
                            }
                        }
                        
                        datas.append(model)
                    }
                })
                
                datesWithColor.append(colors)
                dataSource.append(datas)
                timeDic[time] = index
            }
            
            calendarView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "当前项目任务日历"
        
        setCalendarTask()
        
        navItem.rightBarButtonItem = UIBarButtonItem(title: "个人任务", selector: #selector(getPersonTask), target: self, isBack: false)
        
        //获取数据
        getData()
    }

    func setCalendarTask() {
        
        calendarViewTop.constant = CGFloat(NavibarH) + StatusBarHeight
        
        calendarView.dataSource = self
        calendarView.delegate = self
        
        calendarView.swipeToChooseGesture.isEnabled = true
        
        calendarView.backgroundColor = UIColor.flatWhite
        
        calendarView.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesSingleUpperCase]
    }
    
    //获取个人任务
    @objc fileprivate func getPersonTask() {
        if forMe == "0" {
            forMe = "1"
            navItem.rightBarButtonItem = UIBarButtonItem(title: "全部任务", selector: #selector(getPersonTask), target: self, isBack: false)
        } else {
            forMe = "0"
            navItem.rightBarButtonItem = UIBarButtonItem(title: "个人任务", selector: #selector(getPersonTask), target: self, isBack: false)
        }
        
        getData()
    }
    
    fileprivate func getData() {
        TaskCalendarViewModel().getTaskCalendar(forMe: forMe, VC: self)
    }
    
    deinit {
        log.debug("\(#function)")
    }
}

extension TOTaskCalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        let dateString = dateFormatter2.string(from: date)
        
        if timeDic.keys.contains(dateString) {
            let index = timeDic[dateString] ?? 0
            return datesWithColor[index].count
        }

        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let key = dateFormatter2.string(from: date)
        
        if timeDic.keys.contains(key) {
            let index = timeDic[key] ?? 0
            return datesWithColor[index]
        }

        return nil
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
        
        let key = dateFormatter2.string(from: date)
        
        if timeDic.keys.contains(key) {
            let taskCalendarView = TOTaskCalendarView.newTOTaskCalendarView(VC: self)
            taskCalendarView.models = dataSource[timeDic[key] ?? 0]
            view.addSubview(taskCalendarView)
        }
        
    }
}
