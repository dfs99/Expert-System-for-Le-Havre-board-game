==========================================================
TODO:
    => ver como hacer las actividades del jugador en la ronda final. OK
    => ver como terminar la partida                                  OK (PREGUNTAR PUBLICAR GANADOR)
    => añadir los pagos de un jugador a otro. => Generalizar.        OK 
    => estrategia.              
    => Muelle.                                                       OK


MODELADO PAGOS:

variante PARTICIPANTE
    - Cambiar relación jugador tiene carta por participante tiene carta
    - Cambiar relación jugador tiene recurso por participante tiene recurso --> Inconveniente: tiene que inicializarse en facts (poco natural)
            si no queremos hacer esta segunda modificación |
                                                           |
                                                           |
                                                           |
                                                           v 
variante de ayuntamiento = jugador --> PROBLEMA: no puedes controlar que no se referencia al referenciar dos jugadores

==========================================================
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


no tiene edificio => vacio, no edificio usado : todas las alternativas posibles. 

en edificio => esta en edificio, edificio usado :  todas las alternativas posibles - las del edificio donde está y eliminar el hecho edificio usado.

una regla estrategica => decida entre las alternativas donde quiere entrar, 

entrar edificio => modificar lo de está edificio.




ENTRAR EDIFICIO 
    => TUYO
        ENTRAS SIN MAS
            COMPROBAR SI ALGUIEN EN LAS 8 PRIMERAS RONDAS       (1)
            FIN RONDA                                           (1)
    => AJENO
        GRATIS
            (SIMPLIFICAR CON TUYO)

    Si tuyo o gratis y no tuyo 
 
        PAGAR 

    Si ayunto o otro jugador
            AYUNTO  
                   
            OTRO JUGADOR
                COMPROBAR SI ALGUIEN EN LAS 8 PRIMERAS RONDAS       (1)
                FIN RONDA                                           (1)

1 REGLA PARA ENTRAR 8 PRIMERAS RONDAS 
1 REGLA PARA ENTRAR ULTIMA RONDA

UNA VEZ dentro
    EDIFICIO TUYO => GRATIS 
    EDIFICIO AGENO => PAGAR 



BARCOS INICIALES

valor 2 coste 14 madera 5, cuando se venden van al mazo de barcos de madera



PLANTEAMIENTO ACTUALIZAR MAZO

(actualizar_mazo ?id_mazo)
()



======================================================================





TODOS LOS DESEOS: 
deseo_comprar_edificio
deseo_comprar_barco
deseo_vender_carta
deseo_vender_barco 
deseo_pagar_deuda 
deseo_pagar_demanda
deseo_coger_recurso 
deseo_entrar_edificio
deseo_construccion 
deseo_generar_con_recurso 
deseo_emplear_energia 
deseo_usar_mercado 
deseo_usar_compañia_naviera 

DESEOS NUESTRA ESTRATEGIA: 
deseo_comprar_edificio
deseo_pagar_demanda
deseo_coger_recurso
deseo_entrar_edificio
deseo_construccion
deseo_generar_con_recurso
deseo_emplear_energia
deseo_usar_compañia_naviera

(decision_pago_comida ?nombre_jugador ?recurso)


=> para ejecutar deseos:
    => especialista : tipo_basico_recurso_alimenticio
    => edificios construir : {ed1, ed2, ed3, ...}
    => 


el pescado sale 3 veces por ronda. 
la madera sale 4 veces por ronda.
Ganado / grano sale 1 vez por ronda. 
franco / arcilla sale 2 veces por ronda. 
hierro 1 vez. 

oferta inicial:
Pescado: 3
franco: 3
madera: 3
arcilla: 2
hierro: 1 
grano: 1
ganado: 1

recursos inicio jugadores. 
Pescado: 2
franco: 5
madera: 2
arcilla: 2
hierro: 2 
grano: 0
ganado: 1
carbon 2
piel 2


para obtener la info de q necesitas x recursos PARA la construccion de un edificio y por ende quieras entrar a un edificio para generarlos. 
necesitarás una regla que segun tus prioridades te indique cuantos recursos te faltan para 