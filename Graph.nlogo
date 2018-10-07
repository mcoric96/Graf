__includes["procedure.nls" "bojanje.nls" "algoritmi pretrage.nls" "minimalno razapinjuce stablo.nls" "usporedba algoritama.nls"]
breed[vrhovi vrh]
breed[mravi mrav];pomocna vrsta za pretragu po sirini da znamo je li graf povezan
mravi-own [vrh-here na-cilju? moj-put prijedjeni-put];vrh-here je svojstvo da znamo na kojem se vrhu trenutni pretrazivac nalazi,moj-put je lista vrhova kojim prijedje mrav
vrhovi-own[vrijednost susjedi boja posjecen?];ono sta je pohranjeno u svakom vrhu,tip je string,SUSJEDI JE LISTA SA WHO-OVIMA NJEGOVIH SUSJEDNIH VRHOVA,boja je ono cim je obojen,od pocetka nije
;nicim obojen nijedan vrh ,tek pri pokusaju pravilnog bojanja grafova se boji,POSJECEN? nam govori je li vrh posjecen pri nekoj pretragi(npr. je li povezan graf)
links-own[tezina];tezina je numericka vrijednost pridjeljena svakom linku
globals
[
  broj-vrhova max-stupanj dubina-agenti sirina-agenti uniform-cost-agenti;max stupanj je lista vrhova sa najvecim stupnjem u grafu,"ime algoritma"-agenati govori koliko smo imali ukupno-agenata u kojem algoritmu
  tabu-rjesenje? pohlepni-rjesenje?;ova 2 algoritma nekad nalaze rjesenje,nekad ne,moramo znati koji kad nalazi za BEHAVIOR SPACE
  ;moramo znati koliko vremena treba za koji algoritam,broj koraka
  dubina-ticks sirina-ticks pohlepni-ticks tabu-ticks uniform-ticks
]

to setup
  clear-all
  reset-ticks
  ask patches[set pcolor 9]
  set broj-vrhova 0
  set max-stupanj []
  ;za behaviour space,parametri
  set dubina-agenti 0 set sirina-agenti 0 set uniform-cost-agenti 0
  set dubina-ticks 0 set sirina-ticks 0 set uniform-ticks 0 set pohlepni-ticks 0 set tabu-ticks 0
end

to go;procedura sa kojom pokrenemo animaciju
  if(mouse-down?);ako smo pritisli mis,mozda mozemo pomicati neke vrhove sa misem
  [
    ask vrhovi;pitamo vrhove ,ako je neki od njih pritisnut
    [
      if((abs (mouse-xcor - xcor) <= 1.5) and (abs (mouse-ycor - ycor) <= 1.5));ako smo pritisnuli vrh grafa
      [
        while[mouse-down?];dok je mis dolje
        [
          ask vrh who;postavimo koordinate
          [
            setxy mouse-xcor mouse-ycor
            display
          ]
        ]
      ]
    ]
  ]
end

to napravi-vrh [value];ova procedura prima ono sta je korisnik unio,tj vrijednost koja je sadrzana u novm vrhu
  if(value != "" and (not any? vrhovi with[vrijednost = value]))
  [
    create-vrhovi 1
    [
      set color blue
      set shape "circle"
      setxy random-xcor random-pycor
      set vrijednost value
      set size 3
      set label vrijednost
      set label-color black
      set posjecen? false
      set susjedi []
      set boja ""
    ]
    set novi-vrh ""
    set broj-vrhova broj-vrhova + 1
  ]
end

to dodaj-brid [prvi drugi];procedura kojom dodajemo novi brid,prvi i drugi vrh su brojevi tj who,moraju biti razliciti
  if(prvi != drugi);ako su razliciti vrhovi
  [
    let pocetak ""
    let kraj ""
    ;trazimo vrhove koje cemo povezati
    ask vrhovi
    [
      if(vrijednost = prvi)[set pocetak who]
      if(vrijednost = drugi)[set kraj who]
    ]
    ;sad ako mozemo spojimo ih,tj ako oni stvarno postoje u grafu
    if(prvi != "" and drugi != "")
    [
      carefully
      [
        ask vrh pocetak
        [
          create-link-with vrh kraj[set color boja-bridova set thickness 0.2 ifelse tezina-brida = "" [set tezina 1] [set tezina tezina-brida] set label tezina set label-color black]
          ;dodamo za vrh "pocetak" da mu je susjed vrh "kraj" i obratno
          set susjedi lput vrh kraj susjedi
          set susjedi remove-duplicates susjedi
          ask vrh kraj[set susjedi lput vrh pocetak susjedi set susjedi remove-duplicates susjedi]

          set tezina-brida 1;default vrijednost tezine brida
        ]
      ]
      [];za ovo ne treba kod
      ;postavimo novi najveci-stupanj
    ]
  ]
  ;osvjezimo text boxove
  set prvi-vrh ""
  set drugi-vrh ""
end
@#$#@#$#@
GRAPHICS-WINDOW
402
10
1333
500
-1
-1
13.0
1
10
1
1
1
0
0
0
1
-35
35
-18
18
0
0
1
ticks
30.0

BUTTON
3
10
116
43
Postavi na pocetak
setup
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

INPUTBOX
3
67
98
127
novi-vrh
NIL
1
0
String

