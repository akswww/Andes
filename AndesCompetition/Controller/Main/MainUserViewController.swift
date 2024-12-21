//
//  AudioViewController.swift
//  AndesCompetition
//
//  Created by imac-3570 on 2024/8/27.
//

import UIKit
import Charts



class MainUserViewController: UIViewController {

    @IBOutlet weak var lbName: UILabel!
    
    @IBOutlet weak var lbgender: UILabel!
    
    @IBOutlet weak var lbtall: UILabel!
    
    @IBOutlet weak var lbWeight: UILabel!
    
    @IBOutlet weak var lbBirtherDay: UILabel!
    
    @IBOutlet weak var myChartView: LineChartView!
    
    @IBOutlet weak var btnNFC: UIButton!
    
    @IBOutlet weak var btnQR: UIButton!
    
    var timer: Timer?
    
    var dataEntries: [ChartDataEntry] = []
    
    var dataEntries1: [ChartDataEntry] = []
    
    let manager = NetworkManager()
    
    struct Node: Codable {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setChart()
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(randomSugarBlood), userInfo: nil, repeats: true)
        randomSugarBlood()
    }

    func setChart() {
        // 設定x軸
        myChartView.xAxis.labelPosition = .bottom
        myChartView.xAxis.drawGridLinesEnabled = false // 顯示X軸線
        myChartView.xAxis.avoidFirstLastClippingEnabled = true // 不要超出x軸的範圍
        
        myChartView.leftAxis.drawGridLinesEnabled = true // 顯示Y軸線
        myChartView.rightAxis.enabled = false // 不顯示右邊Y軸
        myChartView.rightAxis.drawGridLinesEnabled = true // 顯示Y軸線
        
        myChartView.legend.enabled = true // 顯示圖例
        myChartView.scaleYEnabled = false // 取消Y轴缩放
        myChartView.highlightPerTapEnabled = false // 取消點擊高亮
        
        myChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        myChartView.leftAxis.drawLimitLinesBehindDataEnabled = true // 设置限制线绘制在折线图的后面
        myChartView.leftAxis.spaceTop = 0.15
        
        myChartView.chartDescription.text = "單位℃\n單位bpm"
        myChartView.chartDescription.textColor = UIColor.red
        myChartView.chartDescription.position = CGPoint(x: myChartView.frame.maxX, y: myChartView.frame.height / 2)
        myChartView.chartDescription.font = .boldSystemFont(ofSize: 20)
        
        for i in 0 ... 200 {
            let fillLine = ChartLimitLine(limit: Double(i))
            fillLine.lineWidth = 0.1
            fillLine.lineColor = NSUIColor.gray.withAlphaComponent(0.5)
            // 将限制线添加到左侧 Y 轴
            myChartView.leftAxis.addLimitLine(fillLine)
        }
        
    }
    @objc func randomSugarBlood() {
        Task {
            let result: measureReponse = try await manager.requestData(method: .post, path: .measure, parameters: Node())
            let random = "\(result.measure.pulse)"
            let random1 = "\(result.measure.temperature)"
            myChartView.leftAxis.axisMaximum = Double(result.measure.pulse + 20)
            myChartView.leftAxis.axisMinimum = result.measure.temperature - 10
            myChartView.leftAxis.granularity = 7
            myChartView.leftAxis.setLabelCount(20, force: true)
            
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 0
            myChartView.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
            
            // 获取当前时间戳
            let currentTime = Date().timeIntervalSince1970
            // 获取当前时间往后1小时的时间戳
            //        let oneHourLater = currentTime + 3600
            let oneHourLater = currentTime + (Double(60.0))
            // 创建数据点并添加到数据集
            let entry = ChartDataEntry(x: currentTime,
                                       y: Double(random)!)
            let entry1 = ChartDataEntry(x: currentTime,
                                       y: Double(random1)!)
            dataEntries.append(entry)
            dataEntries1.append(entry1)
            // 更新折线图数据集
            let dataSet = LineChartDataSet(entries: dataEntries, label: "pulse")
            dataSet.colors = [NSUIColor.red] // 设置折线的颜色
            dataSet.drawCirclesEnabled = true // 显示数据点的圆圈
            dataSet.circleRadius = 4.0  // 设置數據點的半徑
            dataSet.circleColors = [NSUIColor.red] // 设置數據點的圆圈颜色
            dataSet.drawValuesEnabled = true // 显示数据点的值
            dataSet.highlightEnabled = false // 取消选中时高亮
            dataSet.mode = .linear
            
            let dataSet1 = LineChartDataSet(entries: dataEntries1, label: "body temperature")
            dataSet1.colors = [NSUIColor.blue] // 设置折线的颜色
            dataSet1.drawCirclesEnabled = true // 显示数据点的圆圈
            dataSet1.circleRadius = 4.0  // 设置數據點的半徑
            dataSet1.circleColors = [NSUIColor.blue] // 设置數據點的圆圈颜色
            dataSet1.drawValuesEnabled = true // 显示数据点的值
            dataSet1.highlightEnabled = false // 取消选中时高亮
            dataSet1.mode = .linear
            
            let data = LineChartData(dataSets: [dataSet,dataSet1])
            myChartView.data = data
            // 设置 X 轴的范围为从当前时间戳到当前时间往后1小时
            myChartView.xAxis.setLabelCount(6, force: true) //
            myChartView.xAxis.axisMinimum = currentTime - 10
            myChartView.xAxis.axisMaximum = oneHourLater
            // 让图表自动滚动显示最新数据
            if currentTime > oneHourLater {
                myChartView.moveViewToX(currentTime - 60)
            }
            let xAxis = myChartView.xAxis // 获取 X 轴
            xAxis.valueFormatter = ChartXAxisFormatter() // 设置 X 轴的值格式化器
        }
    }
    
    @IBAction func toNFCvc(_ sender: Any) {
        let request: nfcRequest = nfcRequest(national_id: UserPreferences.shared.idcard)
        Task {
            let result: BaseReponse = try await manager.requestData(method: .post, path: .nfcRegister, parameters: request)
            if(result.result == 0) {
                let vc = NFCViewController()
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func toQRvc(_ sender: Any) {
        let vc = ScanQRCodeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

