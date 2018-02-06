// TimelineParser.swift

import Foundation

struct TimelineParser {
    func parse(data: Data) -> [Tweet] {
        let serializedData = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
        
        let json = serializedData as! [Any]
        
        let timeline: [Tweet] = json.flatMap {
            Tweet(json: $0)
        }
        
        return timeline
    }
}
