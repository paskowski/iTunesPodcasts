import XCTest
import RxTest

public func XCTAssertEqualStreams<T>(
    _ values: [T],
    _ testObserver: TestableObserver<T>,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #file,
    line: UInt = #line
) where T: Equatable {
    XCTAssertEqual(
        values,
        testObserver.events.compactMap { $0.value.element },
        message(),
        file: file,
        line: line
    )
}

public func XCTAssertStreamValuesCount<T>(
    _ count: Int,
    _ testObserver: TestableObserver<T>,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #file,
    line: UInt = #line
) {
    XCTAssertEqual(
        count,
        testObserver.events.compactMap { $0.value.element }.count,
        message(),
        file: file,
        line: line
    )
}
