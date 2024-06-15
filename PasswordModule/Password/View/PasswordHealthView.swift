//
//  PasswordHealthView.swift
//  PassLock
//
//  Created by Melo on 2023/9/26.
//

import KakaFoundation
import KakaUIKit
import AppGroupKit
import DGCharts

class PasswordHealthView: UIView {
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
        self.backgroundColor = .clear
        
        self.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(chartView)
        contentView.addSubview(persentView)
        contentView.addSubview(scoreLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(promoteLabel)
        contentView.addSubview(switchButton)
        contentView.addSubview(shareButton)
    }
    
    private func preSetupContains() {
        
        contentView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20.ckValue())
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(16.ckValue())
            make.top.equalToSuperview().inset(10.ckValue())
            make.size.equalTo(titleLabel.size)
        }
        
        chartView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        persentView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.size.equalTo(persentView.size)
        }
        
        scoreLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(persentView)
            make.size.greaterThanOrEqualTo(0)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.centerX.equalTo(persentView)
            make.top.equalTo(scoreLabel.snp.bottom).offset(5.ckValue())
            make.size.greaterThanOrEqualTo(0)
        }
         
        promoteLabel.snp.makeConstraints { make in
            make.leading.equalTo(16.ckValue())
            make.bottom.equalToSuperview().inset(10.ckValue())
            make.size.equalTo(promoteLabel.size)
        }
        
        switchButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(5.ckValue())
            make.size.equalTo(30.ckValue())
            make.top.equalToSuperview().offset(5.ckValue())
        }
        
        shareButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(5.ckValue())
            make.size.equalTo(40.ckValue())
            make.centerY.equalTo(promoteLabel)
        }
    }
    
    private func preSetupHandleBuness() {
        
    }
    
    var score: Double = -1
    
    var status = PassHealthStatus.tooBad
    
    public func updateData(safe: Double, easy: Double, duplicate: Double) {
        
        let isAllSafe = safe > 0 && easy == 0 && duplicate == 0
        let isAllEasy = safe == 0 && easy > 0 && duplicate == 0
        let isAllDuplicate = safe == 0 && easy == 0 && duplicate > 0
                
        var score = 0.0
        if safe + easy + duplicate > 0 {
            score = safe / (safe + easy + duplicate) * 100
        }
        
        var status: PassHealthStatus = .tooBad
        
        if score == 100 {
            status = .bestOfBest
        }else if score >= 80 {
            status = .excellent
        } else if (score < 80 && score >= 60) {
            status = .justPassed
        } else {
            status = .tooBad
        }
                
        if self.isReload { return }
        self.isReload = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isReload = false
        }
        
        if isAllSafe || isAllEasy || isAllDuplicate || status != self.status || status == .tooBad {
            persentView.removeSpeedAnimation()
            persentView.startSpeedAnimation(status)
        }
        
        self.score = score
        self.status = status
        
        let statusColor = UIColor(cgColor: status.gradColors().first!)
        let statusTitle = status.statusTitle()
        
        statusLabel.text = statusTitle
        statusLabel.textColor = statusColor
        scoreLabel.textColor = statusColor
        scoreLabel.attributedText = self.scoreAttbuteStr(title: String(format: "%.f", score), color: scoreLabel.textColor, font: scoreLabel.font)
        
                
        chartView.isHidden = !switchButton.isSelected
        persentView.isHidden = switchButton.isSelected
        statusLabel.isHidden = switchButton.isSelected
        scoreLabel.isHidden = switchButton.isSelected
        
        let dataEntries: [PieChartDataEntry] = [
            PieChartDataEntry(value: safe, label: PassHealthRick.securety.formatStr()),
            PieChartDataEntry(value: easy, label: PassHealthRick.easyGuess.formatStr()),
            PieChartDataEntry(value: duplicate, label: PassHealthRick.duplicate.formatStr())
        ]

        let dataSet = PieChartDataSet(entries: dataEntries, label: "")
        dataSet.colors = [PassHealthRick.securety.healthColor(), PassHealthRick.easyGuess.healthColor(), PassHealthRick.duplicate.healthColor()]
        dataSet.valueFont = UIFontBold(12.ckValue())
        dataSet.valueTextColor = UIColor.white
        
        self.safeCount = Int(safe)
        self.easyCount = Int(easy)
        self.duplicateCount = Int(duplicate)
        
        dataSet.valueFormatter = CustomValueFormatter()
        
        self.chartView.data = PieChartData(dataSet: dataSet)
    }
    
    // MARK: 🌹 GET && SET 🌹
    
    weak var delegate: PasswordHealthViewDelegate?
    
    private (set) var safeCount: Int = 0
    private (set) var easyCount: Int = 0
    private (set) var duplicateCount: Int = 0
    
    
    var isReload: Bool = false
    
    // MARK: 🌹 Lazy init 🌹
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15.ckValue()
        view.backgroundColor = appMainColor
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let title = "Password Health".localStr()
        let font = UIFontBold(12.ckValue())
        
        let view = UILabel(frame: CGRectMake(0, 0, title.width(font) + 15.ckValue(), font.lineHeight + 6.ckValue()))
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor.systemGreen
        view.text = title
        view.font = font
        view.textAlignment = .center
        view.textColor = UIColor.white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 3.ckValue()
        return view
    }()
    
    lazy var chartView: PieChartView = {
        
        let view = PieChartView()
        
        return view
    }()
    
    lazy var persentView: HealthPersentView = {
        let height = kaka_IsiPad() ? 360.0 : 170.ckValue()
        let view = HealthPersentView(frame: CGRect(x: 0, y: 0, width: height, height: height))
        return view
    }()
    
    lazy var statusLabel: UILabel = {
        let view = UILabel()
        view.font = UIFontBold(15.ckValue())
        view.text = PassHealthStatus.tooBad.statusTitle()
        view.textColor = UIColor.white
        view.textAlignment = .center
        return view
    }()
    
    
    lazy var scoreLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.boldSystemFont(ofSize: 48.ckValue())
        view.text = "100"
        view.textColor = UIColor.red
        view.textAlignment = PhoneSetManager.isArabicLanguage() ? .right : .left
        return view
    }()
    
    lazy var shareButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(Reasource.systemNamed("square.and.arrow.up", color: .white), for: .normal)
        view.addTarget(self, action: #selector(shareButtonClick), for: .touchUpInside)
        return view
    }()
    
    lazy var switchButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(Reasource.named("chart_bing"), for: .normal)
        view.setImage(Reasource.named("chart_huan"), for: .selected)
        view.addTarget(self, action: #selector(switchButtonClick(_:)), for: .touchUpInside)
        return view
    }()
    
    lazy var promoteLabel: UILabel = {
        let title = "GUIDE".localStr().uppercased()
        let font = UIFontBold(12.ckValue())
        
        let view = UILabel(frame: CGRectMake(0, 0, title.width(font) + 15.ckValue(), font.lineHeight + 6.ckValue()))
        view.isUserInteractionEnabled = true
        view.attributedText = NSAttributedString(string: title, attributes: [.font: font, .foregroundColor: UIColor.white, .underlineStyle: 1])
        
        let guideTap = UITapGestureRecognizer(target: self, action: #selector(guideLevelClick))
        view.addGestureRecognizer(guideTap)
        return view
    }()
    
}

