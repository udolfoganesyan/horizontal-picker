//
//  ViewController.swift
//  horizontal picker
//
//  Created by Rudolf Oganesyan on 02.12.2020.
//

import UIKit

class ViewController: UIViewController {
    
    let titles = ["1 Aug, Wed", "2 Aug, Tue","3 Aug, Tue","4 Aug, Tue","5 Aug, Tue","22 Aug, Tue","23 Aug, Tue","24 Aug, Tue","25 Aug, Tue","22 Aug, Tue","22 Aug, Tue","22 Aug, Tue","22 Aug, Tue","22 Aug, Tue"
    ]
    
    private var dates: [Date] = []
    
    @IBOutlet weak var pickerContainer: UIView!
    
    let picker = UIPickerView()
    var rotationAngle: CGFloat = -90  * (.pi/180)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateDates()

        picker.delegate = self
        picker.dataSource = self
        
        picker.transform = CGAffineTransform(rotationAngle: rotationAngle)
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        pickerContainer.addSubview(picker)
        
        picker.widthAnchor.constraint(equalToConstant: 40).isActive = true
        picker.heightAnchor.constraint(equalTo: pickerContainer.widthAnchor, constant: 1000).isActive = true
        picker.centerXAnchor.constraint(equalTo: pickerContainer.centerXAnchor).isActive = true
        picker.centerYAnchor.constraint(equalTo: pickerContainer.centerYAnchor, constant: 0).isActive = true

//        picker.frame = CGRect(x: -500, y: 100.0, width: view.bounds.width + 1000, height: 36)
    }
    
    var selectedRow: Int = 0 {
        didSet {
            picker.reloadComponent(0)
        }
    }
    
    private func populateDates() {
        let cal = Calendar.current
        let dateComponents = cal.dateComponents([.year, .month, .day], from: Date())
        let date = cal.date(from: dateComponents)!.zeroSeconds()
        
        for idx in 0..<30 {
            dates.append(date.plusDays(daysCount: idx))
        }
        picker.reloadComponent(0)
    }
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        pickerView.subviews.forEach({
            $0.isHidden = $0.frame.height < 1.0
        })
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        dates.count
    }
    
    final class PickerView: UIView {
        
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            return label
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            addSubview(titleLabel)
            titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            
            let separator = UIView()
            separator.backgroundColor = .darkGray
            separator.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(separator)
            separator.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
            separator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -4).isActive = true
            separator.widthAnchor.constraint(equalToConstant: 2).isActive = true
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setDate(_ date: Date) {
            let formatter = DateFormatter()
            let template = "MMM d, E"
            let usLocale = Locale(identifier: "en_US_POSIX")
            
            formatter.locale = usLocale
            formatter.dateFormat = template
            let string = formatter.string(from: date)
            
            titleLabel.text = string
        }
        
        func setTextColor(_ color: UIColor) {
            titleLabel.textColor = color
        }
        
        func setFont(_ font: UIFont) {
            titleLabel.font = font
        }
        
        func addTrailingSeparator() {
            let rightSeparator = UIView()
            rightSeparator.backgroundColor = UIColor.darkGray.withAlphaComponent(0.45)
            rightSeparator.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(rightSeparator)
            rightSeparator.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
            rightSeparator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
            rightSeparator.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            rightSeparator.widthAnchor.constraint(equalToConstant: 2).isActive = true
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
//        switch pickerView.subviews.count {
//        case 2:
//            pickerView.subviews[1].backgroundColor = UIColor.clear
//        case 3:
//            pickerView.subviews[1].backgroundColor = UIColor.clear
//            pickerView.subviews[2].backgroundColor = UIColor.clear
//        default:
//            break
//        }
        //        pickerView.subviews[0].subviews[0].subviews[1].subviews[0].subviews[0].subviews[0].alpha = 1
        //        pickerView.subviews[0].subviews[0].subviews[0].subviews[0].subviews[0].subviews[0].alpha = 1
        
        let modeView = PickerView()
        modeView.setDate(dates[row])
        
        var color = UIColor.black
        var fontSize: CGFloat = 14
        
        if row == selectedRow {
            color = UIColor.blue
            fontSize = 20
        }
        
        modeView.setFont(.systemFont(ofSize: fontSize))
        modeView.setTextColor(color)
        
        if row == titles.count - 1 {
            modeView.addTrailingSeparator()
        }
        
        modeView.transform = CGAffineTransform(rotationAngle: -rotationAngle)
        
        return modeView
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 140
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.height
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }
}

extension Date {
    
    func plusDays (daysCount: Int) -> Date {
        let calendar = Calendar.current
        guard let endTime = calendar.date(byAdding: .day, value: daysCount, to: self) else {
            // TODO: fix
            return Date()
        }
        return endTime
    }
    
    func zeroSeconds() -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        return calendar.date(from: dateComponents)!
    }
}
