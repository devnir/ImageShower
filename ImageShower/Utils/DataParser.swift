//
//  DataParser.swift
//  ImageShower
//
//  Created by Андрей Белогородский on 08.02.2023.
//

import Foundation

fileprivate enum ObjectFieldPattern: String {
    case title = "title:(.+?),f"
    case firstimg = "firstimg:(.+?),"
    case secondimg = "secondimg:(.+?),"
    case thirdimg = "thirdimg:(.+?),"
    case details = "details:(.+?)\""
    
    var head: Int {
        switch self {
        case .title: return 6
        case .firstimg: return 9
        case .secondimg: return 10
        case .thirdimg: return 9
        case .details: return 8

        }
    }
    
    var patternLen: Int {
        switch self {
        case .title: return 8
        case .firstimg: return 10
        case .secondimg: return 11
        case .thirdimg: return 10
        case .details: return 9
        }
    }
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
                let objects = self.getObjects(inText: contents)//self.getStringObjects(inText: contents, pattern: "\"(.+?)\"")
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
        return ListItemModel(title: self.getValue(from: text, for: .title), firstImg: self.getValue(from: text, for: .firstimg), secondImg: self.getValue(from: text, for: .secondimg), thirdimg: self.getValue(from: text, for: .thirdimg), details: self.getValue(from: text, for: .details))
    }
    
    private func getStringObjects(inText text: String, pattern: String) -> [String]? {
        var clearText = text
        clearText.removeAll(where: {$0 == "\\"})
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let result = regex.matches(in: clearText, options: .init(rawValue: 0), range: NSRange(location: 0, length: clearText.count))
            
            let matches = result.map { result in
                return (clearText as NSString).substring(with: result.range)
            }
            
            return matches
        } catch {
            print(error)
        }
        return nil
    }
    
    private func getValue(from text:String, for type: ObjectFieldPattern) -> String {
        do {
            let regex = try NSRegularExpression(pattern: type.rawValue, options: .caseInsensitive)
            let result = regex.matches(in: text, options: .init(rawValue: 0), range: NSRange(location: 0, length: text.count))
            
            guard let firstResult = result.first else {return ""}
            let range = NSMakeRange(firstResult.range.location + type.head, firstResult.range.length - type.patternLen)
            return (text as NSString).substring(with: range)
        } catch {
            print(error)
        }
        return ""
    }
}
