//
//  Line.swift
//  swift-drawingapp
//
//  Created by 김상진 on 2022/10/22.
//

import Foundation
import CoreGraphics

public class Line: Shape, Identifiable, Codable {
    public let uuid: UUID
    public var points: [CGPoint]
    
    public init(uuid: UUID = UUID(), points: [CGPoint]) {
        self.uuid = uuid
        self.points = points
    }
    
    public func append(point: CGPoint) {
        self.points.append(point)
    }
    
    public func toJsonData() -> Data? {
        if let jsonData = try? JSONEncoder().encode(self) {
            return jsonData
        }
        return nil
    }
}

