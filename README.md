# TN-Prototipo

El codigo principal se encuentra en `main.lua`. Para darle los parametros de arranque al motor love2d lee `conf.lua` donde actualmente solo hay info para hacer una ventana de 1280x720px y darle titulo a la ventana. El resto de los archivos son librerias que sirven difrerentes propositos.

Estas librerias y mas se encuentran en el repositorio [awesome-love2d](https://github.com/love2d-community/awesome-love2d)

- `InputManager.lua` es una libreria para manejo de inputs por FuzzDistor. Actualmente solo da facilidades para eventos de teclado.
- `brinevector.lua` es una libreria para implementacion de vectores y su algebra. [source](https://github.com/novemberisms/brinevector)
- `bump.lua` es una libreria de deteccion de colisiones. [source](https://github.com/kikito/bump.lua)
- `camera.lua` es parte de una coleccion de librerias llamado hump. hump.camera crea una camara y permite moverla con funciones de interpolacion. [source](https://hump.readthedocs.io/en/latest/camera.html)
- `flux.lua` es una libreria de tweening que facilita mucho los movimientos que requieren interpolacion. Actualmente no usado. [source](https://github.com/kikito/tween.lua)
- `tilelayer.lua` es una libreria para creacion y dibujado de capas de tiles hecha por FuzzDistor. Hay que ver de incorporar mas funciones a la liberia.