BUTTON
106
76
212
109
Dodaj vrh u graf
napravi-vrh novi-vrh
NIL
1
T
OBSERVER
NIL
M
NIL
NIL
1

BUTTON
128
11
191
44
Pocni
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
201
10
281
63
Broj vrhova
count vrhovi
10
1
13

INPUTBOX
1
143
90
203
prvi-vrh
NIL
1
0
String

INPUTBOX
92
143
181
203
drugi-vrh
NIL
1
0
String

BUTTON
282
153
370
186
Dodaj brid
dodaj-brid prvi-vrh drugi-vrh
NIL
1
T
OBSERVER
NIL
B
NIL
NIL
1

BUTTON
100
229
207
262
Postavi boju bridova
postavi-boja-bridova
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
218
229
301
262
Potpuni graf
potpuni-graf tezina-brida
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
226
76
324
109
Brisi sve bridove
ocisti-sve-bridove
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
7
354
119
399
Algoritam
Algoritam
"Dubina" "Sirina" "Pohlepni algoritam" "Uniform cost" "Tabu search"
3

TEXTBOX
11
410
171
438
Tehnika pronalaska najkraceg puta izmedju 2 vrha grafa.
11
0.0
1

INPUTBOX
185
143
267
203
tezina-brida
1.0
1
0
Number

BUTTON
312
229
390
262
Dodaj ciklus
dodaj-ciklus
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
295
352
398
385
Najkraci put?
pretraga
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
125
350
206
410
Pocetak-puta
1
1
0
String

INPUTBOX
213
351
291
411
Kraj-puta
7
1
0
String

BUTTON
295
387
398
420
Reset pretraga
reset-pretraga
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
290
10
371
63
Broj bridova
count links
10
1
13

TEXTBOX
9
329
396
350
________________________________________________________________
11
0.0
1

TEXTBOX
5
435
401
453
_________________________________________________________________
11
0.0
1

INPUTBOX
3
218
96
278
boja-bridova
15.0
1
0
Color

INPUTBOX
14
453
87
513
min-tezina
0.0
1
0
Number

INPUTBOX
91
453
162
513
max-tezina
0.0
1
0
Number

INPUTBOX
166
453
235
513
n-vrhova
0.0
1
0
Number

BUTTON
241
465
366
498
Random potpuni graf
random-potpuni-graf
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
4
300
133
333
postotak-tabu-lista
postotak-tabu-lista
25
75
75.0
25
1
NIL
HORIZONTAL

TEXTBOX
7
279
396
297
________________________________________________________________
11
0.0
1

SLIDER
137
300
277
333
slucajni-graf-n
slucajni-graf-n
8
35
20.0
1
1
NIL
HORIZONTAL

BUTTON
288
301
391
334
Random graf
random-graf
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
114
45
205
63
Pomicanje vrhova
11
0.0
1

@#$#@#$#@
## WHAT IS IT?

Program za implementaciju pretrazivanja koja se koriste u umjetnoj inteligenciji na grafovima.

## HOW IT WORKS

Preatrage najkracih puteva na tezinskom grafu i pravilno 2-bojanje grafova.

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

Implementacija usmjerenih grafova i pretrage na usmjerenim grafovima.Pravilna bojanja po komponentama.

## EXTENDING THE MODEL

Pretrage i algoritmi bojanja usmjerenih tezinskih grafova,jednostavnih i onih koji nisu jednostavni,te bojanje svake komponente povezanosti zasebno.

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

orbit 1
true
0
Circle -7500403 true true 116 11 67
Circle -7500403 false true 41 41 218

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="USPOREDBA 2" repetitions="16" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>usporedba-2</go>
    <timeLimit steps="1"/>
    <metric>dubina-agenti</metric>
    <metric>sirina-agenti</metric>
    <metric>uniform-cost-agenti</metric>
    <metric>dubina-ticks</metric>
    <metric>sirina-ticks</metric>
    <metric>pohlepni-ticks</metric>
    <metric>uniform-ticks</metric>
    <metric>tabu-ticks</metric>
    <metric>tabu-rjesenje?</metric>
    <metric>pohlepni-rjesenje?</metric>
    <enumeratedValueSet variable="max-tezina">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-tezina">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="postotak-tabu-lista">
      <value value="25"/>
      <value value="50"/>
      <value value="75"/>
    </enumeratedValueSet>
    <steppedValueSet variable="slucajni-graf-n" first="10" step="1" last="31"/>
  </experiment>
  <experiment name="USPOREDBA1" repetitions="16" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>usporedba-1</go>
    <timeLimit steps="1"/>
    <metric>dubina-agenti</metric>
    <metric>sirina-agenti</metric>
    <metric>uniform-cost-agenti</metric>
    <metric>dubina-ticks</metric>
    <metric>sirina-ticks</metric>
    <metric>pohlepni-ticks</metric>
    <metric>uniform-ticks</metric>
    <metric>tabu-ticks</metric>
    <metric>tabu-rjesenje?</metric>
    <metric>pohlepni-rjesenje?</metric>
    <enumeratedValueSet variable="max-tezina">
      <value value="50000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-tezina">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="postotak-tabu-lista">
      <value value="25"/>
      <value value="50"/>
      <value value="75"/>
    </enumeratedValueSet>
    <steppedValueSet variable="n-vrhova" first="10" step="1" last="31"/>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
