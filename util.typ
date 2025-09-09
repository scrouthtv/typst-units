#let _next_prime(last) = {
  let has-divs = true
  while has-divs {
    last += 1
    has-divs = false

    for i in range(2, last) {
      if calc.rem(last, i) == 0 {
        has-divs = true
        break
      }
    }
  }

  return last
}

// Greatest common divisor of a & b.
// Both numbers must be positive.
// Implementation is based on the Euclidean algorithm:
#let _gcd(a, b) = {
  if a < 0 or b < 0 {
    panic("Both values must be positive.")
  }

  if a == 0 {
    return b
  } else if b == 0 {
    return a
  } else if a == b {
    return a
  }

  if a > b {
    if calc.rem(a, b) == 0 {
      return b
    } else {
      return gcd(a - b, b)
    }
  } else {
    if calc.rem(b, a) == 0 {
      return a
    } else {
      return gcd(a, b - a)
    }
  }
}

// Tests:
/*#gcd(48, 18)
#gcd(54, 24)
#gcd(42, 56)
#gcd(48, 180)
#gcd(20, 28)
#gcd(21, 13)
#gcd(13, 21)*/