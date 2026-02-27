import Foundation

struct OneComponentBateman {
    let t_half: Double
    let t_max: Double
    let c_max: Double
    
    private var eliminationRate: Double {
        log(2) / t_half
    }
    
    private var absorptionRate: Double? {
        let f: (Double) -> Double = { ka in
            log(ka / eliminationRate) / (ka - eliminationRate) - t_max
        }
        return brentq(f: f, a: eliminationRate * 1.001, b: eliminationRate * 200)
    }
    
    private var scaleFactor: Double? {
        guard let absorptionRate else { return nil }
        let divisor = (exp(-eliminationRate * t_max) - exp(-absorptionRate * t_max))
        guard divisor != 0 else { return 0 }
        return c_max / divisor
    }
    
    func getConcentrationAtTime(_ t: Double) -> Double? {
        guard t > 0 else { return 0 }
        guard let absorptionRate, let scaleFactor else { return nil }
        return scaleFactor * (exp(-eliminationRate * t) - exp(-absorptionRate * t))
    }
}

// AI generated version of Brent's method
// OneComponentBateman was tested in jupyter notebook before (brentq is part of SciPy)
// Swift version is just copied in the pharma model need fine tuning anyway
// This should be sufficient for a "Playground"
// TODO: Replace with own implementation of brentq, need to be async
private extension OneComponentBateman {
    func brentq(
        f: (Double) -> Double,
        a: Double,
        b: Double,
        tol: Double = 1e-8,
        maxIter: Int = 500
    ) -> Double? {
        var a = a, b = b
        var fa = f(a), fb = f(b)

        guard fa * fb < 0 else {
            print("Root not bracketed: f(a) and f(b) must have opposite signs")
            return nil
        }

        var c = a, fc = fa
        var d = b - a, e = d

        for _ in 0..<maxIter {
            if fb * fc > 0 {
                c = a; fc = fa
                d = b - a; e = d
            }
            if abs(fc) < abs(fb) {
                let tempA = a, tempFa = fa
                a = b; fa = fb
                b = c; fb = fc
                c = tempA; fc = tempFa
            }

            let tol1 = 2.0 * Double.ulpOfOne * abs(b) + 0.5 * tol
            let xm = 0.5 * (c - b)

            if abs(xm) <= tol1 || fb == 0 { return b }

            if abs(e) >= tol1 && abs(fa) > abs(fb) {
                let s = fb / fa
                var p: Double
                var q: Double
                if a == c {
                    p = 2.0 * xm * s
                    q = 1.0 - s
                } else {
                    let qRatio = fa / fc
                    let r = fb / fc
                    p = s * (2.0 * xm * qRatio * (qRatio - r) - (b - a) * (r - 1.0))
                    q = (qRatio - 1.0) * (r - 1.0) * (s - 1.0)
                }
                if p > 0 { q = -q } else { p = -p }
                if 2.0 * p < min(3.0 * xm * q - abs(tol1 * q), abs(e * q)) {
                    e = d; d = p / q
                } else {
                    d = xm; e = d
                }
            } else {
                d = xm; e = d
            }

            a = b; fa = fb
            b += abs(d) > tol1 ? d : (xm > 0 ? tol1 : -tol1)
            fb = f(b)
        }

        return b
    }
}
