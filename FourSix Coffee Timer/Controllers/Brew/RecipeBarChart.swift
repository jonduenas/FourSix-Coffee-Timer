//
//  RecipeBarChart.swift
//  FourSix Coffee Timer
//
//  Created by Jon Duenas on 2/22/21.
//  Copyright © 2021 Jon Duenas. All rights reserved.
//

import UIKit
import Charts

class RecipeBarChart: BarChartView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        drawValueAboveBarEnabled = false
        legend.enabled = false
        //animate(yAxisDuration: 0.5, easingOption: .easeOutQuint)
        highlightPerTapEnabled = false
        fitBars = true
        
        // Remove Axis and Grid
        rightAxis.drawAxisLineEnabled = false
        leftAxis.drawAxisLineEnabled = false
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        rightAxis.drawGridLinesEnabled = false
        leftAxis.drawGridLinesEnabled = false
        leftAxis.drawLabelsEnabled = false
        rightAxis.drawLabelsEnabled = false
        xAxis.drawLabelsEnabled = false
        
        // Remove extra spacing
        leftAxis.spaceTop = 0
        leftAxis.spaceBottom = 0
        xAxis.spaceMin = 0
        xAxis.spaceMax = 0
        minOffset = 0
        setExtraOffsets(left: 0, top: 0, right: 0, bottom: 0)
    }
    
    func setBarDataPreferences() {
        barData?.barWidth = 0.4
        barData?.setValueFont(.boldSystemFont(ofSize: 24))
        barData?.setValueTextColor(UIColor(named: "Background") ?? UIColor.systemBackground)
        
        let valueFormatter = YAxisValueFormatter()
        barData?.setValueFormatter(valueFormatter)
    }
}

class YAxisValueFormatter: IValueFormatter {
    // Formats values to be shown on bar chart
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return value.clean + "g"
    }
}

extension BarChartDataSet {
    func setRecipeGraphPreferences() {
        // TODO: Move colors to own Style class
        let color1 = UIColor(hue: 0.6, saturation: 0.5, brightness: 0.5, alpha: 1)
        let color2 = UIColor(hue: 0.6, saturation: 0.5, brightness: 0.56, alpha: 1)
        let color3 = UIColor(hue: 0.6, saturation: 0.5, brightness: 0.62, alpha: 1)
        let color4 = UIColor(hue: 0.6, saturation: 0.5, brightness: 0.68, alpha: 1)
        let color5 = UIColor(hue: 0.6, saturation: 0.5, brightness: 0.74, alpha: 1)
        let color6 = UIColor(hue: 0.6, saturation: 0.5, brightness: 0.8, alpha: 1)
        
        setColors(color1, color2, color3, color4, color5, color6)
        barBorderColor = UIColor(named: "Background") ?? UIColor.systemBackground
        barBorderWidth = 2
    }
}
