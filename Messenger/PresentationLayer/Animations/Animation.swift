//
//  Animation.swift
//  Messenger
//
//  Created by Bogdan Belogurov on 02/12/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

import Foundation

class LogoEmitter {
    
    var superView: UIView
    var emitter = CAEmitterLayer()
    
    init(superView: UIView) {
        self.superView = superView
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture))
        panGesture.maximumNumberOfTouches = 1
        panGesture.minimumNumberOfTouches = 1
        self.superView.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            let point = sender.translation(in: self.superView)
            self.setupLayer(point: point, parentView: self.superView)
        case .changed:
            let point = sender.location(in: self.superView)
            self.changePosition(point: point)
        default:
            self.emitter.removeFromSuperlayer()
        }
    }
    
    func changePosition(point: CGPoint) {
        emitter.emitterPosition = point
    }
    
    func setupLayer(point: CGPoint, parentView: UIView) {
        emitter.frame = CGRect(x: point.x, y: point.y, width: 20, height: 20)
        parentView.layer.addSublayer(emitter)
        emitter.emitterShape = CAEmitterLayerEmitterShape.point
        emitter.emitterSize = emitter.frame.size
        
        let emitterCell = CAEmitterCell()
        emitterCell.contents = UIImage(named: "tinkoff")?.cgImage
        emitterCell.lifetime = 20
        emitterCell.redRange = 0.5
        emitterCell.greenRange = 0.5
        emitterCell.blueRange = 0.5
        emitterCell.lifetime = 1
        emitterCell.birthRate = 50
        emitterCell.velocity = 250
        emitterCell.velocityRange = 0.3
        emitterCell.scale = 0.1
        emitterCell.scaleRange = 0.5
        emitterCell.velocityRange = 100
        emitterCell.emissionRange = .pi * 2
        emitter.emitterCells = [emitterCell]
    }
}
