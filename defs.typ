#import "lib.typ":_next_prime, multiply, divide, pow, define_unit

// Prefixes. Consider adding deca, hecto
#let quetta = (iv: 1e30, format: "Q")
#let ronna = (iv: 1e27, format: "R")
#let yotta = (iv: 1e24, format: "Y")
#let zetta = (iv: 1e21, format: "Z")
#let exa = (iv: 1e18, format: "E")
#let peta = (iv: 1e15, format: "P")
#let tera = (iv: 1e12, format: "T")
#let giga = (iv: 1e9, format: "G")
#let mega = (iv: 1e6, format: "M")
#let kilo = (iv: 1e3, format: "k")
#let deci = (iv: 1e-1, format: "d")
#let centi = (iv: 1e-2, format: "c")
#let percent = (iv: 0.01, format: "% ")
#let milli = (iv: 1e-3, format: "m")
#let micro = (iv: 1e-6, format: "u")
#let nano = (iv: 1e-9, format: "n")
#let pico = (iv: 1e-12, format: "p")
#let femto = (iv: 1e-15, format: "f")
#let atto = (iv: 1e-18, format: "a")
#let zepto = (iv: 1e-21, format: "z")
#let yocto = (iv: 1e-24, format: "y")
#let ronto = (iv: 1e-27, format: "r")
#let quecto = (iv: 1e-30, format: "q")

// Base Units
#let second = (nid: _next_prime(1), format: "s ")
#let meter = (nid: _next_prime(second.nid), format: "m ")
#let kilogram = (iv: 1e3, nid: _next_prime(meter.nid), format: "kg ")
#let ampere = (nid: _next_prime(kilogram.nid), format: "A ")
#let kelvin = (nid: _next_prime(ampere.nid), format: "K ")
#let mole = (nid: _next_prime(kelvin.nid), format: "mol ")
#let candela = (nid: _next_prime(mole.nid), format: "cd ")

// Derived Units: Mechanical Units
#let newton = define_unit(multiply(kilogram, divide(meter, pow(second, 2))), "N ")
#let pascal = define_unit(divide(newton, pow(meter, 2)), "Pa ")
#let joule = define_unit(multiply(newton, meter), "J ")

// Derived Units: Electrical Units
#let watt = define_unit(divide(joule, second), "W ")
#let volt = define_unit(divide(watt, ampere), "V ")
#let coulomb = define_unit(multiply(ampere, second), "C ")
#let farad = define_unit(divide(coulomb, volt), "F ")
#let ohm = define_unit(divide(volt, ampere), "O ")
#let henry = define_unit(divide(multiply(volt, second), ampere), "H ")

// Derived Units: Time Units
#let hertz = define_unit(divide(1, second), "Hz ")
#let minute = define_unit(multiply(60, second), "min ")
#let hour = define_unit(multiply(60, minute), "h ")
#let day = define_unit(multiply(24, hour), "d ")
#let year = define_unit(multiply(365, day), "yr ")
