//
//  UIView+LoadingIndicator.swift
//  MadridParkings
//
//  Created by Rafael Gil Pastor on 22/8/17.
//  Copyright © 2017 Rafael Gil. All rights reserved.
//

import Foundation
import UIKit

extension UIView: LoadingIndicatorProtocol {
 
    fileprivate var loadingIndicator: UIActivityIndicatorView {
        
        let indicator = UIActivityIndicatorView(frame: .zero)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .whiteLarge
        indicator.color = UIColor.purple
        indicator.tag = ViewLoadingIndicatorProtocolConstants.loadingIndicatorTag
        return indicator
    }

    @objc public func showLoadingIndicator() {
        
        removeCurrentCanvasView(withAnimation: false)
        let newCanvas = createLoadingIndicatorCanvas()
        let newIndicator = loadingIndicator
        paintLoadingIndicator(indicator: newIndicator, onCanvas: newCanvas)
        showCanvas(canvasView: newCanvas)
        newIndicator.startAnimating()
    }
    
    @objc public func hideLoadingIndicator() {
        
        if let currentIndicator = self.viewWithTag(ViewLoadingIndicatorProtocolConstants.loadingIndicatorTag) as?  UIActivityIndicatorView {
            currentIndicator.stopAnimating()
        }
        removeCurrentCanvasView(withAnimation: true)
    }
}

fileprivate extension UIView {
    
    func createLoadingIndicatorCanvas() -> UIView {
        let canvasView = UIView()
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        canvasView.backgroundColor = UIColor.white
        canvasView.isUserInteractionEnabled = false
        canvasView.tag = ViewLoadingIndicatorProtocolConstants.canvasViewTag
        return canvasView
    }
    
    func removeCurrentCanvasView(withAnimation animation: Bool) {
        let canvasView = self.viewWithTag(ViewLoadingIndicatorProtocolConstants.canvasViewTag)
        UIView.animate(withDuration: animation ? 0.3 : 0.0, animations: {
            canvasView?.alpha = 0
        }) { (finished) in
            canvasView?.removeFromSuperview()
        }
    }
    
    func paintLoadingIndicator(indicator: UIActivityIndicatorView, onCanvas canvas: UIView) {
        canvas.addSubview(indicator)
        indicator.centerYAnchor.constraint(equalTo: canvas.centerYAnchor).isActive = true
        indicator.centerXAnchor.constraint(equalTo: canvas.centerXAnchor).isActive = true
    }
    
    func showCanvas(canvasView canvas: UIView) {
        
        self.addSubview(canvas)
        
        canvas.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        canvas.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        canvas.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        canvas.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        self.bringSubviewToFront(canvas)
    }
}

fileprivate struct ViewLoadingIndicatorProtocolConstants {
    
    static let loadingIndicatorTag: Int = 9998
    static let canvasViewTag: Int = 9999
}
