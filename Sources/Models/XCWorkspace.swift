import Foundation
import Unbox
import PathKit

/// Model that represents a Xcode workspace.
public struct XCWorkspace {

    /// Workspace path
    let path: Path
    
    /// Workspace data
    let data: XCWorkspace.Data
    
    // MARK: - Init
    
    /// Initializes the workspace with the path where the workspace is.
    /// The initializer will try to find an .xcworkspacedata inside the workspace.
    /// If the .xcworkspacedata cannot be found, the init will fail.
    ///
    /// - Parameter path: .xcworkspace path.
    /// - Throws: throws an error if the workspace cannot be initialized.
    init(path: Path, fileManager: FileManager = .default) throws {
        if !fileManager.fileExists(atPath: path.string) {
            throw XCWorkspaceError.notFound(path: path)
        }
        self.path = path
        let xcworkspaceDataPaths = path.glob("*.xcworkspacedata")
        if xcworkspaceDataPaths.count == 0 {
            throw XCWorkspaceError.xcworkspaceDataNotFound(path: path)
        }
        data = try XCWorkspace.Data(path: xcworkspaceDataPaths.first!)
    }
    
    /// Initializes the workspace with its properties.
    ///
    /// - Parameters:
    ///   - path: path where the workspace is.
    ///   - data: workspace data.
    init(path: Path, data: XCWorkspace.Data) {
        self.path = path
        self.data = data
    }

}

/// XCWorkspace Errors
///
/// - notFound: the project cannot be found.
public enum XCWorkspaceError: Error, CustomStringConvertible {
    
    case notFound(path: Path)
    case xcworkspaceDataNotFound(path: Path)

    public var description: String {
        switch self {
        case .notFound(let path):
            return "The project cannot be found at \(path)"
        case .xcworkspaceDataNotFound(let path):
            return "Workspace doesn't contain a .xcworkspacedata file at \(path)"
            
        }
    }
    
}
