El jugador puede:
    actividad principal 
        entrar edificio
            construir   => fin actividad principal
            transformar => fin actividad principal
            comerciar   => fin actividad principal
        tomar recurso oferta => fin turno actividad principal

    comprar / vender cartas
        ? fin actividad principal and ? deseo comprar edificio

    finalizar turno
        ? fin actividad principal => finalizar turno


========================================================

(fin_actividad_principal ?jugador)

otra actividad . genera semáforo fin otra actividad 

fin otra actividad + deseo comprar carta -->

si no --> pasar turno




CONSTRUIR EDIFICIO


cosas mercado

PUEDES COGER UNA UNIDAD DE CADA bienes

    - 1 de pescado, madera, arcilla, hierro, grano, ganado, carbon, piel
    - 