import SwiftSocket

public enum ValueResult<T> {
    case success(value: T)
    case failure(error: Error)
}
