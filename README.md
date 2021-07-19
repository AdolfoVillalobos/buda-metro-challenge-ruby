# Desafío Buda - Red de Metro


## Introducción

En este proyecto encuentra la ruta mas corta de una estación `A` a una estación `B` en una **Red de Metro** usando una adaptación del algoritmo [**Breadth First Search (BFS)**](https://en.wikipedia.org/wiki/Breadth-first_search).

Modelamos la **Red de Metro** como un grafo dirigido `G(V,E)` en donde las estaciones de metro `V` pueden ser de color: verde, rojo o sin color. Viajar por las conexiones `E` de una estación a otra tiene por defecto un costo de 1.

El **color del tren** puede restringir las estaciones en las cuales este puede detenerse. Al diseñar un algoritmo de ruta optima que permita el salto de estaciones por parte del tren, fijamos el costo en 0 de esas aristas en 0 reduciendo las paradas. Ver [detalles](#algoritmo).



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

1. Atributo `metroStations` es un  `Array` no vacio de estaciones de metro.
2. Cada estación de metro tiene atributos:
   1.  **name**: `String` que identifica estación.
   2. **neighbors**: `Array` de vecinos a los cuales se puede llegar en un paso desde la estación.
   3. **color**: `String` que representa el color de la estación. Puede ser `""` si la estación no tiene color, `"V"` si la estación es verde, y `"R"` si la estación es roja.

El programa fallara si el schema no es válido. Ver `lib/utils/schemas/metro_network_schema.json`.


### Setup

La solución se implementa en **Ruby 2.7**. Para instalar las dependencias del `Gemfile` usamos  **bundler**.

```sh
bundle install
```
o
```sh
bin/setup
```


### Ejecución

Ejecutamos el código usando `bundler exec`


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



## Algoritmo

Las restricciones nos permiten modelar el problema usando un grafo dirigido y entrar la ruta mas corta usando una adaptación de **BFS** para el caso especial en que [los costos de viaje entre nodos son son 0 o 1](https://www.geeksforgeeks.org/0-1-bfs-shortest-path-binary-graph/ ).

[Algunas ventajas de **BFS 0-1** son](https://cp-algorithms.com/graph/01_bfs.html):


1. Su complejidad es `O(V+E)`, menor en comparación a algoritmos mas generales como [**Dijkstra**](https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm) (complejidad `O((V+E) log(E))`) o [**Bellman-Ford**](https://en.wikipedia.org/wiki/Bellman%E2%80%93Ford_algorithm) (complejidad `O(VE)`).
2. Se adapta muy bien a nuestro problema y es fácil de implementar usando **listas de adjacencia** y una **Deque** para recorrer las aristas vecinas, poniendo al frente aquellos vecinos que nos permiten saltarnos estaciones.

En un escenario mas general, con tiempos variables de viaje de una estación a otra, entonces **Dijkstra**  o [**A***](https://en.wikipedia.org/wiki/A*_search_algorithm#:~:text=A*%20is%20an%20informed%20search,shortest%20time%2C%20etc.) podrían ser una buena alternativa, y se pueden implementar fácilmente.
