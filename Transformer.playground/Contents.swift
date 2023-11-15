import Foundation
import simd

// NO ERROR CHECKING IS PERFORMED ON THE RECTANGLES.
// IF THE SET OF POINTS PROVIDED DO NOT FORM A VALID RECTANGLE, THE CODE MAY CRASH OR RETURN GARBAGE.
//
// REQUIREMENT: Corners 2 and 3 are adjacent to corner 1, and corner 4 is opposite corner 1.
//
// HINT: If your test points don't wind up where you expect, you specified one rectangle clockwise and the other rectangle counter-clockwise.

class Transformer {

    // MARK: Type definitions

    typealias Point = (x: Double, y: Double)
    typealias Rectangle = (corner1: Point, corner2: Point, corner3: Point, corner4: Point)

    // MARK: Initializer

    init(rectangleInGrid1 rect1: Rectangle, rectangleInGrid2 rect2: Rectangle) {
        self.rect1 = rect1
        self.rect2 = rect2
    }

    // MARK: Public methods

    func transformFromGrid1ToGrid2(_ point: Point) -> Point {
        return transform(point: point, matrix: matrix1To2)
    }

    func transformFromGrid2ToGrid1(_ point: Point) -> Point {
        return transform(point: point, matrix: matrix2To1)
    }

    // MARK: Private methods

    private func transform(point: Point, matrix: simd_double3x3) -> Point {
        let vector = simd_double3(point.x, point.y, 1.0)
        let transformedVector = matrix * vector
        let transformedPoint = Point(x: transformedVector.x, y: transformedVector.y)
        return transformedPoint
    }

    private lazy var matrix1To2: simd_double3x3 = {
        return translationOfRect2 * rotationOfRect2 * scaleOfRect2 * reflectionOfRect2 * reflectionOfRect1.inverse * scaleOfRect1.inverse * rotationOfRect1.inverse * translationOfRect1.inverse
    }()

    private lazy var matrix2To1: simd_double3x3 = matrix1To2.inverse

    private lazy var translationOfRect1 = translationFromOrigin(rect1)
    private lazy var rotationOfRect1 = rotationFromCanonical(rect1)
    private lazy var scaleOfRect1 = scaleFromUnitSize(rect1)
    private lazy var reflectionOfRect1 = reflection(rect1, translationMatrix: translationOfRect1, rotationMatrix: rotationOfRect1)

    private lazy var translationOfRect2 = translationFromOrigin(rect2)
    private lazy var rotationOfRect2 = rotationFromCanonical(rect2)
    private lazy var scaleOfRect2 = scaleFromUnitSize(rect2)
    private lazy var reflectionOfRect2 = reflection(rect2, translationMatrix: translationOfRect2, rotationMatrix: rotationOfRect2)

    private func translationFromOrigin(_ rect: Rectangle) -> simd_double3x3 {
        let rows = [
            simd_double3(1.0, 0.0, rect.corner1.x),
            simd_double3(0.0, 1.0, rect.corner1.y),
            simd_double3(0.0, 0.0, 1.0)
        ]

        let matrix = double3x3(rows: rows)
        return matrix
    }

    private func rotationFromCanonical(_ rect: Rectangle) -> simd_double3x3 {
        let rise = rect.corner2.y - rect.corner1.y
        let run = rect.corner2.x - rect.corner1.x
        let distance = distance(simd_double2(rect.corner1.x, rect.corner1.y), simd_double2(rect.corner2.x, rect.corner2.y))

        let sin = rise / distance
        let cos = run / distance

        let rows = [
            simd_double3(cos, -sin, 0.0),
            simd_double3(sin, cos, 0.0),
            simd_double3(0.0, 0.0, 1.0)
        ]

        let matrix = double3x3(rows: rows)
        return matrix
    }

    private func scaleFromUnitSize(_ rect: Rectangle) -> simd_double3x3 {
        let length = distance(simd_double2(rect.corner1.x, rect.corner1.y), simd_double2(rect.corner2.x, rect.corner2.y))
        let width = distance(simd_double2(rect.corner1.x, rect.corner1.y), simd_double2(rect.corner3.x, rect.corner3.y))

        let scaleX = length
        let scaleY = width

        let rows = [
            simd_double3(scaleX, 0.0, 0.0),
            simd_double3(0.0, scaleY, 0.0),
            simd_double3(0.0, 0.0, 1.0)
        ]

        let matrix = double3x3(rows: rows)
        return matrix
    }

    private func reflection(_ rect: Rectangle, translationMatrix: double3x3, rotationMatrix: double3x3) -> double3x3 {
        let corner4 = rect.corner4
        let partialTransformMatrix = rotationMatrix.inverse * translationMatrix.inverse
        let transformedCorner4 = transform(point: corner4, matrix: partialTransformMatrix)

        let rows = [
            simd_double3(sign(transformedCorner4.x), 0.0, 0.0),
            simd_double3(0.0, sign(transformedCorner4.y), 0.0),
            simd_double3(0.0, 0.0, 1.0)
        ]

        let matrix = double3x3(rows: rows)
        return matrix
    }

    // MARK: Private properties

    private let rect1: Rectangle
    private let rect2: Rectangle
}

// MARK: - Tests

let transformer = Transformer(rectangleInGrid1: ((0, 0), (0, 1), (1, 0), (1, 1)), rectangleInGrid2: ((205, -55), (385, -55), (205, 160), (385, 160)))

func test1(_ point: Transformer.Point) {
    let transformedPoint = transformer.transformFromGrid1ToGrid2(point)
    print("Point \(point) in grid 1 -> \(transformedPoint) in grid 2")
}

func test2(_ point: Transformer.Point) {
    let transformedPoint = transformer.transformFromGrid2ToGrid1(point)
    print("Point \(point) in grid 2 -> \(transformedPoint) in grid 1")
}

test1((0, 0))
test1((0, 1))
test1((1, 0))
test1((1, 1))

test2((205, -55))
test2((385, -55))
test2((205, 160))
test2((385, 160))
