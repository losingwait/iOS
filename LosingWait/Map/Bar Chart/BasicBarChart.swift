//
//  BasicBarChart.swift
//  LosingWait
//
//  Created by Mike Choi on 3/20/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import UIKit

class BasicBarChart: UIView {
    
    let gray = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    
    let red = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
    
    /// the width of each bar
    let barWidth: CGFloat = 14.0
    
    /// space between each bar
    let space: CGFloat = 2.0
    
    /// space at the bottom of the bar to show the title
    private let bottomSpace: CGFloat = 30.0
    
    /// space at the top of each bar to show the value
    private let topSpace: CGFloat = 30.0
    
    /// contain all layers of the chart
    private let mainLayer: CALayer = CALayer()
    
    /// contain mainLayer to support scrolling
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isScrollEnabled = false
        return scroll
    }()
    
    var dataEntries: [BarEntry]? = nil {
        didSet {
            mainLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
            
            if let dataEntries = dataEntries {
                scrollView.contentSize = CGSize(width: self.frame.size.width, height: 150)
                mainLayer.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: 150)
                
                drawHorizontalLines()
                
                for i in 0..<dataEntries.count {
                    showEntry(index: i, entry: dataEntries[i])
                }
            }
        }
    }
    
    var currentIndex: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        scrollView.layer.addSublayer(mainLayer)
        self.addSubview(scrollView)
    }
    
    override func layoutSubviews() {
        scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 150)
    }
    
    private func showEntry(index: Int, entry: BarEntry) {
        /// Starting x postion of the bar
        let xPos: CGFloat = space + CGFloat(index) * (barWidth + space)
        
        /// Starting y postion of the bar
        let yPos: CGFloat = translateHeightValueToYPosition(value: entry.height)
        
        drawBar(index: index, xPos: xPos, yPos: yPos)
        
        if index == currentIndex {
            var status: String
            if entry.height < 0.2 {
                status = "Not busy"
            } else if entry.height < 0.5 {
                status = "Not too busy"
            } else if entry.height < 0.75 {
                status = "Busy"
            } else {
                status = "Packed"
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "h a"
            let hourString = formatter.string(from: Date()).uppercased()
            let textValue = "Live at \(hourString)"
            drawTextValue(xPos: xPos - 25.0, yPos: 0, textValue: textValue, color: red)
            drawTextValue(xPos: xPos - 40.0, yPos: 15, textValue: status, color: .black)
            drawVerticalLine(index: index)
        }
        
        /// Draw text below the bar
        if index % 3 == 0 {
            drawTitle(xPos: xPos - space/2, yPos: mainLayer.frame.height - bottomSpace + 10, title: entry.title)
        }
    }
    
    private func drawBar(index: Int, xPos: CGFloat, yPos: CGFloat) {
        let barLayer = CALayer()
        barLayer.frame = CGRect(x: xPos, y: yPos, width: barWidth, height: mainLayer.frame.height - bottomSpace - yPos)
        barLayer.backgroundColor = index == currentIndex ? red.cgColor : gray.cgColor
        
        if #available(iOS 11.0, *) {
            barLayer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
        barLayer.cornerRadius = 3.0
        mainLayer.addSublayer(barLayer)
    }
    
    private func drawHorizontalLines() {
        self.layer.sublayers?.forEach({
            if $0 is CAShapeLayer {
                $0.removeFromSuperlayer()
            }
        })
        let horizontalLineInfos = [["value": Float(0.0), "dashed": false], ["value": Float(0.5), "dashed": true], ["value": Float(1.0), "dashed": false]]
        for lineInfo in horizontalLineInfos {
            let xPos = CGFloat(0.0)
            let yPos = translateHeightValueToYPosition(value: (lineInfo["value"] as! Float))
            let path = UIBezierPath()
            path.move(to: CGPoint(x: xPos, y: yPos))
            path.addLine(to: CGPoint(x: scrollView.frame.size.width, y: yPos))
            let lineLayer = CAShapeLayer()
            lineLayer.path = path.cgPath
            lineLayer.lineWidth = 0.5
            if lineInfo["dashed"] as! Bool {
                lineLayer.lineDashPattern = [4, 4]
            }
            lineLayer.strokeColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
            self.layer.insertSublayer(lineLayer, at: 0)
        }
    }
    
    
    private func drawVerticalLine(index: Int) {
        self.layer.sublayers?.forEach({
            if $0 is CAShapeLayer {
                $0.removeFromSuperlayer()
            }
        })

        let xPos: CGFloat = space + CGFloat(index) * (barWidth + space) + barWidth / 2
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: xPos, y: 100))
        path.addLine(to: CGPoint(x: xPos, y: scrollView.frame.size.height - bottomSpace + 25))
        let lineLayer = CAShapeLayer()
        lineLayer.path = path.cgPath
        lineLayer.lineWidth = 0.5
        lineLayer.lineDashPattern = [4, 4]
        lineLayer.strokeColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
        self.layer.insertSublayer(lineLayer, at: 0)
    
    }
    
    private func drawTextValue(xPos: CGFloat, yPos: CGFloat, textValue: String, color: UIColor) {
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: xPos, y: yPos, width: 150, height: 22)
        textLayer.foregroundColor = color.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
        textLayer.fontSize = 12
        textLayer.string = textValue
        mainLayer.addSublayer(textLayer)
    }
    
    private func drawTitle(xPos: CGFloat, yPos: CGFloat, title: String) {
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: xPos, y: yPos, width: barWidth + space, height: 22)
        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
        textLayer.fontSize = 12
        textLayer.string = title
        mainLayer.addSublayer(textLayer)
    }
    
    private func translateHeightValueToYPosition(value: Float) -> CGFloat {
        let height: CGFloat = CGFloat(value) * (mainLayer.frame.height - bottomSpace - topSpace)
        return mainLayer.frame.height - bottomSpace - height
    }
}
