#import "lib.typ": *
#import "defs.typ": *
#import "@preview/unify:0.7.1": qty, add-unit

#set heading(numbering: "1.")
#set par(justify: true)

#let result(body) = box(width: 100%, stroke: (left: gray + 2pt),
  inset: (left: 8pt, top: 5pt, bottom: 5pt), outset: (left: -2pt),
  [#body])

// ============================================================================
= Basic Conversions
This package defines units, e. g. `#kilogram` or `#watt`.
It is possible to define custom shorthands for units as well as custom quantities:
```typc
let kwh = multiply(kilo, watt, hour)
let mj = multiply(mega, joule)
let myenergyqty = multiply(15, kwh)
```


#let kwh = multiply(kilo, watt, hour)
#let mj = multiply(mega, joule)
#let myenergyqty = multiply(15, kwh)
As you saw here, each unit already has an implicit value of `1`.

Using the `value-in(qty, unit)` function, a quantity is converted to another unit, provided that the physical dimensions are equal:

#result(value-in(myenergyqty, mj))

Furthermore, units may be prepared for formatting using the `fmt(qty, unit, digits)` function.
The resulting strings can then be passed to Christian Hecker's `unify` package @unify which provides the formatting function (`qty`):
```typc
import "@preview/unify:0.7.1": qty
$qty(..fmt(myenergyqty)) = qty(..fmt(myenergyqty, unit: mj))$
```
#result($qty(..fmt(myenergyqty)) = qty(..fmt(myenergyqty, unit: mj))$)

If no unit for formatting is specified, we use the unit, that was originally used for defining the quantity.

The result may be automatically rounded to a specified number of digits:
```typc
let ms2 = divide(meter, pow(second, 2))
let mygravity = multiply(9.80665, ms2)
$qty(..fmt(mygravity)) approx #qty(..fmt(mygravity, digits: 1))$
//                           ^^^ make sure to add
```
#result[
  #let ms2 = divide(meter, pow(second, 2))
  #let mygravity = multiply(9.80665, ms2)
  $qty(..fmt(mygravity)) approx #qty(..fmt(mygravity, digits: 1))$
]

Note that typst parses numbers inside math mode as content.
However, we cannot use content as an argument to any of the functions.
To correct for the wrong parsing, either

- begin one of the function calls with `#`
- escape the number with `#`

We can also perform maths using the `add`, `subtract`, `multiply`, `divide`, `pow` functions:

```typc
let myvolt = multiply(115, volt)
let myohm = multiply(220, kilo, ohm)
let mycurrent = divide(myvolt, myohm)

When applying
#qty(..fmt(myvolt))
on a
#qty(..fmt(myohm, unit: multiply(mega, ohm)))
resistor, the current is
#qty(..fmt(mycurrent, unit: multiply(milli, ampere), digits: 3))
```
#let myvolt = multiply(115, volt)
#let myohm = multiply(220, kilo, ohm)
#let mycurrent = divide(myvolt, myohm)

#result[When applying #qty(..fmt(myvolt)) on a #qty(..fmt(myohm, unit: multiply(mega, ohm))) resistor,
the current is #qty(..fmt(mycurrent, unit: multiply(milli, ampere), digits: 3)).]

// ============================================================================
#pagebreak()
= A Complete Example: Switching Converter

== Context
#let vi = multiply(5, volt)
#let vo = multiply(2200, milli, volt)
#let dcycle = divide(vo, vi)
#let fs = multiply(300, kilo, hertz)
#let io = multiply(10, ampere)
#let cr = multiply(30, percent)
#let ir = multiply(io, cr)
#let dvo = multiply(10, milli, volt)

When calculating switching converters, there are many units and even more prefixes.
In this example, we will calculate an exemplary switching calculator:
- Input voltage is given as $V_I = qty(..fmt(vi))$
- Output voltage is given as $V_O = qty(..fmt(vo)) = qty(..fmt(vo, unit: volt))$
- Switching frequency is determined by the controller which uses $f_S = qty(..fmt(fs))$
- Output current is given as $I = qty(..fmt(io))$ and inductor current ripple ratio shall be $C R = qty(..fmt(cr))$ @buck-analog
- The output voltage ripple shall be less than $Delta V_O = qty(..fmt(dvo))$.

== Basics
First, we define all our known values. From there, we can already perform some basic calculations:
```typc
let vi = multiply(5, volt)
let vo = multiply(2200, milli, volt)
let fs = multiply(300, kilo, hertz)
let io = multiply(10, ampere)
let cr = multiply(30, percent)

let dcycle = divide(vo, vi)
let ir = multiply(io, cr)

The duty cycle can be calculated to $D = V_O/V_I = qty(..fmt(dcycle, unit: #1))$.

The current ripple would be $Delta I_L = qty(..fmt(ir, unit: ampere))$.
```

