//
//  ScanScanViewController.swift
//  BTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import QRCodeReader
import SharedUIModule
import UIKit

class ScanViewController: UIViewController {
    var output: ScanViewOutput!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: ImageButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cameraView: CameraView!
    lazy var reader: QRCodeReader = {
        let reader = QRCodeReader()
        reader.stopScanningWhenCodeIsFound = true
        return reader
    }()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        output.viewIsReady()
    }
    
    // MARK: Config
    
    private func config() {
        configBackground()
        configColors()
        configFonts()
        configLocalization()
        configButton()
        configCameraView()
    }
    
    private func configBackground() {
        view.backgroundColor = R.color.light()
    }
    
    private func configFonts() {
        titleLabel.font = R.font.poppinsRegular(size: 22)
    }
    
    private func configColors() {
        titleLabel.textColor = R.color.dark()
        backButton.style = .withoutBackground
        backButton.colorAdditionalBackground = R.color.gray1()
    }
    
    private func configButton() {
        backButton.image = R.image.cancel()
        backButton.touchUpInside = { [weak self] _ in
            self?.output.actionBack()
        }
    }
    
    private func configLocalization() {
        titleLabel.text = R.string.localization.qrcodeScreenTitle()
    }
    
    private func configCameraView() {
        guard checkScanPermissions() else {
            return
        }
        cameraView.setupComponents(showCancelButton: false,
                                   showSwitchCameraButton: false,
                                   showTorchButton: false,
                                   showOverlayView: true,
                                   reader: reader)
        
        reader.didFindCode = { [weak self] result in
            self?.reader.stopScanning()
            self?.output.actionScan(string: result.value)
        }
        
        reader.startScanning()
    }
    
    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch {
            output.cameraPermissionsDenied()
            return false
        }
    }
}

// MARK: - ScanViewInput

extension ScanViewController: ScanViewInput {
    func setupInitialState() {
      }
    
    func startScanning() {
        reader.startScanning()
    }
    
    func stopScanning() {
        reader.stopScanning()
    }
}
