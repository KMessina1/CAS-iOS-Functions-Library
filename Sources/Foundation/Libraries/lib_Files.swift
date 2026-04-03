/*--------------------------------------------------------------------------------------------------------------------------
    File: lib_Files.swift
  Author: Kevin Messina
 Created: 7/1/23
Modified:
 
©2023-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
 
2025_05_03 - Added getFileAttribs() to return dictionary of keys.
--------------------------------------------------------------------------------------------------------------------------*/

import Foundation

// MARK: - *** FILES ***
struct Files {
    enum directories:Int { case docsDir,libDir,cacheDir,bundleDir,custom,tempDir,provenanceDir,inventoryDir,sessionsDir,reportsDir }
    enum primeDirectories:Int { case docsDir,libDir,cacheDir }
    enum fileExtensions:Int { case all,jpg,jpeg,mp3,mp4,png,db,doc,csv,tsv,txt,avi,mov,pdf }

    /// Return the PATH string for Directory
    struct dir {
        static let documents:String = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path
        static let library:String = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!.path
        static let cache:String = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.path
        static let temp:String = FileManager.default.temporaryDirectory.path()
        static let provenance:String = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("Provenance").path()
        static let inventory:String = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("Inventory").path()
        static let sessions:String = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("Sessions").path()
        static let reports:String = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("Reports").path()
    }
    
    /// Return the URL string for Directory
    func getPathURL(in directory:directories) -> URL {
        switch directory {
            case .docsDir: return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            case .libDir: return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            case .cacheDir: return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            case .tempDir: return FileManager.default.temporaryDirectory
            case .bundleDir: return Bundle.main.bundleURL
            case .provenanceDir: return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    .appendingPathComponent("Provenance")
            case .inventoryDir: return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    .appendingPathComponent("Inventory")
            case .sessionsDir: return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    .appendingPathComponent("Sessions")
            case .reportsDir: return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    .appendingPathComponent("Reports")
            case .custom: return URL(fileURLWithPath: "")
        }
    }
    
    func getPathForFilename(_ fileName:String,in directory:directories,path:String? = "") -> (url:URL,path:String) {
        var documentsURL:URL
        
        if directory == .custom && !path!.isEmpty {
            documentsURL = URL(string: path!)!
        }else{
            documentsURL = getPathURL(in: directory)
        }
        
        if !fileName.isEmpty {
            documentsURL = documentsURL.appendingPathComponent(fileName)
        }
        
        return (documentsURL,documentsURL.path)
    }
    
    func exists(atPath: String) -> Bool {
        return FileManager.default.fileExists(atPath: atPath)
    }
    
    func exists(filename:String?=nil,in directory:directories) -> Bool {
        guard
            filename != nil,
            !filename!.isEmpty
        else {
            return false
        }
        
        let documentsURL:URL = getPathURL(in: directory).appendingPathComponent(filename!)

        return FileManager.default.fileExists(atPath: documentsURL.path)
    }
    
    @discardableResult func copyFromBundle(fileName:String, to:directories) -> Bool {
        let FM = FileManager.default
        let fromURL = Bundle.main.bundleURL.appendingPathComponent(fileName)
        
        var toURL:URL = getPathURL(in: to)
        toURL = toURL.appendingPathComponent(fileName)

        var fileExists: Bool = false

        if !Files().exists(filename: fileName, in: to) {
            do {
                try FM.copyItem(atPath: fromURL.path, toPath: toURL.path)
                simPrint("\(fileName.uppercased()) copied from bundle to \(to) directory.",action: .success,log: LFFL())
            } catch {
                simPrint("\( fileName.uppercased() ) could not be copied from bundle to \( to ) directory.",
                         action: .error,
                         errorMsg:error.localizedDescription,
                         log: LFFL()
                )
            }

            fileExists = FM.fileExists(atPath: toURL.path)
        }
        
        return fileExists
    }

    func returnPathForFilename(_ filename:String, in directory:directories) -> (url:URL,path:String) {
        var fileURL:URL = getPathURL(in: directory)
        
        if !filename.isEmpty {
            fileURL = fileURL.appendingPathComponent(filename)
        }
        
        return (url: fileURL, path: fileURL.path())
    }
    
