import UIKit

extension String {
    func withPrefix(_ prefix: String) {
        prefix.appending(self)
    }
    
    var isNumeric: Bool {
        Int(self) != nil || Double(self) != nil
    }
    
    var lines: [String] {
        self.split(separator: "\n").map { String($0) }
    }
}

"pet".withPrefix("car")

"42".isNumeric
"3.14".isNumeric
"av1".isNumeric

"this\nis\nSparta".lines

