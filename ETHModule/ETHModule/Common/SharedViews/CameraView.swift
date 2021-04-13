//
//  CameraView.swift
//  ETHModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import Foundation
import QRCodeReader
import SnapKit

class CameraView: UIView, QRCodeReaderDisplayable {
    public lazy var overlayView: UIView? = {
        let overlay = CustomOverlay()
        
        overlay.backgroundColor                           = .clear
        overlay.clipsToBounds = true
        overlay.translatesAutoresizingMaskIntoConstraints = false
        
        return overlay
    }()
    
    public let cameraView: UIView = {
        let cameraView = UIView()
        
        cameraView.clipsToBounds = true
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        
        return cameraView
    }()
    
    public lazy var cancelButton: UIButton? = {
        let cancelButton = UIButton()
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitleColor(.gray, for: .highlighted)
        
        return cancelButton
    }()
    
    public lazy var switchCameraButton: UIButton? = {
        let scb = SwitchCameraButton()
        
        scb.translatesAutoresizingMaskIntoConstraints = false
        
        return scb
    }()
    
    public lazy var toggleTorchButton: UIButton? = {
        let ttb = ToggleTorchButton()
        
        ttb.translatesAutoresizingMaskIntoConstraints = false
        
        return ttb
    }()
    
    private var reader: QRCodeReader?
    
    public func setupComponents(showCancelButton: Bool, showSwitchCameraButton: Bool,
                                showTorchButton: Bool, showOverlayView: Bool, reader: QRCodeReader?) {
        self.reader = reader
        
        addComponents()
        
        cancelButton?.isHidden = !showCancelButton
        switchCameraButton?.isHidden = !showSwitchCameraButton
        toggleTorchButton?.isHidden = !showTorchButton
        overlayView?.isHidden = !showOverlayView
        
        cameraView.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
        }
        
        if  let overlayView = overlayView {
            overlayView.snp.makeConstraints { make in
                make.left.equalTo(self.snp.left)
                make.right.equalTo(self.snp.right)
                make.top.equalTo(self.snp.top)
                make.bottom.equalTo(self.snp.bottom)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        reader?.previewLayer.frame = bounds
    }
    
    // MARK: - Convenience Methods
    
    private func addComponents() {
        addSubview(cameraView)
        
        if let overlay = overlayView {
            addSubview(overlay)
        }
        
        if let switchButton = switchCameraButton {
            addSubview(switchButton)
        }
        
        if let ttb = toggleTorchButton {
            addSubview(ttb)
        }
        
        if let cancel = cancelButton {
            addSubview(cancel)
        }
        
        if let reader = reader {
            cameraView.layer.insertSublayer(reader.previewLayer, at: 0)
        }
    }
}