    @discardableResult func moveOrRename(fromName:String, fromDir: directories, toName:String, in toDir:directories) -> Bool {
        let FM = FileManager.default
        var fromURL:URL = getPathURL(in: fromDir)
        var toURL:URL = getPathURL(in: toDir)
        
        if !fromName.isEmpty {
            fromURL = fromURL.appendingPathComponent(fromName)
        }
        
        if !toName.isEmpty {
            toURL = toURL.appendingPathComponent(toName)
        }
        
        do {
            try FM.moveItem(at: fromURL, to: toURL)
        } catch let error as NSError {
            simPrint(
                "File could not be renamed/moved from \( fromURL.absoluteString ) to \( toURL.absoluteString ).",
                action: .error,
                errorMsg:error.localizedDescription,
                log: LFFL()
            )
        }
        
        let fileExists = FM.fileExists(atPath: toURL.path)
        return fileExists
    }

    func getFileType(forExtension: Files.fileExtensions) -> String {
        switch fileExtensions(rawValue: forExtension.rawValue) {
            case .all: return "ALL"
            case .avi: return "avi"
            case .csv: return "csv"
            case .db: return "db"
            case .doc: return "doc"
            case .jpeg: return "jpeg"
            case .jpg: return "jpg"
            case .mov: return "mov"
            case .mp3: return "mp3"
            case .mp4: return "mp4"
            case .pdf: return "pdf"
            case .png: return "png"
            case .tsv: return "tsv"
            case .txt: return "txt"
            case .none: return ""
        }
    }
    
