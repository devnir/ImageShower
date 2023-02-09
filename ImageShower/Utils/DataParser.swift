//
//  DataParser.swift
//  ImageShower
//
//  Created by Андрей Белогородский on 08.02.2023.
//

import Foundation

fileprivate enum ValueKeys: String, CaseIterable{
    case title = "title:"
    case firstimg = "firstimg:"
    case secondimg = "secondimg:"
    case thirdimg = "thirdimg:"
    case details = "details:"
}

fileprivate struct KeyIndexValue {
    let key : ValueKeys
    let index: Int
    var value: String
}

class DataParser {
    
    static let shared = DataParser()
    
    init(){}
    
    func getListModels() -> [ListItemModel] {
       return self.readFileContent()
    }
    
    private func readFileContent() -> [ListItemModel]{
        if let filepath = Bundle.main.path(forResource: "task", ofType: "json")
        {
            do {
                let contents = try String(contentsOfFile: filepath)
                let objects = self.getObjects(inText: contents)
                return objects
                
            } catch {
                print(error)
            }
        }
        
        return []
    }
    
    private func getObjects(inText text: String) -> [ListItemModel] {
        let objectPattern = "\"(.+?)\""
        var objects: [ListItemModel] = []
        let stringObjects = getStringObjects(inText: text, pattern: objectPattern)
        
        for stringObject in stringObjects ?? [] {
            guard let object = self.createObject(from: stringObject) else { continue }
            objects.append(object)
        }
        
        return objects
    }
    
    private func createObject(from text: String) -> ListItemModel? {
        var listItem = ListItemModel(title: "", firstImg: "", secondImg: "", thirdimg: "", details: "")
        var items = self.getValuesKeys(from: text)
        let values = self.getValues(from: text, for: items)
        
        for item in values {
            switch item.key {
            case .title:
                listItem.title = item.value
            case .firstimg:
                listItem.firstImg = item.value
            case .secondimg:
                listItem.secondImg = item.value
            case .thirdimg:
                listItem.thirdimg = item.value
            case .details:
                listItem.details = item.value
            }
        }
        
        return listItem
    }
    
    private func getStringObjects(inText text: String, pattern: String) -> [String]? {
        var clearText = text
        clearText.removeAll(where: {$0 == "\\"})
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let result = regex.matches(in: clearText, options: .init(rawValue: 0), range: NSRange(location: 0, length: clearText.count))
            
            let matches = result.map { result in
                var r = (clearText as NSString).substring(with: result.range)
                r.removeFirst()
                r.removeLast()
                return r
            }
            
            return matches
        } catch {
            print(error)
        }
        return nil
    }
    
    private func getValuesKeys(from text: String) -> [KeyIndexValue] {
        print("Start parsing values")
        print("Input String: \(text)")
        var result: [KeyIndexValue] = []
        for key in ValueKeys.allCases {
            guard let range: Range<String.Index> = text.firstRange(of: key.rawValue) else { return []}
            let index = text.distance(from: text.startIndex, to: range.lowerBound)
            let item = KeyIndexValue(key: key, index: index, value: "")
            result.append(item)
        }
        
        result = result.sorted(by: { $0.index < $1.index })
        return result
    }
    
    private func getValues(from text: String, for items: [KeyIndexValue]) -> [KeyIndexValue] {
        var result: [KeyIndexValue]  = []
        
        for (i, item) in items.enumerated() {
            var newItem = item
            let valStart = item.index
            var valEnd = -1
            if i < items.count - 1 {
                valEnd = items[i + 1].index
            } else {
                valEnd = text.count + 1
            }
           
            let range = text.index(text.startIndex, offsetBy: valStart + item.key.rawValue.count)..<text.index(text.startIndex, offsetBy: valEnd - 1)
            let val = text.substring(with: range)
            
            newItem.value = val
            result.append(newItem)
        }
        return result
    }
}
