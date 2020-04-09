//
//  PPFDynamicPickerView.swift
//  TestPPFPickerView
//
//  Created by 潘鹏飞 on 2020/3/6.
//  Copyright © 2020 潘鹏飞. All rights reserved.
//

import UIKit

@objc protocol PPFDynamicPickerView_datasource:class {
    func ppfDynamicPickerViewNumberOfComponents(_ vc:PPFDynamicPickerView) -> Int
    func ppfDynamicPickerView(_ vc:PPFDynamicPickerView,numberOfRowsInComponent component:Int) -> Int
    @objc optional func ppfDynamicPickerView(_ vc:PPFDynamicPickerView,attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString?
}

@objc protocol PPFDynamicPickerView_delegate:class {
    @objc optional func ppfDynamicPickerView(_ vc:PPFDynamicPickerView,didSelected row: Int, inComponent component: Int)
}


class PPFDynamicPickerView: UIView {

    weak var contentView:UIView!
    private var pickerViews:[UIPickerView] = []
    
    var dataSource:PPFDynamicPickerView_datasource?
    var delegate:PPFDynamicPickerView_delegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeUIs()
        initializeConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeUIs()
        initializeConstraints()
    }
    

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        reloadAllComponents()
    }

    
    private func initializeUIs() {
        contentView = {
            let cv = UIView()
            cv.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(cv)
            return cv
        }()
    }
    private func initializeConstraints() {
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
        
    func reloadAllComponents() {
        for v in pickerViews {
            v.removeFromSuperview()
        }
        pickerViews = []
        
        let components = dataSource?.ppfDynamicPickerViewNumberOfComponents(self) ?? 0
        for i in 0 ..< components {
            let pv = UIPickerView()
            pv.translatesAutoresizingMaskIntoConstraints = false
            pv.dataSource = self
            pv.delegate = self
            
            pickerViews.append(pv)
            contentView.addSubview(pv)
            
            pv.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
            if i == 0 {
                pv.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
            }else{
                pv.widthAnchor.constraint(equalTo: pickerViews[i - 1].widthAnchor).isActive = true
                pv.leftAnchor.constraint(equalTo: pickerViews[i - 1].rightAnchor).isActive = true
            }
            if i == components - 1 {
                pv.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
            }
        }
        
    }
    
    func reloadComponent(component:Int){
        pickerViews[component].reloadComponent(0)
    }
    
    func removeComponents(components:IndexSet,animate:Bool){
        let l = components.sorted(by: >)
        for c in l {
            remvoveComponent(component: c, animate: false)
        }
        if animate {
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
    }
    
    func remvoveComponent(component:Int,animate:Bool){
        guard component >= 0 && component < pickerViews.count else {
            fatalError("component \(component) is invalide")
        }
        pickerViews[component].removeFromSuperview()
        pickerViews.remove(at: component)
        if component == 0 {
            pickerViews.first?.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        }else if component == pickerViews.count {
            pickerViews.last?.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        }else{
            pickerViews[component].leftAnchor.constraint(equalTo: pickerViews[component - 1].rightAnchor).isActive = true
            pickerViews[component].widthAnchor.constraint(equalTo: pickerViews[component - 1].widthAnchor).isActive = true
        }
        
        if animate {
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }

    }
    
    func insertComponentIn(component:Int,animate:Bool) {
        let pv = UIPickerView()
        pv.frame.size.height = contentView.bounds.height
        pv.center.y = contentView.bounds.minY
        pv.frame.origin.x = contentView.bounds.maxX
        
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.dataSource = self
        pv.delegate = self
        
        let list = pickerViews
        pickerViews.insert(pv, at: component)
        contentView.addSubview(pv)
        
        pv.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        if list.isEmpty { // the insert one is only one
            pv.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
            pv.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        }else{ // the one is inserted to first
            if component == 0 { //
                for con in contentView.constraints {
                    if con.firstItem === list.first && con.firstAttribute == .left{
                        contentView.removeConstraint(con)
                        pv.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
                        list.first?.leftAnchor.constraint(equalTo: pv.rightAnchor).isActive = true
                        list.first?.widthAnchor.constraint(equalTo: pv.widthAnchor).isActive = true
                        
                        break
                    }
                }
            }else if component == list.count {// inerted to last
                for con in contentView.constraints {
                    if con.firstItem === list.last && con.firstAttribute == .right {
                        contentView.removeConstraint(con)
                        pv.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
                        pv.leftAnchor.constraint(equalTo: list.last!.rightAnchor).isActive = true
                        pv.widthAnchor.constraint(equalTo: list.last!.widthAnchor).isActive = true
                    }
                }
            }else{// is inserted to middle
                for con in contentView.constraints {
                    if con.firstItem === list[component] && con.firstAttribute == .left &&
                        con.secondItem === list[component - 1] && con.secondAttribute == .right {
                        contentView.removeConstraint(con)
                        
                        pv.leftAnchor.constraint(equalTo: list[component - 1].rightAnchor).isActive = true
                        pv.widthAnchor.constraint(equalTo: list[component - 1].widthAnchor).isActive = true
                        
                        list[component].leftAnchor.constraint(equalTo: pv.rightAnchor).isActive = true
                        list[component].widthAnchor.constraint(equalTo: pv.widthAnchor).isActive = true
                    }
                }
            }
            
            if animate {
                pv.alpha = 0
                UIView.animate(withDuration: 0.3) {
                    pv.alpha = 1
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    func selectedItemIn(component:Int) -> Int{
        pickerViews[component].selectedRow(inComponent: 0)
    }
    func selectRow(row:Int,inComponnent component:Int,animated:Bool){
        pickerViews[component].selectRow(row, inComponent: 0, animated: animated)
    }
    
    

    
    private func indexOf(pickerView:UIPickerView) -> Int {
        for i in 0 ..< pickerViews.count {
            if pickerViews[i] === pickerView {
                return i
            }
        }
        fatalError()
    }
}

// MARK: -------------UIPickerViewDataSource
extension PPFDynamicPickerView:UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let com = indexOf(pickerView: pickerView)
        return dataSource?.ppfDynamicPickerView(self, numberOfRowsInComponent: com) ?? 0
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let com = indexOf(pickerView: pickerView)
        return dataSource?.ppfDynamicPickerView?(self, attributedTitleForRow: row, forComponent: com)
    }
}
// MARK: ------UIPickerViewDelegate
extension PPFDynamicPickerView:UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var index = 0
        for i in 0 ..< pickerViews.count {
            if pickerView === pickerViews[i] {
                index = i
                break
            }
        }
        delegate?.ppfDynamicPickerView?(self, didSelected: row, inComponent: index)
    }
}
