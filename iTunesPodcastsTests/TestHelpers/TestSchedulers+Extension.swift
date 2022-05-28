import RxTest

extension TestScheduler {

    public func advance(by: TimeInterval = 1.0) {
        self.advanceTo(self.clock + Int(by * 1000))
    }

}
