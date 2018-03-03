//
//  TOProjectProgressView.swift
//  TheOne
//
//  Created by lala on 2017/11/18.
//  Copyright © 2017年 ZLZK. All rights reserved.
//

import UIKit
import Charts

class TOProjectProgressView: PieChartView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initUI()
    }
    
}

extension TOProjectProgressView {
    
    func initUI() {
        
        setup()
        setDataCount(value: [20.0, 20.0, 20.0, 20.0])
        
        backgroundColor = superview?.backgroundColor ?? UIColor.flatWhite
    }
    
    func setup() {
        
        delegate = self
        
        // entry label styling
        entryLabelColor = .white
        entryLabelFont = .systemFont(ofSize: 12, weight: .light)
        
        animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        
        usePercentValuesEnabled = true
        drawSlicesUnderHoleEnabled = false
        holeRadiusPercent = 0.58
        holeColor = UIColor.clear
        transparentCircleRadiusPercent = 0.61
        transparentCircleColor = UIColor.orange
        setExtraOffsets(left: 5, top: 0, right: 5, bottom: 0)
        drawHoleEnabled = false //是否空心
        rotationAngle = 0
        rotationEnabled = true
        highlightPerTapEnabled = true
        
        chartDescription?.enabled = false
        
//        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
//        paragraphStyle.lineBreakMode = .byTruncatingTail
//        paragraphStyle.alignment = .center
//        drawCenterTextEnabled = true
//        let centerText = NSMutableAttributedString(string: "项目状态", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 10),
//                                                                                        NSAttributedStringKey.foregroundColor: UIColor.orange])
//        centerAttributedText = centerText

        
        legend.maxSizePercent = 1
        legend.formToTextSpace = 5
        legend.font = UIFont.systemFont(ofSize: 10)
        legend.textColor = UIColor.gray
        legend.form = .circle
        legend.formSize = 12
        
    }
    
    func setDataCount(_ count: Int = 4, value: [Double], label:[String] = ["正常进行", "延期", "延期完成", "正常完成"]) {
        
        let entries = (0..<count).map { (i) -> PieChartDataEntry in
            
            return PieChartDataEntry(value: value[i], label: label[i])
        }
        
        let set = PieChartDataSet(values: entries, label: "")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        set.drawValuesEnabled = true
        set.valueLinePart1OffsetPercentage = 0.85
        set.valueLinePart1Length = 0.5
        set.valueLinePart2Length = 0.4
        set.valueLineWidth = 1
        set.valueLineColor = UIColor.brown
        set.xValuePosition = .insideSlice
        set.yValuePosition = .outsideSlice
        
        set.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.brown)
        
        self.data = data
        highlightValues(nil)
    }
}

extension TOProjectProgressView: ChartViewDelegate {
    
    // TODO: Cannot override from extensions
    //extension DemoBaseViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        NSLog("chartValueSelected");
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        NSLog("chartValueNothingSelected");
    }
    
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        
    }
    
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        
    }
    
}