#result[
The duty cycle can be calculated to $D = V_O/V_I = qty(..fmt(dcycle, unit: #1))$.

The current ripple would be $Delta I_L = qty(..fmt(ir, unit: ampere))$.
]

== Complex Calculations
Calculation of the inductance and output capacitor is a more complex calculation @buck-ti:
$ L = (D (V_I - V_O))/(Delta I_L f_S) quad quad quad
C_O = (Delta I_L)/(8 f_S Delta V_O) $

```typc
let inductance = divide(multiply(dcycle, subtract(vi, vo)), multiply(ir, fs))
let capacitance = divide(ir, multiply(8, fs, dvo))
```
#let inductance = divide(multiply(dcycle, subtract(vi, vo)), multiply(ir, fs))
#let capacitance = divide(ir, multiply(8, fs, dvo))

With a simple calculator, one would get results such as
$ L &= qty(..fmt(inductance)) \
C_O &= qty(..fmt(capacitance)) $

Which this library can simply convert using:
```typc
$ L &= qty(..fmt(inductance, unit: multiply(micro, henry), digits: #3)) \
C_O &= qty(..fmt(capacitance, unit: multiply(micro, farad), digits: #3)) $
```
#result[$ L &= qty(..fmt(inductance, unit: multiply(micro, henry), digits: #3)) \
C_O &= qty(..fmt(capacitance, unit: multiply(micro, farad), digits: #3)) $]

// ============================================================================
= Example: Stress Analysis
#let height = multiply(140, milli, meter)
#let width = multiply(120, milli, meter)
#let thick = multiply(8, milli, meter)
#let length = multiply(3, meter)
#let force = multiply(16, kilo, newton)
#let yield = multiply(355, mega, pascal)

#columns(2)[
#include "ibeam.typ"  // Show a little picture
#colbreak()

A simple I beam is defined using
- Height $H = qty(..fmt(height))$
- Width $W = qty(..fmt(width))$
- Constant thickness $t = qty(..fmt(thick)) << H, W$
- Beam length $l = qty(..fmt(length))$
- Applied force at the end $F = qty(..fmt(force))$
- Yield strength $sigma_y = qty(..fmt(yield))$ (S355 material)
]

The area moment of inertia may be approximated in thin-walled profiles like this:
$ I_(y y) &= integral x^2 dif a = t integral x^2 dif s \
&= 2 t integral_(-W/2)^(+W/2) s^2 dif s
= 2 t [1/3 s^3]_(-W/2)^(+W/2) = 2t dot 1/3 dot 2 dot W^3/8
= underline(underline((W^3 t)/6))
$

As well as $
I_(z z) &= t integral y^2 dif s
/*&= t (2 dot H^2/4 integral_(-W/2)^(+W/2) dif s + integral_(-H/2)^(+H/2) s^2 dif s) \
&= t (2 dot H^2/4 W + 1/3 [s^3]_(-W/2)^(+W/2)) \*/
= t ((W H^2)/2 + 1/3 dot 2 dot W^3/8) = underline(underline((W H^2 t)/2 + (W^3 t)/12))
$

#let iyy = divide(multiply(pow(width, 3), thick), 6)
#let izz = add(divide(multiply(width, pow(height, 2), thick), 2),
  divide(multiply(pow(width, 3), thick), 12))
#let mm4 = pow(multiply(milli, meter), 4)

Using the specific sizes, we calculate
$I_(y y) = qty(..fmt(iyy, unit: mm4, digits: #0))$ and $I_(z z) = qty(..fmt(izz, unit: mm4, digits: #0))$.

#let wy = multiply(iyy, divide(2, width))
#let wz = multiply(izz, divide(2, height))
#let mm3 = pow(multiply(milli, meter), 3)

The section modulus measures the resistance against a bending moment:
$W_y = I_(y y)/(W\/2) = qty(..fmt(wy, unit: mm3, digits: #0))$ and
$W_z = I_(y y)/(H\/2) = qty(..fmt(wz, unit: mm3, digits: #0))$.

#let stress = divide(multiply(force, length), wz)
#let mpa = multiply(mega, pascal)
Now we can calculate the stress under load: $sigma = M/W = (F dot l)/W
= qty(..fmt(stress, unit: mpa, digits: #0))$.

#let reserve = divide(yield, stress)
In this scenario, the reserve factor were
$R F = "strength"/"load" = qty(..fmt(reserve, unit: percent, digits: #1))$.

// ============================================================================
#pagebreak()
= Defining Custom Units

== Defining Imperial Units

We can define custom units based on existing units using `define_unit`:
```typc
let inch = define_unit(multiply(25.4, milli, meter), "in ")
let foot = define_unit(multiply(12, inch), "ft ")
let yard = define_unit(multiply(3, foot), "yd ")
let mile = define_unit(multiply(1760, yard), "mi ")
```
Furthermore, when introducing new units, make sure that they either exist in `unify`, or that you register them there as well @unify:
```typc
import "@preview/unify:0.7.1": add-unit
add-unit("inch", "in", "upright(\"in\")")
add-unit("feet", "ft", "upright(\"ft\")")
add-unit("yard", "yd", "upright(\"yd\")")
add-unit("mile", "mi", "upright(\"mi\")")
```

#let inch = define_unit(multiply(25.4, milli, meter), "in ")
#let foot = define_unit(multiply(12, inch), "ft ")
#let yard = define_unit(multiply(3, foot), "yd ")
#let mile = define_unit(multiply(1760, yard), "mi ")
// We need to add imperial units to unify as well:
#add-unit("inch", "in", "upright(\"in\")")
#add-unit("feet", "ft", "upright(\"ft\")")
#add-unit("yard", "yd", "upright(\"yd\")")
#add-unit("mile", "mi", "upright(\"mi\")")

Afterwards, it is no more problem to convert these units:
```typc
let mydist = multiply(3, mile)
$qty(..fmt(mydist, unit: mile)) =
qty(..fmt(mydist, unit: foot)) =
qty(..fmt(mydist, unit: meter, digits: #2)) =
qty(..fmt(mydist, unit: multiply(kilo, meter), digits: #3))$
```
#let mydist = multiply(3, mile)
#result[
$qty(..fmt(mydist, unit: mile)) =
qty(..fmt(mydist, unit: foot)) =
qty(..fmt(mydist, unit: meter, digits: #2)) =
qty(..fmt(mydist, unit: multiply(kilo, meter), digits: #3))$
]

== Using Custom Units in Powers
This also works with squared and cubed units:
```typc
define_unit(pow(multiply(deci, meter), 3), "L ")
#let myvolume = multiply(10, pow(yard, 3))

A concrete truck carries $qty(..fmt(myvolume)) =
qty(..fmt(myvolume, unit: pow(meter, #3), digits: #2)) =
qty(..fmt(myvolume, unit: liter, digits: #0))$ of concrete.
```

#let liter = define_unit(pow(multiply(deci, meter), 3), "L ")
#let myvolume = multiply(10, pow(yard, 3))
#result[
A concrete truck carries $qty(..fmt(myvolume)) =
qty(..fmt(myvolume, unit: pow(meter, #3), digits: #2)) =
qty(..fmt(myvolume, unit: liter, digits: #0))$ of concrete.]

== Common Mistake
The second argument is the unit format, which is at some point passed to unify.
When defining a unit instead of a prefix, you must add a space after the formatting string.

The library has no way of verifying that the unit format is correct, it is possible to do something like:
```typc
let inch = define_unit(multiply(25.4, second), "in ")
//                                    ^^^^^^   ^^^^^ undetectable mismatch
```
And the library has no way of detecting that error!

== Pressure Conversion
First, we define some alternative units for pressure measurement:
```typc
let bar = define_unit(multiply(100, kilo, pascal), "bar ")
let atm = define_unit(multiply(1.01325, bar), "atm ")
let hecto = define_unit(100, "h")  // for hPa
```
#let bar = define_unit(multiply(100, kilo, pascal), "bar ")
#let atm = define_unit(multiply(1.01325, bar), "atm ")
#let hecto = define_unit(100, "h")

We can use these units to directly convert the standard atmospheric pressure @isa:
```typc
let pres = multiply(1, atm)
$qty(..fmt(pres)) =
qty(..fmt(pres, unit: bar)) =
qty(..fmt(pres, unit: multiply(hecto, pascal)))$
```
#let pres = multiply(1, atm)
#result[
$qty(..fmt(pres)) =
qty(..fmt(pres, unit: bar)) =
qty(..fmt(pres, unit: multiply(hecto, pascal)))$
]

Furthermore, using the density of mercury, we can convert the pressure to the height of the liquid column:
```typc
let density = divide(multiply(13595.1, kilogram), pow(meter, 3))
let gravity = multiply(9.81, divide(meter, pow(second, 2)))
let hg = multiply(density, gravity)
let height = divide(pres, hg)

qty(..fmt(pres)) is equivalent to
qty(..fmt(height, unit: multiply(milli, meter), digits: 0)) or
qty(..fmt(height, unit: inch, digits: 2)) of mercury.
```

#let density = divide(multiply(13595.1, kilogram), pow(meter, 3))
#let gravity = multiply(9.81, divide(meter, pow(second, 2)))
#let hg = multiply(density, gravity)
#let height = divide(pres, hg)

#result[
#qty(..fmt(pres)) is equivalent to
#qty(..fmt(height, unit: multiply(milli, meter), digits: 0)) or
#qty(..fmt(height, unit: inch, digits: 2)) of mercury.
]

// ============================================================================
#pagebreak()
#bibliography("bib.yaml")