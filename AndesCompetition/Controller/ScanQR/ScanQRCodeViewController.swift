//
//  ScanQRCodeViewController.swift
//  Smart Healthcare App
//
//  Created by Gary on 2023/6/8.
//

import UIKit
import AVFoundation
import ProgressHUD
import CryptoSwift

class ScanQRCodeViewController: BaseViewController {
    // MARK: - IBOutlet
    
    @IBOutlet weak var cameraFrame: UIView?
    
    // MARK: - Variables
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var scanQRcodePath = UIBezierPath()
    var blackBackgroundView = UIView()
    var lineView = UIView()
    let manager = NetworkManager()
    var patientID: PatientID? = nil
    
    struct PatientID: Decodable {
        var number: String
        var id: String
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraPrivacy()
        setup()
    }
    
    // MARK: - Setup
    
    func setup() {
        self.title = "Scan QR Code"
    }
    
    func presentCamera() {
        // 取得後置鏡頭來擷取影片
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                                      mediaType: AVMediaType.video,
                                                                      position: .back)
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("後置鏡頭取得失敗")
            return
        }
        
        do {
            // 使用前一個裝置物件 captureDevice 來取得 AVCaptureDeviceInput 類別的實例
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // 實例化 AVCaptureSession，設定 captureSession 的輸入裝置
            captureSession.addInput(input)
            
            // 實例化 AVCaptureMetadataOutput 物件並將其設定做為 captureSession 的輸出
            let captureMataDataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMataDataOutput)
            
            // 設置 delegate 為 self，並使用預設的調度佇列來執行 Call back
            // 當一個新的元資料被擷取時，便會將其轉交給委派物件做進一步處理
            // 依照 Apple 的文件，我們這邊使用 DispatchQueue.main 來取得預設的主佇列
            captureMataDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // 告訴 App 我們所想要處理 metadata 的對象對象類型
            captureMataDataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            // 設定限制的掃描範圍
            scanQRCodeRectOfInterest()
            captureMataDataOutput.rectOfInterest = CGRect(x: scanQRcodePath.bounds.minY / view.frame.height,
                                                   y: scanQRcodePath.bounds.minX / view.frame.width,
                                                   width: scanQRcodePath.bounds.height / view.frame.height,
                                                   height: scanQRcodePath.bounds.width / view.frame.width)
            // 顯示遮罩畫面
            DispatchQueue.main.async {
                self.scanQRCodeBlackView()
            }
            
            // 用於顯示我們的相機畫面
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            
            // 設置影片在 videoPreivewLayer 的顯示方式
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resize
            videoPreviewLayer?.frame = cameraFrame!.bounds
            cameraFrame!.layer.addSublayer(videoPreviewLayer!)
            
            // 開始擷取畫面
            DispatchQueue.global().async {
                self.captureSession.startRunning()
            }
            
        } catch {
            // 假如有錯誤發生、印出錯誤描述並且 return
            print(error.localizedDescription)
            return
        }
    }
    
    func scanQRCodeRectOfInterest() {
        let width = view.frame.width / 2
        let newX = view.frame.width / 2 - (width / 2)
        let newY = view.frame.height / 2 - (width / 1)
        let tempPath = UIBezierPath(roundedRect: CGRect(x: newX, y: newY, width: width, height: width),
                                    cornerRadius: width / 10)
        scanQRcodePath = tempPath
    }
    
    func scanQRCodeBlackView() {
        blackBackgroundView = UIView(frame: UIScreen.main.bounds)
        blackBackgroundView.backgroundColor = UIColor.black
        blackBackgroundView.alpha = 0.6
        blackBackgroundView.layer.mask = addTransparencyView(tempPath: scanQRcodePath) // 只有遮罩層覆蓋的地方才會顯示出來
        blackBackgroundView.layer.name = "blackBackgroundView"
        cameraFrame!.addSubview(blackBackgroundView)
    }
    
    func addTransparencyView(tempPath: UIBezierPath) -> CAShapeLayer {
        let path = UIBezierPath(rect: UIScreen.main.bounds)
        path.append(tempPath)
        path.usesEvenOddFillRule = true
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.black.cgColor // 其他顏色都可以，只要不是透明的
        shapeLayer.fillRule = .evenOdd
        
        return shapeLayer
    }
    
    // MARK: - Camera Privacy
    
    func cameraPrivacy() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        //已授權
        case .authorized:
            print("相機權限已給予")
            presentCamera()
        // 拒絕
        case .denied, .restricted :
            showCameraPrivacyDeniedAlert()
        // 沒有定義
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                guard success == true else {
                    showCameraPrivacyDeniedAlert()
                    return
                }
                DispatchQueue.main.async {
                    self.presentCamera()
                }
                
            }
        @unknown default:
            print("相機權限未知錯誤")
        }
        
        func showCameraPrivacyDeniedAlert() {
            Alert.showAlert(title: "相機權限啟用失敗", message: "相機服務為請用", vc: self, confirmTitle: "前往設定", cancelTitle: "取消") {
                // 開啟設定 -> 相機權限
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl) { _ in }
                }
            } cancelAction: {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
//    func loadJson(filename fileName: Data) {
//        do {
//            let decoder = JSONDecoder()
//            let jsonData: PatientID = try decoder.decode(PatientID.self, from: fileName)
//
//            patientID = jsonData
//            print(patientID?.id)
//        } catch {
//            print("error:\(error)")
//        }
//    }
    
    // MARK: - IBAction
    

}

extension ScanQRCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        self.captureSession.stopRunning()
        if let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
            if metadataObj.type == AVMetadataObject.ObjectType.qr {
                print(metadataObj.stringValue!)
            }
        }
    }
}

