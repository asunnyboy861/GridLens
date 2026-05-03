import ARKit
import RealityKit

final class ARGridRenderer {
    private weak var arView: ARView?
    private var gridEntities: [UUID: Entity] = [:]
    private var labelEntities: [UUID: [Entity]] = [:]

    init(arView: ARView) {
        self.arView = arView
    }

    func addGrid(on planeAnchor: ARPlaneAnchor, configuration: GridConfiguration) {
        removeGrid(for: planeAnchor.identifier)
        let gridEntity = createGridEntity(for: planeAnchor, configuration: configuration)
        arView?.scene.addAnchor(gridEntity)
        gridEntities[planeAnchor.identifier] = gridEntity
    }

    func updateGrid(on planeAnchor: ARPlaneAnchor, configuration: GridConfiguration) {
        removeGrid(for: planeAnchor.identifier)
        let gridEntity = createGridEntity(for: planeAnchor, configuration: configuration)
        arView?.scene.addAnchor(gridEntity)
        gridEntities[planeAnchor.identifier] = gridEntity
    }

    func removeAllGrids() {
        for (_, entity) in gridEntities {
            if let anchor = entity as? AnchorEntity {
                arView?.scene.removeAnchor(anchor)
            }
        }
        gridEntities.removeAll()
        labelEntities.removeAll()
    }

    private func removeGrid(for id: UUID) {
        if let entity = gridEntities[id] {
            if let anchor = entity as? AnchorEntity {
                arView?.scene.removeAnchor(anchor)
            }
            gridEntities.removeValue(forKey: id)
        }
        if let labels = labelEntities[id] {
            for label in labels {
                label.removeFromParent()
            }
            labelEntities.removeValue(forKey: id)
        }
    }

    private func createGridEntity(for planeAnchor: ARPlaneAnchor, configuration: GridConfiguration) -> AnchorEntity {
        let anchorEntity = AnchorEntity(anchor: planeAnchor)

        let gridSize = configuration.gridSize
        let extent = configuration.gridExtent
        let color = configuration.gridColor.uiColor
        let opacity = configuration.gridOpacity

        let halfExtent = extent / 2.0
        let lineCount = Int(extent / gridSize) + 1

        var lineIndex = 0
        for i in 0..<min(lineCount, 500) {
            let offset = -halfExtent + Float(i) * gridSize

            let lineX = createLine(
                from: SIMD3<Float>(offset, 0.001, -halfExtent),
                to: SIMD3<Float>(offset, 0.001, halfExtent),
                color: color,
                opacity: opacity
            )
            anchorEntity.addChild(lineX)

            let lineZ = createLine(
                from: SIMD3<Float>(-halfExtent, 0.001, offset),
                to: SIMD3<Float>(halfExtent, 0.001, offset),
                color: color,
                opacity: opacity
            )
            anchorEntity.addChild(lineZ)

            lineIndex += 2
            if lineIndex >= 500 { break }
        }

        if configuration.showLabels {
            let labels = createGridLabels(
                gridSize: gridSize,
                extent: extent,
                color: color,
                unit: configuration.unit
            )
            var labelList: [Entity] = []
            for label in labels {
                anchorEntity.addChild(label)
                labelList.append(label)
            }
            labelEntities[planeAnchor.identifier] = labelList
        }

        return anchorEntity
    }

    private func createLine(from: SIMD3<Float>, to: SIMD3<Float>, color: UIColor, opacity: Float) -> Entity {
        let distance = simd_distance(from, to)
        let direction = simd_normalize(to - from)
        let midpoint = (from + to) / 2

        let lineEntity = Entity()
        lineEntity.position = midpoint

        let mesh = MeshResource.generateBox(size: SIMD3<Float>(0.005, 0.001, distance))
        let material = SimpleMaterial(color: color.withAlphaComponent(CGFloat(opacity)), isMetallic: false)

        lineEntity.components.set(ModelComponent(mesh: mesh, materials: [material]))

        let rotation = simd_quatf(from: SIMD3<Float>(0, 0, 1), to: direction)
        lineEntity.orientation = rotation

        return lineEntity
    }

    private func createGridLabels(gridSize: Float, extent: Float, color: UIColor, unit: MeasurementUnit) -> [Entity] {
        var labels: [Entity] = []
        let halfExtent = extent / 2.0
        let lineCount = Int(extent / gridSize) + 1

        for i in stride(from: 0, to: min(lineCount, 20), by: max(1, lineCount / 10)) {
            let offset = -halfExtent + Float(i) * gridSize
            let converted = unit.convert(meters: Float(i) * gridSize)
            let text = String(format: "%.1f%@", converted, unit.rawValue)

            if let labelEntity = createTextEntity(text: text, position: SIMD3<Float>(offset, 0.002, -halfExtent - 0.1), color: color) {
                labels.append(labelEntity)
            }
        }

        return labels
    }

    private func createTextEntity(text: String, position: SIMD3<Float>, color: UIColor) -> Entity? {
        let mesh = MeshResource.generateText(
            text,
            extrusionDepth: 0.001,
            font: .monospacedSystemFont(ofSize: 0.05, weight: .regular),
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byWordWrapping
        )

        let material = SimpleMaterial(color: color, isMetallic: false)

        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.position = position
        entity.scale = SIMD3<Float>(1, 1, 1)

        return entity
    }
}
