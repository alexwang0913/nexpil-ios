//
//  SiriMedicationViewController.swift
//  Nexpil
//
//  Created by Admin on 5/18/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

import SkyFloatingLabelTextField

import Speech
import Alamofire

class SiriMedicationViewController: InformationCardEditViewController, SFSpeechRecognizerDelegate,UITextViewDelegate {
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var threedotsView: UIView!
    @IBOutlet weak var nextbutton: NPButton!
    @IBOutlet weak var upperViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textView: UIView!
    
    @IBOutlet weak var enteredText: UITextView!
    
    @IBOutlet weak var showHideButton: UIButton!
    
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var labelmsg: UILabel!    
    @IBOutlet weak var errorTextView: UITextView!
    @IBOutlet weak var micView: GradientView!
    @IBOutlet weak var errorBottomView: GradientView!
    @IBOutlet weak var errorBottomTextView: UITextView!
    @IBOutlet weak var errorImageView: UIImageView!
    @IBOutlet weak var micViewTopMargin: NSLayoutConstraint!
    @IBOutlet weak var doneButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondDButtonBottomConstraint: NSLayoutConstraint!
    
    let screensize = UIScreen.main.bounds.size
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
//    var timer = Timer()
    var isButtonEnabled = false
    var waveAnimationObject:PXSiriWave = PXSiriWave()
    var isError = true
    var asNeeded = 0
    var failCount = 0
    var frequency = ""
    var amount = ""
    var timings = ""
    var quantity = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        upperViewHeight.constant = (screensize.width * 72.53) / 100
        threedotsView.aj_showDotLoadingIndicator()
        threedotsView.isHidden = true
        secondButton.layer.cornerRadius = 20
        enteredText.delegate = self
        enteredText.autocorrectionType = .no
        textView.addShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), alpha: 0.16, x: 0, y: 3, blur: 6.0)
        textView.layer.cornerRadius = 20
        enteredText.text = "Take..."
        enteredText.textColor = UIColor.lightGray
        
        let screenSize = UIScreen.main.bounds.size
        waveAnimationObject.frame = CGRect(x: (screenSize.width/2)/2, y: 0, width: (screenSize.width/2), height: 150)
        waveAnimationObject.backgroundColor = UIColor.clear
        waveAnimationObject.frequency = 1.5
        waveAnimationObject.amplitude = 1.0
        waveAnimationObject.intensity = 0.3
        waveAnimationObject.colors = [UIColor.init(hex: "#4939E3"),UIColor.init(hex: "#3BBFE3"),UIColor.init(hex: "#397EE3")]
        waveAnimationObject.configure()

        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.targetMethod(_:)), userInfo: waveAnimationObject, repeats: true)
        
        self.hideKeyboardWhenTappedAround()
        speechRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            switch authStatus {
            case .authorized:
                self.isButtonEnabled = true
                
            case .denied:
                self.isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                self.isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                self.isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }

        }
        visualEffectView = self.view.backgroundBlur(view: self.view)
        
//        let attributedString = NSMutableAttributedString(string: errorBottomTextView.text!)
//        let mutableParagraphStyle = NSMutableParagraphStyle()
//        mutableParagraphStyle.lineSpacing = CGFloat(25)
//
//        if let stringLength = errorBottomTextView.text?.characters.count {
//            attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: mutableParagraphStyle, range: NSMakeRange(0, stringLength))
//        }
//
//        errorBottomTextView.attributedText = attributedString
//        errorBottomTextView.font = UIFont(name: errorBottomTextView.font?.fontName ?? "", size: 15)
//        errorBottomTextView.textAlignment = .center
        
        errorTextView.isHidden = true
        errorBottomView.isHidden = true
        errorImageView.isHidden = true
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 12
        let attributes = [NSAttributedStringKey.paragraphStyle: style]
        errorTextView.attributedText = NSAttributedString(string: "Looks like your medication instructions were not entered correctly, let's try that again.", attributes: attributes)
        errorTextView.textAlignment = .center
        errorTextView.textColor = UIColor(hex: "E34939")
        errorTextView.font = UIFont(name: "Montserrat-Regular", size: 15)
        
        micViewTopMargin.constant = 15
        
        originalHeight = doneButtonBottomConstraint.constant
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func showHideAction(_ sender: UIButton) {
//        self.audioEngine.stop()
//        self.recognitionRequest?.endAudio()
//        self.audioEngine.inputNode.removeTap(onBus: 0)
        
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(self.hideTextView))
        self.textView.addGestureRecognizer(gesture1)
        self.enteredText.isUserInteractionEnabled = false
