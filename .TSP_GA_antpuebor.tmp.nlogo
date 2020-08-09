; ------------------- Include Genetic Algorithm Module --------------------

;GeneticAlgorithm.nls: libreria del profesor
;setupWorld.nls:libreria para generar el mundo seleccionado
__includes ["GeneticAlgorithm.nls" "setupWorld.nls"]

; --------------------------- Main procedures calling ---------------------

breed [cities city]
cities-own[ id ]
globals[ N ]

undirected-link-breed [blue-links blue-link]
blue-links-own [ weight ]  ;; link breeds can own variables just like turtle breeds


to Setup
  ca
;distinta colocacion de las ciudades en el mundo
  if Mundo = "circle"[setup-cities-circulo] ; finish
  if Mundo = "random"[setup-cities-random] ; finish
  if Mundo = "mesh of points"[setup-cities-malla-puntos] ; finish

  if Mundo = "Y"[setup-cities-Y] ;

  if Mundo = "aurea section"[setup-cities-random] ;
  if Mundo = "K4"[setup-cities-random] ;
  if Mundo = "three circles"[setup-cities-random] ;
  if Mundo = "three lines"[setup-cities-random] ;
  if Mundo = "pyramid"[setup-cities-random] ;
  if Mundo = "four scattered points"[setup-cities-random] ;


;asignacion de un id concreto a cada ciudad y modificar algunas propiedades irrelevantes para el problema.
  let i 0
  ask cities[
    set shape "circle"
    set id i
    set i i + 1
    set label id
    set color green
    set size 0.25
  ]

  ;se crea la primera generacion de individuos.
  AI:Initial-Population population
  ;se representa de forma visual los datos que nos proporciona las funciones predeterminadas de la libreria
  AI:ExternalUpdate
  set-current-plot "Fitness"
  set-plot-y-range 0 N
  plots
end

to Launch
  show AI:GeneticAlgorithm numero-iteraciones Population crossover-ratio mutation-ratio
  plots
end

to plots
  let lista-fitness [fitness] of AI:individuals
  let mejor-fitness max lista-fitness
  let media-fitness mean lista-fitness
  let peor-fitness min lista-fitness
  set-current-plot "Fitness"
  set-current-plot-pen "mean"
  plot media-fitness
  set-current-plot-pen "best"
  plot mejor-fitness
  set-current-plot-pen "worst"
  plot peor-fitness
  if plot-diversity?
  [
    set-current-plot "Diversity"
    set-current-plot-pen "diversity"
    plot AI:diversity
  ]
end

;------------------ Customizable Procedures ---------------------------------

; Create Initial Population.
; It depends on the problem to be solved as it uses a concrete representation
; Para generar los individuos iniciales se crea listas ordenadas de N valores y seguidamente se desordena de forma aleatoria
to AI:Initial-Population [#population]
  create-AI:individuals #population [
    set content shuffle n-values N [i -> i]
    ;se le asigna el valor fitness a cada individuo generado de forma aleatoria para saber cual es el mejor
    AI:Compute-fitness
    hide-turtle
  ]


end

; Individual report to compute its fitness
to AI:Compute-fitness ;contra mayor es el fitness mejor

;R1 es la suma de todas las aristas
  let R1 todos-weight content

  let lista content
  set lista remove-duplicates lista
;R2 penaliza mucho que tenga ciudades sin visitar
  let R2 ((N - length lista) * 100)
;el fitness se le asigna el numero mas alto como en nuestro caso es de minimización lo multiplicamos por -1
  set fitness   (-1 * (R1 + R2))
end

; Crossover procedure
; It takes content from two parents and returns a list with two contents.
; When content is a list (as in DNA case) it uses a random cut-point to
; cut both contents and mix them:
; a1|a2, b1|b2, where long(ai)=long(bi)
; and report: a1|b2, b1|a2






; Mutation procedure
; Random mutation of units of the content.
; Individual procedure

