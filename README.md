# Desafío Buda - Red de Metro


## Introducción

En este proyecto se encuentra **la ruta con menor cantidad de estaciones** entre dos estaciones `A` y `B` de una **Red de Metro** usando una adaptación del algoritmo [**Breadth First Search (BFS)**](https://en.wikipedia.org/wiki/Breadth-first_search).

Modelamos la **Red de Metro** como un grafo dirigido `G(V,E)` en donde las estaciones de metro `V` pueden ser de color: verde, rojo o sin color. Viajar por las conexiones `E` de una estación a otra tiene por defecto un costo de 1.

El **color del tren** puede restringir las estaciones en las cuales este puede detenerse, y por lo tanto influirá en la ruta con menos paradas. Al diseñar un algoritmo de ruta optima que permita el salto de estaciones por parte del tren, modificamos el costo de esas aristas a 0, priorizando rutas en donde el tren pare lo menos posible. Ver [Algoritmo](#algoritmo).



## Input Red de Metro


El grafo de la  **Red de Metro** se representa a través de una **Lista de Adjacencia**, la cual se ingresa en un archivo `.json`:

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


### Setup

La solución se implementa en **Ruby 2.7**. Al clonar este repositorio, se debe navegar al directorio del proyecto e instalar las dependencias del `Gemfile` usando  **bundler**:

```sh
bundle install
```
o
```sh
bin/setup
```


### Ejecución

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

Las restricciones nos permiten modelar el problema usando un grafo dirigido y encontrar la ruta mas con menos paradas usando una adaptación de **BFS** para el caso especial en que [los costos de viaje entre nodos son son 0 o 1](https://www.geeksforgeeks.org/0-1-bfs-shortest-path-binary-graph/ ).


Algunas ventajas de **BFS 0-1** [(ref)](https://cp-algorithms.com/graph/01_bfs.html):


1. Su complejidad es `O(V+E)`, menor en comparación a algoritmos mas generales como [**Dijkstra**](https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm) (complejidad `O((V+E) log(E))`) o [**Bellman-Ford**](https://en.wikipedia.org/wiki/Bellman%E2%80%93Ford_algorithm) (complejidad `O(VE)`).
2. Se adapta muy bien a nuestro problema y es fácil de implementar usando **listas de adjacencia**.
3. En oposición a **BFS** tradicional, se usa una **Deque** para recorrer las aristas vecinas, lo cual permite poner al frente aquellos vecinos a costo 0 que nos permiten saltarnos estaciones.

En un escenario mas general, con tiempos variables de viaje de una estación a otra, entonces **Dijkstra**  o [**A***](https://en.wikipedia.org/wiki/A*_search_algorithm#:~:text=A*%20is%20an%20informed%20search,shortest%20time%2C%20etc.) podrían ser una buena alternativa, y se pueden implementar fácilmente.


### Estructuras de Datos

#### lib/metro

1. `Metro::MetroNetwork`: Modela la red de metro a partir de un grafo de listas de adyacencia entre estaciones.
2. `Metro::EdgeCostMap`: Modela el mapeo de costos para cada arista de la red, de acuerdo al color de tren.
3. `Metro::ShortestPath`: Dado una instancia de  `Metro::MetroNetwork` y `Metro::EdgeCostMap`, implementa el algoritmo de ruta mas corta entre `source` y `target`.
#### lib/utils

1. `Metro::CommandLineParser`: Procesa y valida el input de la linea de comandos.
2. `Metro::MetroNetworkParser`: Procesa el `.json` de la red de metro.
3. `Metro::RecoverPath`: Recupera recursivamente la ruta optima a partir de un hash de nodos antecesores.


## Referencias

1. Algunas ideas sobre la implementación de **BFS 0-1**: https://www.geeksforgeeks.org/0-1-bfs-shortest-path-binary-graph/
2. Discusión sobre la correctitud de **BFS 0-1**: https://cp-algorithms.com/graph/01_bfs.html