//        self.showHideButton.isHidden = true
        threedotsView.isHidden = false
        
        startRecording1()
        upperViewHeight.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func hideTextView(gesture: UIGestureRecognizer)
    {
        self.audioEngine.stop()
        self.recognitionRequest?.endAudio()
        self.showHideButton.isHidden = false
        threedotsView.isHidden = true
        self.enteredText.isUserInteractionEnabled = true
        let array = self.textView!.gestureRecognizers
        for recognizer in array! {
            self.textView.removeGestureRecognizer(recognizer)
        }

        if self.enteredText.text == "Take..." || self.enteredText.text == ""
        {
            self.enteredText.text = "Take..."
            self.textViewHeight.constant = 64.0
            self.enteredText.textColor = UIColor.lightGray
            secondButton.isHidden = false
        }
        else
        {
            secondButton.isHidden = true
        }
        upperViewHeight.constant = (screensize.width * 72.53) / 100
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    @objc func targetMethod(_ timer: Timer?) {
        let siriWave = timer?.userInfo as? PXSiriWave
        
        siriWave?.update(withLevel: _normalizedPowerLevel(fromDecibels: 0.1))
    }
    
    func _normalizedPowerLevel(fromDecibels decibels: CGFloat) -> CGFloat {
        if decibels < -60.0 || decibels == 0.0 {
            return 0.0
        }
        
        return CGFloat(powf((powf(10.0, Float(0.05 * decibels)) - powf(10.0, 0.05 * -60.0)) * (1.0 / (1.0 - powf(10.0, 0.05 * -60.0))), 1.0 / 2.0))
    }
    
    @objc func gotoBack(sender : UITapGestureRecognizer) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = appDelegate.pageViewController!.pageControl.currentPage - 1
        appDelegate.pageViewController?.gotoPage()
    }
    
    @objc func gotoNext1(sender : UITapGestureRecognizer) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = appDelegate.pageViewController!.pageControl.currentPage + 1//3
        appDelegate.pageViewController?.gotoPage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        let medicationname = DataUtils.getMedicationName()!
        labelmsg.text = "How do you take your " + medicationname + "?"
        if DataUtils.getMedicationFrequency()?.isEmpty == false
        {
            //self.ctfHowTo.textView.text = DataUtils.getMedicationFrequency()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc override func keyboardWillShow(_ notification: Notification)
    {
        keyboardHeight = (notification.userInfo?["UIKeyboardBoundsUserInfoKey"] as! CGRect).height
        upperViewHeight.constant = 0
        doneButtonBottomConstraint.constant = originalHeight! + self.keyboardHeight!
        secondDButtonBottomConstraint.constant = originalHeight! + self.keyboardHeight!
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
//        micView.isHidden = true
    }
    
    @objc override func keyboardWillHide(_ notification:Notification) {
        doneButtonBottomConstraint.constant = originalHeight!
        secondDButtonBottomConstraint.constant = originalHeight!
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
//        if isError == false {
//            upperViewHeight.constant = (screensize.width * 72.53) / 100
//            UIView.animate(withDuration: 0.5) {
//                self.view.layoutIfNeeded()
//            }
//            micView.isHidden = false
//        }
    }

    @IBAction func closeWindow(_ sender: Any) {
        self.view.addSubview(visualEffectView!)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CloseAddMedicationViewController") as! CloseAddMedicationViewController
        viewController.delegate = self
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: false, completion: nil)
    }
    
    @objc func showImage(sender : UITapGestureRecognizer) {
        self.view.addSubview(visualEffectView!)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HelpImageViewController") as! HelpImageViewController
        viewController.imageName = "board_3_howto_prescript.png"//"dosehelpimage.png"
        //viewController.delegate = self
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: false, completion: nil)
    }
    
    func startRecording1() {
        if isButtonEnabled == false
        {
            return
        }
        if audioEngine.isRunning {
            stopRecord()
        } else {
            startRecording()
        }
    }

    @objc func stopRecord() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
        threedotsView.isHidden = true
        