; Auxiliary procedure to be executed in every iteration of the main loop.
; Usually to show or update some information.
to AI:ExternalUpdate
  clear-links

  let  best  max-one-of AI:individuals [fitness]
  let c [content] of best


  foreach c[

    i ->
;creamos un link azul entre el ultimo elemento y el primero de la lista del mejor individuo
    if i = ( N - 1 ) [ ask cities with [ id = item i c] [ create-blue-link-with  one-of cities with[ id = item 0 c][
      set color blue
      set weight compute-weight (item i c ) (item 0 c)
      ;set label weight
      set label link-length
      set label-color red]  ]]
;creamos links azul de manera a -> b -> c .. de las lista del mejor individuo
    if i != ( N - 1 ) [ask cities with [ id = item i c] [ create-blue-link-with  one-of cities with[ id = item (i + 1) c][
      set color blue
      set weight compute-weight (item i c ) (item (i + 1) c)
      ;set label weight
      set label link-length
      set label-color red] ]]

  ]

end
@#$#@#$#@
GRAPHICS-WINDOW
220
10
828
619
-1
-1
37.5
1
10
1
1
1
0
0
0
1
0
15
0
15
0
0
1
ticks
30.0

BUTTON
110
10
210
43
NIL
Launch
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
10
10
110
43
NIL
setup
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
10
45
210
78
Population
Population
5
2000
750.0
5
1
NIL
HORIZONTAL

PLOT
840
10
1120
130
Fitness
gen #
fitness
0.0
50.0
0.0
101.0
true
true
"" ""
PENS
"best" 1.0 0 -2674135 true "" ""
"mean" 1.0 0 -10899396 true "" ""
"worst" 1.0 0 -13345367 true "" ""

SLIDER
10
115
210
148
mutation-ratio
mutation-ratio
0
10
2.0
0.1
1
NIL
HORIZONTAL

PLOT
840
130
1120
250
Diversity
gen #
diversidad
0.0
20.0
0.0
1.0
true
false
"" ""
PENS
"diversity" 1.0 0 -8630108 true "" ""

SWITCH
10
150
210
183
plot-diversity?
plot-diversity?
0
1
-1000

SLIDER
10
80
210
113
crossover-ratio
crossover-ratio
0
100
50.0
1
1
NIL
HORIZONTAL

SLIDER
10
220
210
253
NCities
NCities
0
30
25.0
1
1
NIL
HORIZONTAL

MONITOR
840
255
1120
300
mejor fitness
[fitness] of max-one-of AI:individuals [fitness]
17
1
11

SLIDER
10
255
210
288
numero-iteraciones
numero-iteraciones
0
1000
100.0
5
1
NIL
HORIZONTAL

CHOOSER
10
290
210
335
Mundo
Mundo
"circle" "random" "mesh of points" "Y"
1

MONITOR
840
305
1120
350
NIL
iteraciones
17
1
11

CHOOSER
10
345
210
390
Metodo-de-cruzamiento
Metodo-de-cruzamiento
"opt2" "single-point" "two-point" "uniform" "uniform media"
0

CHOOSER
10
395
140
440
metodo-de-seleccion
metodo-de-seleccion
"elitist" "range" "rulette" "natural"
0

CHOOSER
10
460
210
505
metodo-de-mutacion
metodo-de-mutacion
"opt2" "two flip" "flip" "scramble" "inversion"
0

INPUTBOX
145
395
210
455
N-Range
5.0
1
0
Number

SWITCH
10
185
210
218
natural-selecion?
natural-selecion?
0
1
-1000

@#$#@#$#@
# SOLUCIÓN A TSP CON ALGORITMOS GENÉTICOS.

## ¿Qué es un algoritmo genético?

Los **algoritmos genéticos (AGs)** son mecanismos de búsqueda basados en las leyes de la selección natural y de la genética. Combinan la supervivencia de los individuos mejor adaptados junto con operadores de búsqueda genéticos como la mutación y el cruce, de ahí que sean comparables a una búsqueda biológica. Estos algoritmos se utilizan con éxito para gran variedad de problemas que no permiten una solución eficiente a través de la aplicación de técnicas convencionales.

##  Problema del viajante (TSP)

En el **Problema del Viajante - TSP (Travelling Salesman Problem)**, el objetivo es encontrar un recorrido completo que conecte todos los nodos de una red, visitándolos tan solo una vez y volviendo al punto de partida, y que además minimice la distancia total de la ruta, o el tiempo total del recorrido.

