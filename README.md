# Desafío Buda - Red de Metro

## Introducción

En este proyecto, se resuelve el problema de encontrar la ruta mas corta de una estación `A` a una estación `B` en una **Red de Metro**.

El **color del tren** influye en las estaciones en las cuales este puede detenerse. Esto representa una restricción importante a la hora de diseñar un algoritmo que encuentre la ruta optima, pues un tren de color puede saltarse estaciones.


## Idea de Solución [create an anchor](#anchors-in-markdown)

Modelamos nuestra **Red de Metro** como un grafo dirigido `G(V,E)` en donde las estaciones de metro `V` pueden ser de color: verde, rojo o sin color. Viajar por las conexiones `E` de una estación a otra tiene por defecto un costo de 1.

En caso de que el **color del tren** impida arribar a una determinada estación, entonces fijamos el costo en 0, ya que esto nos permite **saltarnos estaciones, reduciendo las paradas**.

### Algoritmo

La configuración anterior nos permite usar una adaptación de [**Breadth First Search (BFS)**](https://en.wikipedia.org/wiki/Breadth-first_search) para encontrar el camino mas corto, adaptando al caso en que [los costos son 0 o 1](https://www.geeksforgeeks.org/0-1-bfs-shortest-path-binary-graph/ ).

Tal como señala [este articulo](https://cp-algorithms.com/graph/01_bfs.html), algunas ventajas de **BFS 0-1** son:


1. Su complejidad es `O(V+E)`, menor en comparación a algoritmos mas generales como [**Dijkstra**](https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm) (complejidad `O((V+E) log(E))`) o [**Bellman-Ford**](https://en.wikipedia.org/wiki/Bellman%E2%80%93Ford_algorithm) (complejidad `O(VE)`).
2. Se adapta muy bien a nuestro problema y es fácil de implementar usando **listas de adjacencia** y una **Deque** para recorrer las aristas vecinas, poniendo al frente aquellos vecinos que nos permiten saltarnos estaciones.

Si nos interesara un escenario mas general con tiempos variables de viaje de una estación a otra, entonces **Dijkstra**  o [**A***](https://en.wikipedia.org/wiki/A*_search_algorithm#:~:text=A*%20is%20an%20informed%20search,shortest%20time%2C%20etc.) podrían ser una buena alternativa, aun cuando son un poco mas complejos de implementar.

## Uso

### Archivo de Input

El grafo de la  **Red de Metro** se representa a través de una **Lista de Adjacencia**, la cual se codifica en un archivo `.json` con la siguiente estructura.

```json
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

El `.json` tiene un atributo `metroStations` que consiste en un `Array` de estaciones de metro. Para que el `schema` sea válido, cada estación de metro debe tener:

1. **name**: `String` que identifica a la estación de metro.
2. **neighbors** `Array` de `Strings` que contiene los vecinos a los cuales se puede llegar en un paso desde la estación.
3. **color**: `String` que representa el color de la estación. Puede ser `""` si la estación no tiene color, `"V"` si la estación es verde, y `"R"` si la estación es roja., Cualquier otro valor generara error.

Para mas detalles de la validación del schema, ver `lib/utils/schemas/metro_network_schema.json`.


### Setup

La solución se implementa en **Ruby**. Para instalar las dependencias del `Gemfile` usamos  **bundler**.

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


### Ejemplo:

Cuando existe una ruta

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

Cuando no existe una ruta:

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
