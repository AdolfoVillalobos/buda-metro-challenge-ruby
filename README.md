# Desafío Buda - Red de Metro

## Introducción
---

En este proyecto, se resuelve el problema de encontrar la ruta mas corta de una estación $A$ a una estación $B$ en una **Red de Metro**.

El **color del tren** tiene un impacto en las estaciones en las cuales puede detenerse. Esto representa una restricción importante a la hora de diseñar un algoritmo que encuentre la ruta optima, en términos de **minimizar la cantidad de paradas**.


## Idea de Solución

Modelamos nuestra **Red de Metro** como un grafo dirigido $G(V,E)$ en donde:

1. Las estaciones de metro $V$ pueden ser de color: `verde`, `rojo` o `sin color`.
2. Las conexiones $E$ de una estación a otra.


Dadas las condiciones anteriores, utilizamos un algoritmo de tipo **Breadth First Search**, adaptado a costos 0-1:


1. La complejidad de  **BFS 0-1** es $O(V+E)$, lo cual se adapta muy bien.
2. Un algoritmo mas general para resolver este problema es [Dijksta](https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm), cuya complejidad $O((V+E)\log(E))$ es peor. En caso de que consideraramos tiempos variables de viaje de una estacion a otra, Dijkstra podria ser mejor.

## Uso
---

### Archivo de Input

La **Red de Metro** se ingresa a partir de un archivo `.json` con la siguiente estructura.

```json
{
  "metroStations": [
    {
      "name": "A",
      "neighbors": ["B"],
      "color": 0
    },
    {
      "name": "B",
      "neighbors": ["A", "C"],
      "color": 1
    }
  ]
}
```

Para mas detalles de la validación del schema, ver `lib/utils/schemas/metro_network_schema.json`.


---
### Setup

La solución se implementa en **Ruby**. Para instalar las dependencias, usamos `bundler`.

```sh
bin/setup
```

o

```sh
bundle install
```


### Ejecución

Ejecutamos el código usando `bundler exec`


```sh
$ bundle exec ruby -Ilib script/main.rb -h

---

Usage: bundle exec ruby -Ilib script/main.rb -f FILE -s SOURCE -t TARGET -c TRAINCOLOR

    -f, --file FILE                  FILE (json) containing Metro Network (required)
    -s, --source SOURCE              SOURCE Station (required)
    -t, --target TARGET              TARGET Station (required)
    -c, --train-color TRAINCOLOR     Color of the Train: no, red or green (optional)
    -h, --help                       Prints this help
```


Ejemplo:

```sh
bundle exec ruby -Ilib script/main.rb -f data/base.json -s A -t F -c green
```


### Test

Para correr los tests

```sh
bundle exec rake
```

Para ver cada uno de los tests ejecutados

```sh
bundle exec rspec -fd
```
