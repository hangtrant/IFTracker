//
//  HomeViewController.swift
//  IFTracker
//
//  Created by チャン　トゥハン on 2021/09/13.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {
    let realm = try! Realm()
    
    var goal: Int = 16
    var startTime = Date()
    var timer: Timer!
    var count: Int = 0
    var timerCouting: Bool = false
    var outputValue : String?
    
    let shapeLayer = CAShapeLayer()
    let percentageLabel : UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
        
    }()
    let datePicker = UIDatePicker()
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var goalButton: UIButton!
    @IBOutlet weak var fastingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goalButton.setTitle("\(goal)hours", for: .normal)
        
//        let user = realm.objects(User.self).last
//        outputValue = user?.nickname
//        nicknameLabel.text = "Hi,\(outputValue ?? "you")"
        statusLabel.text = "Best of luck on today's fast!"
        // Do any additional setup after loading the view.
        hiddenLabel()
        drawProgressChart()
        createDateTimePicker()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let user = realm.objects(User.self).last
        outputValue = user?.nickname
        nicknameLabel.text = "Hi,\(outputValue ?? "you")"
    }
    func hiddenLabel() {
        startLabel.isHidden = true
        endLabel.isHidden = true
        startTimeTextField.isHidden = true
        endTimeLabel.isHidden = true
        timerLabel.isHidden = true
    }
    
    func invisibleLabel() {
        startLabel.isHidden = false
        endLabel.isHidden = false
        startTimeTextField.isHidden = false
        endTimeLabel.isHidden = false
        timerLabel.isHidden = false
    }
    
    //Start Or Stop Fasting
    @IBAction func fastingButton(_ sender: Any) {
        if timerCouting == false {
            timerCouting = true
            count = 0
            fastingButton.setTitle("Stop Fasting", for: .normal)
            statusLabel.text = "You are fasting ! Keep it up !"
            invisibleLabel()
            displayStartTime()
            displayEndTime(startTime: startTime)
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        } else {
            let alert = UIAlertController(title: "Stop Fasting ?", message: "Are you sure stop fasting ?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: {(_) in
                // nothing
            }))
            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (_) in
                let lastTracker = self.realm.objects(Tracker.self).last
                let tracker = Tracker()
                if lastTracker == nil {
                    tracker.id = 0
                } else {
                    tracker.id = lastTracker!.id + 1
                }
                tracker.startTime = self.datePicker.date
                tracker.stopTime = self.datePicker.date + TimeInterval((60 * 60 * self.goal))
                tracker.elapsedTime = Double(self.count)
                tracker.goalTime = Double(self.goal * 60 * 60)
                print(tracker)
                try! self.realm.write() {
                    self.realm.add(tracker, update: .modified)
                    print("DONE")
                }
                self.timerCouting = false
                self.count = 0
                self.fastingButton.setTitle("Start Fasting", for: .normal)
                self.statusLabel.text = "Best of luck on today's fast!"
                self.hiddenLabel()
                self.timer.invalidate()
                self.timer = nil
                self.timerLabel.text = self.makeTimeString(hours: 0, minutes: 0, seconds: 0)
                self.datePicker.date = Date()
                self.drawProgressChart()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //timerCounter
    @objc func timerCounter() {
        count = Int(Date().timeIntervalSince(datePicker.date))
        let time = secondsToHourMinutesSeconds(seconds: count)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        timerLabel.text = timeString
        beginCountingTime(count: count)
    }
    
    // Change from seconds to hours, minutes, seconds
    func secondsToHourMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
        return ((seconds / 3600), ((seconds % 3600) / 60), ((seconds % 3600) % 60))
    }
    
    // make time string
    func makeTimeString(hours: Int, minutes: Int, seconds: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += " : "
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
        
        return timeString
    }
    
    //Choose start time
    func createDateTimePicker() {
        displayStartTime()
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar Button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        //assign toolbar
        startTimeTextField.inputAccessoryView = toolbar
        startTimeTextField.inputView = datePicker
        
        // date picker mode
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .dateAndTime
    }
    
    // Display choosen time
    @objc func donePressed() {
        //formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd、HH:mm"
        let startTime = formatter.string(from: datePicker.date)
        startTimeTextField.text = "\(startTime)"
        self.view.endEditing(true)
        displayEndTime(startTime: datePicker.date)
    }
    
    //Display start time
    func displayStartTime() {
        //formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd、HH:mm"
        let startTime = formatter.string(from: Date())
        startTimeTextField.text = "\(startTime)"
    }
    
    // Display ending time
    func displayEndTime(startTime: Date) {
        //formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd、HH:mm"
        let endTime = formatter.string(from: datePicker.date + TimeInterval((60 * 60 * goal)))
        endTimeLabel.textAlignment = .center
        endTimeLabel.text = "\(endTime)"
    }
    
    //Draw Progress Chart
    func drawProgressChart() {
        percentageLabel.text = "Start"
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center
        //drawing circle
        let center = view.center
        
        //create my strack layer
        let trackLayer = CAShapeLayer()
        
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0 , endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        trackLayer.position = center
        
        view.layer.addSublayer(trackLayer)
        
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.position = center
        
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(shapeLayer)
    }
    
    // Count fasting time
    private func beginCountingTime(count: Int) {
        shapeLayer.strokeEnd = 0
        let totalTime = 60 * 60 * goal
        let percentage = CGFloat(count) / CGFloat(totalTime)
        DispatchQueue.main.async { [self] in
            if percentage > 1.0 {
                shapeLayer.strokeColor = UIColor.green.cgColor
            } else {
                shapeLayer.strokeColor = UIColor.red.cgColor
            }
            self.percentageLabel.text = "\(Int(percentage * 100))%"
            self.shapeLayer.strokeEnd = percentage
        }
    }
    
    // Animate Circle Progress Chart
    fileprivate func animateCircle() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        basicAnimation.duration = 1
        
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }

    // Comeback from choose goal
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        guard let source = segue.source as? GoalViewController else {return}
        goal = source.newGoal
        goalButton.setTitle("\(goal)hours", for: .normal)
        displayEndTime(startTime: datePicker.date)
      }
}
