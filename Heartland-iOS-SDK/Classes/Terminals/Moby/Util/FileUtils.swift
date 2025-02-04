//
//  FileUtils.swift
//  Heartland-iOS-SDK
//
//

import Foundation


class FileUtils {
    
    func getFirmware8500DowngradePath() -> String?{
        return Bundle(for: type(of: self)).url(forResource: "DEV-8500-V33.01.00.uns", withExtension: nil)?.path
    }
    
    func getFirmware5500DowngradePath() -> String?{
        return Bundle(for: type(of: self)).url(forResource: "DEV-5500-V11.00.uns", withExtension: nil)?.path
    }
    
    
    func printSanboxFiles(){
        let filemgr = FileManager.default
        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        let temporaryPath = dirPaths[0].path
        
        let url = URL(fileURLWithPath: temporaryPath)
        if let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
            for case let fileURL as URL in enumerator {
                print("File in sandbox : \(fileURL)")
            }
            
        }
    }
    
    func printContentSandboxFiles(){
        let filemgr = FileManager.default
        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        let temporaryPath = dirPaths[0].path
        
        print("temporaryPath = \(temporaryPath)")
        
        let url = URL(fileURLWithPath: temporaryPath)
        var files = [URL]()
        if let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
            for case let fileURL as URL in enumerator {
                do {
                    let fileAttributes = try fileURL.resourceValues(forKeys:[.isRegularFileKey])
                    if fileAttributes.isRegularFile! {
                        
                        let contentFromFile = try NSString(contentsOfFile: fileURL.relativePath, encoding: String.Encoding.utf8.rawValue)
                        //print(contentFromFile)
                        print("\n\n----->   \(fileURL)\n\n")
                        print(contentFromFile)
                        print("\n\n")
                        files.append(fileURL)
                    }
                } catch { print(error, fileURL) }
            }
            print(files)
        }
    }
    
}

extension String{
    func replacingLastOccurrenceOfString(_ searchString: String,
                                         with replacementString: String,
                                         caseInsensitive: Bool = true) -> String
    {
        let options: String.CompareOptions
        if caseInsensitive {
            options = [.backwards, .caseInsensitive]
        } else {
            options = [.backwards]
        }
        
        if let range = self.range(of: searchString,
                                  options: options,
                                  range: nil,
                                  locale: nil) {
            
            return self.replacingCharacters(in: range, with: replacementString)
        }
        return self
    }
    
    func toJsonObject()-> Dictionary<String,AnyObject>?{
        let data = self.data(using: .utf8)
        do {
            return try JSONSerialization.jsonObject(with: data!, options : .allowFragments) as? [String:AnyObject]
            
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    
}
