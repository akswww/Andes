import UIKit
import AVFoundation
import Vision

class PhoteViewController: UIViewController {
    
    let captureSession = AVCaptureSession()
    let photoOutput = AVCapturePhotoOutput()
    
    let manager = NetworkManager()
    struct PhoteRequest: Codable {
        var name: String
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
        
        // 確保有正確的影像資料
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else { return }
        
        // 透過 Vision 偵測臉部，裁切圖片
        cropFaceFromImage(image) { [self] croppedImage in
            guard let croppedImage = croppedImage else { return }
            
            // 壓縮圖片為 JPEG 格式
            guard let resizedImageData = croppedImage.jpegData(compressionQuality: 1) else { return }
            let base64String = resizedImageData.base64EncodedString()
            
            // 打印 Base64 編碼的圖片字串
            print(base64String)
            
            let request: PhoteRequest = PhoteRequest(name: "admit1", image: base64String)
            UserPreferences.shared.photebinary = base64String
            
            Task {
                do {
                    // 發送請求到伺服器
                    let result: BaseReponse = try await manager.requestData(method: .post, path: .UserInfo, parameters: request)
                    print(result)
                    self.dismiss(animated: true)
                } catch {
                    print("Error sending request:", error)
                }
            }
        }
    }
    
    /// 使用 Vision 框住臉部並裁切圖片
    private func cropFaceFromImage(_ image: UIImage, completion: @escaping (UIImage?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }
        
        let request = VNDetectFaceRectanglesRequest { request, error in
            guard error == nil else {
                print("臉部偵測錯誤: \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            // 確保有偵測到臉部
            guard let results = request.results as? [VNFaceObservation], let firstFace = results.first else {
                print("未檢測到臉部")
                completion(nil)
                return
            }
            
            // 取得臉部的 bounding box
            let boundingBox = firstFace.boundingBox
            
            // 將 bounding box 轉換為圖片的實際尺寸
            let imageWidth = CGFloat(cgImage.width)
            let imageHeight = CGFloat(cgImage.height)
            
            let cropRect = CGRect(
                x: boundingBox.origin.x * imageWidth,
                y: (1 - boundingBox.origin.y - boundingBox.size.height) * imageHeight,
                width: boundingBox.size.width * imageWidth,
                height: boundingBox.size.height * imageHeight
            )
            
            // 切割圖片
            if let croppedCgImage = cgImage.cropping(to: cropRect) {
                let croppedImage = UIImage(cgImage: croppedCgImage, scale: image.scale, orientation: image.imageOrientation)
                completion(croppedImage)
            } else {
                completion(nil)
            }
        }
        
        // 使用 Vision 處理圖片
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("處理圖片時發生錯誤: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}


