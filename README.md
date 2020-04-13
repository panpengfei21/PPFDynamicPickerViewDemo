# PPFDynamicPickerViewDemo

## 效果

![Gif](https://upload-images.jianshu.io/upload_images/2261768-f8bd8f388e94e44c.gif?imageMogr2/auto-orient/strip)
## 引用

[GitHub](https://github.com/panpengfei21/PPFDynamicPickerViewDemo.git)
```
pod 'PPFDynamicPickerView'
```

## 怎么用

#### initialize
```
        var data:[[String]] = [["A1","A2","A3","A4","A5"],["B1","B2","B3","B4","B5","B6"],["C1","C2","C3","C4"]]


          let v = PPFDynamicPickerView()
          v.translatesAutoresizingMaskIntoConstraints = false
          v.dataSource = self
         v.delegate = self
```

#### insert compoent
```
        data.insert(["D1","D2","D3","D4"], at: data.count)
        picker.insertComponentIn(component: data.count - 1, animate: true)
```
#### remove component
```
        data.removeLast()
        picker.remvoveComponent(component: data.count , animate: true)
```

#### data source and delegate
```
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


```