## ¿Cómo funciona?

1. Se crea una población aleatoria de soluciones. Cada solución está formada por una lista aleatoria de números diferentes de 0 a N sin repetirse, donde N es el número de ciudades. 

   -  **`AI:Initial-Population [#population]`**: realiza el paso 1.
   - **`#population`**: Población (número) de individuos que tendrá cada generación.

2. Cada solución se evalúa en en función de lo bien que resuelve el problema. Esta medida de la “bondad” de la solución se llama “fitness”. 

   - **`AI:Compute-fitness`**: calcula el valor del fitness según el contenido del individuo de la siguiente forma:

     $$
     fitness(d) = -1*(R1 + R2)  =-1*( \sum d_i + (N - sizeof(d)) * 100)
     $$

     - R1 es el sumatorio de las distancias euclídeas entre las ciudades del individuo d.
     - R2 es la penalización en función del tamaño de la lista del individuo d, que será mayor cuanto mayor sea la diferencia entre el numero total de ciudades y el numero de ciudades del individuo.
     - El -1 se usa porque es una función de minimización, ya que buscamos el camino de menor distancia.
     
   -  **`fitness`**: variable que almacena el valor de Fitness del individuo.

   - **`content`** : variable que almacena el contenido (valor) del estado.

3. Se crea una generación nueva de soluciones a partir de la generación anterior, donde aquellas soluciones que tengan un fitness más alto tienen más probabilidad de ser escogidos como padres de las nuevas soluciones.  

   - 3.1) El método de selección usado en el modelo es el de torneo de tamaño 3, lo que significa que se toman aleatoriamente 3 soluciones de la generación anterior, y de entre ellos se toma el que tenga mejor fitness para ser uno de los padres de la siguiente generación.  Pero este modelo emplea un aditivo  que consiste en eliminar a individuos similares para mantener la diversidad y evitar la que se conoce como (immature convergence) convergencia prematura, que es uno de los problemas más conocidos en AG. 
   
     - **`AI:Select-torneo[#old-generation]`**:  método que realiza la selección por torneo.
     - **`aquí_va_la_explicación_del_método_de_selección`** 
   
   - 3.2) Una vez que la selección ha elegido a los individuos aptos, éstos deben ser alterados aleatoriamente con la esperanza de mejorar su aptitud para la siguiente generación. Existen dos estrategias básicas para realizar esta tarea:
   
     - La primera y más sencilla es la que se conoce como **mutación**. Al igual que una mutación en los seres vivos cambia un gen por otro, una mutación en un algoritmo genético también causa pequeñas alteraciones en puntos concretos de la codificación del individuo.
   
       - **`#mutation-ratio`** : probabilidad de mutación de cada unidad informativa del ADN de los individuos
   
     - El segundo método se llama **cruzamiento**, y consiste en seleccionar a dos individuos para que intercambien segmentos de su código genético, produciendo una "descendencia" artificial cuyos individuos son combinaciones de sus padres. Aquí es donde entra en juego el método de cruzamiento opt-2 que se explica a continuación: 
   
       - **TODA ESTE PUNTO HAY QUE ELIMINARLO SI NO SE PROGAMA EL METODO OPT2**           El **método 2opt** es uno de los algoritmos de búsqueda local más conocidos entre los algoritmos de resolución de TSP. Mejora la ronda de arista a arista e invierte el orden del subtour. Por ejemplo, imagine un recorrido como el que se muestra en la parte superior de la Fig.1. Quitar las dos aristas ab y cd, e invertir el orden del subtour (de b a c), y añadir las dos aristas ac y bd. Esto nos da un recorrido como se muestra en la parte inferior de la Fig. 1. El tour inferior es más corto que el superior porque ab + cd > ac + bd.
   
         Comprobamos cada par de aristas, por ejemplo, ab y cd. Si ab + cd > ac + bd se mantiene, los mejoramos de la misma manera que se muestra en la Fig. 1. En realidad, si tanto ac > ab como bd > cd se mantienen, entonces no es necesario comprobar las aristas. Por lo tanto, podemos saltarnos los pares cuyas aristas estén muy alejadas entre sí.
   
         Repetimos los procedimientos descritos anteriormente hasta que no se puedan hacer más mejoras.
   
         - **`AI:Crossover-opt2 [c1 c2]`**: Este método realiza un cruzamiento del contenido de los individuos que se le pasan como entrada , para explicar el cruzamiento nos apoyaremos en la siguiente figura:
   
           ![image-20191214190548175](C:\Users\Sergio\AppData\Roaming\Typora\typora-user-images\image-20191214190548175.png)
   
           Supongamos que los cromosomas de los padres son ***ga* = (D; H; B; A; C; F; G; E) *y* *gb* = (*B;* C; D; G; H; F; E; A)**. Primero, elije una ciudad al azar. En este ejemplo, se elige la ciudad C. Entonces x = *4*  e  *y* = *1*  porque  *a4*  *=* C y *b1* = C respectivamente. Ahora el hijo *es (**C**).*
   
           Luego, recoja las ciudades de los padres alternativamente. Comience con *a3*  (ciudad A) porque x =4 - 1= 3,  y luego *b2* (ciudad D) porque y= 1 + 1= 2.  El hijo se convierte en g = (**A; C; D**).
   
           De la misma manera, se agrega *a2*  (ciudad  B), *b3* (ciudad G),  *a1* (ciudad  H),  y el hijo se convierte en  g = (**H; B; A; C; D; G**).  Ahora la siguiente ciudad es *b4* = H  y la ciudad H ya ha aparecido en el hijo (recuerde que el vendedor no puede visitar la misma ciudad dos veces), así que no podemos añadir más ciudades del padre gb.
   
           Por lo tanto, añadiremos ciudades del padre ga. La siguiente ciudad es a0  = D, pero D ya se usa. Por lo tanto, tampoco podemos añadir ciudades  del padre ga.
   
           Después, añadimos el resto de las ciudades, es decir, E y F, al hijo en el orden aleatorio. Finalmente el hijo es g = (**H; B; A; C; D; G; F; E**).
         
       - **`#crossover-ratio`** : % de cruzamientos que se harán en cada iteración
   
