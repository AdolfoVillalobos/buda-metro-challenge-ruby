# Desafío Buda - Red de Metro


## Introducción


### El Problema

En esta Tarea se considera una **Red de Metro**. El objetivo es diseñar un algoritmo que encuentre la **ruta con menor cantidad de estaciones** entre dos estaciones `A` (`origen`) y `B` (`destino`).


Una dificultad adicional es que en esta **Red de Metro** existe una coloración de los trenes y las estaciones de metro - estaciones **sin color** pueden recibir cualquier tipo de trenes (incluidos trenes **sin color**), mientras que estaciones **con color** no pueden recibir trenes de un color distinto - y por lo tanto, la coloración de la **Red de Metro** y del Tren influirán en la ruta con menos paradas.

Decidimos abordar la Tarea diseñando un algoritmo de **Ruta Óptima en un Grafo** que permita el salto de estaciones por parte del tren.

 ## Desiciones de Diseño

 ### Modelación y Algoritmo

 Resolvemos el problema de **Ruta Óptima en un Grafo** usando una adaptación de un algoritmo tipo [**Breadth First Search (BFS)**](https://en.wikipedia.org/wiki/Breadth-first_search). Para ello, modelamos la **Red de Metro** como un **grafo dirigido** `G(V,E)` en donde las estaciones de metro `V` son de color: `verde`, `rojo` o `sin color`.

En nuestro algoritmo de ruta óptima, adaptamos **BFS** al caso en que las aristas del grafo [tienen costos  0 o 1](https://www.geeksforgeeks.org/0-1-bfs-shortest-path-binary-graph/ ). Esta **selección de costos** le permitirá al tren visitar estaciones a costo 0, lo cual es equivalente a **saltarse una estación**, si es que el color del tren lo permite.

### Estructura de Datos
La **Estructura de Datos** utilizada para representar el **La Red de Metro** `G(V, E)` es una **Lista de Adjacencia**. Esto permite implementar **BFS** de manera muy sencilla.

 Representamos la **Lista de Adjacencia** en archivos `.json`. Estos archivos son sencillos de leer y validar de manera confiable en Ruby. Ver [Input](#input).

### Complejidad Computacional

Esta estrategia *ad-hoc* nos entrega un algoritmo con complejidad `O(V+E)` bastante sencillo de implementar.

Descartamos algoritmos populares de **Ruta Óptima** como **Dijkstra, Bellman-Ford o A***. Ellos se adaptan muy bien a casos mas generales, pero suelen ser mas complejos de implementar, o bien pueden tener peor complejidad en tiempo/espacio. En nuestro caso, dado que tenemos un grafo muy especial, decidimos aprovechar dicha regularidad. Ver [Algoritmo](#algoritmo) para más detalles.

## Input

Deinimos un  `schema` para representar listas de adjacencia válidas. Un ejemplo de `.json` es:

```json
//data/base.json

{
  "metroStations": [
    {
      "name": "A",
      "neighbors": ["B"],
      "color": ""
    },
    {
      "name": "B",
      "neighbors": ["A", "C"],
      "color": "V"
    }
  ]
}
```
En nuestro `schema`:
`
1. **metroStations**: `Array` no vacío de `estaciones de metro`.
2. Cada `estación de metro` tiene atributos:
   1.  **name**: `String` que identifica la estación.
   1. **neighbors**: `Array` de vecinos a los cuales se puede llegar en un paso desde la estación.
   2. **color**: `String` que representa el color de la estación. Puede ser `""` si la estación no tiene color, `"V"` si la estación es verde, y `"R"` si la estación es roja.

El programa fallará si el schema no es válido. Ver `lib/utils/schemas/metro_network_schema.json`.


## Setup

La solución se implementa en **Ruby 2.7**. Usamos `docker-compose` para ejecutar el código en **contenedores**.

Hacemos un **build** de nuestra imagen:

```sh
docker-compose build
```
o
```sh
bin/setup
```

La `Dockerfile` implementa el comando `bundle install` para installar las dependencias necesarias.

Adicionalmente, en el archivo `docker-compose.yaml` especificamos un `bind-mount` con la carpeta `/data/`. Esto permite probar distintas redes de metro sin necesidad de hacer un nuevo `build` de la imagen.


## Ejecución

Ejecutamos el código usando `docker-compose run`


```sh
Usage:

$ docker-compose run --rm app bundle exec ruby -Ilib script/main.rb -f FILE -s SOURCE -t TARGET -c TRAINCOLOR

    -f, --file FILE                  FILE (json) containing Metro Network (required)
    -s, --source SOURCE              SOURCE Station (required)
    -t, --target TARGET              TARGET Station (required)
    -c, --train-color TRAINCOLOR     Color of the Train: no, red or green (optional)
    -h, --help                       Prints this help
```


### Ejemplo

Consideramos la red de metro especificada en el archivo de ejemplo `data/base.json`.


Cuando EXISTE una ruta de `SOURCE=A` a `TARGET=F` en un tren `TRAINCOLOR=red`

```sh
docker-compose run --rm app bundle exec ruby -Ilib script/main.rb -f data/base.json -s A -t G -c red

Parameters:
        FILE: data/base.json
        SOURCE: A
        TARGET: F
        TRAIN COLOR: RED
---
Best Route:
         A -> B -> C -> H -> F
```

Cuando NO EXISTE una ruta de `SOURCE=A` a `TARGET=G` en un tren `TRAINCOLOR=red`

```sh
Parameters:
        FILE: data/base.json
        SOURCE: A
        TARGET: G
        TRAIN COLOR: RED
---
No routes found from A to G

```

## Test

Para correr los tests usamos `rake`

```sh
docker-compose run --rm app bundle exec rake
```

Para ver el output de cada uno de los tests ejecutados usamos `rspec`:

```sh
docker-compose run --rm app bundle exec rspec -fd
```



## Detalles de la Solución

### Algoritmo

Las restricciones nos permiten modelar el problema usando un grafo dirigido y encontrar la ruta  con menos estaciones usando una adaptación de **BFS** para el caso especial en que [los costos de viaje entre nodos son son 0 o 1](https://www.geeksforgeeks.org/0-1-bfs-shortest-path-binary-graph/ ).


La complejidad de **BFS** es `O(V+E)`.  Esta complejidad es menor en comparación a algoritmos mas generales como [**Dijkstra**](https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm) (complejidad `O((V+E) log(E))`) o [**Bellman-Ford**](https://en.wikipedia.org/wiki/Bellman%E2%80%93Ford_algorithm) (complejidad `O(VE)`). Esta cota se logra imitando el `Heap` de  **Dijkstra** al usar una **Deque** para recorrer las aristas vecinas, lo cual permite dar prioridad a aquellos vecinos a costo 0 que nos permiten saltarnos estaciones [(ref)](https://cp-algorithms.com/graph/01_bfs.html).

En un escenario mas general, en donde el tiempo de viaje de una estación a otra es variable y el objetivo es minimizar el tiempo total de viaje, algorimots como  **Dijkstra**  o [**A***](https://en.wikipedia.org/wiki/A*_search_algorithm#:~:text=A*%20is%20an%20informed%20search,shortest%20time%2C%20etc.) podrían ser una mejor alternativa.


### Estructuras de Datos

#### lib/metro

1. `Metro::MetroNetwork`: Modela la Red de Metro como un grafo a partir de listas de adyacencia entre estaciones de metro.
2. `Metro::EdgeCostMap`: Genera un mapeo de costos para cada arista de la red, de acuerdo al color de tren.
3. `Metro::ShortestPath`: Dado una instancia de  `Metro::MetroNetwork` y `Metro::EdgeCostMap`, implementa el algoritmo de ruta con menos estaciones entre `source` y `target`.
#### lib/utils

1. `Metro::CommandLineParser`: Procesa y valida el input de la linea de comandos.
2. `Metro::MetroNetworkParser`: Procesa el `.json` de la red de metro.
3. `Metro::RecoverPath`: Recupera recursivamente la ruta óptima a partir de un hash de nodos antecesores.


## Referencias

1. Algunas ideas sobre la implementación de **BFS 0-1**: https://www.geeksforgeeks.org/0-1-bfs-shortest-path-binary-graph/
2. Discusión sobre la correctitud de **BFS 0-1**: https://cp-algorithms.com/graph/01_bfs.html
