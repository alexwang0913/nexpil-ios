/*
 * CalendarHeaderView.swift
 * Created by Michael Michailidis on 07/04/2015.
 * http://blog.karmadust.com/
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

import UIKit
open class CalendarHeaderView: UIView {
    var calendarView: CalendarView?
    
    func commonInit(_ calendarView: CalendarView) {
        self.calendarView = calendarView
    }
    
    lazy var prevButton : UIButton = {
        let btn = UIButton(type: .custom)

        switch CalendarView.Style.colorTheme {
            case 0:
                btn.setImage(UIImage(named: "cyan_back"), for: .normal)
                break
            case 1:
                btn.setImage(UIImage(named: "blue_back"), for: .normal)
            break
            case 2:
                btn.setImage(UIImage(named: "purple_back"), for: .normal)
            break
        case 3:
            btn.setImage(UIImage(named: "violet_back"), for: .normal)
            break
            default:
                btn.setImage(UIImage(named: "violet_back"), for: .normal)
                break
        }
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: #selector(prevButtonClick), for: .touchUpInside)
        
        self.addSubview(btn)
        
        return btn
    }()
    
    lazy var nextButton : UIButton = {
        let btn = UIButton(type: .custom)
        
        switch CalendarView.Style.colorTheme {
        case 0:
            btn.setImage(UIImage(named: "cyan_forward"), for: .normal)
            break
        case 1:
            btn.setImage(UIImage(named: "blue_forward"), for: .normal)
            break
        case 2:
            btn.setImage(UIImage(named: "purple_forward"), for: .normal)
            break
        case 3:
            btn.setImage(UIImage(named: "violet_forward"), for: .normal)
            break
        default:
            btn.setImage(UIImage(named: "violet_forward"), for: .normal)
            break
        }
        btn.contentHorizontalAlignment = .right

        btn.addTarget(self, action: #selector(nextButtonClick), for: .touchUpInside)
        
        self.addSubview(btn)
        
        return btn
    }()
    
    
    lazy var monthLabel : UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = NSTextAlignment.center
        lbl.font = UIFont(name: "Montserrat-Bold", size: 15)
        lbl.textColor = UIColor(hex: "333333") //CalendarView.Style.headerTextColor
        lbl.frame = CGRect(x:0, y: 0, width: self.bounds.size.width, height:40)
        self.addSubview(lbl)
        
        return lbl
    }()
    
    lazy var dayLabelContainerView : UIView = {
        let v = UIView()
        
        let formatter = DateFormatter()
        formatter.locale = CalendarView.Style.locale
        formatter.timeZone = CalendarView.Style.timeZone
        
        var start = CalendarView.Style.firstWeekday == .sunday ? 0 : 1
        
        for index in start..<(start+7) {
            
            let weekdayLabel = UILabel()
            
            weekdayLabel.font = UIFont(name: CalendarView.Style.headerFontName, size: 14.0)
            
            weekdayLabel.text = formatter.veryShortWeekdaySymbols[(index % 7)].capitalized
            
            weekdayLabel.textColor = CalendarView.Style.headerTextColor
            weekdayLabel.textAlignment = NSTextAlignment.center
            
            v.addSubview(weekdayLabel)
        }
        
        self.addSubview(v)
        
        return v
        
    }()
    
    override open func layoutSubviews() {
        
        super.layoutSubviews()
        
        var frm = self.bounds
        frm.origin.y += 5.0
        frm.size.height = self.bounds.size.height / 2.0 - 5.0
        frm.origin.x = 20
        frm.size.width /= 4
        self.prevButton.frame = frm
        self.nextButton.frame.size = frm.size
        
        self.nextButton.frame.origin = CGPoint(x:self.frame.size.width - self.nextButton.frame.size.width - 20, y: self.prevButton.frame.origin.y)
        
        
        var labelFrame = CGRect(
            x: 0.0,
            y: self.bounds.size.height / 2.0,
            width: self.bounds.size.width / 7.0,
            height: self.bounds.size.height / 2.0
        )
        
        for lbl in self.dayLabelContainerView.subviews {
            
            lbl.frame = labelFrame
            labelFrame.origin.x += labelFrame.size.width
        }
        
        self.monthLabel.frame = CGRect(x:0, y: 0, width: self.bounds.size.width, height:40)
    }
    
    @objc func prevButtonClick() {
        self.calendarView?.goToPreviousMonth()
    }
    
    @objc func nextButtonClick() {
        self.calendarView?.goToNextMonth()
    }
}
