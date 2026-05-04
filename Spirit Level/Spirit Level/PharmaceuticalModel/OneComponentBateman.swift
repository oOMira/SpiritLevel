import Foundation

struct OneComponentBateman {
    let halfLife: Double
    let peakTime: Double
    let peakConcentration: Double

    private var eliminationRate: Double {
        log(2) / halfLife
    }

    private var absorptionRate: Double? {
        let concentrationDelta: (Double) -> Double = { absorptionRate in
            log(absorptionRate / eliminationRate) / (absorptionRate - eliminationRate) - peakTime
        }
        return brentq(
            function: concentrationDelta,
            lowerBound: eliminationRate * 1.001,
            upperBound: eliminationRate * 200
        )
    }

    private var scaleFactor: Double? {
        guard let absorptionRate else { return nil }
        let divisor = exp(-eliminationRate * peakTime) - exp(-absorptionRate * peakTime)
        guard divisor != 0 else { return 0 }
        return peakConcentration / divisor
    }

    func getConcentrationAtTime(_ time: Double) -> Double? {
        guard time > 0 else { return 0 }
        guard let absorptionRate, let scaleFactor else { return nil }
        return scaleFactor * (exp(-eliminationRate * time) - exp(-absorptionRate * time))
    }
}

// AI-generated version of Brent's method.
// `OneComponentBateman` was previously tested in a Jupyter notebook (`brentq` is part of SciPy).
// The pharmacokinetic model needs fine-tuning anyway.
// This should be sufficient for a playground.
// Note: This can be replaced with a dedicated implementation if numerical tuning is needed later.
private extension OneComponentBateman {
    struct BrentState {
        var intervalStart: Double
        var intervalEnd: Double
        var functionAtStart: Double
        var functionAtEnd: Double
        var previousPoint: Double
        var functionAtPreviousPoint: Double
        var stepSize: Double
        var previousStepSize: Double
    }

    func brentq(
        function: (Double) -> Double,
        lowerBound: Double,
        upperBound: Double,
        tol: Double = 1e-8,
        maxIter: Int = 500
    ) -> Double? {
        var state = makeInitialState(
            lowerBound: lowerBound,
            upperBound: upperBound,
            function: function
        )

        guard state.functionAtStart * state.functionAtEnd < 0 else {
            return nil
        }

        for _ in 0..<maxIter {
            updateBracket(for: &state)
            reorderEndpointsIfNeeded(for: &state)

            let tolerance = convergenceTolerance(for: state.intervalEnd, tol: tol)
            let midpointOffset = 0.5 * (state.previousPoint - state.intervalEnd)

            if abs(midpointOffset) <= tolerance || state.functionAtEnd == 0 {
                return state.intervalEnd
            }

            updateStep(
                for: &state,
                midpointOffset: midpointOffset,
                tolerance: tolerance
            )
            advance(
                state: &state,
                midpointOffset: midpointOffset,
                tolerance: tolerance,
                function: function
            )
        }

        return state.intervalEnd
    }

    func makeInitialState(
        lowerBound: Double,
        upperBound: Double,
        function: (Double) -> Double
    ) -> BrentState {
        let functionAtStart = function(lowerBound)
        let functionAtEnd = function(upperBound)
        let stepSize = upperBound - lowerBound
        return BrentState(
            intervalStart: lowerBound,
            intervalEnd: upperBound,
            functionAtStart: functionAtStart,
            functionAtEnd: functionAtEnd,
            previousPoint: lowerBound,
            functionAtPreviousPoint: functionAtStart,
            stepSize: stepSize,
            previousStepSize: stepSize
        )
    }

    func convergenceTolerance(for intervalEnd: Double, tol: Double) -> Double {
        2.0 * Double.ulpOfOne * abs(intervalEnd) + 0.5 * tol
    }

