//
//  TOCalendarViewController.swift
//  TheOne
//
//  Created by lala on 2017/11/22.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import FSCalendar
import ChameleonFramework
import EventKit

typealias closureBlock = (String) -> Void
class TOCalendarViewController: TOBaseViewController {
    
  
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var calendarView: FSCalendar!
    
    var indexPath:IndexPath = IndexPath(row: 1000, section: 1000)
    
    //项目开始时间
    var startTime:String = ""
    //项目预计结束时间
    var endTime:String = ""
    
    
    fileprivate var events:Array? = []
    
    fileprivate let lunarChars = ["初一","初二","初三","初四","初五","初六","初七","初八","初九","初十","十一","十二","十三","十四","十五","十六","十七","十八","十九","二十","二一","二二","二三","二四","二五","二六","二七","二八","二九","三十"]
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    fileprivate let chineseCalendar:NSCalendar = NSCalendar(calendarIdentifier: .chinese)!
    
    var postValueBlock:closureBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //覆盖父类方法，使之失效
    override func initUI() {
        
        //获取系统事件
        systemEvents()
        
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.firstWeekday = 2
        calendarView.appearance.headerDateFormat = "yyyy年MM月"
        calendarView.appearance.headerTitleColor = FlatGreen()
        calendarView.appearance.weekdayTextColor = FlatGreen()
        
        let locale = Locale(identifier: "zh_CN")
        
        calendarView.locale = locale
        
        if indexPath.section == 0 {
            titleLabel.text = (indexPath.row == 1) ? "选择开始日期" : "选择预计结束日期"
        } else if indexPath.section == 1 {
            titleLabel.text = "选择节点时间"
        }
    }
    
    //获取系统事件
    fileprivate func systemEvents() {
        
        let store = EKEventStore()
        store.requestAccess(to: .event) {[weak self] (granted, error) in
            
            if granted {
                
                let startDate = Date()
                let endDate = self?.timeDisNow(dis: 365)
                let fetchCalendarEvents = store.predicateForEvents(withStart: startDate, end: endDate!, calendars: nil)
                let eventList = store.events(matching: fetchCalendarEvents)
                let eventss = eventList.filter({ (event) -> Bool in
                    return event.calendar.isSubscribed
                })
                
                self?.events = eventss
            }
            
        }
        
    }

    @IBAction func buttonAct(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
}

//Mark: - 日历协议
extension TOCalendarViewController: FSCalendarDelegate,FSCalendarDataSource {
    
    func eventsForDate(data: Date) -> [EKEvent] {
        
        let filteredEvents = events?.filter({ (evaluatedObject) -> Bool in
            return ((evaluatedObject as! EKEvent).occurrenceDate as NSDate).isEqual(to: data)
        })
        
        return filteredEvents as! [EKEvent]
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {

        if chineseCalendar.isDateInToday(date) {
            return "今天"
        }
        
        //添加项目开始/结束标记
        let dayTime:String = "\(formatter.string(from: date))"
        if dayTime.isEqual(startTime) {
            return "项目开始"
        } else if dayTime.isEqual(endTime) {
            return "项目结束"
        }
        
        let event = eventsForDate(data: date).first
        if (event != nil) {
            return event?.title
        }
        
        //农历
//        let lunarDay = chineseCalendar.component(.day, from: date)

        return ""//lunarChars[lunarDay - 1]
    }
    
//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//        return chineseCalendar.isDateInToday(date) ? "今天" : nil
//    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        print("did select date \(formatter.string(from: date))")
        
        guard let postValueBlock = postValueBlock else { return }
        postValueBlock("\(formatter.string(from: date))")
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension TOCalendarViewController {
    
    func timeDisNow(dis: TimeInterval) -> Date {
        
        let nowDate = Date()
        
        let oneDay:Double = 24*60*60*1
        
        let theDay = nowDate.addingTimeInterval(TimeInterval(oneDay*dis))
        
        return theDay
        
    }
    
}
