//
//  ViewController.swift
//  PPFDynamicPickerViewDemo
//
//  Created by jdp on 2020/4/8.
//  Copyright © 2020 PPF. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    weak var picker:PPFDynamicPickerView!
    weak var addButton:UIButton!
    weak var redButton:UIButton!

    var data:[[String]] = [["A1","A2","A3","A4","A5"],["B1","B2","B3","B4","B5","B6"],["C1","C2","C3","C4"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUIs()
        initializeConstraints()
    }
    
    func initializeUIs() {
        
        picker = {
            let v = PPFDynamicPickerView()
            v.translatesAutoresizingMaskIntoConstraints = false
            v.dataSource = self
            v.delegate = self
            view.addSubview(v)
            return v
        }()
        
        addButton = {
            let b = UIButton()
            b.translatesAutoresizingMaskIntoConstraints = false
            b.backgroundColor = UIColor.gray
            b.setTitle("ADD", for: .normal)
            b.addTarget(self, action: #selector(add), for: .touchUpInside)
            view.addSubview(b)
            return b
        }()

        redButton = {
            let b = UIButton()
            b.translatesAutoresizingMaskIntoConstraints = false
            b.backgroundColor = UIColor.gray
            b.setTitle("REDUCE", for: .normal)
            b.addTarget(self, action: #selector(reduce), for: .touchUpInside)
            view.addSubview(b)
            return b
        }()

    }
    func initializeConstraints() {
        picker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        picker.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80).isActive = true
        picker.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        picker.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        addButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addButton.topAnchor.constraint(equalTo: picker.bottomAnchor,constant: 40).isActive = true

        redButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        redButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        redButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        redButton.topAnchor.constraint(equalTo: addButton.bottomAnchor,constant: 40).isActive = true
    }

    
    @objc func add() {
        data.insert(["D1","D2","D3","D4"], at: data.count)
        picker.insertComponentIn(component: data.count - 1, animate: true)
    }
    
    @objc func reduce() {
        guard !data.isEmpty else {
            return
        }
        data.removeLast()
        picker.remvoveComponent(component: data.count , animate: true)
    }
}

// MARK: -------------PPFDynamicPickerView_datasource
extension ViewController:PPFDynamicPickerView_datasource,PPFDynamicPickerView_delegate {
    func ppfDynamicPickerViewNumberOfComponents(_ vc: PPFDynamicPickerView) -> Int {
        return data.count
    }
    
    func ppfDynamicPickerView(_ vc: PPFDynamicPickerView, numberOfRowsInComponent component: Int) -> Int {
        data[component].count
    }
    
    func ppfDynamicPickerView(_ vc: PPFDynamicPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let text = data[component][row]
        return NSAttributedString(string: text)
    }
}


