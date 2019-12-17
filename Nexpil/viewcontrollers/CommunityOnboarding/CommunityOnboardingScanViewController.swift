//
//  CommunityOnboardingScanViewController.swift
//  Nexpil
//
//  Created by mac on 6/30/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import AVKit

class CommunityOnboardingScanViewController: UIViewController {
    
    var lastSampleTaken = Date()
    var timer: Timer!
    let session = AVCaptureSession()
    let dataOutput = AVCaptureVideoDataOutput()
    var visualEffectView:VisualEffectView?
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addManually(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "CommunityOnboardingManualCodeViewController") as! CommunityOnboardingManualCodeViewController
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let inputDevice = AVCaptureDevice.default(for: .video) else {
            fatalError("No camera found.")
        }
        guard let input = try? AVCaptureDeviceInput(device: inputDevice) else {
            fatalError("Can't get camera input.")
        }

        session.addInput(input)
        session.startRunning()

        let preview = AVCaptureVideoPreviewLayer(session: session)
        preview.frame = self.view.bounds
        preview.videoGravity = AVLayerVideoGravity.resizeAspectFill

        view.layer.insertSublayer(preview, at: 0)

        session.addOutput(dataOutput)
        session.sessionPreset = AVCaptureSession.Preset.photo

        let sampleBufferQueue = DispatchQueue(label: "sampleBufferQueue")

        dataOutput.alwaysDiscardsLateVideoFrames = true
        dataOutput.setSampleBufferDelegate(self, queue: sampleBufferQueue)
        
        visualEffectView = self.view.backgroundBlur(view: self.view)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if DataUtils.getCameraStatus() == true
        {
            self.dismiss(animated: false, completion: nil)
            DataUtils.setCameraStatus(name: false)
            return
        }
        timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: false, block: { (timer) in
            self.session.stopRunning()
//            if self.finder.drug != nil {
//                self.prescription = self.finder.getPrescription()
//                self.performSegue(withIdentifier: "summarySegue", sender: self)
//            }
//            else {
//                print("notComplete")
//            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "summarySegue" {
            timer.invalidate()
            URLSession.shared.finishTasksAndInvalidate()
            let vc = segue.destination as! SummaryScreenViewController
//            vc.prescription = prescription!
        }
    }
}

extension CommunityOnboardingScanViewController : AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if lastSampleTaken.timeIntervalSinceNow < -0.75 {
            
            let imageBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
            let ciimage : CIImage = CIImage(cvPixelBuffer: imageBuffer)
            let context:CIContext = CIContext.init(options: nil)
            let cgImage:CGImage = context.createCGImage(ciimage, from: ciimage.extent)!
            let uiimage = UIImage(cgImage: cgImage)
            let data = UIImageJPEGRepresentation(uiimage, 0.10)!
            
            
            lastSampleTaken = Date()
            let image = Image(fromContent: data.base64EncodedString())
            
//            let requests = AnnotateImageRequest(image: image, features: features, context: nil)
//            let request = Request(requests: [requests])
//            request.perform { response in
//                guard let texts = response.responses.first!.fullTextAnnotation else { return }
//                let page = texts.pages[0]
//                for i in 0..<page.blocks.count {
//                    print("Block: \(i)")
//                    for j in 0..<page.blocks[i].paragraphs.count {
//                        print("Paragraph: \(j)")
//                        print(page.blocks[i].paragraphs[j].text)
//                    }
//                }
//                self.finder.delegate = self
//                self.finder.userName = "Patient Test"
//                self.finder.addResponse(response)
//            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillDisappear(animated)
    }
}
