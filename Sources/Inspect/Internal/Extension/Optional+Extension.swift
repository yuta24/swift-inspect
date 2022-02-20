import Foundation

func zip<Value1, Value2>(_ optional1: Optional<Value1>, _ optional2: Optional<Value1>, map: (Value1, Value1) -> Value2) -> Optional<Value2> {
    if let value1 = optional1, let value2 = optional2 {
        return map(value1, value2)
    } else {
        return nil
    }
}
