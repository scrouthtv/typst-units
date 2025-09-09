#import "util.typ": _next_prime, _gcd

// Each quantity is defined by
// a) A numerical value.
// b) An implicit value, that is already contained within the unit, e.g.
//    1 inch has an implicit value of 0.0254 (meter).
// c) A fractional unit. Both nominator and divisor are stored as products
//    of the base units, which are represented by prime numbers.
//    It is therefore possible, to simplify the fractional unit and
//    also determine the base units that it is made up of.
// d) A textual representation of the unit. The unit symbols are taken from
//    the unify package, and spaces are inserted after every unit (but not
//    prefixes!). Powers are inserted like "mm^2" and fractions like "/s".
//    This is helpful for formatting the quantities with unify.
//
// Quantities may be calculated with (multiplication, division, exponential).
// Furthermore, a quantity may be rendered using `unify`.
#let unity = (value: 1.0, iv: 1.0, nid: 1, did: 1, format: "")

// Getters:
#let _value(x) = {
  if type(x) == int or type(x) == float {
    return x
  } else if type(x) == dictionary {
    return x.at("value", default: 1)
  } else {
    panic("Unknown format, type is " + str(type(x)) + "! If in math mode, make sure to escape number.")
  }
}

#let _iv(x) = {
  if type(x) == int or type(x) == float {
    return 1
  } else if type(x) == dictionary {
    return x.at("iv", default: 1)
  } else {
    panic("Unknown format! If in math mode, make sure to escape number.")
  }
}

#let _nid(x) = {
  if type(x) == int or type(x) == float {
    return 1
  } else if type(x) == dictionary {
    return x.at("nid", default: 1)
  } else {
    panic("Unknown format! If in math mode, make sure to escape number.")
  }
}

#let _did(x) = {
  if type(x) == int or type(x) == float {
    return 1
  } else if type(x) == dictionary {
    return x.at("did", default: 1)
  } else {
    panic("Unknown format! If in math mode, make sure to escape number.")
  }
}

#let _format(x) = {
  if type(x) == int or type(x) == float {
    return ""
  } else if type(x) == dictionary {
    return x.at("format", default: " ")
  } else {
    panic("Unknown format! If in math mode, make sure to escape number.")
  }
}

// Create a new unit which is specified by its quantity and a different
// format. For example
// let minute = _define_unit(multiply(60, second), "min ")
#let define_unit(qty, format) = {
  qty.iv = _iv(qty) * _value(qty)
  qty.value = 1
  qty.format = format
  return qty
}

// Formatting

// Invert a textual unit, e. g. "kg m /s" becomes
// "/kg m /s"
#let _invert_format(txt) = {
  // 1. Insert slashes in front of every unit:
  txt = "/" + txt.replace(" ", " /")

  // 2. Remove extra slash at the end.
  txt = txt.slice(0, -1)

  // 3. Prune double slashes:
  return txt.replace("//", "")
}

// Power a textual unit, e. g. "kg m^2" becomes "kg^3 m^6".
// Extra exponents are introduced
// before every space and at the end.
#let _pow_format(txt, exp) = {
  let _pat = regex("[0-9]+")

  txt = txt.split(" ").slice(0, -1)
  let new = ""

  for unit in txt {
    let last-exp = unit.find(_pat)
    if last-exp == none {
      unit += "^" + str(exp)
    } else {
      let new-exp = str(int(last-exp) * exp)
      unit = unit.replace(last-exp, new-exp)
    }

    new += unit + " "
  }

  return new
}

// Maths
#let multiply(..num) = {
  let result = unity

  for n in num.pos() {
    result.value *= _value(n)
    result.iv *= _iv(n)
    result.nid *= _nid(n)
    result.did *= _did(n)
    result.format += _format(n)
  }

  return result
}

#let divide(a, b) = {
  let result = unity

  result.value = _value(a) / _value(b)
  result.iv = _iv(a) / _iv(b)
  result.nid = _nid(a) * _did(b)
  result.did = _did(a) * _nid(b)
  result.format = _format(a) + _invert_format(_format(b))

  return result
}

#let pow(a, exp) = {
  let result = unity

  result.value = calc.pow(_value(a), exp)
  result.iv = calc.pow(_iv(a), exp)
  result.nid = calc.pow(_nid(a), exp)
  result.did = calc.pow(_did(a), exp)
  result.format = _pow_format(_format(a), exp)

  return result
}

#let value-in(num, unit) = {
  if type(unit) == dictionary {
    unit.value = 1
  }

  let result = divide(num, unit)

  if result.nid != result.did {
    panic("Units do not match!")
  }

  return result.value * (_iv(num) / _iv(unit))
}

#let add(a, ..num) = {
  let result = a

  for n in num.pos() {
    result.value += value-in(n, a)
  }

  return result
}

#let subtract(a, b) = {
  a.value -= value-in(b, a)
  return a
}

// Utility Functions
#let simplify(num) = {
  // Simplify unit fraction:
  let gcd = _gcd(nid(num), did(num))
  num.nid = nid(num) / gcd
  num.did = did(num) / gcd

  return num
}

// Displays a quantity.
#let fmt(num, unit: auto, digits: auto) = {
  if unit == auto {
    unit = num
  }

  let val = value-in(num, unit)
  if digits != auto {
    val = calc.round(val, digits: digits)
  }

  return (val, _format(unit).trim())
}