4. Los pasos 2 y 3 anteriores se repiten hasta llegar a un número de iteraciones, y el individuo que se da como resultado es el de la última iteración;

   - **`#num-iters`** : Número de iteraciones (generaciones) que dará el algoritmo

Por otro lado, para la posible representación es necesario la implementación de:

- **`AI:ExternalUpdate`** : Procedimiento auxiliar que se ejecutará tras cada iteración del bucle principal. Contiene instrucciones para mostrar y actualizar información del modelo.
- **`setupWorld.nls`**: Archivo que contiene código de algunos modelos de ejemplo para representar posibles recorridos del viajante y poder calcular mediante el algoritmo el camino óptimo que debería realizar el viajante.

## 
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

chess queen
false
0
Circle -7500403 true true 140 11 20
Circle -16777216 false false 139 11 20
Circle -7500403 true true 120 22 60
Circle -16777216 false false 119 20 60
Rectangle -7500403 true true 90 255 210 300
Line -16777216 false 75 255 225 255
Rectangle -16777216 false false 90 255 210 300
Polygon -7500403 true true 105 255 120 90 180 90 195 255
Polygon -16777216 false false 105 255 120 90 180 90 195 255
Rectangle -7500403 true true 105 105 195 75
Rectangle -16777216 false false 105 75 195 105
Polygon -7500403 true true 120 75 105 45 195 45 180 75
Polygon -16777216 false false 120 75 105 45 195 45 180 75
Circle -7500403 true true 180 35 20
Circle -16777216 false false 180 35 20
Circle -7500403 true true 140 35 20
Circle -16777216 false false 140 35 20
Circle -7500403 true true 100 35 20
Circle -16777216 false false 99 35 20
Line -16777216 false 105 90 195 90

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

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.4
@#$#@#$#@
need-to-manually-make-preview-for-this-model
@#$#@#$#@
@#$#@#$#@
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
1
@#$#@#$#@
