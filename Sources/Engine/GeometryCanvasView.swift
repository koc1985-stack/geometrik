import Foundation
import SwiftUI

/// Bir dersin animasyonunu çizen tek motor. `player.revealedSteps` neyin görüneceğini,
/// `player.lesson.steps` (tam liste) ise nokta konumlarının sabit referans tablosunu belirler -
/// bir doğru parçası her zaman daha önce eklenmiş iki noktayı birleştirir, bu yüzden konumları
/// tam listeden çözüyoruz, sadece görünürlüğü `revealedSteps`'ten alıyoruz.
struct GeometryCanvasView: View {
    let player: GeometryStepPlayer

    private var pointPositions: [String: GeoPoint] {
        var positions: [String: GeoPoint] = [:]
        for step in player.lesson.steps {
            if case let .addPoint(position, _) = step.kind {
                positions[step.id] = position
            }
        }
        return positions
    }

    private var highlightedIds: Set<String> {
        var ids: Set<String> = []
        for step in player.revealedSteps {
            if case let .highlight(targetIds) = step.kind {
                ids = Set(targetIds)
            }
        }
        return ids
    }

    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            ZStack {
                ForEach(player.revealedSteps) { step in
                    stepView(for: step, size: size)
                }
            }
            .frame(width: size.width, height: size.height)
        }
        .aspectRatio(1, contentMode: .fit)
    }

    @ViewBuilder
    private func stepView(for step: GeometryStep, size: CGSize) -> some View {
        switch step.kind {
        case let .addPoint(position, label):
            PointMarkerView(
                position: position.toPoint(in: size),
                label: label,
                isHighlighted: highlightedIds.contains(step.id)
            )

        case let .drawSegment(fromId, toId):
            if let from = pointPositions[fromId]?.toPoint(in: size),
                let to = pointPositions[toId]?.toPoint(in: size)
            {
                SegmentRevealView(
                    from: from,
                    to: to,
                    isHighlighted: highlightedIds.contains(step.id)
                )
            }

        case let .drawArc(centerId, radius, startDegrees, endDegrees, label):
            if let center = pointPositions[centerId]?.toPoint(in: size) {
                ArcRevealView(
                    center: center,
                    radius: radius * min(size.width, size.height),
                    startDegrees: startDegrees,
                    endDegrees: endDegrees,
                    label: label,
                    isHighlighted: highlightedIds.contains(step.id)
                )
            }

        case let .showLabel(text, at):
            Text(text)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(Theme.gold)
                .position(at.toPoint(in: size))
                .transition(.opacity.combined(with: .scale(scale: 0.7)))

        case .highlight:
            EmptyView()
        }
    }
}

private extension GeoPoint {
    func toPoint(in size: CGSize) -> CGPoint {
        CGPoint(x: x * size.width, y: y * size.height)
    }
}

// MARK: - Alt bileşenler

private struct PointMarkerView: View {
    let position: CGPoint
    let label: String?
    let isHighlighted: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(isHighlighted ? Theme.gold : Color.white)
                .frame(width: 9, height: 9)
                .overlay(Circle().stroke(Theme.gold.opacity(0.6), lineWidth: 1.5))

            if let label {
                Text(label)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .offset(x: labelOffset(for: position).width, y: labelOffset(for: position).height)
            }
        }
        .position(position)
        .transition(.scale(scale: 0.01).combined(with: .opacity))
    }

    /// Etiketi noktanın üstüne/altına, kanvasın hangi yarısında olduğuna göre kabaca yerleştirir.
    private func labelOffset(for position: CGPoint) -> CGSize {
        CGSize(width: 14, height: -14)
    }
}

private struct SegmentRevealView: View {
    let from: CGPoint
    let to: CGPoint
    let isHighlighted: Bool
    @State private var revealed = false

    var body: some View {
        Path { path in
            path.move(to: from)
            path.addLine(to: to)
        }
        .trim(from: 0, to: revealed ? 1 : 0)
        .stroke(
            isHighlighted ? Theme.gold : Color.white.opacity(0.85),
            style: StrokeStyle(lineWidth: isHighlighted ? 3 : 2, lineCap: .round)
        )
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) { revealed = true }
        }
    }
}

private struct ArcRevealView: View {
    let center: CGPoint
    let radius: Double
    let startDegrees: Double
    let endDegrees: Double
    let label: String?
    let isHighlighted: Bool
    @State private var revealed = false

    var body: some View {
        ZStack {
            Path { path in
                path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: .degrees(startDegrees),
                    endAngle: .degrees(endDegrees),
                    clockwise: false
                )
            }
            .trim(from: 0, to: revealed ? 1 : 0)
            .stroke(
                isHighlighted ? Theme.gold : Color.purpleAccent,
                style: StrokeStyle(lineWidth: 2, lineCap: .round)
            )

            if let label {
                let midAngle = Angle.degrees((startDegrees + endDegrees) / 2).radians
                let labelRadius = radius + 16
                Text(label)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.purpleAccent)
                    .position(
                        x: center.x + labelRadius * Foundation.cos(midAngle),
                        y: center.y + labelRadius * Foundation.sin(midAngle)
                    )
                    .opacity(revealed ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) { revealed = true }
        }
    }
}
