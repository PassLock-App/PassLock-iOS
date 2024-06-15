//
//  CloudSyncHeadView.swift
//  PassLock
//
//  Created by Melo on 2024/6/8.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit
import DGCharts

class CloudSyncHeadView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.preSetupSubViews()
        self.preSetupContains()
        self.preSetupHandleBuness()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func preSetupSubViews() {
        self.addSubview(chartView)
    }
    
    private func preSetupContains() {
        chartView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func preSetupHandleBuness() {
        
    }
    
    // MARK:  GET && SET
    func updateCloudType(clouds: Int, locals: Int) {
        
        let dataEntries: [PieChartDataEntry] = [
            PieChartDataEntry(value: Double(clouds), label: "Cloud data".localStr()),
            PieChartDataEntry(value: Double(locals), label: "Local data".localStr())
        ]

        let dataSet = PieChartDataSet(entries: dataEntries, label: "")
        dataSet.colors = [UIColor.systemGreen, UIColor.red]
        dataSet.valueFont = UIFontBold(12.ckValue())
        dataSet.valueTextColor = UIColor.white
        
        dataSet.valueFormatter = CustomValueFormatter()
        
        self.chartView.data = PieChartData(dataSet: dataSet)
    }
    
    // MARK:  Lazy Init
    lazy var chartView: PieChartView = {
        
       
        return view
    }()
    
}
