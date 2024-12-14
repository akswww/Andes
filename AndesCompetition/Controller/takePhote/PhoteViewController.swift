import UIKit
import AVFoundation

class PhoteViewController: UIViewController {
    
    let captureSession = AVCaptureSession()
    let photoOutput = AVCapturePhotoOutput()
    
    let manager = NetworkManager()
    struct PhoteRequest: Codable {
        var image: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }
    
    private func setupCamera() {
        // 檢查相機權限
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            if granted {
                DispatchQueue.main.async {
                    self?.configureCameraSession()
                }
            }
        }
    }
    
    private func configureCameraSession() {
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video,position: .front) else { return }
        
        do {
            // 創建輸入
            let input = try AVCaptureDeviceInput(device: device)
            captureSession.addInput(input)
            
            // 創建輸出
            captureSession.addOutput(photoOutput)
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = view.bounds
            view.layer.addSublayer(previewLayer)
            
            // 創建拍照按鈕
            let button = UIButton(frame: CGRect(x: view.frame.midX - 50,
                                              y: view.frame.maxY - 130,
                                              width: 80,
                                              height: 80))
            button.backgroundColor = .white
            button.layer.cornerRadius = 40
            let lineLayer = CAShapeLayer()
            let outerPath = UIBezierPath(ovalIn: button.bounds) // 外圈路径
            let insetRect = button.bounds.insetBy(dx: 10, dy: 10) // 内圈路径偏移
            let innerPath = UIBezierPath(ovalIn: insetRect) // 内圈路径

            outerPath.append(innerPath.reversing()) // 创建镂空效果
            lineLayer.path = outerPath.cgPath
            lineLayer.fillRule = .evenOdd
            lineLayer.fillColor = UIColor.clear.cgColor // 无需填充
            lineLayer.strokeColor = UIColor.black.cgColor // 分隔线颜色
            lineLayer.lineWidth = 2 // 分隔线宽度

            button.layer.addSublayer(lineLayer) // 添加到按钮的层
            button.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
            view.addSubview(button)
            
            // 開始捕捉
            DispatchQueue.global().async {
                self.captureSession.startRunning()
            }
           
            
        } catch {
            print("相機設置錯誤：\(error.localizedDescription)")
        }
    }
    
    @objc private func takePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}

extension PhoteViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                    didFinishProcessingPhoto photo: AVCapturePhoto,
                    error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else { return }
        
       
        
//        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
//        image.draw(in: CGRect(origin: .zero, size: targetSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let resizedImageData = resizedImage?.jpegData(compressionQuality: 1) else { return }
        let base64String = resizedImageData.base64EncodedString()
        print(base64String)
        let request: PhoteRequest = PhoteRequest(image: base64String)
        UserPreferences.shared.photebinary = base64String
        dismiss(animated: true)
        Task {
            let result: BaseReponse = try await manager.requestData(method: .post, path: .UserInfo, parameters: request)
            print(result)
            
        }
    }

}


