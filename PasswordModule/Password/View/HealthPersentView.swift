//
//  HealthPersentView.swift
//  PassLock
//
//  Created by Melo on 2024/5/30.
//

import KakaFoundation

class HealthPersentView: UIView {
    
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
        
        let backPath = UIBezierPath(arcCenter: CGPoint(x: self.width / 2, y: self.height / 2), radius: (self.width - lineWidth * 1) / 2, startAngle: Double.pi * (230 / 360), endAngle: Double.pi * (130 / 360), clockwise: true)
        backPath.lineWidth = lineWidth
        backPath.lineCapStyle = .square
        UIColor.clear.setStroke()
        backPath.stroke()
        
        let shaperLayer = CAShapeLayer()
        shaperLayer.path = backPath.cgPath
        shaperLayer.lineWidth = lineWidth
        shaperLayer.strokeColor = UIColor.rgb(80, 86, 127).cgColor
        shaperLayer.fillColor = UIColor.clear.cgColor
        shaperLayer.strokeStart = 0
        shaperLayer.strokeEnd = 1
        shaperLayer.lineCap = .round
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 1
        animation.fromValue = 0
        animation.toValue = 1
        shaperLayer.add(animation, forKey: "ellip_path")
        
        self.layer.addSublayer(shaperLayer)
    }
    
    private func preSetupContains() {
        
    }
    
    private func preSetupHandleBuness() {
        
    }
    
    // MARK: 🌹 GET && SET 🌹
    let lineWidth = 20.ckValue()
    
    var status: PassHealthStatus = .tooBad
    
    // MARK: 🌹 Lazy init 🌹
    
    func startSpeedAnimation(_ status: PassHealthStatus) {
        self.status = status
        let tempView = self.tempAnimationView()
        self.addSubview(tempView)
        tempView.layer.mask = self.addShapLayer(tempView, status: status)
    }
    
    func removeSpeedAnimation() {
        var lastView = self.viewWithTag(9528)
        lastView?.layer.removeAllSublayers()
        lastView?.removeFromSuperview()
        lastView = nil
        
    }
    
    func tempAnimationView() -> UIView {
        let view = UIView(frame: self.bounds)
        view.tag = 9528
        view.autoresizingMask = UIView.AutoresizingMask.flexibleTopMargin
        return view
    }
    
    func addShapLayer(_ tempView: UIView, status: PassHealthStatus) -> CAShapeLayer {
        let gradientLayerRight = CAGradientLayer()
        gradientLayerRight.frame = tempView.bounds
        gradientLayerRight.colors = status.gradColors()
        gradientLayerRight.locations = [0, 1]
        gradientLayerRight.startPoint = CGPointMake(0, 0)
        gradientLayerRight.endPoint = CGPointMake(0, 1)
        tempView.layer.addSublayer(gradientLayerRight)
        
        let backPath = UIBezierPath(arcCenter: CGPoint(x: tempView.width / 2, y: tempView.height / 2), radius: (tempView.width - lineWidth * 1) / 2, startAngle: Double.pi * (230 / 360), endAngle: Double.pi * (130 / 360), clockwise: true)
        backPath.lineWidth = lineWidth
        backPath.lineCapStyle = .square
        UIColor.clear.setStroke()
        backPath.stroke()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = backPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.lineWidth = lineWidth
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 1
        animation.fromValue = 0
        animation.toValue = 1
        shapeLayer.add(animation, forKey: "ellip_path")
                
        return shapeLayer
    }
    
}