    func deleteAllFiles(in dir:directories) {
        let documentsUrl = Files().getPathURL(in: dir)
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(
                at: documentsUrl,
                includingPropertiesForKeys: nil,
                options: .skipsHiddenFiles
            )
            
            for fileURL in fileURLs {
                try FileManager.default.removeItem(at: fileURL)
            }
        } catch  {
            print(error)
        }
    }

    func deleteAllFilesOfType(ext: Files.fileExtensions,in dir:directories) {
        let documentsUrl = Files().getPathURL(in: dir)
        let ofType: String = getFileType(forExtension: ext)
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(
                at: documentsUrl,
                includingPropertiesForKeys: nil,
                options: .skipsHiddenFiles
            )
            
            for fileURL in fileURLs where fileURL.pathExtension == ofType {
                try FileManager.default.removeItem(at: fileURL)
            }
        } catch  {
            print(error)
        }
    }
    
    @discardableResult func delete(fileName:String?=nil,in directory:directories) -> Bool {
        var documentsURL:URL = getPathURL(in: directory)
        if fileName != nil { documentsURL = documentsURL.appendingPathComponent(fileName!) }
        
        do {
            try FileManager.default.removeItem(atPath: documentsURL.path)
            simPrint("\( fileName?.uppercased() ?? "file" ) deleted from \( directory ) directory.",action: .success, log: LFFL())
            return true
        } catch {
            simPrint("\( fileName?.uppercased() ?? "file" ) could not be deleted from \( directory ) directory.",action: .error, errorMsg:error.localizedDescription, log: LFFL())
            return false
        }
    }
    
    func renameFileURL(oldFileName: String, newFileName: String, in directory:directories) {
        let FM = FileManager.default
        let folderURL:URL = getPathURL(in: directory)
        
        let oldFileURL = folderURL.appendingPathComponent(oldFileName)
        let newFileURL = folderURL.appendingPathComponent(newFileName)
        
        do {
            // Attempt to move (rename) the file
            try FM.moveItem(at: oldFileURL, to: newFileURL)
            print("File '\(oldFileName)' successfully renamed to '\(newFileName)'.")
        } catch {
            print("Error renaming file: \(error.localizedDescription)")
        }
    }

    func copyFileURLToDirectory(fileURL: URL, newFilename: String, in directory:directories) {
        guard fileURL.startAccessingSecurityScopedResource() else {
            print("Failed to start accessing security-scoped resource")
            return
        }
        
        defer {
            fileURL.stopAccessingSecurityScopedResource()
        }
        
        do {
            let filename = fileURL.lastPathComponent
            let destinationURL = getPathForFilename(filename, in: directory).url

            // Remove existing file if present to avoid errors during copy
            if Files().exists(filename: filename, in: directory) {
                Files().delete(fileName: filename, in: directory)
            }

            try FileManager.default.copyItem(at: fileURL, to: destinationURL)
            
            print("File copied to: \(destinationURL.path)")
            // You can now safely access the copied file from destinationURL
        } catch {
            print("Error copying file: \(error.localizedDescription)")
        }
    }
    
    @discardableResult func createDirectory(folderName:String,in directory:directories) -> Bool {
        let folderURL = getPathURL(in: directory).appendingPathComponent(folderName)
        
        if !Files().exists(filename: "/"+folderName, in: directory) {
            do {
                try FileManager.default.createDirectory(atPath: folderURL.path, withIntermediateDirectories: true, attributes: nil)
                
                let results = Files().exists(filename: "/"+folderName, in: directory)
                simPrint("\( folderName.uppercased()) created in documents directory.",action: .success, log: LFFL())
                
                return results
            } catch {
                simPrint("\( folderName.uppercased() ) could not be created in documents directory.",action: .error, errorMsg:error.localizedDescription, log: LFFL())
                fatalError("Couldn't create the \( folderName.uppercased() ) folder in documents directory.")
            }
        }
        
        return false
    }
    
    func returnContentsOfDirectoryAt(path: String) -> [String] {
        do {
            return try FileManager.default.contentsOfDirectory(atPath: path)
        } catch {
            simPrint("\( path.uppercased() ) could not send contents in directory.",action: .error, errorMsg:error.localizedDescription, log: LFFL())
            return []
        }
    }
    
    func returnContentsOf(directory: primeDirectories) -> [String] {
        var directoryPath = ""
        
        switch directory {
            case .libDir: directoryPath = getPathURL(in: .libDir).path()
            case .cacheDir: directoryPath = getPathURL(in: .cacheDir).path()
            case .docsDir: directoryPath = getPathURL(in: .docsDir).path()
        }

        do {
            return try FileManager.default.contentsOfDirectory(atPath: directoryPath)
        } catch {
            simPrint("\( directoryPath.uppercased() ) could not send contents in directory.",action: .error, errorMsg:error.localizedDescription, log: LFFL())
            return []
        }
    }
    
    func returnContentsOfDirectoryOfType(ext: Files.fileExtensions,in dir:directories) -> (filenames: [String], count:Int) {
        let documentsUrl = Files().getPathURL(in: dir)
        let ofType: String = getFileType(forExtension: ext)
        var filenames: [String] = []
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(
                at: documentsUrl,
                includingPropertiesForKeys: nil,
                options: .skipsHiddenFiles
            )
            
            for fileURL in fileURLs where fileURL.pathExtension == ofType {
                filenames.append(fileURL.path)
            }
        } catch  {
            simPrint("\( documentsUrl.path.uppercased() ) could not send contents in directory.",action: .error, errorMsg:error.localizedDescription, log: LFFL())
        }
        
        return (filenames: filenames, count: filenames.count)
    }
    
    /// Returns the attributes of a file
    /// - Parameters:
    ///   - filename: String filename
    ///   - in: directory preset
    ///
    /// - Usage: let attribs = Files().getFileAttribs(filename: Databases.primaryDB.fullFilename, in: .docsDir)
    ///          let created = attribs[FileAttributeKey.creationDate] ?? "N/A"
    ///
    /// Common Attributes
    ///   NSFileSize: The size of the file in bytes.
    ///   NSFileCreationDate: The date the file was created.
    ///   NSFileModificationDate: The date the file was last modified.
    ///   NSFileType: The type of the file (e.g., regular file, directory, symbolic link).
    ///   NSFileOwnerAccountName: The name of the file’s owner.
    ///   NSFileGroupOwnerAccountName: The name of the file’s group owner.
    ///   NSFilePosixPermissions: The POSIX permissions of the file.
    func getFileAttribs(filename: String, in dir: directories) -> [FileAttributeKey: Any] {
        var fileAttributes: [FileAttributeKey: Any] = [:]
        let documentsPath = Files().getPathForFilename(filename, in: dir).path

        do {
            fileAttributes = try FileManager.default.attributesOfItem(atPath: documentsPath)
            print("File attributes: \(fileAttributes)")
            print(fileAttributes[FileAttributeKey.creationDate] ?? "N/A")
            print(fileAttributes[FileAttributeKey.modificationDate] ?? "N/A")
            print(fileAttributes[FileAttributeKey.size] ?? "N/A")
        } catch {
            print("Failed to retrieve attributes: \(error.localizedDescription)")
        }
        
        return fileAttributes
    }
}
