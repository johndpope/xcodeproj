import Foundation
import XCTest

@testable import Models

final class PBXResourcesBuildPhaseSpec: XCTestCase {
    
    var subject: PBXResourcesBuildPhase!
    
    override func setUp() {
        super.setUp()
        subject = PBXResourcesBuildPhase(reference: "ref",
                                         files: Set(arrayLiteral: "333"),
                                         runOnlyForDeploymentPostprocessing: 0)
    }
    
    func test_init_initializesTheBuildPhaseWithTheRightValues() {
        XCTAssertEqual(subject.reference, "ref")
        XCTAssertEqual(subject.files, Set(arrayLiteral: "333"))
        XCTAssertEqual(subject.runOnlyForDeploymentPostprocessing, 0)
    }
    
    func test_initWithReferenceAndDictionary_returnsThePhaseWithTheRightAttributes() {
        let dictionary = testDictionary()
        let phase = try! PBXResourcesBuildPhase(reference: "ref", dictionary: dictionary)
        XCTAssertEqual(phase.reference, "ref")
        XCTAssertEqual(phase.files, Set(arrayLiteral: "file1"))
        XCTAssertEqual(phase.runOnlyForDeploymentPostprocessing, 3)
    }
    
    func test_initFails_whenRunOnlyForDeploymentPostprocessingIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "runOnlyForDeploymentPostprocessing")
        do {
            _ = try PBXResourcesBuildPhase(reference: "ref", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }
    
    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXResourcesBuildPhase.isa, "PBXResourcesBuildPhase")
    }
    
    func test_addingFile_returnsANewBuildPhaseWithTheFileAdded() {
        let got = subject.adding(file: "file2")
        XCTAssertTrue(got.files.contains("file2"))
    }
    
    func test_removingFile_returnsANewBuildPhaseWithTheFileRemoved() {
        let got = subject.removing(file: "333")
        XCTAssertFalse(got.files.contains("333"))
    }
    
    func test_equals_returnsTheCorrectValue() {
        let another = PBXResourcesBuildPhase(reference: "ref",
                                             files: Set(arrayLiteral: "333"),
                                             runOnlyForDeploymentPostprocessing: 0)
        XCTAssertEqual(subject, another)
    }
    
    private func testDictionary() -> [String: Any] {
        return [
            "files": ["file1"],
            "runOnlyForDeploymentPostprocessing": 3
        ]
    }
}
