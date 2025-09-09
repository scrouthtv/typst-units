#import "lib.typ": *
#import "defs.typ": *
#import "@preview/unify:0.7.1": qty

= Example 1: Basic Conversions

#let kwh = multiply(kilo, watt, hour)
#let mj = multiply(mega, joule)
#let myenergyqty = multiply(15, kwh)

$qty(..fmt(myenergyqty)) = qty(..fmt(myenergyqty, unit: mj))$

#let myvolt = multiply(115, volt)
#let myohm = multiply(220, kilo, ohm)
#let thecurrent = divide(myvolt, myohm)

We can use Ohm's law: $U = R dot I <=> I = U / R$.
When applying #qty(..fmt(myvolt)) on a #qty(..fmt(myohm, unit: multiply(mega, ohm))) resistor, the current is #qty(..fmt(thecurrent, unit: multiply(milli, ampere), digits: 3)).

= Example 2: Switching Converter
#let khz = multiply(kilo, hertz)

#let vi = multiply(5, volt)
#let vo = multiply(2200, milli, volt)
#let dcycle = divide(vo, vi)
#let fs = multiply(300, kilo, hertz)
#let io = multiply(10, ampere)
#let cr = multiply(30, percent)
#let ir = multiply(io, cr)

The Buck converter is defined by
- Input voltage is given as $V_I = qty(..fmt(vi))$
- Output voltage is given as $V_O = qty(..fmt(vo, unit: volt))$
// In the next step, we have to "escape" the number, or it will be parsed as content inside math mode instead of integer.
- Therefore, the duty cycle can be calculated to $D = qty(..fmt(dcycle, unit: #1))$
- Switching frequency is determined by the controller which uses $f_S = qty(..fmt(fs))$
- Output current is given as $I = qty(..fmt(io))$ and inductor current ripple ratio shall be $C R = qty(..fmt(cr))$
- Therefore, the current ripple can be calculated to $Delta I_L = qty(..fmt(ir, unit: ampere))$

With this information, we can calculate the inductor and output capacitor:

#let inductance = divide(multiply(dcycle, subtract(vi, vo)), multiply(ir, fs))
#let uhenry = multiply(micro, henry)
$ L = (D (V_I - V_O))/(Delta I_L f_S) =
qty(..fmt(inductance, unit: uhenry, digits: #3)) $

#let dvo = multiply(10, milli, volt)
Now we require the output voltage ripple to be less than $Delta V_O = qty(..fmt(dvo))$.
#let capacitance = divide(ir, multiply(8, fs, dvo))
#let ufarad = multiply(micro, farad)
$ C_O >= (Delta I_L)/(8 f_S Delta V_O) =
qty(..fmt(capacitance, unit: ufarad, digits: #3)) $

#pagebreak()
= Example 3: Stress Analysis
#let height = multiply(140, milli, meter)
#let width = multiply(120, milli, meter)
#let thick = multiply(8, milli, meter)
#let length = multiply(3, meter)
#let force = multiply(18, kilo, newton)

#columns(2)[
#include "ibeam.typ"  // Show a little picture
#colbreak()

A very simple I beam is defined using
- Height $H = qty(..fmt(height))$
- Width $W = qty(..fmt(width))$
- Constant thickness $t = qty(..fmt(thick)) << H, W$
- Beam length $l = qty(..fmt(length))$
- Applied force at the end $F = qty(..fmt(force))$
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
= t ((W H^2)/2 + 1/3 dot 2 dot W^3/8) = (W H^2 t)/2 + (W^3 t)/12
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

Now we can calculate the tension under a load.