# Desafío Buda - Red de Metro


## Introducción


### El Problema

En este proyecto se implementa un programa para encontrar **la ruta con menor cantidad de estaciones** entre dos estaciones `A` y `B` de una **Red de Metro**.

En esta red de tren, el **Color del Tren** puede restringir las estaciones en las cuales este puede detenerse, y por lo tanto influirá en la ruta con menos paradas.

Buscamos diseñar un algoritmo de **Ruta Óptima** que permita el salto de estaciones por parte del tren, modificamos el costo de esas aristas a 0, priorizando rutas en donde el tren pare lo menos posible.

 ## La Solución y Desiciones de Diseño

 Resolvemos el problema usando una adaptación de un algoritmo tipo [**Breadth First Search (BFS)**](https://en.wikipedia.org/wiki/Breadth-first_search). Para ello, modelamos la **Red de Metro** como un grafo dirigido `G(V,E)` en donde las estaciones de metro `V` son de color: `verde`, `rojo` o `sin color`.

El grafo se representa a través de una **Lista de Adjacencia** como estructura de datos  pues esto permite implementar **BFS** de manera muy sencilla para encontrar rutas mas cortas. Guardamos estas listas en archivos `.json`. Estos archivos son sencillos de leer y validar de manera confiable en Ruby.

En nuestro algoritmo de ruta óptima, adaptamos **BFS** al caso en que las aristas del grafo [tienen costos  0 o 1](https://www.geeksforgeeks.org/0-1-bfs-shortest-path-binary-graph/ ). Esta estrategia *ad-hoc* nos entrega un algoritmo con complejidad `O(V+E)` bastante sencillo de implementar.


Por el momento, descartamos algoritmos como **Dijkstra, Bellman-Ford o A***, que se adaptan muy bien a casos mas generales, pero suelen ser mas complejos de implementar, o bien pueden tener peor complejidad en tiempo/espacio. En nuestro caso, dado que tenemos un grafo muy especial, decidimos aprovechar dicha regularidad. Ver [Algoritmo](#algoritmo) para mas detalles.

## Input Red de Metro


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

El `schema` soportado para el `.json` es:

1. **metroStations**: `Array` no vacío de estaciones de metro.
2. Cada estación de metro tiene atributos:
   1.  **name**: `String` que identifica la estación.
   2. **neighbors**: `Array` de vecinos a los cuales se puede llegar en un paso desde la estación.
   3. **color**: `String` que representa el color de la estación. Puede ser `""` si la estación no tiene color, `"V"` si la estación es verde, y `"R"` si la estación es roja.

El programa fallara si el schema no es válido. Ver `lib/utils/schemas/metro_network_schema.json`.


## Setup

La solución se implementa en **Ruby 2.7**. Al clonar este repo, ir al directorio del proyecto e instalar las dependencias del `Gemfile` usando  **bundler**:

```sh
bundle install
```
o
```sh
bin/setup
```


## Ejecución

Ejecutamos el código usando `bundle exec`


```sh
Usage:

$ bundle exec ruby -Ilib script/main.rb -f FILE -s SOURCE -t TARGET -c TRAINCOLOR

    -f, --file FILE                  FILE (json) containing Metro Network (required)
    -s, --source SOURCE              SOURCE Station (required)
    -t, --target TARGET              TARGET Station (required)
    -c, --train-color TRAINCOLOR     Color of the Train: no, red or green (optional)
    -h, --help                       Prints this help
```


### Ejemplo

Cuando existe una ruta de `SOURCE=A` a `TARGET=F` en un tren `TRAINCOLOR=red`

```sh
bundle exec ruby -Ilib script/main.rb -f data/base.json -s A -t F -c red

Parameters:
        FILE: data/base.json
        SOURCE: A
        TARGET: F
        TRAIN COLOR: RED
---
Best Route:
         A -> B -> C -> H -> F
```

Cuando existe una ruta de `SOURCE=A` a `TARGET=G` en un tren `TRAINCOLOR=red`

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

Para correr los tests usamos `rspec` o `rake`

```sh
bundle exec rake
```

Para ver cada uno de los tests ejecutados

```sh
bundle exec rspec -fd
```



## Detalles de la Solución

### Algoritmo

Las restricciones nos permiten modelar el problema usando un grafo dirigido y encontrar la ruta  con menos estaciones usando una adaptación de **BFS** para el caso especial en que [los costos de viaje entre nodos son son 0 o 1](https://www.geeksforgeeks.org/0-1-bfs-shortest-path-binary-graph/ ).


La complejidad de **BFS** es `O(V+E)`.  Esta complejidad es menor en comparación a algoritmos mas generales como [**Dijkstra**](https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm) (complejidad `O((V+E) log(E))`) o [**Bellman-Ford**](https://en.wikipedia.org/wiki/Bellman%E2%80%93Ford_algorithm) (complejidad `O(VE)`). Esta cota se logra imitando el `Heap` de  **Dijkstra** al usar una **Deque** para recorrer las aristas vecinas, lo cual permite dar prioridad a aquellos vecinos a costo 0 que nos permiten saltarnos estaciones [(ref)](https://cp-algorithms.com/graph/01_bfs.html).

En un escenario mas general, por ejemplo con tiempos variables de viaje de una estación a otra,  **Dijkstra**  o [**A***](https://en.wikipedia.org/wiki/A*_search_algorithm#:~:text=A*%20is%20an%20informed%20search,shortest%20time%2C%20etc.) podrían ser una mejor alternativa.


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