//        DispatchQueue.main.async { [unowned self] in
//            guard let task = self.recognitionTask else {
//                fatalError("Error")
//            }
//            task.cancel()
//            task.finish()
////            self.recognitionTask = nil
//        }
        recognitionTask?.cancel()
        recognitionTask?.finish()
        
        if (self.enteredText.text != "") {
            getPrescriptions(self.enteredText.text)
        }
    }
    
    func height(constraintedWidth width: CGFloat, font: UIFont, str: String) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = str
        label.font = font
        label.sizeToFit()
        
        return label.frame.height
    }
    
    func startRecording() {
//        if recognitionTask != nil {  //1
//            recognitionTask?.cancel()
//            recognitionTask = nil
//        }
        
        let audioSession = AVAudioSession.sharedInstance()  //2
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()  //3
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        } //5
        
        recognitionRequest.shouldReportPartialResults = true  //6
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in  //7
            
            var isFinal = false  //8
            
            if result != nil {
                if (result?.bestTranscription.formattedString)! != ""
                {
                    self.enteredText.text = result?.bestTranscription.formattedString
                    self.textViewHeight.constant = 24 + self.textViewDidChange(self.enteredText)
                    self.enteredText.textColor = UIColor.black
                }
                else
                {
                    self.enteredText.text = "Take..."
                    self.textViewHeight.constant = 64.0
                    self.enteredText.textColor = UIColor.lightGray
                    
                }
                
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {  //10
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)  //11
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()  //12
        
        do {
            try audioEngine.start()
            Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(stopRecord), userInfo: nil, repeats: false)
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            isButtonEnabled = true
        } else {
            isButtonEnabled = false
        }
    }
    
    @IBAction func gotoBack(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = appDelegate.pageViewController!.pageControl.currentPage - 1
        appDelegate.pageViewController?.gotoPage()
        
    }
    @IBAction func gotoNext(_ sender: Any) {
        if self.enteredText.text == "" &&  self.enteredText.text == "Take..." {
            DataUtils.messageShow(view: self, message: "Please input Medication Instruction.", title: "")
            return
        }
        DataUtils.setMedicationDose(name: self.enteredText.text)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = appDelegate.pageViewController!.pageControl.currentPage + 1//3
        appDelegate.pageViewController?.gotoPage()
        
    }
    @IBAction func siriStart(_ sender: Any) {
        
    }
    
    @IBAction func gotoSummaryScreenViewController(_ sender: Any) {
        if self.enteredText.text == "" &&  self.enteredText.text == "Take..." {
            DataUtils.messageShow(view: self, message: "Please input Medication Instruction.", title: "")
            return
        }

        DataUtils.setMedicationFrequency(name: self.enteredText.text)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let medicationController = storyBoard.instantiateViewController(withIdentifier: "SummaryScreenViewController") as! SummaryScreenViewController
        medicationController.asNeeded = self.asNeeded
        medicationController.frequency = self.frequency
        medicationController.amount = self.amount
        medicationController.timings = self.timings
        medicationController.quantity = self.quantity
        medicationController.delegate = self.delegate
        FirstMedicationAddViewController.directionMode = 0
        self.navigationController?.pushViewController(medicationController, animated: true)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func crossAction(_ sender: UIButton) {
        self.view.addSubview(visualEffectView!)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CloseAddMedicationViewController") as! CloseAddMedicationViewController
        viewController.delegate = self
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: false, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.enteredText.text == "Take..."
        {
            self.enteredText.textColor = UIColor.black
            self.enteredText.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.enteredText.text == ""
        {
            self.enteredText.text = "Take..."
            self.textViewHeight.constant = 64.0
            self.enteredText.textColor = UIColor.lightGray
            secondButton.isHidden = false
        }
        else
        {
            //secondButton.isHidden = true
            getPrescriptions(self.enteredText.text)
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        return true
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text + text != ""
        {
            print(textViewDidChange(textView))
            self.textViewHeight.constant = 24 + textViewDidChange(textView)
            self.enteredText.textColor = UIColor.black
        }
        else
        {
//            self.enteredText.text = "Take..."
            self.textViewHeight.constant = 64.0
            self.enteredText.textColor = UIColor.lightGray
        }
        
        return true
    }
    
    private func textViewDidChange(_ textView: UITextView) -> CGFloat{
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame
        return textView.frame.size.height
    }
    
    private func getPrescriptions(_ keyword: String) {
        let urlString =  "http://3.91.41.76/get-prescription?text=\(keyword)"

        let url = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        DataUtils.customActivityIndicatory(self.view,startAnimate: true)
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            DataUtils.customActivityIndicatory(self.view,startAnimate: false)
            if let data = response.result.value {
                let json : [String:Any] = data as! [String : Any]

                let error = json["error"] as? String
                let frequency = json["Frequency"] as? String
                let amount = json["Amount"] as? String
                let timings = json["Timings"] as? String
                
                if amount == "" || frequency == "" || timings == "" || error != nil {
//                    self.micView.isHidden = true
                    self.handlePrescriptionError()
                    return
                }
                
                self.secondButton.isHidden = true
                
                self.enteredText.textColor = UIColor.black
                self.textView.layer.borderWidth = 1
                self.textView.layer.borderColor = UIColor.white.cgColor
                self.errorTextView.isHidden = true
                self.errorBottomView.isHidden = true
                self.errorImageView.isHidden = true
                self.micViewTopMargin.constant = 15
                
                self.upperViewHeight.constant = (self.screensize.width * 72.53) / 100
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
                self.micView.isHidden = false
                
                if frequency?.contains("as needed") ?? false {
                    self.asNeeded = 1
                } else {
                    self.asNeeded = 0
                }
                
                // calculate freuqncy
                self.frequency = frequency?.replacingOccurrences(of: "as needed", with: "") ?? ""
                self.amount = amount ?? ""
                self.timings = timings!
                let charAmount = self.amount.components(separatedBy: " ")[0]
                let decAmount = charAmount.count > 1 ? GlobalManager.convertStringToNumber(charAmount) : Int(charAmount)
                if decAmount == 1 {
                    let lastCharacter = self.amount.last!
                    if lastCharacter == "s" {
                        self.amount = String(self.amount.dropLast())
                    }
                } else if decAmount! > 1 {
                    let lastCharacter = self.amount.last!
                    if lastCharacter != "s" {
                        self.amount = self.amount + "s"
                    }
                }
                self.amount = "\(decAmount!) " + self.amount.components(separatedBy: " ")[1]
                self.quantity = decAmount! * self.timings.components(separatedBy: ",").count * 30
                
            } else {
                self.handlePrescriptionError()
            }
        }
    }
    
    private func handlePrescriptionError() {
        self.failCount += 1
        
        if self.failCount == 1 {
            self.errorTextView.text = "Looks like your medication instructions were not entered correctly, let’s try that again."
        } else {
            self.errorTextView.text = "Hmm, looks like something is still not right. Let’s try that again."
            self.errorBottomView.isHidden = false
        }
        self.enteredText.textColor = UIColor.init(hex: "#EC877C")
        self.textView.layer.borderWidth = 1
        self.textView.layer.borderColor = UIColor.init(hex: "#EC877C").cgColor
        self.errorTextView.isHidden = false
        self.errorImageView.isHidden = false
        self.micViewTopMargin.constant = 80
    }
    
    @IBAction func scanBottleButtonClick(_ sender: Any) {
        FirstMedicationAddViewController.directionMode = 1
        self.navigationController?.popToRootViewController(animated: false)
    }
}