    func updateBracket(for state: inout BrentState) {
        guard state.functionAtEnd * state.functionAtPreviousPoint > 0 else { return }
        state.previousPoint = state.intervalStart
        state.functionAtPreviousPoint = state.functionAtStart
        state.stepSize = state.intervalEnd - state.intervalStart
        state.previousStepSize = state.stepSize
    }

    func reorderEndpointsIfNeeded(for state: inout BrentState) {
        guard abs(state.functionAtPreviousPoint) < abs(state.functionAtEnd) else { return }
        let previousIntervalStart = state.intervalStart
        let previousFunctionAtStart = state.functionAtStart
        state.intervalStart = state.intervalEnd
        state.functionAtStart = state.functionAtEnd
        state.intervalEnd = state.previousPoint
        state.functionAtEnd = state.functionAtPreviousPoint
        state.previousPoint = previousIntervalStart
        state.functionAtPreviousPoint = previousFunctionAtStart
    }

    func updateStep(
        for state: inout BrentState,
        midpointOffset: Double,
        tolerance: Double
    ) {
        guard abs(state.previousStepSize) >= tolerance,
              abs(state.functionAtStart) > abs(state.functionAtEnd) else {
            state.stepSize = midpointOffset
            state.previousStepSize = state.stepSize
            return
        }

        let interpolationStep = interpolationStep(for: state, midpointOffset: midpointOffset)
        if let interpolationStep, shouldUseInterpolationStep(
            interpolationStep,
            state: state,
            midpointOffset: midpointOffset,
            tolerance: tolerance
        ) {
            state.previousStepSize = state.stepSize
            state.stepSize = interpolationStep
        } else {
            state.stepSize = midpointOffset
            state.previousStepSize = state.stepSize
        }
    }

    func interpolationStep(for state: BrentState, midpointOffset: Double) -> Double? {
        let slopeRatio = state.functionAtEnd / state.functionAtStart
        var numerator: Double
        var denominator: Double

        if state.intervalStart == state.previousPoint {
            numerator = 2.0 * midpointOffset * slopeRatio
            denominator = 1.0 - slopeRatio
        } else {
            let previousSlopeRatio = state.functionAtStart / state.functionAtPreviousPoint
            let endSlopeRatio = state.functionAtEnd / state.functionAtPreviousPoint
            numerator = slopeRatio * (
                2.0 * midpointOffset * previousSlopeRatio * (previousSlopeRatio - endSlopeRatio) -
                (state.intervalEnd - state.intervalStart) * (endSlopeRatio - 1.0)
            )
            denominator = (previousSlopeRatio - 1.0) *
                (endSlopeRatio - 1.0) *
                (slopeRatio - 1.0)
        }

        guard denominator != 0 else { return nil }
        if numerator > 0 {
            denominator = -denominator
        } else {
            numerator = -numerator
        }
        return numerator / denominator
    }

    func shouldUseInterpolationStep(
        _ interpolationStep: Double,
        state: BrentState,
        midpointOffset: Double,
        tolerance: Double
    ) -> Bool {
        let slopeRatio = state.functionAtEnd / state.functionAtStart
        let signedDenominator = slopeRatio == 1.0 ? 1.0 : abs(interpolationStep) > 0 ? 1.0 : 1.0
        let numerator = abs(interpolationStep * signedDenominator)
        return 2.0 * numerator < min(
            3.0 * midpointOffset * signedDenominator - abs(tolerance * signedDenominator),
            abs(state.previousStepSize * signedDenominator)
        )
    }

    func advance(
        state: inout BrentState,
        midpointOffset: Double,
        tolerance: Double,
        function: (Double) -> Double
    ) {
        state.intervalStart = state.intervalEnd
        state.functionAtStart = state.functionAtEnd
        state.intervalEnd += abs(state.stepSize) > tolerance
            ? state.stepSize
            : (midpointOffset > 0 ? tolerance : -tolerance)
        state.functionAtEnd = function(state.intervalEnd)
    }
}
