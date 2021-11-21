
;    ▄█          ▄████████         ▄█    █▄       ▄████████  ▄█    █▄     ▄████████    ▄████████ 
;   ███         ███    ███        ███    ███     ███    ███ ███    ███   ███    ███   ███    ███ 
;   ███         ███    █▀         ███    ███     ███    ███ ███    ███   ███    ███   ███    █▀  
;   ███        ▄███▄▄▄           ▄███▄▄▄▄███▄▄   ███    ███ ███    ███  ▄███▄▄▄▄██▀  ▄███▄▄▄     
;   ███       ▀▀███▀▀▀          ▀▀███▀▀▀▀███▀  ▀███████████ ███    ███ ▀▀███▀▀▀▀▀   ▀▀███▀▀▀     
;   ███         ███    █▄         ███    ███     ███    ███ ███    ███ ▀███████████   ███    █▄  
;   ███▌    ▄   ███    ███        ███    ███     ███    ███ ███    ███   ███    ███   ███    ███ 
;   █████▄▄██   ██████████        ███    █▀      ███    █▀   ▀██████▀    ███    ███   ██████████ 
;   ▀                                                                    ███    ███              
;
;                                          ╦═╗╔═╗╔═╗╦  ╔═╗╔═╗
;                                          ╠╦╝║╣ ║ ╦║  ╠═╣╚═╗
;                                          ╩╚═╚═╝╚═╝╩═╝╩ ╩╚═╝
;             +-----------------------------+--------------+-------------------------+
;             |           Authors           |     NIAs     |      Github Account     |
;             +-----------------------------+--------------+-------------------------+
;             | Ricardo Grande Cros         |  100386336   |      ricardograndecros  |
;             | Diego Fernandez Sebastian   |  100387203   |      dfs99              |
;             +-----------------------------+--------------+-------------------------+
;
;  from Universidad Carlos III de Madrid - November 2021

; +=============================================================================================+
; |                                        REGLAS GESTIÓN PARTIDA                               |
; +=============================================================================================+
; |                                                                                             |
; | A continuación se listan las reglas propias de la gestión de una partida. En este caso,     |
; | sólo existe una regla engargada de generar los ficheros de salida de las pruebas            |
; | pertinentes con sus correspondientes "logs" para su correcta comprensión.                   |
; |                                                                                             |
; +=============================================================================================+ 

; Regla 1 
(defrule COMIENZO_PARTIDA
    ; obtener el flag de inicio de partida.
    ?flag_inicio_partida <- (comienzo_partida NO)
    =>
    (retract ?flag_inicio_partida)
    (assert (comienzo_partida SI))
    ; desactivar trazas debug.
    ;(unwatch rules)
    ;(unwatch facts)
    ;(unwatch instances)
    ; activar trazas debug.
    (watch rules)
    (watch facts)
    (watch instances)
    (dribble-on salidas/salida-pruebaX.txt)
    (printout t"=====================================================================================================" crlf)
    (printout t"                                PARTIDA JUEGO LE HAVRE" crlf)
    (printout t" fichero prueba: pruebaX.clp" crlf)
    (printout t" Sistema operativo empleado: " (operating-system) "." crlf)
    (printout t" fecha ejecución: " (local-time) "." crlf)
    (printout t"=====================================================================================================" crlf)
)

; +=============================================================================================+
; |                                        REGLAS JUEGO                                         |
; +=============================================================================================+
; |                                                                                             |
; | A continuación se listan las reglas propias del juego. En este caso por completitud se han  |
; | implementado reglas del juego que aunque no sean empleadas por la estrategia diseñada, si   |
; | son funcionales por si otra persona quisiera determinar una estrategia distinta con el      |
; | código proporcionado. También pensado para rediseñar estrategias más complejas a futuro.    |
; |                                                                                             |
; +=============================================================================================+

; Regla 1
(defrule DESTAPAR_LOSETA
    ; obtener casilla y que esté oculta.
    ?casilla <- (object (is-a LOSETA) (posicion ?pos) (visibilidad FALSE))
    ; comprobar que hay un jugador en la casilla
    ?posicion_jugador <- (object (is-a JUGADOR_ESTA_EN_LOSETA) (posicion ?pos) (nombre_jugador ?))
    =>
    ; hacer casilla visible
    (modify-instance ?casilla (visibilidad TRUE))
    ; log
    (printout t"La loseta con posición : <" ?pos "> queda visible. " crlf)
)

; Regla 2
(defrule PAGAR_INTERESES_FRANCOS
    ; obtiene el jugador
    ?jugador <- (object(is-a JUGADOR)(nombre ?nombre)(deudas ?deudas))
    ; obtiene los recursos del jugador
    ?jugador_recursos <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre) (recurso FRANCO) (cantidad ?cantidad_francos))
    ; obtiene la posición del jugador
    ?jugador_loseta <- (object (is-a JUGADOR_ESTA_EN_LOSETA) (posicion ?pos) (nombre_jugador ?nombre))
    ; la loseta tiene pago de intereses
    ?loseta <- (object (is-a LOSETA) (posicion ?pos) (visibilidad TRUE) (intereses TRUE))
    ; el jugador tiene deudas 
    (test (> ?deudas 0))
    ; el jugador tiene dinero para pagarlo
    (test (> ?cantidad_francos 0))
    ; fin actividad principal
    (fin_actividad_principal ?nombre)
    (ronda_actual ?ronda)
    (not (jugador_intereses_pagados ?nombre ?ronda))
    =>
    ; restar dinero al jugador
    (modify-instance ?jugador_recursos (cantidad (- ?cantidad_francos 1)))
    (assert (jugador_intereses_pagados ?nombre ?ronda))
    ; log
    (printout t"El jugador <" ?nombre "> con <"?deudas"> deudas ha pagado <1> franco debido a los intereses de sus deudas." crlf)
)

; Regla 3
(defrule PAGAR_INTERESES_ENDEUDANDOSE
    ; obtiene el jugador y sus deudas.
    ?jugador <- (object(is-a JUGADOR)(nombre ?nombre)(deudas ?deudas))
    ; obtiene los recursos del jugador
    ?jugador_recursos <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre) (recurso FRANCO)(cantidad ?cantidad_francos))
    ; obtiene la posición del jugador
    ?jugador_loseta <- (object (is-a JUGADOR_ESTA_EN_LOSETA)(posicion ?pos)(nombre_jugador ?nombre))
    ; la loseta tiene pago de intereses
    ?loseta <- (object (is-a LOSETA)(posicion ?pos)(visibilidad TRUE)(intereses TRUE))
    ; el jugador tiene al menos una deuda.
    (test (> ?deudas 0))
    ; el jugador NO tiene dinero para pagarlo
    (test (< ?cantidad_francos 1))
    ; fin actividad principal
    (fin_actividad_principal ?nombre)
    (ronda_actual ?ronda)
    (not (jugador_intereses_pagados ?nombre ?ronda))
    =>
    ; aumentar deuda del jugador en 1
    (modify-instance ?jugador (deudas (+ ?deudas 1)))
    ; una deuda otorga 4 francos, pero al necesitarla para pagar 
    (modify-instance ?jugador_recursos (cantidad (+ ?cantidad_francos 3)))
    (assert (jugador_intereses_pagados ?nombre ?ronda))
    ;log
    (printout t"El jugador <" ?nombre "> con <"?deudas"> deudas ha necesitado otra deuda para poder pagar los intereses de las deudas contraidas anteriormente." crlf)
)

; Regla 4
(defrule ACTUALIZAR_MAZO
    ; se ha disparado un hecho para actualizar un mazo.
	?ref <- (actualizar_mazo ?id ?numero_actualizaciones_restante ?pos1)
    ; obtener la carta correspondiente del mazo para actulizarse. (Siempre se empieza por la 2ª carta del mazo.)
    ?carta_mazo1 <- (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id) (nombre_carta ?nombre_carta) (posicion_en_mazo ?pos1))
	; comprobar que aún se puedan realizar actualizaciones.
	(test (> ?numero_actualizaciones_restante 0))
	=>
    ; actualizar la posición de la carta en el mazo.
	(modify-instance ?carta_mazo1(posicion_en_mazo (- ?pos1 1)))
	; actualizamos el hecho de actualizar mazo.
    (retract ?ref)
	(assert (actualizar_mazo ?id (- ?numero_actualizaciones_restante 1) (+ ?pos1 1)))
	; log
    (printout t"El mazo <" ?id "> ha actualizado la posición de la carta con nombre: <"?nombre_carta"> de la posición <"?pos1"> a la posición <" (- ?pos1 1) ">." crlf)
)

; Regla 5
(defrule FIN_ACTUALIZAR_MAZO
    ; comprobar que la actualización del mazo ha llegado a su fin.
    ?ref <- (actualizar_mazo ?id 0 ?)
	=>
    ; deshacer el hecho de actualizar mazo.
	(retract ?ref)
    ; log
	(printout t"El mazo <"?id"> ha terminado de actualizarse." crlf)
)

; Regla 6
(defrule COMPRAR_EDIFICIO_AL_AYUNTO_NO_BONUS
    ; Se puede comprar en la ronda actual. [en todas las rondas excepto la última.]
    (ronda_actual ?nombre_ronda)
    (test (neq ?nombre_ronda RONDA_EXTRA_FINAL))
    ; Obtener al jugador.
    ?jugador <- (object (is-a JUGADOR) (nombre ?nombre_jugador) (riqueza ?riqueza_jugador))
    ; Obtener el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; Obtener el edificio del deseo
    ?deseo <- (deseo_comprar_edificio ?nombre_jugador ?nombre_edificio)
    ; Ha finalizado su actividad principal dentro de su turno.
    (fin_actividad_principal ?nombre_jugador)
    ; El edificio es del ayuntamiento
    ?edificio_ayuntamiento <- (object (is-a PARTICIPANTE_TIENE_CARTA) (nombre_jugador "AYUNTAMIENTO") (nombre_carta ?nombre_edificio))
    ; Obtiene el coste de comprar el edificio
    (object (is-a CARTA) (nombre ?nombre_edificio) (valor ?valor_edificio))
    ; NO TIENE BONUS
    (not (object (is-a CARTA_TIENE_BONUS) (nombre_carta ?nombre_edificio) (bonus ?)))
    ; Obtiene el dinero del jugador
    ?recurso_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso FRANCO) (cantidad ?cantidad_recurso))
    ; El jugador tiene suficiente dinero
    (test (>= ?cantidad_recurso ?valor_edificio))
    =>
    ; Modificar el dinero del jugador
    (modify-instance ?recurso_jugador (cantidad (- ?cantidad_recurso ?valor_edificio)))
    ; Aumentar la riqueza del jugador 
    (modify-instance ?jugador (riqueza (+ ?riqueza_jugador ?valor_edificio)))
    ; Quitar el edificio al ayuntamiento
    (unmake-instance ?edificio_ayuntamiento)
    ; Asignar el edificio al jugador
    (make-instance of PARTICIPANTE_TIENE_CARTA (nombre_jugador ?nombre_jugador) (nombre_carta ?nombre_edificio))
    ; Eliminar el deseo de comprar el edificio
    (retract ?deseo)
    (printout t"El jugador: <" ?nombre_jugador "> ha comprado el edificio: <" ?nombre_edificio "> por <" ?valor_edificio "> francos al AYUNTAMIENTO." crlf)
)

; Regla 7
(defrule COMPRAR_EDIFICIO_AL_AYUNTO_SI_BONUS
    ; Se puede comprar en la ronda actual. [en todas las rondas excepto la última.]
    (ronda_actual ?nombre_ronda)
    (test (neq ?nombre_ronda RONDA_EXTRA_FINAL))
    ; Obtener al jugador.
    ?jugador <- (object (is-a JUGADOR) (nombre ?nombre_jugador) (riqueza ?riqueza_jugador))
    ; Obtener el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; Obtener el edificio del deseo
    ?deseo <- (deseo_comprar_edificio ?nombre_jugador ?nombre_edificio)
    ; Ha finalizado su actividad principal dentro de su turno.
    (fin_actividad_principal ?nombre_jugador)
    ; El edificio es del ayuntamiento
    ?edificio_ayuntamiento <- (object (is-a PARTICIPANTE_TIENE_CARTA) (nombre_jugador "AYUNTAMIENTO") (nombre_carta ?nombre_edificio))
    ; Obtiene el coste de comprar el edificio
    (object (is-a CARTA) (nombre ?nombre_edificio) (valor ?valor_edificio))
    ; obtiene el bonus
    (object (is-a CARTA_TIENE_BONUS)(nombre_carta ?nombre_edificio)(bonus ?bonus))
    ; obtiene la relación de jugador tiene bonus
    ?jugador_tiene_bonus <- (object (is-a JUGADOR_TIENE_BONUS)(nombre_jugador ?nombre_jugador)(tipo ?bonus)(cantidad ?cantidad_bonus))
    ; Obtiene el dinero del jugador
    ?recurso_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso FRANCO) (cantidad ?cantidad_recurso))
    ; El jugador tiene suficiente dinero
    (test (>= ?cantidad_recurso ?valor_edificio))
    =>
    ; Modificar el dinero del jugador
    (modify-instance ?recurso_jugador (cantidad (- ?cantidad_recurso ?valor_edificio)))
    ; Aumentar la riqueza del jugador 
    (modify-instance ?jugador (riqueza (+ ?riqueza_jugador ?valor_edificio)))
    ; Quitar el edificio al ayuntamiento
    (unmake-instance ?edificio_ayuntamiento)
    ; Asignar el edificio al jugador
    (make-instance of PARTICIPANTE_TIENE_CARTA (nombre_jugador ?nombre_jugador) (nombre_carta ?nombre_edificio))
    ; Eliminar el deseo de comprar el edificio
    (retract ?deseo)
    ; actualizar los bonus de los jugadores.
    (modify-instance ?jugador_tiene_bonus (cantidad (+ ?cantidad_bonus 1)))
    (printout t"El jugador: <" ?nombre_jugador "> ha comprado el edificio: <" ?nombre_edificio "> [que tiene bonus: <"?bonus">] por <" ?valor_edificio "> francos al AYUNTAMIENTO." crlf)
)

; Regla 8 => No usada en estrategia implementada.
(defrule COMPRAR_BARCO
    ; Se puede comprar en la ronda actual. [en todas las rondas excepto la última.]
    (ronda_actual ?nombre_ronda)
    (test (neq ?nombre_ronda RONDA_EXTRA_FINAL))
    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; Existe el deseo de comprar el barco
    ?deseo <- (deseo_comprar_barco ?nombre_jugador ?nombre_barco)
    ; Ha finalizado su actividad principal dentro de su turno.
    (fin_actividad_principal ?nombre_jugador)
    ; El barco está disponible
    ?disponible <- (BARCO_DISPONIBLE (nombre_barco ?nombre_barco))
    ; El barco es el primero de su mazo
    ?barco_en_mazo <- (object  (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id_mazo) (nombre_carta ?nombre_barco) (posicion_en_mazo 1))
    ; El jugador tiene dinero para comprarlo
    ; Obtiene el coste de comprar el barco
    (object (is-a BARCO) (nombre ?nombre_barco) (coste ?coste_barco) (valor ?valor_barco)(uds_comida_genera ?uds_comida_genera)(capacidad_envio ?capacidad_envio_barco))
    ; Obtiene el dinero del jugador
    ?recurso_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso FRANCO) (cantidad ?cantidad_recurso))
    ; El jugador tiene suficiente dinero
    (test (>= ?cantidad_recurso ?coste_barco))
    ; se obtiene al jugador
    ?jugador <- (object (is-a JUGADOR)(nombre ?nombre_jugador)(num_barcos ?num_barcos)(capacidad_envio ?capacidad_envio_jugador)(demanda_comida_cubierta ?demanda_comida_cubierta)(riqueza ?riqueza_jugador))
    ; obtener el mazo y actualizarlo.
    ?mazo <- (object (is-a MAZO) (id_mazo ?id_mazo) (numero_cartas_en_mazo ?cartas_en_mazo))
    =>
    ; Modificar el dinero del jugador
    (modify-instance ?recurso_jugador (cantidad (- ?cantidad_recurso ?coste_barco)))
    ; Quitar la carta del mazo
    (unmake-instance ?barco_en_mazo)
    ; Asignar el barco al jugador
    (make-instance of PARTICIPANTE_TIENE_CARTA (nombre_jugador ?nombre_jugador) (nombre_carta ?nombre_barco))
    ; Aumentar la riqueza del jugador 
    (modify-instance ?jugador (riqueza (+ ?riqueza_jugador ?valor_barco)))
    ; Actualiza los valores relacionados con el barco en el jugador
    (modify-instance ?jugador (num_barcos (+ ?num_barcos 1)) (capacidad_envio (+ ?capacidad_envio_jugador ?capacidad_envio_barco)) (demanda_comida_cubierta (+ ?demanda_comida_cubierta ?uds_comida_genera)))
    ; Eliminar el deseo de comprar el barco
    (retract ?deseo)
    ; Quitar el barco de disponibles
    (retract ?disponible)
    ; Generar hecho semáforo para actualizar el orden de las cartas del mazo
    (assert (actualizar_mazo ?id_mazo (- ?cartas_en_mazo 1) 2))
    ;log
    (printout t"El jugador: <" ?nombre_jugador "> ha comprado el barco: <" ?nombre_barco "> por <" ?coste_barco "> francos al mazo: <"?id_mazo">." crlf)
)

; Regla 9
(defrule COMPRAR_EDIFICIO_AL_MAZO_NO_BONUS
    ; Se puede comprar en la ronda actual. [en todas las rondas excepto la última.]
    (ronda_actual ?nombre_ronda)
    (test (neq ?nombre_ronda RONDA_EXTRA_FINAL))
    ; Obtener al jugador.
    ?jugador <- (object (is-a JUGADOR) (nombre ?nombre_jugador) (riqueza ?riqueza_jugador))
    ; Obtener el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; Obtener el edificio del deseo
    ?deseo <- (deseo_comprar_edificio ?nombre_jugador ?nombre_edificio)
    ; Ha finalizado su actividad principal dentro de su turno.
    (fin_actividad_principal ?nombre_jugador)
    ; El edificio es del mazo
    ?carta_en_mazo <- (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id_mazo) (nombre_carta ?nombre_edificio) (posicion_en_mazo 1))
    ; Obtiene el coste de comprar el edificio
    (object (is-a CARTA) (nombre ?nombre_edificio) (tipo ?) (valor ?valor_edificio))
    ; NO TIENE BONUS
    (not (object (is-a CARTA_TIENE_BONUS)(nombre_carta ?nombre_edificio)(bonus ?)))
    ; Obtiene el dinero del jugador
    ?recurso_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso FRANCO) (cantidad ?cantidad_recurso))
    ; El jugador tiene suficiente dinero
    (test (>= ?cantidad_recurso ?valor_edificio))
    ; el edificio no es el banco
    (test (neq ?nombre_edificio "BANCO"))
    ; obtener el mazo y actualizarlo.
    ?mazo <- (object (is-a MAZO) (id_mazo ?id_mazo) (numero_cartas_en_mazo ?cartas_en_mazo))
    =>
    ; Modificar el dinero del jugador
    (modify-instance ?recurso_jugador (cantidad (- ?cantidad_recurso ?valor_edificio)))
    ; Quitar la carta del mazo y mover todas las cartas 1 posición
    (unmake-instance ?carta_en_mazo)
    ; Asignar el edificio al jugador
    (make-instance of PARTICIPANTE_TIENE_CARTA (nombre_jugador ?nombre_jugador) (nombre_carta ?nombre_edificio))
    ; Aumentar la riqueza del jugador 
    (modify-instance ?jugador (riqueza (+ ?riqueza_jugador ?valor_edificio)))
    ; Eliminar el deseo de comprar el edificio
    (retract ?deseo)
    ; Generar hecho semáforo para actualizar el orden de las cartas del mazo
    (assert (actualizar_mazo ?id_mazo (- ?cartas_en_mazo 1) 2))
    ; actualizar 
    (modify-instance ?mazo (numero_cartas_en_mazo (- ?cartas_en_mazo 1)))
    ; log
    (printout t"El jugador: <" ?nombre_jugador "> ha comprado el edificio: <" ?nombre_edificio "> por <" ?valor_edificio "> francos al mazo <"?id_mazo">." crlf)
)

; Regla 10
(defrule COMPRAR_EDIFICIO_AL_MAZO_SI_BONUS
    ; Se puede comprar en la ronda actual. [en todas las rondas excepto la última.]
    (ronda_actual ?nombre_ronda)
    (test (neq ?nombre_ronda RONDA_EXTRA_FINAL))
    ; Obtener al jugador.
    ?jugador <- (object (is-a JUGADOR) (nombre ?nombre_jugador) (riqueza ?riqueza_jugador))
    ; Obtener el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; Obtener el edificio del deseo
    ?deseo <- (deseo_comprar_edificio ?nombre_jugador ?nombre_edificio)
    ; Ha finalizado su actividad principal dentro de su turno.
    (fin_actividad_principal ?nombre_jugador)
    ; El edificio es del mazo
    ?carta_en_mazo <- (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id_mazo) (nombre_carta ?nombre_edificio) (posicion_en_mazo 1))
    ; Obtiene el coste de comprar el edificio
    (object (is-a CARTA) (nombre ?nombre_edificio) (tipo ?) (valor ?valor_edificio))
    ; obtiene el bonus
    (object (is-a CARTA_TIENE_BONUS)(nombre_carta ?nombre_edificio)(bonus ?bonus))
    ; obtiene la relación de jugador tiene bonus
    ?jugador_tiene_bonus <- (object (is-a JUGADOR_TIENE_BONUS)(nombre_jugador ?nombre_jugador)(tipo ?bonus)(cantidad ?cantidad_bonus))    
    ; Obtiene el dinero del jugador
    ?recurso_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso FRANCO) (cantidad ?cantidad_recurso))
    ; El jugador tiene suficiente dinero
    (test (>= ?cantidad_recurso ?valor_edificio))
    ; el edificio no es el banco
    (test (neq ?nombre_edificio "BANCO"))
    ; obtener el mazo y actualizarlo.
    ?mazo <- (object (is-a MAZO) (id_mazo ?id_mazo) (numero_cartas_en_mazo ?cartas_en_mazo))
    =>
    ; Modificar el dinero del jugador
    (modify-instance ?recurso_jugador (cantidad (- ?cantidad_recurso ?valor_edificio)))
    ; Quitar la carta del mazo y mover todas las cartas 1 posición
    (unmake-instance ?carta_en_mazo)
    ; Asignar el edificio al jugador
    (make-instance of PARTICIPANTE_TIENE_CARTA (nombre_jugador ?nombre_jugador) (nombre_carta ?nombre_edificio))
    ; Aumentar la riqueza del jugador 
    (modify-instance ?jugador (riqueza (+ ?riqueza_jugador ?valor_edificio)))
    ; Eliminar el deseo de comprar el edificio
    (retract ?deseo)
    ; Generar hecho semáforo para actualizar el orden de las cartas del mazo
    (assert (actualizar_mazo ?id_mazo (- ?cartas_en_mazo 1) 2))
    ; actualizar 
    (modify-instance ?mazo (numero_cartas_en_mazo (- ?cartas_en_mazo 1)))
    ; actualizar los bonus de los jugadores.
    (modify-instance ?jugador_tiene_bonus (cantidad (+ ?cantidad_bonus 1)))
    (printout t"El jugador: <" ?nombre_jugador "> ha comprado el edificio: <" ?nombre_edificio "> [que tiene bonus: <"?bonus">] por <" ?valor_edificio "> francos al mazo <"?id_mazo">." crlf)
)

; Regla 11 => No usada en la estrategia implementada.
(defrule COMPRAR_EDIFICIO_BANCO_DEL_MAZO
    ; Se puede comprar en la ronda actual. [en todas las rondas excepto la última.]
    (ronda_actual ?nombre_ronda)
    (test (neq ?nombre_ronda RONDA_EXTRA_FINAL))
    ; Obtener al jugador.
    ?jugador <- (object (is-a JUGADOR) (nombre ?nombre_jugador) (riqueza ?riqueza_jugador))
    ; Obtener el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; Obtener el edificio del deseo
    ?deseo <- (deseo_comprar_edificio ?nombre_jugador ?nombre_edificio)
    ; Ha finalizado su actividad principal dentro de su turno.
    (fin_actividad_principal ?nombre_jugador)
    ; El edificio es del mazo
    ?carta_en_mazo <- (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id_mazo) (nombre_carta ?nombre_edificio) (posicion_en_mazo 1))
    ; Obtiene el coste de comprar el edificio
    (object (is-a CARTA_BANCO) (nombre ?nombre_edificio) (coste ?coste_edificio) (valor ?valor_edificio))
    ; Obtiene el dinero del jugador
    ?recurso_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso FRANCO) (cantidad ?cantidad_recurso))
    ; El jugador tiene suficiente dinero
    (test (>= ?cantidad_recurso ?coste_edificio))
    ; obtener el mazo y actualizarlo.
    ?mazo <- (object (is-a MAZO) (id_mazo ?id_mazo) (numero_cartas_en_mazo ?cartas_en_mazo))
    =>
    ; Modificar el dinero del jugador
    (modify-instance ?recurso_jugador (cantidad (- ?cantidad_recurso ?coste_edificio)))
    ; Quitar la carta del mazo y mover todas las cartas 1 posición
    (unmake-instance ?carta_en_mazo)
    ; Asignar el edificio al jugador
    (make-instance of PARTICIPANTE_TIENE_CARTA (nombre_jugador ?nombre_jugador) (nombre_carta ?nombre_edificio))
    ; Aumentar la riqueza del jugador 
    (modify-instance ?jugador (riqueza (+ ?riqueza_jugador ?valor_edificio)))
    ; Eliminar el deseo de comprar el edificio
    (retract ?deseo)
    ; Generar hecho semáforo para actualizar el orden de las cartas del mazo
    (assert (actualizar_mazo ?id_mazo (- ?cartas_en_mazo 1) 2))
    ; actualizar mazo
    (modify-instance ?mazo (numero_cartas_en_mazo (- ?cartas_en_mazo 1)))
    (printout t"El jugador: <" ?nombre_jugador "> ha comprado el edificio: <" ?nombre_edificio "> por <" ?coste_edificio "> francos al mazo <"?id_mazo">." crlf)
)

; Regla 12 => No usada en la estrategia implementada.
(defrule VENDER_CARTA_NO_BONUS
    ; Obtener al jugador.
    ?jugador <- (object (is-a JUGADOR) (nombre ?nombre_jugador) (riqueza ?riqueza_jugador))
    ; Existe un deseo de vender un edificio
    ?deseo <- (deseo_vender_carta ?nombre_jugador ?nombre_carta)
    ; Ha finalizado su actividad principal dentro de su turno.
    (fin_actividad_principal ?nombre_jugador)
    ; Es el turno del jugador
    (turno ?nombre_jugador)
    ; El jugador tiene la carta. 
    ?edificio_jugador <- (object (is-a PARTICIPANTE_TIENE_CARTA) (nombre_jugador ?nombre_jugador)(nombre_carta ?nombre_carta))
     ; NO TIENE BONUS
    (not (object (is-a CARTA_TIENE_BONUS)(nombre_carta ?nombre_edificio)(bonus ?)))
    ; referencia de la carta para obtener su valor. 
    ?carta <- (object (is-a CARTA) (nombre ?nombre_carta) (valor ?valor_carta))
    ; referencia del recurso del jugador.
    ?recurso_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso FRANCO) (cantidad ?cantidad_recurso))
    =>
    ; obtener el beneficio de la venta de la carta.
    (bind ?ingreso (integer (/ ?valor_carta 2)))
    ; Modificar el dinero del jugador
    (modify-instance ?recurso_jugador (cantidad (+ ?cantidad_recurso ?ingreso)))
    ; Decrementar la riqueza del jugador 
    (modify-instance ?jugador (riqueza (- ?riqueza_jugador ?valor_carta)))
    ; Asignar edificio al ayuntamiento
    (make-instance of PARTICIPANTE_TIENE_CARTA (nombre_jugador "AYUNTAMIENTO")(nombre_carta ?nombre_carta))
    ; Quitarle el edificio al jugador
    (unmake-instance ?edificio_jugador)
    ; quitar el deseo.
    (retract ?deseo)
    ; print final
    (printout t"El jugador: <" ?nombre_jugador "> ha vendido el edificio: <" ?nombre_carta "> por <" ?ingreso "> francos." crlf)
)

; Regla 13 => No usada en la estrategia implementada.
(defrule VENDER_CARTA_SI_BONUS
    ; Obtener al jugador.
    ?jugador <- (object (is-a JUGADOR) (nombre ?nombre_jugador) (riqueza ?riqueza_jugador))
    ; Existe un deseo de vender un edificio
    ?deseo <- (deseo_vender_carta ?nombre_jugador ?nombre_carta)
    ; Ha finalizado su actividad principal dentro de su turno.
    (fin_actividad_principal ?nombre_jugador)
    ; Es el turno del jugador
    (turno ?nombre_jugador)
    ; El jugador tiene la carta. 
    ?edificio_jugador <- (object (is-a PARTICIPANTE_TIENE_CARTA) (nombre_jugador ?nombre_jugador)(nombre_carta ?nombre_carta))
    ; obtiene el bonus
    (object (is-a CARTA_TIENE_BONUS)(nombre_carta ?nombre_carta)(bonus ?bonus))
    ; obtiene la relación de jugador tiene bonus
    ?jugador_tiene_bonus <- (object (is-a JUGADOR_TIENE_BONUS)(nombre_jugador ?nombre_jugador)(tipo ?bonus)(cantidad ?cantidad_bonus))   
    ; referencia de la carta para obtener su valor. 
    ?carta <- (object (is-a CARTA) (nombre ?nombre_carta) (valor ?valor_carta))
    ; referencia del recurso del jugador.
    ?recurso_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso FRANCO) (cantidad ?cantidad_recurso))
    =>
    ; obtener el beneficio de la venta de la carta.
    (bind ?ingreso (integer (/ ?valor_carta 2)))
    ; Modificar el dinero del jugador
    (modify-instance ?recurso_jugador (cantidad (+ ?cantidad_recurso ?ingreso)))
    ; Decrementar la riqueza del jugador 
    (modify-instance ?jugador (riqueza (- ?riqueza_jugador ?valor_carta)))
    ; Asignar edificio al ayuntamiento
    (make-instance of PARTICIPANTE_TIENE_CARTA (nombre_jugador "AYUNTAMIENTO")(nombre_carta ?nombre_carta))
    ; Quitarle el edificio al jugador
    (unmake-instance ?edificio_jugador)
    ; quitar el deseo.
    (retract ?deseo)
    (modify-instance ?jugador_tiene_bonus (cantidad (- ?cantidad_bonus 1)))
    ; print final
    (printout t"El jugador: <" ?nombre_jugador "> ha vendido el edificio: <" ?nombre_carta "> [que tiene bonus: <"?bonus">] por <" ?ingreso "> francos." crlf)
)

; Regla 14 => No usada en la estrategia implementada.
(defrule VENDER_BARCO
    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; Existe el deseo de vender el barco
    ?deseo <- (deseo_vender_barco ?nombre_jugador ?nombre_barco)
    ; Ha finalizado su actividad principal dentro de su turno.
    (fin_actividad_principal ?nombre_jugador)
    ; El barco es del jugador
    ?jugador_tiene_barco <- (object (is-a PARTICIPANTE_TIENE_CARTA) (nombre_jugador ?nombre_jugador)(nombre_carta ?nombre_barco))
    ; Obtiene el valor del barco
    ?barco <- (object (is-a BARCO)(nombre ?nombre_barco)(coste ?coste_barco)(valor ?valor_barco)(uds_comida_genera ?uds_comida_genera)(capacidad_envio ?capacidad_envio_barco))
    ; Obtiene el dinero del jugador
    ?recurso_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso FRANCO) (cantidad ?cantidad_recurso))
    ; se obtiene al jugador
    ?jugador <- (object (is-a JUGADOR)(nombre ?nombre_jugador)(num_barcos ?num_barcos)(capacidad_envio ?capacidad_envio_jugador)(demanda_comida_cubierta ?demanda_comida_cubierta)(riqueza ?riqueza_jugador))
    ; Obtener el mazo del barco
    (barco_pertenece_mazo ?nombre_barco ?id_mazo)
    ?mazo_barco <- (object(is-a MAZO)(id_mazo ?id_mazo)(numero_cartas_en_mazo ?num_cartas_mazo))
    =>
    ; Elimina el barco del jugador
    (unmake-instance ?jugador_tiene_barco)
    ; Actualiza los valores relacionados con el barco en el jugador
    (modify-instance ?jugador (num_barcos (- ?num_barcos 1)) (capacidad_envio (- ?capacidad_envio_jugador ?capacidad_envio_barco)) (demanda_comida_cubierta (- ?demanda_comida_cubierta ?uds_comida_genera)))
    ; Actualiza el dinero del jugador
    (modify-instance ?recurso_jugador (cantidad (integer (+ ?cantidad_recurso (/ ?valor_barco 2)))))
    ; Decrementar la riqueza del jugador 
    (modify-instance ?jugador (riqueza (- ?riqueza_jugador ?valor_barco)))
    ; Insertar el barco en el mazo
    (make-instance of CARTA_PERTENECE_A_MAZO (id_mazo ?id_mazo) (nombre_carta ?nombre_barco) (posicion_en_mazo (+ ?num_cartas_mazo 1)))
    (modify-instance ?mazo_barco (numero_cartas_en_mazo (+ ?num_cartas_mazo 1)))
    ; Elimina el deseo
    (retract ?deseo)
    ; log
    (printout t"El jugador <"?nombre_jugador"> ha vendido el barco <"?nombre_barco"> por <"(integer (/ ?valor_barco 2))"> francos." crlf)
)

; Regla 15
(defrule PAGAR_DEUDA
    ; Para simplificar la ejecución, debe ser el turno del jugador
    (turno ?nombre_jugador)
    ; Además, simplificamos para que haya terminado la actividad principal
    (fin_actividad_principal ?nombre_jugador)
    ; obtiene las deudas del jugador
    ?jugador <- (object (is-a JUGADOR) (nombre ?nombre_jugador) (deudas ?numero_deudas))
    ; deseo de pagar deudas
    ; todo: el jugador en una regla estratégica deberá comprobar cuanta deuda quiere pagar.
    ?deseo <- (deseo_pagar_deuda ?nombre_jugador ?numero_deudas_deseo)
    ; Obtener los francos del jugador
    ?jugador_dinero <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso FRANCO) (cantidad ?cantidad_francos))
    ;(bind cantidad_a_pagar (min (* 5 ?deudas) ?cantidad_deuda))
    (test (> ?cantidad_francos (* 5 ?numero_deudas_deseo)))
    =>
    (modify-instance ?jugador_dinero (cantidad (- ?cantidad_francos (* 5 ?numero_deudas_deseo))))
    (modify-instance ?jugador (deudas (- ?numero_deudas ?numero_deudas_deseo)))
    (retract ?deseo)
    (printout t"El jugador <" ?nombre_jugador "> ha pagado <" ?numero_deudas_deseo "> deudas por un valor de <" (* 5 ?numero_deudas_deseo) ">." crlf)
)

; Regla 16
(defrule AÑADIR_CARTA_AYUNTO_FINAL_RONDA
    ; encontrarse en el cambio de ronda.
    (cambiar_ronda TRUE)
    ; ronda actual
    (ronda_actual ?nombre_ronda_actual)
    ; la ronda actual asigna un edificio al ayunto.
    ?asignacion_edificio <- (object (is-a RONDA_ASIGNA_EDIFICIO) (nombre_ronda ?nombre_ronda_actual) (id_mazo ?id_mazo))
    ; el mazo tiene que tener más de 1 carta.
    ?ref_mazo <- (object (is-a MAZO) (id_mazo ?id_mazo) (numero_cartas_en_mazo ?num_cartas_en_mazo))
    (test (> ?num_cartas_en_mazo 0))
    ; seleccionar la primera carta del mazo.
    ?carta_en_mazo <- (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id_mazo) (nombre_carta ?nombre_edificio) (posicion_en_mazo 1))
    =>
    ; Eliminar carta mazo.
    (unmake-instance ?carta_en_mazo)
    ; indicar que el edificio se encuentra ahora en el ayunto.
    (make-instance of PARTICIPANTE_TIENE_CARTA (nombre_jugador "AYUNTAMIENTO") (nombre_carta ?nombre_edificio))
    ; actualiza el numero de cartas en el mazo.
    (modify-instance ?ref_mazo (numero_cartas_en_mazo (- ?num_cartas_en_mazo 1)))
    ; Generar hecho semáforo para actualizar el orden de las cartas del mazo
    (assert (actualizar_mazo ?id_mazo (- ?num_cartas_en_mazo 1) 2))
    ; Elimina la instancia de ronda_asigna_edificio
    (unmake-instance ?asignacion_edificio)
    ; semáforo para pasar de ronda 
    (assert (edificio_entregado ?nombre_ronda_actual))
    (printout t"Se ha añadido el edificio: <" ?nombre_edificio "> al AYUNTAMIENTO desde el mazo <" ?id_mazo "> durante el cambio de ronda." crlf)
)

; Regla 17
(defrule PAGAR_DEMANDA_COMIDA
    ; Si el jugador no tuviese recursos suficientes, tomará automáticamente una deuda.
    ; semáforo cambiar ronda
    (cambiar_ronda TRUE)
    ; obtener los datos del jugador.
    (object (is-a JUGADOR) (nombre ?nombre_jugador))
    ; obtener los datos de la ronda.
    (ronda_actual ?ronda)
    (object (is-a RONDA) (nombre_ronda ?ronda) (coste_comida ?coste_ronda))
    ; deseo de pagar la demanda de la ronda con los recursos del jugador.
    ?deseo <- (deseo_pagar_demanda ?nombre_jugador ?deseo_pagar_pescado ?deseo_pagar_pescado_ahumado ?deseo_pagar_pan ?deseo_pagar_carne ?deseo_pagar_francos)
    ; obtener los recursos del jugador.
    ?jugador_pescado <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso PESCADO) (cantidad ?cantidad_pescado))
    ?jugador_pescado_ahumado <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso PESCADO_AHUMADO) (cantidad ?cantidad_pescado_ahumado))
    ?jugador_pan <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso PAN) (cantidad ?cantidad_pan))
    ?jugador_carne <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso CARNE) (cantidad ?cantidad_carne))
    ?jugador_francos <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso FRANCO) (cantidad ?cantidad_francos))
    ; obtener contador de pagar comida.
    ?comida_restante <- (cantidad_comida_demandada ?nombre_jugador ?ronda ?cantidad_queda_por_pagar)
    ; queda por pagar una cantidad mayor / igual de 0.
    ; Note que si es cero se limpian los deseos y se permite seguir con el flow de la partida.
    (test (>= ?cantidad_queda_por_pagar 0))
    ; Tiene que tener recursos para poder pagar. Sino se endeudará.
    (test (> (+ (* ?cantidad_pescado 1) (* ?cantidad_pescado_ahumado 2)  (* ?cantidad_pan 3) (* ?cantidad_carne 3) (* ?cantidad_francos 1)) 0))  
    =>
    
    (bind ?total_recursos_para_pagar (+ (* ?cantidad_pescado 1) (* ?cantidad_pescado_ahumado 2)  (* ?cantidad_pan 3) (* ?cantidad_carne 3) (* ?cantidad_francos 1) ))
    ; Actualizar las cantidades.
    (modify-instance ?jugador_pescado (cantidad (- ?cantidad_pescado ?deseo_pagar_pescado)))
    (modify-instance ?jugador_pescado_ahumado (cantidad (- ?cantidad_pescado_ahumado ?deseo_pagar_pescado_ahumado)))
    (modify-instance ?jugador_pan (cantidad (- ?cantidad_pan ?deseo_pagar_pan)))
    (modify-instance ?jugador_carne (cantidad (- ?cantidad_carne ?deseo_pagar_carne)))
    (modify-instance ?jugador_francos (cantidad (- ?cantidad_francos ?deseo_pagar_francos)))
    ; Eliminar el deseo.
    (retract ?deseo)
    ; Actualizar la comida restante.
    (retract ?comida_restante )
    (assert (cantidad_comida_demandada ?nombre_jugador ?ronda (max 0 (- ?cantidad_queda_por_pagar ?total_recursos_para_pagar)) ))
    ; log
    (printout t"El jugador: <"?nombre_jugador"> dispone de: <"?total_recursos_para_pagar"> unidades [COMIDA & DINERO] para satisfacer <"?cantidad_queda_por_pagar"> de demanda de comida restantes." crlf)
    (printout t"El jugador: <"?nombre_jugador"> tiene que pagar aún un total de: <" (max 0 (- ?cantidad_queda_por_pagar ?total_recursos_para_pagar)) "> unidades de la demanda de comida." crlf)
)

; Problemas al no tener una función ceil en CLIPS. Se ha tenido que desdoblar en dos reglas 
; debido a que la expresión matemática empleada no contempla el caso de X mod 4 == 0.
; Cuando X mod 4 != 0 sí se cumple. 

; Regla 18
(defrule PAGAR_COMIDA_ENDEUDANDOSE_MODULO_DISTINTO_0
    ; se está en medio de un cambio de ronda.
    (cambiar_ronda TRUE)
    ; obtener los datos del jugador.
    ?jugador <- (object (is-a JUGADOR) (nombre ?nombre_jugador)(deudas ?deudas))
    ; obtener los datos de la ronda.
    (ronda_actual ?ronda)
    ; obtener los recursos del jugador.
    ?jugador_pescado <- (object (is-a PARTICIPANTE_TIENE_RECURSO)(nombre_jugador ?nombre_jugador) (recurso PESCADO) (cantidad 0))
    ?jugador_pescado_ahumado <- (object (is-a PARTICIPANTE_TIENE_RECURSO)(nombre_jugador ?nombre_jugador) (recurso PESCADO_AHUMADO) (cantidad 0))
    ?jugador_pan <- (object (is-a PARTICIPANTE_TIENE_RECURSO)(nombre_jugador ?nombre_jugador) (recurso PAN) (cantidad 0))
    ?jugador_carne <- (object (is-a PARTICIPANTE_TIENE_RECURSO)(nombre_jugador ?nombre_jugador) (recurso CARNE) (cantidad 0))
    ?jugador_francos <- (object (is-a PARTICIPANTE_TIENE_RECURSO)(nombre_jugador ?nombre_jugador) (recurso FRANCO) (cantidad 0))
    ; obtener contador de pagar comida.
    ?comida_restante <- (cantidad_comida_demandada ?nombre_jugador ?ronda ?cantidad_queda_por_pagar)
     ; queda por pagar una cantidad distinta de 0.
    (test (> ?cantidad_queda_por_pagar 0))
    (test (<> (mod ?cantidad_queda_por_pagar 4) 0))
    =>
    ; Calcular cuántos préstamos hay que tomar para poder pagar toda la comida
    ; IMPLEMENTA LA FUNCIÓN CEIL: c = comida a pagar, v = valor deuda :
    ;       préstamos a tomar = (c / v)+(1-((c mod v) / v))
    (bind ?deudas_a_obtener (integer (+ (/ ?cantidad_queda_por_pagar 4) (- 1 (/ (mod ?cantidad_queda_por_pagar 4) 4)))  ))
    ; modificar valores deudas y cantidades francos.
    (modify-instance ?jugador (deudas (+ ?deudas ?deudas_a_obtener)))
    (modify-instance ?jugador_francos (cantidad (- (* ?deudas_a_obtener 4) ?cantidad_queda_por_pagar)))
    ; actualizar hecho de cantidad comida demandada. Se generan tantas deudas como sean necesarias y se finaliza de una tacada el pago.
    (retract ?comida_restante)
    (assert (cantidad_comida_demandada ?nombre_jugador ?ronda 0))
    ; Log.
    (printout t"El jugador: <"?nombre_jugador"> tiene que pagar aún un total de: <" ?cantidad_queda_por_pagar "> unidades de la demanda de comida y no tiene recursos para asumir el pago." crlf)
    (printout t"El jugador: <"?nombre_jugador"> se ha visto obligado a tomar: <"?deudas_a_obtener"> deuda(s) para poder pagar <"?cantidad_queda_por_pagar"> unidad(es) de comida demandada restante(s)." crlf)
)

; Regla 19
(defrule PAGAR_COMIDA_ENDEUDANDOSE_MODULO_0
    ; se está en medio de un cambio de ronda.
    (cambiar_ronda TRUE)
    ; obtener los datos del jugador.
    ?jugador <- (object (is-a JUGADOR) (nombre ?nombre_jugador)(deudas ?deudas))
    ; obtener los datos de la ronda.
    (ronda_actual ?ronda)
    ; obtener los recursos del jugador.
    ?jugador_pescado <- (object (is-a PARTICIPANTE_TIENE_RECURSO)(nombre_jugador ?nombre_jugador) (recurso PESCADO) (cantidad 0))
    ?jugador_pescado_ahumado <- (object (is-a PARTICIPANTE_TIENE_RECURSO)(nombre_jugador ?nombre_jugador) (recurso PESCADO_AHUMADO) (cantidad 0))
    ?jugador_pan <- (object (is-a PARTICIPANTE_TIENE_RECURSO)(nombre_jugador ?nombre_jugador) (recurso PAN) (cantidad 0))
    ?jugador_carne <- (object (is-a PARTICIPANTE_TIENE_RECURSO)(nombre_jugador ?nombre_jugador) (recurso CARNE) (cantidad 0))
    ?jugador_francos <- (object (is-a PARTICIPANTE_TIENE_RECURSO)(nombre_jugador ?nombre_jugador) (recurso FRANCO) (cantidad 0))
    
    ; obtener contador de pagar comida.
    ?comida_restante <- (cantidad_comida_demandada ?nombre_jugador ?ronda ?cantidad_queda_por_pagar)
     ; queda por pagar una cantidad distinta de 0.
    (test (> ?cantidad_queda_por_pagar 0))
    ; comprobación módulo
    (test (= (mod ?cantidad_queda_por_pagar 4) 0))
    =>
    ; Al ser x mod 4 = 0 basta con hacer la división y transformarlo a integer.
    (bind ?deudas_a_obtener (integer (/ ?cantidad_queda_por_pagar 4)))
    ; modificar valores deudas y francos.
    (modify-instance ?jugador (deudas (+ ?deudas ?deudas_a_obtener)))
    (modify-instance ?jugador_francos (cantidad (- (* ?deudas_a_obtener 4) ?cantidad_queda_por_pagar)))
    ; actualizar hecho de cantidad comida demandada.
    (retract ?comida_restante)
    (assert (cantidad_comida_demandada ?nombre_jugador ?ronda 0))
    ; Log.
    (printout t"El jugador: <"?nombre_jugador"> tiene que pagar aún un total de: <" ?cantidad_queda_por_pagar "> unidades de la demanda de comida y no tiene recursos para asumir el pago." crlf)
    (printout t"El jugador: <"?nombre_jugador"> se ha visto obligado a tomar: <"?deudas_a_obtener"> deuda(s) para poder pagar <"?cantidad_queda_por_pagar"> unidad(es) de comida demandada restante(s)." crlf)
)

; Reglas 20, 21 podrían simplificarse..
; Regla 20
(defrule AÑADIR_GANADO_POR_COSECHA
    (ronda_actual ?nombre_ronda_actual)
    ; precondiciones de ejecución: se ejecutará por cada jugador que se le añada algo.
    (object (is-a RONDA) (nombre_ronda ?nombre_ronda_actual) (hay_cosecha TRUE))
    ; cuando ambos jugadores hayan pagado su demanda, se añadirá la cosecha
    (object (is-a JUGADOR) (nombre ?nombre_jugador1) )
    (object (is-a JUGADOR) (nombre ?nombre_jugador2) )
    (test (neq ?nombre_jugador1 ?nombre_jugador2))
    (cantidad_comida_demandada ?nombre_jugador1 ?nombre_ronda_actual 0)
    (cantidad_comida_demandada ?nombre_jugador2 ?nombre_ronda_actual 0)
    ; no haya pillado cosecha
    (not (cosechado ?nombre_jugador1 ?nombre_ronda_actual GANADO))
    ; recursos jugador.  
    ?ganado_jugador1 <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador1) (recurso GANADO) (cantidad ?cantidad_ganado))
    ; comprobar cantidades.
    (test (> ?cantidad_ganado 1))
    =>
    (modify-instance ?ganado_jugador1 (cantidad (+ ?cantidad_ganado 1)))
    ; bloquear que se ejecute varias veces.
    (assert (cosechado ?nombre_jugador1 ?nombre_ronda_actual GANADO))
    (printout t"El jugador <" ?nombre_jugador1 "> ha recibido de la cosecha +1 GANADO." crlf)
)

; Regla 21
(defrule AÑADIR_GRANO_POR_COSECHA
    (ronda_actual ?nombre_ronda_actual)
    ; precondiciones de ejecución: se ejecutará por cada jugador que se le añada algo.
    (object (is-a RONDA) (nombre_ronda ?nombre_ronda_actual) (hay_cosecha TRUE))
    ; cuando ambos jugadores hayan pagado su demanda, se añadirá la cosecha
    (object (is-a JUGADOR) (nombre ?nombre_jugador1) )
    (object (is-a JUGADOR) (nombre ?nombre_jugador2) )
    ; ambos jugadores han pagado.
    (cantidad_comida_demandada ?nombre_jugador1 ?nombre_ronda_actual 0)
    (cantidad_comida_demandada ?nombre_jugador2 ?nombre_ronda_actual 0)  
    ; jugadores distintos.
    (test (neq ?nombre_jugador1 ?nombre_jugador2))
    ; no haya pillado cosecha
    (not (cosechado ?nombre_jugador1 ?nombre_ronda_actual GRANO))
    ; recursos jugador.  
    ?grano_jugador1 <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador1) (recurso GRANO) (cantidad ?cantidad_grano))
    ; comprobar cantidades.
    (test (> ?cantidad_grano 0))
    =>
    (modify-instance ?grano_jugador1 (cantidad (+ ?cantidad_grano 1)))
    (assert (cosechado ?nombre_jugador1 ?nombre_ronda_actual GRANO))
    ; log.
    (printout t"El jugador <" ?nombre_jugador1 "> ha recibido de la cosecha +1 GRANO." crlf)
)

; Regla 22
(defrule PASAR_TURNO_AL_FINAL_DE_LA_RONDA
    ; para cambiar de ronda se tiene que dar la siguiente situación
    ;1| |1| |1|2|1|   y turno de 2
    ;0|1|2|3|4|5|6|0
    ?jugador1 <- (object (is-a JUGADOR) (nombre ?nombre_jugador1)(demanda_comida_cubierta ?demanda_comida_cubierta_jugador1))
    ?posicion_jugador1 <- (object (is-a JUGADOR_ESTA_EN_LOSETA) (posicion ?pos_jugador1) (nombre_jugador ?nombre_jugador1))
    ?jugador2 <- (object (is-a JUGADOR) (nombre ?nombre_jugador2)(demanda_comida_cubierta ?demanda_comida_cubierta_jugador2))
    ?posicion_jugador2 <- (object (is-a JUGADOR_ESTA_EN_LOSETA) (posicion ?pos_jugador2) (nombre_jugador ?nombre_jugador2))
    (test (eq ?pos_jugador1 6))
    (test (eq ?pos_jugador2 5))
    (test (neq ?jugador1 ?jugador2))
    ; Ha finalizado su actividad principal dentro de su turno.
    ?turno_finalizado <- (fin_actividad_principal ?nombre_jugador1)
    ?turno_j1 <- (turno ?nombre_jugador1)
    ; se ha realizado la limpieza de razonamiento del jugador.
    ?limpieza <- (proceso_limpieza_finalizado ?nombre_jugador1)
    ; obtener de la ronda, la demanda de comida.
    (ronda_actual ?nombre_ronda_actual)
    (object (is-a RONDA) (nombre_ronda ?nombre_ronda_actual) (coste_comida ?coste_comida))
    ; eliminar el semaforo de la restriccion de añadir recurso a la oferta.
    ?semaforo <- (recursos_añadidos_loseta ?)
    =>
    (bind ?nueva_posicion (+ ?pos_jugador2 2))
    ; deshace el hecho semaforo del turno.
    (retract ?turno_finalizado)
    ; eliminar turno jugador 1
    (retract ?turno_j1)
    ; eliminar la limpieza.
    (retract ?limpieza)
    ; generar hecho turno j2.
    (assert (turno ?nombre_jugador2))
    ; modifica la posición del jugador 2
    (modify-instance ?posicion_jugador2 (posicion (mod ?nueva_posicion 7)))
    ; eliminar semaforo
    (retract ?semaforo)
    ; añadir semaforo
    (assert (cambiar_ronda TRUE))
    ; iniciar contadores para llevar registro de la comida que falta por pagar.
    (assert (cantidad_comida_demandada ?nombre_jugador1 ?nombre_ronda_actual (max 0 (- ?coste_comida ?demanda_comida_cubierta_jugador1))))
    (assert (cantidad_comida_demandada ?nombre_jugador2 ?nombre_ronda_actual (max 0 (- ?coste_comida ?demanda_comida_cubierta_jugador2))))
    ; contadores    
    (assert (contador_comida_demandada ?nombre_jugador1 ?nombre_ronda_actual (max 0 (- ?coste_comida ?demanda_comida_cubierta_jugador1))))
    (assert (contador_comida_demandada ?nombre_jugador2 ?nombre_ronda_actual (max 0 (- ?coste_comida ?demanda_comida_cubierta_jugador2))))
    ; logs
    (printout t"El jugador: <" ?nombre_jugador1 "> ha finalizado su turno. " crlf)
    (printout t"El jugador: <" ?nombre_jugador2 "> ha empezado su turno en la posicion <" (mod ?nueva_posicion 7) ">. " crlf)
    (printout t"La ronda: <"?nombre_ronda_actual"> tiene una demanda de comida de: <" ?coste_comida "> unidades." crlf)
)

; Regla 23
(defrule PASAR_TURNO
    ; pensar si debería haber alguna precondición o si simplemente por estar 
    ; en la posición que está la regla ya se asegura que sólo se instancia
    ; cuando el jugador no puede hacer nada más
    ?jugador1 <- (object (is-a JUGADOR) (nombre ?nombre_jugador1))
    ?jugador2 <- (object (is-a JUGADOR) (nombre ?nombre_jugador2))
    ?posicion_jugador1 <- (object (is-a JUGADOR_ESTA_EN_LOSETA) (posicion ?pos_jugador1) (nombre_jugador ?nombre_jugador1))
    ?posicion_jugador2 <- (object (is-a JUGADOR_ESTA_EN_LOSETA) (posicion ?pos_jugador2) (nombre_jugador ?nombre_jugador2))
    (test (neq ?jugador1 ?jugador2))
    (test (neq ?pos_jugador1 6))
    ; Ha finalizado su actividad principal dentro de su turno.
    ?turno_finalizado <- (fin_actividad_principal ?nombre_jugador1)
    ?turno_j1 <- (turno ?nombre_jugador1)
    ; se ha realizado la limpieza de razonamiento del jugador.
    ?limpieza <- (proceso_limpieza_finalizado ?nombre_jugador1)
    ; Generalización: mueve al otro jugador
    ?posicion_actual_jugador2 <- (object (is-a JUGADOR_ESTA_EN_LOSETA) (posicion ?pos_jugador2) (nombre_jugador ?nombre_jugador2))
    ; eliminar el semaforo de la restriccion de añadir recurso a la oferta.
    ?semaforo <- (recursos_añadidos_loseta ?)
    ; No existen actualizaciones de mazo.
    (not (actualizar_mazo ? ? ?))
    =>
    (bind ?nueva_posicion (+ ?pos_jugador2 2))
    ; deshace el hecho semaforo del turno.
    (retract ?limpieza)
    (retract ?turno_finalizado)
    ; eliminar turno jugador 1
    (retract ?turno_j1)
    ; generar hecho turno j2.
    (assert (turno ?nombre_jugador2))
    ; modifica la posición del jugador 2
    (modify-instance ?posicion_actual_jugador2 (posicion (mod ?nueva_posicion 7)))
    ; eliminar semaforo
    (retract ?semaforo)
    (printout t"El jugador: <" ?nombre_jugador1 "> ha finalizado su turno. " crlf)
    (printout t"El jugador: <" ?nombre_jugador2 "> ha empezado su turno en la posicion <" (mod ?nueva_posicion 7) ">. " crlf)
)

; Regla 24
(defrule PASAR_TURNO_RONDA_EXTRA_FINAL
    (ronda_actual RONDA_EXTRA_FINAL)
    ; pensar si debería haber alguna precondición o si simplemente por estar 
    ; en la posición que está la regla ya se asegura que sólo se instancia
    ; cuando el jugador no puede hacer nada más
    ?jugador1 <- (object (is-a JUGADOR) (nombre ?nombre_jugador1))
    ?jugador2 <- (object (is-a JUGADOR) (nombre ?nombre_jugador2))
    (test (neq ?jugador1 ?jugador2))
    ; Ha finalizado su actividad principal dentro de su turno.
    ?turno_finalizado <- (fin_actividad_principal ?nombre_jugador1)
    ?turno_j1 <- (turno ?nombre_jugador1)
    ; se ha realizado la limpieza de razonamiento del jugador.
    (proceso_limpieza_finalizado ?nombre_jugador1)
    ; No existen actualizaciones de mazo.
    (not (actualizar_mazo ? ? ?))
    ?turnos_restantes <- (turnos_restantes ?restantes)
    ; tiene que ser mayor que 0 para pasar turno.
    (test (> ?restantes 0))
    =>
    ; deshace el hecho semaforo del turno.
    (retract ?turno_finalizado)
    ; eliminar turno jugador 1
    (retract ?turno_j1)
    ; descuenta un turno.
    (retract ?turnos_restantes)
    (assert (turnos_restantes (- ?restantes 1)))
    ; generar hecho turno j2.
    (assert (turno ?nombre_jugador2))
    (printout t"El jugador: <" ?nombre_jugador1 "> ha finalizado su turno. " crlf)
    (printout t"El jugador: <" ?nombre_jugador2 "> ha empezado su turno." crlf)
)

; Regla 25
(defrule AÑADIR_RECURSOS_OFERTA
    ; Esperar a que termine el proceso de ejecución de cambio de ronda.
    (not (cambiar_ronda TRUE))
    ; la ronda actual no puede ser la ronda final
    (not (ronda_actual RONDA_EXTRA_FINAL))
    ; no añadir dos veces 
    (not (recursos_añadidos_loseta ?pos))
    ; obtiene la loseta con visibilidad TRUE
    ?loseta <- (object (is-a LOSETA) (posicion ?pos) (visibilidad TRUE))
    ; el jugador está en la loseta
    (object (is-a JUGADOR_ESTA_EN_LOSETA) (posicion ?pos) (nombre_jugador ?nombre_jugador))
    ; y turno jugador
    (turno ?nombre_jugador)
    ; Obtiene la oferta
    ?oferta_recurso1 <- (OFERTA_RECURSO (recurso ?recurso1) (cantidad ?cantidad_oferta1))
    ?oferta_recurso2 <- (OFERTA_RECURSO (recurso ?recurso2) (cantidad ?cantidad_oferta2))
    ; Por cada recurso de la loseta...
    ?ref_recurso1 <- (object (is-a LOSETA_TIENE_RECURSO) (posicion ?pos) (recurso ?recurso1) (cantidad ?cantidad_recurso1))
    ?ref_recurso2 <- (object (is-a LOSETA_TIENE_RECURSO) (posicion ?pos) (recurso ?recurso2) (cantidad ?cantidad_recurso2))
    (test (neq ?ref_recurso1 ?ref_recurso2))
    => 
    ; añadir a la oferta.
    (modify ?oferta_recurso1 (cantidad (+ ?cantidad_oferta1 ?cantidad_recurso1)))
    (modify ?oferta_recurso2 (cantidad (+ ?cantidad_oferta2 ?cantidad_recurso2)))
    ; evitar bucle y que otras reglas estratégicas se adelanten.
    (assert (recursos_añadidos_loseta ?pos))
    ; Ahora los jugadores podrán realizar su acción.
    (assert (permitir_realizar_accion ?nombre_jugador))
    (printout t"Se han añadido a la OFERTA los recursos de la loseta con posición: <" ?pos ">" crlf)
    (printout t"-> La cantidad <" ?cantidad_recurso1 "> de recurso <" ?recurso1 ">." crlf)
    (printout t"-> La cantidad <" ?cantidad_recurso2 "> de recurso <" ?recurso2 ">." crlf)
)

; Regla 26
(defrule TOMAR_RECURSO_OFERTA
    ; si loseta oculta no se puede tomar recurso de la oferta.
    (object (is-a LOSETA) (posicion ?pos_jugador) (visibilidad TRUE))
    (object (is-a JUGADOR_ESTA_EN_LOSETA) (posicion ?pos_jugador) (nombre_jugador ?nombre_jugador))
    ; El jugador q esté en la loseta tiene que tener su turno.
    (turno ?nombre_jugador)
    ; debe haberse activado la autorización de realizar acción
    ?permiso <- (permitir_realizar_accion ?nombre_jugador)
    ; Obtiene los datos del recurso del jugador
    ?recurso_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ?recurso_deseado) (cantidad ?cantidad_recurso))
    ; Obtiene el recurso de la oferta que se va a tomar
    ?recurso_oferta <- (OFERTA_RECURSO (recurso ?recurso_deseado) (cantidad ?cantidad_oferta))
    ; Comprueba que el recurso de la oferta se pueda obtener
    (test (> ?cantidad_oferta 0))
    ; Hecho estratégico que implique coger recurso de la oferta
    ?deseo <- (deseo_coger_recurso ?nombre_jugador ?recurso_deseado)
    =>
    ; eliminar deseo
    (retract ?deseo)
    (retract ?permiso)
    ; Actualizar la cantidad de la oferta
    (modify ?recurso_oferta (cantidad 0))
    ; Actualizar los recursos del jugador
    (modify-instance ?recurso_jugador (cantidad (+ ?cantidad_recurso ?cantidad_oferta)))
    ; fin actividad principal
    (assert (fin_actividad_principal ?nombre_jugador))
    (printout t"El jugador: <" ?nombre_jugador "> ha tomado de la oferta: <" ?cantidad_oferta "> de <" ?recurso_deseado ">. " crlf)
)

; Regla 27
(defrule ENTRAR_EDIFICIO_GRATIS_RONDAS
    ; Se puede entrar de uno en uno en el resto de las rondas.
    (ronda_actual ?nombre_ronda)
    (test (neq ?nombre_ronda RONDA_EXTRA_FINAL))
    ; Existe un deseo de entrar a un edificio, este tiene el tipo de recurso que quiere usar para pagar y su nombre
    ?deseo <- (deseo_entrar_edificio ?nombre_jugador ?nombre_edificio)
    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; se le permite realizar una acción
    ?permiso <- (permitir_realizar_accion ?nombre_jugador)
    ; no existe un jugador en ese edificio.
    (not (object (is-a JUGADOR_ESTA_EDIFICIO) (nombre_edificio ?nombre_edificio)(nombre_jugador ?)))
    ; obtiene la posición del jugador
    ?pos_jugador <- (object (is-a JUGADOR_ESTA_EDIFICIO) (nombre_edificio ?edificio_actual) (nombre_jugador ?nombre_jugador))
    ; Comprobar que alguien (ya sea el ayuntamiento o un jugador) posee el edificio.
    (not (object (is-a CARTA_PERTENECE_A_MAZO)(nombre_carta ?nombre_edificio)(id_mazo ?)(posicion_en_mazo ?)))
    ; No tiene coste de entrada y pertence a otro jugador o pertenece al jugador y entra gratis. 
    (or
       (not (object (is-a COSTE_ENTRADA_CARTA) (nombre_carta ?nombre_edificio) (tipo ?) (cantidad ?))) 
       (object (is-a PARTICIPANTE_TIENE_CARTA) (nombre_jugador ?nombre_jugador) (nombre_carta ?nombre_edificio))
    )
    =>
    ; indicar que el jugador está en el edificio.
    (modify-instance ?pos_jugador (nombre_edificio ?nombre_edificio))
    ; quitar el deseo.
    (retract ?deseo)
    (retract ?permiso)
    (printout t"El jugador: <" ?nombre_jugador "> ha entrado gratis al edificio: <" ?nombre_edificio ">. Ya sea porque le pertenece o porque no tiene coste de entrada." crlf)
)

; Reglas 28, 29, 30, 31 podrían simplificarse... Estudiarlo...
; Regla 28
(defrule ENTRAR_EDIFICIO_CON_COSTE_ENTRADA_DINERO_RONDAS
    ; Se puede entrar de uno en uno en el resto de las rondas.
    (ronda_actual ?nombre_ronda)
    (test (neq ?nombre_ronda RONDA_EXTRA_FINAL))
    ; Existe un deseo de entrar a un edificio, este tiene el tipo de recurso que quiere usar para pagar y su nombre
    ?deseo <- (deseo_entrar_edificio ?nombre_jugador ?nombre_edificio DINERO ?nombre_recurso)
    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; se le permite realizar una acción
    ?permiso <- (permitir_realizar_accion ?nombre_jugador)
    ; no exista un jugador en ese edificio.
     (not (object (is-a JUGADOR_ESTA_EDIFICIO) (nombre_edificio ?nombre_edificio)(nombre_jugador ?)))
    ; obtiene la posición del jugador
    ?pos_jugador <- (object (is-a JUGADOR_ESTA_EDIFICIO) (nombre_edificio ?edificio_actual) (nombre_jugador ?nombre_jugador))
    (test (neq ?edificio_actual ?nombre_edificio))
    ; Comprobar que alguien (ya sea el ayuntamiento o un jugador) posee el edificio.
    (not (object (is-a CARTA_PERTENECE_A_MAZO)(nombre_carta ?nombre_edificio)(id_mazo ?)(posicion_en_mazo ?)))
    ; Tiene coste de entrada.
    (object (is-a COSTE_ENTRADA_CARTA) (nombre_carta ?nombre_edificio) (tipo DINERO) (cantidad ?coste_entrada))
    ; comprobar que tenga recursos suficientes para entrar.
    ?recurso_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ?nombre_recurso) (cantidad ?cantidad_recurso))
    (test (>= ?cantidad_recurso ?coste_entrada))
    ; ***** Obtiene el recurso del jugador propietario del edificio para entregarle el recurso de entrada
    (object (is-a PARTICIPANTE_TIENE_CARTA) (nombre_jugador ?nombre_jugador_propietario)(nombre_carta ?nombre_edificio))
    (test (neq ?nombre_jugador ?nombre_jugador_propietario))
    ?recurso_propietario <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador_propietario)(recurso ?nombre_recurso)(cantidad ?cantidad_recurso_propietario))
    =>
    ; Modificar el recurso del jugador
    (modify-instance ?recurso_jugador (cantidad (- ?cantidad_recurso ?coste_entrada) ))
    ; **** Modificar el recurso del propietario
    (modify-instance ?recurso_propietario (cantidad (+ ?cantidad_recurso_propietario ?coste_entrada)))
    ; indicar que el jugador está en el edificio.
    (modify-instance ?pos_jugador (nombre_edificio ?nombre_edificio))
    ; quitar el deseo.
    (retract ?deseo)
    (retract ?permiso)
    ; Print final
    (printout t"El jugador: <" ?nombre_jugador "> ha entrado al edificio: <" ?nombre_edificio "> por <" ?coste_entrada "> DINERO." crlf)
)

; Regla 29
(defrule ENTRAR_EDIFICIO_CON_COSTE_ENTRADA_ALIMENTO_RONDAS
    ; Se puede entrar de uno en uno en el resto de las rondas.
    (ronda_actual ?nombre_ronda)
    (test (neq ?nombre_ronda RONDA_EXTRA_FINAL))
    ; Existe un deseo de entrar a un edificio, este tiene el tipo de recurso que quiere usar para pagar y su nombre
    ?deseo <- (deseo_entrar_edificio ?nombre_jugador ?nombre_edificio COMIDA ?nombre_recurso)
    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; se le permite realizar una acción
    ?permiso <- (permitir_realizar_accion ?nombre_jugador)
    ; no exista un jugador en ese edificio.
     (not (object (is-a JUGADOR_ESTA_EDIFICIO) (nombre_edificio ?nombre_edificio)(nombre_jugador ?)))
    ; obtiene la posición del jugador
    ?pos_jugador <- (object (is-a JUGADOR_ESTA_EDIFICIO) (nombre_edificio ?edificio_actual) (nombre_jugador ?nombre_jugador))
    (test (neq ?edificio_actual ?nombre_edificio))
    ; Comprobar que alguien (ya sea el ayuntamiento o un jugador) posee el edificio.
    (not (object (is-a CARTA_PERTENECE_A_MAZO)(nombre_carta ?nombre_edificio)(id_mazo ?)(posicion_en_mazo ?)))
    ; Tiene coste de entrada.
    (object (is-a COSTE_ENTRADA_CARTA) (nombre_carta ?nombre_edificio) (tipo COMIDA) (cantidad ?coste_entrada))
    ; comprobar que tenga recursos suficientes para entrar.
    ?recurso_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ?nombre_recurso) (cantidad ?cantidad_recurso))
    (object (is-a RECURSO_ALIMENTICIO) (nombre ?nombre_recurso) (comida_genera ?ratio))
    (test (>= (* ?cantidad_recurso ?ratio) ?coste_entrada))
    ; Obtener los valores del propietario para pagarle.
    (object (is-a PARTICIPANTE_TIENE_CARTA) (nombre_jugador ?nombre_jugador_propietario)(nombre_carta ?nombre_edificio))
    (test (neq ?nombre_jugador ?nombre_jugador_propietario))
    ?recurso_propietario <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador_propietario)(recurso ?nombre_recurso)(cantidad ?cantidad_recurso_propietario))
    =>
    ; obtener la cantidad justa que deberá pagar
    (bind ?cantidad_pagada (integer (- ?cantidad_recurso (/ ?coste_entrada ?ratio))))
    ; Modificar el recurso del jugador
    (modify-instance ?recurso_jugador (cantidad (- ?cantidad_recurso ?cantidad_pagada) ))
    ; **** Modificar el recurso del propietario
    (modify-instance ?recurso_propietario (cantidad (+ ?cantidad_recurso_propietario ?cantidad_pagada)))
    ; indicar que el jugador está en el edificio.
    (modify-instance ?pos_jugador (nombre_edificio ?nombre_edificio))
    ; quitar el deseo y permiso.
    (retract ?deseo)
    (retract ?permiso)
    ; Print final
    (printout t"El jugador: <" ?nombre_jugador "> ha entrado al edificio: <" ?nombre_edificio "> por <" ?coste_entrada "> COMIDA." crlf)
)

; Regla 30
(defrule ENTRAR_EDIFICIO_GRATIS_RONDA_EXTRA_FINAL

    ; Se puede entrar de uno en uno en el resto de las rondas.
    (ronda_actual RONDA_EXTRA_FINAL)
    ; Existe un deseo de entrar a un edificio, este tiene el tipo de recurso que quiere usar para pagar y su nombre
    ?deseo <- (deseo_entrar_edificio ?nombre_jugador ?nombre_edificio)
    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; se le permite realizar una acción => TODO: GENERARLO ARTIFICIALMENTE.
    ?permiso <- (permitir_realizar_accion ?nombre_jugador)
    ; obtiene la posición del jugador
    ?pos_jugador <- (object (is-a JUGADOR_ESTA_EDIFICIO) (nombre_edificio ?edificio_actual) (nombre_jugador ?nombre_jugador))
    ; comprobar que el jugador no se encuentre en el edificio.
    (test (neq ?edificio_actual ?nombre_edificio))
    ; Comprobar que alguien (ya sea el ayuntamiento o un jugador) posee el edificio. Es decir, no existe la relación que vincula a carta y mazo.
    (not (object (is-a CARTA_PERTENECE_A_MAZO) (nombre_carta ?nombre_edificio) (id_mazo ?) (posicion_en_mazo ?)))
    ; No tiene coste de entrada y pertence a otro jugador o pertenece al jugador y entra gratis. 
    (or
       (not (object (is-a COSTE_ENTRADA_CARTA) (nombre_carta ?nombre_edificio) (tipo ?) (cantidad ?))) 
       (object (is-a PARTICIPANTE_TIENE_CARTA) (nombre_jugador ?nombre_jugador) (nombre_carta ?nombre_edificio))
    )
    =>
    ; indicar que el jugador está en el edificio.
    (modify-instance ?pos_jugador (nombre_edificio ?nombre_edificio))
    ; quitar el deseo.
    (retract ?deseo)
    (retract ?permiso)
    (printout t"El jugador: <" ?nombre_jugador "> ha entrado al edificio: <" ?nombre_edificio "> sin coste de entrada o porque le pertenece." crlf)
)

; Regla 31
(defrule ENTRAR_EDIFICIO_CON_COSTE_ENTRADA_ALIMENTO_RONDA_EXTRA_FINAL
    ; Se puede entrar de uno en uno en el resto de las rondas.
    (ronda_actual RONDA_EXTRA_FINAL)
    ; Existe un deseo de entrar a un edificio, este tiene el tipo de recurso que quiere usar para pagar y su nombre
    ?deseo <- (deseo_entrar_edificio ?nombre_jugador ?nombre_edificio COMIDA ?nombre_recurso)
    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; se le permite realizar una acción
    ?permiso <- (permitir_realizar_accion ?nombre_jugador)
    ; obtiene la posición del jugador
    ?pos_jugador <- (object (is-a JUGADOR_ESTA_EDIFICIO) (nombre_edificio ?edificio_actual) (nombre_jugador ?nombre_jugador))
    (test (neq ?edificio_actual ?nombre_edificio))
    ; Comprobar que alguien (ya sea el ayuntamiento o un jugador) posee el edificio.
    (not (object (is-a CARTA_PERTENECE_A_MAZO)(nombre_carta ?nombre_edificio)(id_mazo ?)(posicion_en_mazo ?)))
    ; Tiene coste de entrada.
    (object (is-a COSTE_ENTRADA_CARTA) (nombre_carta ?nombre_edificio) (tipo COMIDA) (cantidad ?coste_entrada))    
    ; comprobar que tenga recursos suficientes para entrar.
    ?recurso_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ?nombre_recurso) (cantidad ?cantidad_recurso))
    (object (is-a RECURSO_ALIMENTICIO) (nombre ?nombre_recurso) (comida_genera ?ratio))
    (test (>= (* ?cantidad_recurso ?ratio) ?coste_entrada))
    ; Obtener los valores del propietario para pagarle.
    (object (is-a PARTICIPANTE_TIENE_CARTA) (nombre_jugador ?nombre_jugador_propietario)(nombre_carta ?nombre_edificio))
    (test (neq ?nombre_jugador ?nombre_jugador_propietario))
    ?recurso_propietario <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador_propietario)(recurso ?nombre_recurso)(cantidad ?cantidad_recurso_propietario))
    =>
    ; obtener la cantidad justa que deberá pagar
    (bind ?cantidad_pagada (integer (- ?cantidad_recurso (/ ?coste_entrada ?ratio))))
    ; Modificar el recurso del jugador
    (modify-instance ?recurso_jugador (cantidad (- ?cantidad_recurso ?cantidad_pagada) ))
    ; **** Modificar el recurso del propietario
    (modify-instance ?recurso_propietario (cantidad (+ ?cantidad_recurso_propietario ?cantidad_pagada)))
    ; indicar que el jugador está en el edificio.
    (modify-instance ?pos_jugador (nombre_edificio ?nombre_edificio))
    ; quitar el deseo y permiso.
    (retract ?deseo)
    (retract ?permiso)
    ; Print final
    (printout t"El jugador: <" ?nombre_jugador "> ha entrado al edificio: <" ?nombre_edificio "> por <" ?coste_entrada "> COMIDA." crlf)
)

; Regla 32
(defrule ENTRAR_EDIFICIO_CON_COSTE_ENTRADA_MONETARIO_RONDA_EXTRA_FINAL
    ; Se puede entrar de uno en uno en el resto de las rondas.
    (ronda_actual RONDA_EXTRA_FINAL)
    ; Existe un deseo de entrar a un edificio, este tiene el tipo de recurso que quiere usar para pagar y su nombre
    ?deseo <- (deseo_entrar_edificio ?nombre_jugador ?nombre_edificio DINERO ?nombre_recurso)
    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; se le permite realizar una acción
    ?permiso <- (permitir_realizar_accion ?nombre_jugador)
    ; obtiene la posición del jugador
    ?pos_jugador <- (object (is-a JUGADOR_ESTA_EDIFICIO) (nombre_edificio ?edificio_actual) (nombre_jugador ?nombre_jugador))
    (test (neq ?edificio_actual ?nombre_edificio))
    ; Comprobar que alguien (ya sea el ayuntamiento o un jugador) posee el edificio.
    (not (object (is-a CARTA_PERTENECE_A_MAZO)(nombre_carta ?nombre_edificio)(id_mazo ?)(posicion_en_mazo ?)))
     ; Tiene coste de entrada.
    (object (is-a COSTE_ENTRADA_CARTA) (nombre_carta ?nombre_edificio) (tipo DINERO) (cantidad ?coste_entrada))    
    ; comprobar que tenga recursos suficientes para entrar.
    ?recurso_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ?nombre_recurso) (cantidad ?cantidad_recurso))
    (test (>= ?cantidad_recurso ?coste_entrada))
    (object (is-a PARTICIPANTE_TIENE_CARTA) (nombre_jugador ?nombre_jugador_propietario)(nombre_carta ?nombre_edificio))
    (test (neq ?nombre_jugador ?nombre_jugador_propietario))
    ?recurso_propietario <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador_propietario)(recurso ?nombre_recurso)(cantidad ?cantidad_recurso_propietario))
    =>
    ; Modificar el recurso del jugador
    (modify-instance ?recurso_jugador (cantidad (- ?cantidad_recurso ?coste_entrada) ))
    ; **** Modificar el recurso del propietario
    (modify-instance ?recurso_propietario (cantidad (+ ?cantidad_recurso_propietario ?coste_entrada)))
    ; indicar que el jugador está en el edificio.
    (modify-instance ?pos_jugador (nombre_edificio ?nombre_edificio))
    ; quitar el deseo y permiso.
    (retract ?deseo)
    (retract ?permiso)
    ; Print final
    (printout t"El jugador: <" ?nombre_jugador "> ha entrado al edificio: <" ?nombre_edificio "> por <" ?coste_entrada "> DINERO." crlf)
)

; Regla 33
(defrule UTILIZAR_EDIFICIO_CONSTRUCTOR_NO_BONUS
    ; Obtener al jugador.
    ?jugador <- (object (is-a JUGADOR) (nombre ?nombre_jugador) (riqueza ?riqueza_jugador))
    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; El jugador debe estar en el edificio.
    (object (is-a JUGADOR_ESTA_EDIFICIO) (nombre_edificio ?nombre_edificio) (nombre_jugador ?nombre_jugador))
    ; el jugador no ha usado anteriormente el edificio sin haber entrado a otro antes
    ?edificio_usado <- (object (is-a JUGADOR_HA_USADO_EDIFICIO)(nombre_edificio ?ed)(nombre_jugador ?nombre_jugador))
    (test (neq ?nombre_edificio ?ed))
    ; deseo construir edificio
    ?deseo <- (deseo_construccion ?nombre_jugador ?nombre_carta)
    ; el edificio puede construir. 
    (or 
        (test (eq ?nombre_edificio "CONSTRUCTORA1"))
        (test (eq ?nombre_edificio "CONSTRUCTORA2"))
        (test (eq ?nombre_edificio "CONSTRUCTORA3"))
    )
    ; comprobar que se encuentra en la parte superior del mazo.
    ?pertenencia_mazo <- (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id_mazo) (nombre_carta ?nombre_carta) (posicion_en_mazo 1))
    ?ref_mazo <- (object (is-a MAZO)(id_mazo ?id_mazo)(numero_cartas_en_mazo ?num_cartas_mazo))
    ; Obtener la carta para modificar la riqueza del jugador
    (object (is-a CARTA) (nombre ?nombre_carta)(valor ?valor_edificio))
    ; NO TIENE BONUS
    (not (object (is-a CARTA_TIENE_BONUS)(nombre_carta ?nombre_carta)(bonus ?)))
    ; obtener el coste de la carta
    ?coste_carta <- (object (is-a COSTE_CONSTRUCCION_CARTA) (nombre_carta ?nombre_carta) (cantidad_madera ?coste_madera) (cantidad_arcilla ?coste_arcilla) (cantidad_ladrillo ?coste_ladrillos) (cantidad_hierro ?coste_hierro) (cantidad_acero ?coste_acero))
    ; comprobar que el jugador tiene suficientes recursos para construirla.
    ?recurso_jugador_madera <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso MADERA) (cantidad ?cantidad_madera))
    ?recurso_jugador_arcilla <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ARCILLA) (cantidad ?cantidad_arcilla))
    ?recurso_jugador_ladrillos <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso LADRILLOS) (cantidad ?cantidad_ladrillos))
    ?recurso_jugador_hierro <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso HIERRO) (cantidad ?cantidad_hierro))
    ?recurso_jugador_acero <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ACERO) (cantidad ?cantidad_acero))
    (test (>= ?cantidad_madera ?coste_madera))
    (test (>= ?cantidad_arcilla ?coste_arcilla))
    (test (>= ?cantidad_ladrillos ?coste_ladrillos))
    (test (>= ?cantidad_hierro ?coste_hierro))
    (test (>= ?cantidad_acero ?coste_acero))
    =>
    ; modificar cantidad de materiales del jugador
    (modify-instance ?recurso_jugador_madera (cantidad (- ?cantidad_madera ?coste_madera)))
    (modify-instance ?recurso_jugador_arcilla (cantidad (- ?cantidad_arcilla ?coste_arcilla)))
    (modify-instance ?recurso_jugador_ladrillos (cantidad (- ?cantidad_ladrillos ?coste_ladrillos)))
    (modify-instance ?recurso_jugador_hierro (cantidad (- ?cantidad_hierro ?coste_hierro)))
    (modify-instance ?recurso_jugador_acero (cantidad (- ?cantidad_acero ?coste_acero)))
    ; quitar carta del mazo
    (unmake-instance ?pertenencia_mazo)
    ; eliminar deseo
    (retract ?deseo)
    ; asignar la carta al jugador
    (make-instance of PARTICIPANTE_TIENE_CARTA (nombre_jugador ?nombre_jugador) (nombre_carta ?nombre_carta))
    ; Aumentar la riqueza del jugador 
    (modify-instance ?jugador (riqueza (+ ?riqueza_jugador ?valor_edificio)))
    ; actualiza el numero de cartas en el mazo.
    (modify-instance ?ref_mazo (numero_cartas_en_mazo (- ?num_cartas_mazo 1)))
    ;generar hecho semáforo para reordenar el mazo
    (assert (actualizar_mazo ?id_mazo (- ?num_cartas_mazo 1) 2))
    ; semaforo final actividad principal.
    (assert(fin_actividad_principal ?nombre_jugador)) 
    ; relación para no permitir usar el mismo edificio dos veces.
    (modify-instance ?edificio_usado (nombre_edificio ?nombre_edificio))
    (printout t "El jugador <"?nombre_jugador"> ha usado el edificio <"?nombre_edificio"> para construir la carta <"?nombre_carta"> empleando los siguientes recursos: <"?coste_madera"> madera, <"?coste_arcilla"> arcilla, <"?coste_ladrillos"> ladrillos, <"?coste_hierro"> hierro y <"?coste_acero"> acero." crlf)
)

; Regla 34
(defrule UTILIZAR_EDIFICIO_CONSTRUCTOR_SI_BONUS
    ; Obtener al jugador.
    ?jugador <- (object (is-a JUGADOR) (nombre ?nombre_jugador) (riqueza ?riqueza_jugador))
    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; El jugador debe estar en el edificio.
    (object (is-a JUGADOR_ESTA_EDIFICIO) (nombre_edificio ?nombre_edificio) (nombre_jugador ?nombre_jugador))
    ; el jugador no ha usado anteriormente el edificio sin haber entrado a otro antes
    ?edificio_usado <- (object (is-a JUGADOR_HA_USADO_EDIFICIO)(nombre_edificio ?ed)(nombre_jugador ?nombre_jugador))
    (test (neq ?nombre_edificio ?ed))
    ; deseo construir edificio
    ?deseo <- (deseo_construccion ?nombre_jugador ?nombre_carta)
    ; el edificio puede construir. 
    (or 
        (test (eq ?nombre_edificio "CONSTRUCTORA1"))
        (test (eq ?nombre_edificio "CONSTRUCTORA2"))
        (test (eq ?nombre_edificio "CONSTRUCTORA3"))
    )
    ; comprobar que se encuentra en la parte superior del mazo.
    ?pertenencia_mazo <- (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id_mazo) (nombre_carta ?nombre_carta) (posicion_en_mazo 1))
    ?ref_mazo <- (object (is-a MAZO)(id_mazo ?id_mazo)(numero_cartas_en_mazo ?num_cartas_mazo))
    ; Obtener la carta para modificar la riqueza del jugador
    (object (is-a CARTA) (nombre ?nombre_carta)(valor ?valor_edificio))
    ; obtiene el bonus
    (object (is-a CARTA_TIENE_BONUS)(nombre_carta ?nombre_carta)(bonus ?bonus))
    ; obtiene la relación de jugador tiene bonus
    ?jugador_tiene_bonus <- (object (is-a JUGADOR_TIENE_BONUS)(nombre_jugador ?nombre_jugador)(tipo ?bonus)(cantidad ?cantidad_bonus))   
    ; obtener el coste de la carta
    ?coste_carta <- (object (is-a COSTE_CONSTRUCCION_CARTA) (nombre_carta ?nombre_carta) (cantidad_madera ?coste_madera) (cantidad_arcilla ?coste_arcilla) (cantidad_ladrillo ?coste_ladrillos) (cantidad_hierro ?coste_hierro) (cantidad_acero ?coste_acero))
    ; comprobar que el jugador tiene suficientes recursos para construirla.
    ?recurso_jugador_madera <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso MADERA) (cantidad ?cantidad_madera))
    ?recurso_jugador_arcilla <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ARCILLA) (cantidad ?cantidad_arcilla))
    ?recurso_jugador_ladrillos <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso LADRILLOS) (cantidad ?cantidad_ladrillos))
    ?recurso_jugador_hierro <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso HIERRO) (cantidad ?cantidad_hierro))
    ?recurso_jugador_acero <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ACERO) (cantidad ?cantidad_acero))
    (test (>= ?cantidad_madera ?coste_madera))
    (test (>= ?cantidad_arcilla ?coste_arcilla))
    (test (>= ?cantidad_ladrillos ?coste_ladrillos))
    (test (>= ?cantidad_hierro ?coste_hierro))
    (test (>= ?cantidad_acero ?coste_acero))
    =>
    ; modificar cantidad de materiales del jugador
    (modify-instance ?recurso_jugador_madera (cantidad (- ?cantidad_madera ?coste_madera)))
    (modify-instance ?recurso_jugador_arcilla (cantidad (- ?cantidad_arcilla ?coste_arcilla)))
    (modify-instance ?recurso_jugador_ladrillos (cantidad (- ?cantidad_ladrillos ?coste_ladrillos)))
    (modify-instance ?recurso_jugador_hierro (cantidad (- ?cantidad_hierro ?coste_hierro)))
    (modify-instance ?recurso_jugador_acero (cantidad (- ?cantidad_acero ?coste_acero)))
    ; quitar carta del mazo
    (unmake-instance ?pertenencia_mazo)
    ; eliminar deseo
    (retract ?deseo)
    ; asignar la carta al jugador
    (make-instance of PARTICIPANTE_TIENE_CARTA (nombre_jugador ?nombre_jugador) (nombre_carta ?nombre_carta))
    ; Aumentar la riqueza del jugador 
    (modify-instance ?jugador (riqueza (+ ?riqueza_jugador ?valor_edificio)))
    ; actualiza el numero de cartas en el mazo.
    (modify-instance ?ref_mazo (numero_cartas_en_mazo (- ?num_cartas_mazo 1)))
    ;generar hecho semáforo para reordenar el mazo
    (assert (actualizar_mazo ?id_mazo (- ?num_cartas_mazo 1) 2))
    ; semaforo final actividad principal.
    (assert(fin_actividad_principal ?nombre_jugador)) 
    ; relación para no permitir usar el mismo edificio dos veces.
    (modify-instance ?edificio_usado (nombre_edificio ?nombre_edificio))
    ; actualizar los bonus de los jugadores.
    (modify-instance ?jugador_tiene_bonus (cantidad (+ ?cantidad_bonus 1)))
    (printout t "El jugador <"?nombre_jugador"> ha usado el edificio <"?nombre_edificio"> para construir la carta <"?nombre_carta"> [con bonus: "?bonus"] empleando los siguientes recursos: <"?coste_madera"> madera, <"?coste_arcilla"> arcilla, <"?coste_ladrillos"> ladrillos, <"?coste_hierro"> hierro y <"?coste_acero"> acero." crlf)
)

; Regla 35
(defrule EDIFICIO_GENERA_RECURSO_SIN_INPUTS_UN_OUTPUT_SI_BONUS_NO_ENERGIA
    ;   INPUTS          OUTPUT          BONUS   ENERGIA     EDIFICIOS
    ;      0               1              1        0        (piscifactoria, arcilla, colliery [* máximo 1 ud con bonuses])
    ; no hay caso de 0 inputs y 1 output sin bonus. 
    ; no existe deseo, se entra únicamente y por el mero hecho de estar dentro se toma los outputs correspondientes.
    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; la carta solo puede tener un output
    (object (is-a CARTA_EDIFICIO_GENERADOR) (nombre ?nombre_edificio)(numero_recursos_salida 1))
    ; El jugador debe estar en el edificio.
    (object (is-a JUGADOR_ESTA_EDIFICIO) (nombre_edificio ?nombre_edificio) (nombre_jugador ?nombre_jugador))
    ; el jugador no ha usado anteriormente el edificio sin haber entrado a otro antes
    ?edificio_usado <- (object (is-a JUGADOR_HA_USADO_EDIFICIO)(nombre_edificio ?ed)(nombre_jugador ?nombre_jugador))
    (test (neq ?nombre_edificio ?ed))
    ; el edificio no tiene coste energético
    (not (object (is-a COSTE_ENERGIA) (nombre_carta ?nombre_edificio) (coste_unitario ?) (cantidad ?) ))
    ; caso donde unicamente genera output.
    (not (object (is-a EDIFICIO_INPUT) (nombre_carta ?nombre_edificio) (recurso ?) (cantidad_maxima ?)))
    ; tiene output.
    (object (is-a EDIFICIO_OUTPUT) (nombre_carta ?nombre_edificio) (recurso ?recurso) (cantidad_min_generada_por_unidad ?cantidad_output))
    ; obtener el tipo de bonus de output de la carta
    (object (is-a CARTA_OUTPUT_BONUS) (nombre_carta ?nombre_edificio)(bonus ?tipo_bonus) (cantidad_maxima_permitida ?cantidad_max_permitida))
    ; Caso donde la carta tiene bonus aplicables. 
    (object (is-a JUGADOR_TIENE_BONUS) (nombre_jugador ?nombre_jugador) (tipo ?tipo_bonus) (cantidad ?cantidad_bonus))
    ; obtener los recursos del jugador que otorga el edificio
    ?recurso_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador)(recurso ?recurso) (cantidad ?cantidad_recurso))
    =>
    ; cantidad proporciona al jugador de output por bonus.
    (bind ?cantidad_proporciona_bonus (min ?cantidad_bonus ?cantidad_max_permitida))
    ; añadir recursos al jugador 
    (modify-instance ?recurso_jugador (cantidad (+ ?cantidad_recurso (+ ?cantidad_output ?cantidad_proporciona_bonus))))
    ; Ha finalizado su actividad principal dentro de su turno.
    (assert (fin_actividad_principal ?nombre_jugador))
    ; flag para no permitir usar el mismo edificio dos veces.
    (modify-instance ?edificio_usado (nombre_edificio ?nombre_edificio))
    ; log
    (printout t"El jugador: <" ?nombre_jugador "> ha generado en el edificio: <" ?nombre_edificio "> un total de <" (+ ?cantidad_output ?cantidad_proporciona_bonus) "> recursos de <" ?recurso ">. Los cuales <" ?cantidad_output "> son por entrar y <" ?cantidad_proporciona_bonus "> por los bonus que tiene." crlf)
)

; Regla 36
(defrule EDIFICIO_GENERA_RECURSO_UN_INPUT_UN_OUTPUT_NO_BONUS_NO_ENERGIA
    ;   INPUTS          OUTPUT          BONUS   ENERGIA     EDIFICIOS
    ;      1               1              0        0        (Carbon vegetal, ironworks)

    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; El jugador debe estar en el edificio.
    (object (is-a JUGADOR_ESTA_EDIFICIO) (nombre_edificio ?nombre_edificio) (nombre_jugador ?nombre_jugador))
    ; el jugador no ha usado anteriormente el edificio sin haber entrado a otro antes
    ?edificio_usado <- (object (is-a JUGADOR_HA_USADO_EDIFICIO)(nombre_edificio ?ed)(nombre_jugador ?nombre_jugador))
    (test (neq ?nombre_edificio ?ed))
    ; la carta solo puede tener un output
    (object (is-a CARTA_EDIFICIO_GENERADOR) (nombre ?nombre_edificio)(numero_recursos_salida 1))
    ; El edificio tiene sólo 1 input como recurso.
    (object (is-a EDIFICIO_INPUT) (nombre_carta ?nombre_edificio) (recurso ?recurso_entrada) (cantidad_maxima ?cantidad_maxima))
    ; el eficio tiene 1 sólo output como recurso.  
    (object (is-a EDIFICIO_OUTPUT) (nombre_carta ?nombre_edificio) (recurso ?recurso_salida) (cantidad_min_generada_por_unidad ?cantidad_unitaria))
    ; el edificio no genera recursos adicionales por bonus.
    (not (object (is-a CARTA_OUTPUT_BONUS) (nombre_carta ?nombre_edificio) (bonus ?) (cantidad_maxima_permitida ?)))
    ; el edificio no tiene coste energético
    (not (object (is-a COSTE_ENERGIA) (nombre_carta ?nombre_edificio) (coste_unitario ?) (cantidad ?) ))
    ; referencia los recursos del jugador
    ?recurso_jugador_entrada <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ?recurso_entrada) (cantidad ?cantidad_recurso_entrada_jugador))
    ?recurso_jugador_salida <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ?recurso_salida) (cantidad ?cantidad_recurso_salida_jugador))
    ; el jugador tiene el deseo de generar X recursos outputs empleando Y recursos inputs.
    ?deseo <- (deseo_generar_con_recurso ?nombre_jugador ?nombre_edificio ?recurso_entrada ?cantidad_a_transformar)
    ; comprobar que tenga los recursos necesarios.
    (test (>= ?cantidad_recurso_entrada_jugador ?cantidad_a_transformar))
    
    =>
    ; obtener la cantidad que ha transformado del recurso de salida.
    (bind ?cantidad_transformada (integer (* ?cantidad_a_transformar ?cantidad_unitaria)))
    (modify-instance ?recurso_jugador_entrada (cantidad (- ?cantidad_recurso_entrada_jugador ?cantidad_a_transformar)))
    (modify-instance ?recurso_jugador_salida (cantidad (+ ?cantidad_recurso_salida_jugador ?cantidad_transformada)))
    ; Ha finalizado su actividad principal dentro de su turno.
    (assert (fin_actividad_principal ?nombre_jugador))
    ; elimina el deseo
    (retract ?deseo)
    ; flag para no permitir usar el mismo edificio dos veces.
    (modify-instance ?edificio_usado (nombre_edificio ?nombre_edificio))
    (printout t"El jugador: <" ?nombre_jugador "> ha transformado en el edificio: <" ?nombre_edificio "> <" ?cantidad_a_transformar "> recursos de <" ?recurso_entrada "> en <" ?cantidad_transformada "> recursos de <" ?recurso_salida ">." crlf)
)

; Regla 37 : NO USAMOS ENERGIA: HABRIA QUE ELIMINARLA...
(defrule EDIFICIO_GENERA_RECURSO_UN_INPUT_UN_OUTPUT_NO_BONUS_SI_ENERGIA_Y_ES_UNITARIA
    ;   INPUTS          OUTPUT          BONUS   ENERGIA     EDIFICIOS
    ;      1               1              0        1        (steel mill 5 energia por cada output.)
    ; ENERGIA UNITARIO, es decir, es variable

    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; El jugador debe estar en el edificio.
    (object (is-a JUGADOR_ESTA_EDIFICIO) (nombre_edificio ?nombre_edificio) (nombre_jugador ?nombre_jugador))
    ; el jugador no ha usado anteriormente el edificio sin haber entrado a otro antes
    ?edificio_usado <- (object (is-a JUGADOR_HA_USADO_EDIFICIO) (nombre_edificio ?ed)(nombre_jugador ?nombre_jugador))
    (test (neq ?nombre_edificio ?ed))
    ; la carta solo puede tener un output
    (object (is-a CARTA_EDIFICIO_GENERADOR) (nombre ?nombre_edificio)(numero_recursos_salida 1))
    ; El edificio tiene sólo 1 input como recurso.
    (object (is-a EDIFICIO_INPUT) (nombre_carta ?nombre_edificio) (recurso ?recurso_entrada) (cantidad_maxima ?cantidad_maxima))
    ; el eficio tiene 1 sólo output como recurso.  
    (object (is-a EDIFICIO_OUTPUT) (nombre_carta ?nombre_edificio) (recurso ?recurso_salida) (cantidad_min_generada_por_unidad ?cantidad_unitaria))
    ; el edificio no genera recursos adicionales por bonus.
    (not (object (is-a CARTA_OUTPUT_BONUS) (nombre_carta ?nombre_edificio) (bonus ?) (cantidad_maxima_permitida ?)))
    ; obtiene el coste energético del edificio
    (object (is-a COSTE_ENERGIA) (nombre_carta ?nombre_edificio) (coste_unitario TRUE) (cantidad ?coste_energia))
    ; referencia los recursos del jugador
    ?recurso_jugador_entrada <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ?recurso_entrada) (cantidad ?cantidad_recurso_entrada_jugador))
    ?recurso_jugador_salida <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ?recurso_salida) (cantidad ?cantidad_recurso_salida_jugador))
    ; el jugador tiene el deseo de generar X recursos outputs empleando Y recursos inputs.
    ?deseo_generar <- (deseo_generar_con_recurso ?nombre_jugador ?nombre_edificio ?recurso_entrada ?cantidad_a_transformar)
    ; y tiene el deseo de pagar con X de energía. 
    ?deseo_pago_energia <- (deseo_emplear_energia ?nombre_jugador ?nombre_edificio ?cantidad_madera ?cantidad_carbon_vegetal ?cantidad_carbon ?cantidad_coque)
    ; obtener los recursos de energia del jugador.
    ?madera_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso MADERA) (cantidad ?cantidad_madera_jugador))
    ?carbon_vegetal_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso CARBON_VEGETAL) (cantidad ?cantidad_carbon_vegetal_jugador))
    ?carbon_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso CARBON) (cantidad ?cantidad_cabon_jugador))
    ?coque_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso COQUE) (cantidad ?cantidad_coque_jugador))
    ; comprobar que tenga los recursos necesarios.
    (test (>= ?cantidad_recurso_entrada_jugador ?cantidad_a_transformar))
    (test (>= (+ (* ?cantidad_madera 1) (* ?cantidad_carbon_vegetal 3) (* ?cantidad_carbon 3) (* ?cantidad_coque 10)) (* ?cantidad_a_transformar ?coste_energia) ))
    
    =>
    ; calcula la cantidad generada y de energía empleada
    (bind ?cantidad_transformada (integer (* ?cantidad_unitaria ?cantidad_a_transformar)))
    (bind ?cantidad_energia_empleada (* ?cantidad_a_transformar ?coste_energia))

    ; modifica los recursos de entrada/salida del jugador
    (modify-instance ?recurso_jugador_entrada (cantidad (- ?cantidad_recurso_entrada_jugador ?cantidad_a_transformar)))
    (modify-instance ?recurso_jugador_salida (cantidad (+ ?cantidad_recurso_salida_jugador ?cantidad_transformada)))
    ; modifica los recursos energéticos del jugador.
    (modify-instance ?madera_jugador (cantidad (- ?cantidad_madera_jugador ?cantidad_madera)))
    (modify-instance ?carbon_vegetal_jugador (cantidad (- ?cantidad_carbon_vegetal_jugador ?cantidad_carbon_vegetal)))
    (modify-instance ?carbon_jugador (cantidad (- ?cantidad_cabon_jugador ?cantidad_carbon)))
    (modify-instance ?coque_jugador (cantidad (- ?cantidad_coque_jugador ?cantidad_coque)))
    ; Ha finalizado su actividad principal dentro de su turno.
    (assert (fin_actividad_principal ?nombre_jugador))
    ; eliminar deseos
    (retract ?deseo_generar)
    (retract ?deseo_pago_energia)
    ; flag para no permitir usar el mismo edificio dos veces.
    (modify-instance ?edificio_usado (nombre_edificio ?nombre_edificio))
    (printout t"El jugador: <" ?nombre_jugador "> ha transformado en el edificio: <" ?nombre_edificio "> <" ?cantidad_a_transformar "> recursos de <" ?recurso_entrada "> en <" ?cantidad_transformada "> recursos de <" ?recurso_salida "> empleando <" ?cantidad_energia_empleada "> de energía." crlf)
)

; Regla 38
(defrule EDIFICIO_GENERA_RECURSO_UN_INPUT_DOS_OUTPUT_NO_BONUS_NO_ENERGIA
    ;   INPUTS          OUTPUT          BONUS   ENERGIA     EDIFICIOS
    ;      1               2              0        0        (matadero, peleteria y coqueria)

    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; El jugador debe estar en el edificio.
    (object (is-a JUGADOR_ESTA_EDIFICIO) (nombre_edificio ?nombre_edificio) (nombre_jugador ?nombre_jugador))
    ; el jugador no ha usado anteriormente el edificio sin haber entrado a otro antes
    ?edificio_usado <- (object (is-a JUGADOR_HA_USADO_EDIFICIO)(nombre_edificio ?ed)(nombre_jugador ?nombre_jugador))
    (test (neq ?nombre_edificio ?ed))
    ; la carta solo puede tener un output
    (object (is-a CARTA_EDIFICIO_GENERADOR) (nombre ?nombre_edificio)(numero_recursos_salida 2))    
    ; el jugador tiene el deseo de usar el edificio empleando X recursos de entrada
    ?deseo <- (deseo_generar_con_recurso ?nombre_jugador ?nombre_edificio ?recurso_entrada ?cantidad_a_transformar)
    ; obtiene el input del edificio 
    (object (is-a EDIFICIO_INPUT) (nombre_carta ?nombre_edificio) (recurso ?recurso_entrada) (cantidad_maxima ?cantidad_maxima))
    ; Se obtienen los outputs del edificio.
    (object (is-a EDIFICIO_OUTPUT) (nombre_carta ?nombre_edificio) (recurso ?recurso_salida1) (cantidad_min_generada_por_unidad ?cantidad_unitaria1))
    (object (is-a EDIFICIO_OUTPUT) (nombre_carta ?nombre_edificio) (recurso ?recurso_salida2) (cantidad_min_generada_por_unidad ?cantidad_unitaria2))
    (test (neq ?recurso_salida1 ?recurso_salida2))
    ; el edificio no tiene bonus
    (not (object (is-a CARTA_OUTPUT_BONUS) (nombre_carta ?nombre_edificio) (bonus ?)))
    ; el edificio no tiene coste energético
    (not (object (is-a COSTE_ENERGIA) (nombre_carta ?nombre_edificio) (coste_unitario ?) (cantidad ?) ))
    ; obtiene los recursos del jugador del mismo tipo que el input y output
    ?recurso_jugador_entrada <- (object (is-a PARTICIPANTE_TIENE_RECURSO)(nombre_jugador ?nombre_jugador) (recurso ?recurso_entrada) (cantidad ?cantidad_recurso_entrada_jugador))
    ?recurso_jugador_salida1 <- (object (is-a PARTICIPANTE_TIENE_RECURSO)(nombre_jugador ?nombre_jugador) (recurso ?recurso_salida1) (cantidad ?cantidad_recurso_salida1_jugador))
    ?recurso_jugador_salida2 <- (object (is-a PARTICIPANTE_TIENE_RECURSO)(nombre_jugador ?nombre_jugador) (recurso ?recurso_salida2) (cantidad ?cantidad_recurso_salida2_jugador))
    ; comprueba que el jugador tiene suficiente input
    (test (>= ?cantidad_recurso_entrada_jugador ?cantidad_a_transformar))
    =>
    ; calcula la cantidad a transformar
    (bind ?cantidad_transformada_recurso_salida1 (integer (min (* ?cantidad_maxima ?cantidad_unitaria1) (* ?cantidad_a_transformar ?cantidad_unitaria1))))
    (bind ?cantidad_transformada_recurso_salida2 (integer (min (* ?cantidad_maxima ?cantidad_unitaria2) (* ?cantidad_a_transformar ?cantidad_unitaria2))))
    ; modifica el recurso input del jugador
    (modify-instance ?recurso_jugador_entrada (cantidad (- ?cantidad_recurso_entrada_jugador ?cantidad_a_transformar)))
    ; modifica el primer output del jugador
    (modify-instance ?recurso_jugador_salida1 (cantidad (+ ?cantidad_recurso_salida1_jugador ?cantidad_transformada_recurso_salida1)))
    ; modifica el segundo output del jugador
    (modify-instance ?recurso_jugador_salida2 (cantidad (+ ?cantidad_recurso_salida2_jugador ?cantidad_transformada_recurso_salida2)))
    ; Ha finalizado su actividad principal dentro de su turno.
    (assert (fin_actividad_principal ?nombre_jugador))
    ; flag para no permitir usar el mismo edificio dos veces.
    (modify-instance ?edificio_usado (nombre_edificio ?nombre_edificio))
    ; eliminar deseo
    (retract ?deseo)
    (printout t"El jugador: <" ?nombre_jugador "> ha transformado en el edificio: <" ?nombre_edificio "> <" ?cantidad_a_transformar "> recursos de <" ?recurso_entrada "> en <" ?cantidad_transformada_recurso_salida1 "> recursos de <" ?recurso_salida1 "> y <" ?cantidad_transformada_recurso_salida2"> recursos de <" ?recurso_salida2 ">." crlf)
)

; Regla 39: NO USAMOS ENERGIA: HABRIA QUE ELIMINARLA...
(defrule EDIFICIO_GENERA_RECURSO_UN_INPUT_DOS_OUTPUT_NO_BONUS_SI_ENERGIA_Y_UNITARIA
    ;   INPUTS          OUTPUT          BONUS   ENERGIA     edificios
    ;      1               2              0        1        (ahumador (1 total), ladrillos (por ud), panaderia (por ud))
    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; El jugador debe estar en el edificio.
    (object (is-a JUGADOR_ESTA_EDIFICIO) (nombre_edificio ?nombre_edificio) (nombre_jugador ?nombre_jugador))
    ; el jugador no ha usado anteriormente el edificio sin haber entrado a otro antes
    ?edificio_usado <- (object (is-a JUGADOR_HA_USADO_EDIFICIO)(nombre_edificio ?ed)(nombre_jugador ?nombre_jugador))
    (test (neq ?nombre_edificio ?ed))
    ; la carta solo puede tener un output
    (object (is-a CARTA_EDIFICIO_GENERADOR) (nombre ?nombre_edificio)(numero_recursos_salida 2))    
    ; obtiene el input del edificio 
    (object (is-a EDIFICIO_INPUT) (nombre_carta ?nombre_edificio) (recurso ?recurso_entrada) (cantidad_maxima ?cantidad_maxima))
    ; Se obtienen los outputs del edificio.
    (object (is-a EDIFICIO_OUTPUT) (nombre_carta ?nombre_edificio) (recurso ?recurso_salida1) (cantidad_min_generada_por_unidad ?cantidad_unitaria1))
    (object (is-a EDIFICIO_OUTPUT) (nombre_carta ?nombre_edificio) (recurso ?recurso_salida2) (cantidad_min_generada_por_unidad ?cantidad_unitaria2))
    (test (neq ?recurso_salida1 ?recurso_salida2))
    ; el edificio no tiene bonus
    (not (object (is-a CARTA_OUTPUT_BONUS) (nombre_carta ?nombre_edificio) (bonus ?)))
    ; obtiene los recursos del jugador del mismo tipo que el input y output
    ?recurso_jugador_entrada <- (object (is-a PARTICIPANTE_TIENE_RECURSO)(nombre_jugador ?nombre_jugador) (recurso ?recurso_entrada) (cantidad ?cantidad_recurso_entrada_jugador))
    ?recurso_jugador_salida1 <- (object (is-a PARTICIPANTE_TIENE_RECURSO)(nombre_jugador ?nombre_jugador) (recurso ?recurso_salida1) (cantidad ?cantidad_recurso_salida1_jugador))
    ?recurso_jugador_salida2 <- (object (is-a PARTICIPANTE_TIENE_RECURSO)(nombre_jugador ?nombre_jugador) (recurso ?recurso_salida2) (cantidad ?cantidad_recurso_salida2_jugador))
    ; obtiene el coste energético del edificio
    (object (is-a COSTE_ENERGIA) (nombre_carta ?nombre_edificio) (coste_unitario TRUE) (cantidad ?coste_energia))
    ; el jugador tiene el deseo de generar X recursos outputs empleando Y recursos inputs.
    ?deseo_generar <- (deseo_generar_con_recurso ?nombre_jugador ?nombre_edificio ?recurso_entrada ?cantidad_a_transformar)
    ; y tiene el deseo de pagar con X de energía. 
    ?deseo_pago_energia <- (deseo_emplear_energia ?nombre_jugador ?nombre_edificio ?cantidad_madera ?cantidad_carbon_vegetal ?cantidad_carbon ?cantidad_coque)
    ; obtener los recursos de energia del jugador.
    ?madera_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso MADERA) (cantidad ?cantidad_madera_jugador))
    ?carbon_vegetal_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso CARBON_VEGETAL) (cantidad ?cantidad_carbon_vegetal_jugador))
    ?carbon_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso CARBON) (cantidad ?cantidad_cabon_jugador))
    ?coque_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso COQUE) (cantidad ?cantidad_coque_jugador))
    ; comprobar que tenga los recursos necesarios.
    (test (>= ?cantidad_recurso_entrada_jugador ?cantidad_a_transformar))
    (test (>= (+ (* ?cantidad_madera 1) (* ?cantidad_carbon_vegetal 3) (* ?cantidad_carbon 3) (* ?cantidad_coque 10)) (* ?cantidad_a_transformar ?coste_energia) ))
    =>
    ; calcula la cantidad a transformar
    (bind ?cantidad_transformada_recurso_salida1 (integer (min (* ?cantidad_maxima ?cantidad_unitaria1) (* ?cantidad_a_transformar ?cantidad_unitaria1))))
    (bind ?cantidad_transformada_recurso_salida2 (integer (min (* ?cantidad_maxima ?cantidad_unitaria2) (* ?cantidad_a_transformar ?cantidad_unitaria2))))
    (bind ?cantidad_energia_empleada (* ?cantidad_a_transformar ?coste_energia))
    ; modifica el recurso I/O del jugador
    (modify-instance ?recurso_jugador_entrada (cantidad (- ?cantidad_recurso_entrada_jugador ?cantidad_a_transformar)))
    (modify-instance ?recurso_jugador_salida1 (cantidad (+ ?cantidad_recurso_salida1_jugador ?cantidad_transformada_recurso_salida1)))
    (modify-instance ?recurso_jugador_salida2 (cantidad (+ ?cantidad_recurso_salida2_jugador ?cantidad_transformada_recurso_salida2)))
    ; modifica los recursos energéticos del jugador.
    (modify-instance ?madera_jugador (cantidad (- ?cantidad_madera_jugador ?cantidad_madera)))
    (modify-instance ?carbon_vegetal_jugador (cantidad (- ?cantidad_carbon_vegetal_jugador ?cantidad_carbon_vegetal)))
    (modify-instance ?carbon_jugador (cantidad (- ?cantidad_cabon_jugador ?cantidad_carbon)))
    (modify-instance ?coque_jugador (cantidad (- ?cantidad_coque_jugador ?cantidad_coque)))
    ; Ha finalizado su actividad principal dentro de su turno.
    (assert (fin_actividad_principal ?nombre_jugador))
    ; eliminar deseos
    (retract ?deseo_generar)
    (retract ?deseo_pago_energia)
    ; flag para no permitir usar el mismo edificio dos veces.
    (modify-instance ?edificio_usado (nombre_edificio ?nombre_edificio))
    (printout t"El jugador: <" ?nombre_jugador "> ha transformado en el edificio: <" ?nombre_edificio "> <" ?cantidad_a_transformar "> recursos de <" ?recurso_entrada "> en <" ?cantidad_transformada_recurso_salida1 "> recursos de <" ?recurso_salida1 "> y <" ?cantidad_transformada_recurso_salida2"> recursos de <" ?recurso_salida2 ">." crlf)
    (printout t" Empleando la siguiente energía:" crlf)
    (printout t" Madera: <" ?cantidad_madera ">" crlf)
    (printout t" Carbón Vegetal: <" ?cantidad_carbon_vegetal_jugador ">" crlf)
    (printout t" Carbón: <" ?cantidad_carbon ">" crlf)
    (printout t" Coque: <" ?cantidad_coque ">" crlf)
)

; Regla 40: NO USAMOS ENERGIA: HABRÍA QUE ELIMINARLA...
(defrule EDIFICIO_GENERA_RECURSO_UN_INPUT_DOS_OUTPUT_NO_BONUS_SI_ENERGIA_Y_FIJA

    ;   INPUTS          OUTPUT          BONUS   ENERGIA     edificios
    ;      1               2              0        1        (ahumador (1 total), ladrillos (por ud), panaderia (por ud))
    
    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; El jugador debe estar en el edificio.
    (object (is-a JUGADOR_ESTA_EDIFICIO) (nombre_edificio ?nombre_edificio) (nombre_jugador ?nombre_jugador))
    ; el jugador no ha usado anteriormente el edificio sin haber entrado a otro antes
    ?edificio_usado <- (object (is-a JUGADOR_HA_USADO_EDIFICIO)(nombre_edificio ?ed)(nombre_jugador ?nombre_jugador))
    (test (neq ?nombre_edificio ?ed))
    ; la carta solo puede tener un output
    (object (is-a CARTA_EDIFICIO_GENERADOR) (nombre ?nombre_edificio)(numero_recursos_salida 2))    
    ; obtiene el input del edificio 
    (object (is-a EDIFICIO_INPUT) (nombre_carta ?nombre_edificio) (recurso ?recurso_entrada) (cantidad_maxima ?cantidad_maxima))
    ; Se obtienen los outputs del edificio.
    (object (is-a EDIFICIO_OUTPUT) (nombre_carta ?nombre_edificio) (recurso ?recurso_salida1) (cantidad_min_generada_por_unidad ?cantidad_unitaria1))
    (object (is-a EDIFICIO_OUTPUT) (nombre_carta ?nombre_edificio) (recurso ?recurso_salida2) (cantidad_min_generada_por_unidad ?cantidad_unitaria2))
    (test (neq ?recurso_salida1 ?recurso_salida2))
    ; el edificio no tiene bonus
    (not (object (is-a CARTA_OUTPUT_BONUS) (nombre_carta ?nombre_edificio) (bonus ?)))
    ; obtiene los recursos del jugador del mismo tipo que el input y output
    ?recurso_jugador_entrada <- (object (is-a PARTICIPANTE_TIENE_RECURSO)(nombre_jugador ?nombre_jugador) (recurso ?recurso_entrada) (cantidad ?cantidad_recurso_entrada_jugador))
    ?recurso_jugador_salida1 <- (object (is-a PARTICIPANTE_TIENE_RECURSO)(nombre_jugador ?nombre_jugador) (recurso ?recurso_salida1) (cantidad ?cantidad_recurso_salida1_jugador))
    ?recurso_jugador_salida2 <- (object (is-a PARTICIPANTE_TIENE_RECURSO)(nombre_jugador ?nombre_jugador) (recurso ?recurso_salida2) (cantidad ?cantidad_recurso_salida2_jugador))
    ; obtiene el coste energético del edificio
    (object (is-a COSTE_ENERGIA) (nombre_carta ?nombre_edificio) (coste_unitario FALSE) (cantidad ?coste_energia))
    ; el jugador tiene el deseo de generar X recursos outputs empleando Y recursos inputs.
    ?deseo_generar <- (deseo_generar_con_recurso ?nombre_jugador ?nombre_edificio ?recurso_entrada ?cantidad_a_transformar)
    ; y tiene el deseo de pagar con X de energía. 
    ?deseo_pago_energia <- (deseo_emplear_energia ?nombre_jugador ?nombre_edificio ?cantidad_madera ?cantidad_carbon_vegetal ?cantidad_carbon ?cantidad_coque)
    ; obtener los recursos de energia del jugador.
    ?madera_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso MADERA) (cantidad ?cantidad_madera_jugador))
    ?carbon_vegetal_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso CARBON_VEGETAL) (cantidad ?cantidad_carbon_vegetal_jugador))
    ?carbon_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso CARBON) (cantidad ?cantidad_cabon_jugador))
    ?coque_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso COQUE) (cantidad ?cantidad_coque_jugador))
    ; comprobar que tenga los recursos necesarios.
    (test (>= ?cantidad_recurso_entrada_jugador ?cantidad_a_transformar))
    (test (>= (+ (* ?cantidad_madera 1) (* ?cantidad_carbon_vegetal 3) (* ?cantidad_carbon 3) (* ?cantidad_coque 10)) ?coste_energia ))

    =>
    ; calcula la cantidad a transformar
    (bind ?cantidad_transformada_recurso_salida1 (integer (min (* ?cantidad_maxima ?cantidad_unitaria1) (* ?cantidad_a_transformar ?cantidad_unitaria1))))
    (bind ?cantidad_transformada_recurso_salida2 (integer (min (* ?cantidad_maxima ?cantidad_unitaria2) (* ?cantidad_a_transformar ?cantidad_unitaria2))))
    
    ; modifica el recurso I/O del jugador
    (modify-instance ?recurso_jugador_entrada (cantidad (- ?cantidad_recurso_entrada_jugador ?cantidad_a_transformar)))
    (modify-instance ?recurso_jugador_salida1 (cantidad (+ ?cantidad_recurso_salida1_jugador ?cantidad_transformada_recurso_salida1)))
    (modify-instance ?recurso_jugador_salida2 (cantidad (+ ?cantidad_recurso_salida2_jugador ?cantidad_transformada_recurso_salida2)))
    ; modifica los recursos energéticos del jugador.
    (modify-instance ?madera_jugador (cantidad (- ?cantidad_madera_jugador ?cantidad_madera)))
    (modify-instance ?carbon_vegetal_jugador (cantidad (- ?cantidad_carbon_vegetal_jugador ?cantidad_carbon_vegetal)))
    (modify-instance ?carbon_jugador (cantidad (- ?cantidad_cabon_jugador ?cantidad_carbon)))
    (modify-instance ?coque_jugador (cantidad (- ?cantidad_coque_jugador ?cantidad_coque)))
    ; Ha finalizado su actividad principal dentro de su turno.
    (assert (fin_actividad_principal ?nombre_jugador))
    ; eliminar deseos
    (retract ?deseo_generar)
    (retract ?deseo_pago_energia)
    ; flag para no permitir usar el mismo edificio dos veces.
    (modify-instance ?edificio_usado (nombre_edificio ?nombre_edificio))
    (printout t"El jugador: <" ?nombre_jugador "> ha transformado en el edificio: <" ?nombre_edificio "> <" ?cantidad_a_transformar "> recursos de <" ?recurso_entrada "> en <" ?cantidad_transformada_recurso_salida1 "> recursos de <" ?recurso_salida1 "> y <" ?cantidad_transformada_recurso_salida2"> recursos de <" ?recurso_salida2 ">," crlf
     "empleando <"?coste_energia"> unidades de energía, pagadas con <"?cantidad_madera"> unidades de madera, <"?cantidad_carbon_vegetal"> unidades de carbón vegetal, <"?cantidad_carbon"> unidades de carbón y <"?cantidad_coque"> unidades de coque." crlf)
)

; Regla 41 => No usada en la estrategia implementada. 
; AL SER UNA SIMPLIFICACIÓN PODRÍAMOS ELIMINARLA...
(defrule COMERCIAR_MERCADO
    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; El jugador debe estar en el edificio.
    (object (is-a JUGADOR_ESTA_EDIFICIO) (nombre_edificio "MERCADO") (nombre_jugador ?nombre_jugador))

    ; el jugador no ha usado anteriormente el edificio sin haber entrado a otro antes
    ?edificio_usado <- (object (is-a JUGADOR_HA_USADO_EDIFICIO)(nombre_edificio ?ed)(nombre_jugador ?nombre_jugador))
    (test (neq "MERCADO" ?ed))
    ; SOLO PUEDE TOMAR UNA UNIDAD DE CADA RECURSO QUE HAY EN EL MERCADO (POR CADA VEZ).
    ?deseo <- (deseo_usar_mercado ?nombre_jugador ?cantidad_pescado ?cantidad_madera ?cantidad_arcilla ?cantidad_hierro ?cantidad_grano ?cantidad_ganado ?cantidad_carbon ?cantidad_piel)
    (test (<= ?cantidad_pescado 1))
    (test (<= ?cantidad_madera 1))
    (test (<= ?cantidad_arcilla 1))
    (test (<= ?cantidad_hierro 1))
    (test (<= ?cantidad_grano 1))
    (test (<= ?cantidad_ganado 1))
    (test (<= ?cantidad_carbon 1))
    (test (<= ?cantidad_piel 1))
    ; la suma no puede ser superior a 5
    (test (<= 5 (+ ?cantidad_pescado ?cantidad_madera ?cantidad_arcilla ?cantidad_hierro ?cantidad_grano ?cantidad_ganado ?cantidad_carbon ?cantidad_piel)))
    ; UN MINIMO DE 2 VECES Y UN MÁXIMO DE 8
    ; rECURSOS: 1 de pescado, madera, arcilla, hierro, grano, ganado, carbon, piel

    ; PROBLEMA ECONTRADO: COMO RECORRER LOS EDIFICIOS DEL JUGADOR PARA OBTENER EL Nº DE EDIFICOS BASICOS.
    ; ==> De momento simplificamos el juego y puede tomar siempre 5 recursos

    ; Obtiene los recursos del jugador
    ?jugador_pescado <- (object (is-a PARTICIPANTE_TIENE_RECURSO)(nombre_jugador ?nombre_jugador)(recurso PESCADO)(cantidad ?cantidad_jugador_pescado))
    ?jugador_madera <- (object (is-a PARTICIPANTE_TIENE_RECURSO)(nombre_jugador ?nombre_jugador)(recurso MADERA)(cantidad ?cantidad_jugador_madera))
    ?jugador_arcilla <- (object (is-a PARTICIPANTE_TIENE_RECURSO)(nombre_jugador ?nombre_jugador)(recurso ARCILLA)(cantidad ?cantidad_jugador_arcilla))
    ?jugador_hierro <- (object (is-a PARTICIPANTE_TIENE_RECURSO)(nombre_jugador ?nombre_jugador)(recurso HIERRO)(cantidad ?cantidad_jugador_hierro))
    ?jugador_grano <- (object (is-a PARTICIPANTE_TIENE_RECURSO)(nombre_jugador ?nombre_jugador)(recurso GRANO)(cantidad ?cantidad_jugador_grano))
    ?jugador_ganado <- (object (is-a PARTICIPANTE_TIENE_RECURSO)(nombre_jugador ?nombre_jugador)(recurso GANADO)(cantidad ?cantidad_jugador_ganado))
    ?jugador_carbon <- (object (is-a PARTICIPANTE_TIENE_RECURSO)(nombre_jugador ?nombre_jugador)(recurso CARBON)(cantidad ?cantidad_jugador_carbon))
    ?jugador_piel <- (object (is-a PARTICIPANTE_TIENE_RECURSO)(nombre_jugador ?nombre_jugador)(recurso PIEL)(cantidad ?cantidad_jugador_piel))
     =>
    ; actualiza los recursos del jugador
    (modify-instance ?jugador_pescado (cantidad (+ ?cantidad_jugador_pescado ?cantidad_pescado)))
    (modify-instance ?jugador_madera (cantidad (+ ?cantidad_jugador_madera ?cantidad_madera)))
    (modify-instance ?jugador_arcilla (cantidad (+ ?cantidad_jugador_arcilla ?cantidad_arcilla)))
    (modify-instance ?jugador_hierro (cantidad (+ ?cantidad_jugador_hierro ?cantidad_hierro)))
    (modify-instance ?jugador_grano (cantidad (+ ?cantidad_jugador_grano ?cantidad_grano)))
    (modify-instance ?jugador_ganado (cantidad (+ ?cantidad_jugador_ganado ?cantidad_ganado)))
    (modify-instance ?jugador_carbon (cantidad (+ ?cantidad_jugador_carbon ?cantidad_carbon)))
    (modify-instance ?jugador_piel (cantidad (+ ?cantidad_jugador_piel ?cantidad_piel)))

    (retract ?deseo)
    ; Ha finalizado su actividad principal dentro de su turno.
    (assert (fin_actividad_principal ?nombre_jugador))
    ; flag para no permitir usar el mismo edificio dos veces.
    (modify-instance ?edificio_usado (nombre_edificio "MERCADO"))
    
    (printout t"El jugado <"?nombre_jugador"> ha comprado en el mercado los siguientes recursos: " crlf)
    (printout t"<"?cantidad_pescado"> unidades de pescado." crlf)
    (printout t"<"?cantidad_madera"> unidades de madera." crlf)
    (printout t"<"?cantidad_arcilla"> unidades de arcilla." crlf)
    (printout t"<"?cantidad_hierro"> unidades de hierro." crlf)
    (printout t"<"?cantidad_grano"> unidades de grano." crlf)
    (printout t"<"?cantidad_ganado"> unidades de ganado." crlf)
    (printout t"<"?cantidad_carbon"> unidades de carbon." crlf)
    (printout t"<"?cantidad_piel"> unidades de piel." crlf)
)

; Regla 42
(defrule COMERCIAR_EN_COMPAÑIA_NAVIERA
    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; El jugador debe estar en el edificio.
    (object (is-a JUGADOR_ESTA_EDIFICIO) (nombre_edificio "COMPAÑIA NAVIERA") (nombre_jugador ?nombre_jugador))
    ; el jugador no ha usado anteriormente el edificio sin haber entrado a otro antes
    ?edificio_usado <- (object (is-a JUGADOR_HA_USADO_EDIFICIO)(nombre_edificio ?ed)(nombre_jugador ?nombre_jugador))
    (test (neq "COMPAÑIA NAVIERA" ?ed))
    ; existe el deseo de usar la compañía naviera (contiene qué objetos vender)
    ?deseo <- (deseo_usar_compañia_naviera ?nombre_jugador ?pescado ?madera ?arcilla ?hierro ?grano ?ganado ?carbon ?piel ?pescado_ahumado ?carbon_vegetal ?ladrillos ?acero ?pan ?carne ?coque ?cuero)

    ; obtiene los datos del jugador.
    ?jugador <- (object (is-a JUGADOR)(nombre ?nombre_jugador)(capacidad_envio ?capacidad_envio))
    ; comprobar que la suma no excede la capacidad de los barcos
    (test (<= (+ ?pescado ?madera ?arcilla ?hierro ?grano ?ganado ?carbon ?piel ?pescado_ahumado ?carbon_vegetal ?ladrillos ?acero ?pan ?carne ?coque ?cuero) ?capacidad_envio))
    ; obtencion numero de recursos del jugador.
    ?pescado_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso PESCADO) (cantidad ?cantidad_pescado))
    ?madera_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso MADERA) (cantidad ?cantidad_madera))
    ?arcilla_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ARCILLA) (cantidad ?cantidad_arcilla))
    ?hierro_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso HIERRO) (cantidad ?cantidad_hierro))
    ?grano_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso GRANO) (cantidad ?cantidad_grano))
    ?ganado_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso GANADO) (cantidad ?cantidad_ganado))
    ?carbon_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso CARBON) (cantidad ?cantidad_carbon))
    ?piel_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso PIEL) (cantidad ?cantidad_piel))
    ?pescado_ahumado_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso PESCADO_AHUMADO) (cantidad ?cantidad_pescado_ahumado))
    ?carbon_vegetal_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso CARBON_VEGETAL) (cantidad ?cantidad_carbon_vegetal))
    ?ladrillos_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso LADRILLOS) (cantidad ?cantidad_ladrillos))
    ?acero_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ACERO) (cantidad ?cantidad_acero))
    ?pan_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso PAN) (cantidad ?cantidad_pan))
    ?carne_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso CARNE) (cantidad ?cantidad_carne))
    ?coque_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso COQUE) (cantidad ?cantidad_coque))
    ?cuero_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso CUERO) (cantidad ?cantidad_cuero))
    ; las cantidades quedan comprobadas en el deseo.
    ; obtener la referencia de los francos para el jugador.
    ?francos_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso FRANCO) (cantidad ?cantidad_francos))
    ; obtener la cantidad generada por el deseo.
    ;(bind ?ingresos_comercio =(+ (* ?pescado 1) (* ?madera 1) (* ?arcilla 1) (* ?hierro 2) (* ?grano 1) (* ?ganado 3) (* ?carbon 3) (* ?piel 2)
    ;                            (* ?pescado_ahumado 2) (* ?carbon_vegetal 2) (* ?ladrillos 2) (* ?acero 8)
    ;                           (* ?pan 3) (* ?carne 2) (* ?coque 5) (* ?cuero 4) ))
    =>
    ; restar cantidades vendidas
    (modify-instance ?pescado_jugador (cantidad (- ?cantidad_pescado ?pescado)))
    (modify-instance ?madera_jugador (cantidad (- ?cantidad_madera ?madera)))
    (modify-instance ?arcilla_jugador (cantidad (- ?cantidad_arcilla ?arcilla)))
    (modify-instance ?hierro_jugador (cantidad (- ?cantidad_hierro ?hierro)))
    (modify-instance ?grano_jugador (cantidad (- ?cantidad_grano ?grano)))
    (modify-instance ?ganado_jugador (cantidad (- ?cantidad_ganado ?ganado)))
    (modify-instance ?carbon_jugador (cantidad (- ?cantidad_carbon ?carbon)))
    (modify-instance ?piel_jugador (cantidad (- ?cantidad_piel ?piel)))
    (modify-instance ?pescado_ahumado_jugador (cantidad (- ?cantidad_pescado_ahumado ?pescado_ahumado)))
    (modify-instance ?carbon_vegetal_jugador (cantidad (- ?cantidad_carbon_vegetal ?carbon_vegetal)))
    (modify-instance ?ladrillos_jugador (cantidad (- ?cantidad_ladrillos ?ladrillos)))
    (modify-instance ?acero_jugador (cantidad (- ?cantidad_acero ?acero)))
    (modify-instance ?pan_jugador (cantidad (- ?cantidad_pan ?pan)))
    (modify-instance ?carne_jugador (cantidad (- ?cantidad_carne ?carne)))
    (modify-instance ?coque_jugador (cantidad (- ?cantidad_coque ?coque)))
    (modify-instance ?cuero_jugador (cantidad (- ?cantidad_cuero ?cuero)))

    ; añadir francos al jugador
    (modify-instance ?francos_jugador (cantidad (+ ?cantidad_francos (+ (* ?pescado 1) (* ?madera 1) (* ?arcilla 1) (* ?hierro 2) (* ?grano 1) (* ?ganado 3) (* ?carbon 3) (* ?piel 2)(* ?pescado_ahumado 2) (* ?carbon_vegetal 2) (* ?ladrillos 2) (* ?acero 8) (* ?pan 3) (* ?carne 2) (* ?coque 5) (* ?cuero 4) ))))
    ; eliminar deseo
    (retract ?deseo)
    ; semaforo final actividad principal.
    (assert (fin_actividad_principal ?nombre_jugador))
    ; flag para no permitir usar el mismo edificio dos veces.
    (modify-instance ?edificio_usado (nombre_edificio "COMPAÑIA NAVIERA"))
    ; log
    (printout t"El jugador <" ?nombre_jugador "> ha obtenido <" (+ (* ?pescado 1) (* ?madera 1) (* ?arcilla 1) (* ?hierro 2) (* ?grano 1) (* ?ganado 3) (* ?carbon 3) (* ?piel 2)(* ?pescado_ahumado 2) (* ?carbon_vegetal 2) (* ?ladrillos 2) (* ?acero 8)(* ?pan 3) (* ?carne 2) (* ?coque 5) (* ?cuero 4) )"> francos comerciando con sus barcos tras comerciar con: " crlf)
    (printout t"<"?pescado"> unidades de pescado." crlf)
    (printout t"<"?madera"> unidades de madera." crlf)
    (printout t"<"?arcilla"> unidades de arcilla." crlf)
    (printout t"<"?hierro"> unidades de hierro." crlf)
    (printout t"<"?grano"> unidades de grano." crlf)
    (printout t"<"?ganado"> unidades de ganado." crlf)
    (printout t"<"?carbon"> unidades de carbon." crlf)
    (printout t"<"?piel"> unidades de piel." crlf)
    (printout t"<"?pescado_ahumado"> unidades de pescado ahumado." crlf)
    (printout t"<"?carbon_vegetal"> unidades de carbón vegetal." crlf)
    (printout t"<"?ladrillos"> unidades de ladrillos." crlf)
    (printout t"<"?acero"> unidades de acero." crlf)
    (printout t"<"?pan"> unidades de pan." crlf)
    (printout t"<"?carne"> unidades de carne." crlf)
    (printout t"<"?coque"> unidades de coque." crlf)
    (printout t"<"?cuero"> unidades de cuero." crlf)
)

; Regla 43
(defrule USAR_EDIFICIO_MUELLE
    ; Obtener al jugador.
    ?jugador <- (object (is-a JUGADOR) (nombre ?nombre_jugador) (num_barcos ?num_barcos) (capacidad_envio ?capacidad_total_envio) (demanda_comida_cubierta ?demanda_total_cubierta) (riqueza ?riqueza_jugador))
    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; El jugador debe estar en el edificio.
    (object (is-a JUGADOR_ESTA_EDIFICIO) (nombre_edificio "MUELLE") (nombre_jugador ?nombre_jugador))
    ; el jugador no ha usado anteriormente el edificio sin haber entrado a otro antes
    ?edificio_usado <- (object (is-a JUGADOR_HA_USADO_EDIFICIO)(nombre_edificio ?ed)(nombre_jugador ?nombre_jugador))
    (test (neq "MUELLE" ?ed))
    ; deseo construir edificio
    ?deseo <- (deseo_construccion ?nombre_jugador ?nombre_carta)
    ; comprobar que se encuentra Disponible
    ?diponibilidad <- (BARCO_DISPONIBLE (nombre_barco ?nombre_carta))
    ?pertenencia_mazo <- (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id_mazo) (nombre_carta ?nombre_carta) (posicion_en_mazo 1))
    ?ref_mazo <- (object (is-a MAZO)(id_mazo ?id_mazo) (numero_cartas_en_mazo ?num_cartas_mazo))
    ; Obtener la carta para modificar la riqueza del jugador
    (object (is-a BARCO) (nombre ?nombre_carta) (valor ?valor_barco) (uds_comida_genera ?unidades_comida_genera_barco) (capacidad_envio ?capacidad_envio_barco))
    ; obtener el coste de la carta
    ?coste_carta <- (object (is-a COSTE_CONSTRUCCION_CARTA) (nombre_carta ?nombre_carta) (cantidad_madera ?coste_madera) (cantidad_hierro ?coste_hierro) (cantidad_acero ?coste_acero))
    ; comprobar que el jugador tiene suficientes recursos para construirla.
    ?recurso_jugador_madera <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso MADERA) (cantidad ?cantidad_madera))
    ?recurso_jugador_hierro <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso HIERRO) (cantidad ?cantidad_hierro))
    ?recurso_jugador_acero <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ACERO) (cantidad ?cantidad_acero))
    (test (>= ?cantidad_madera ?coste_madera))
    (test (>= ?cantidad_hierro ?coste_hierro))
    (test (>= ?cantidad_acero ?coste_acero))
    =>
    ; eliminar disponibilidad
    (retract ?diponibilidad )
    ; modificar cantidad de materiales del jugador
    (modify-instance ?recurso_jugador_madera (cantidad (- ?cantidad_madera ?coste_madera)))
    (modify-instance ?recurso_jugador_hierro (cantidad (- ?cantidad_hierro ?coste_hierro)))
    (modify-instance ?recurso_jugador_acero (cantidad (- ?cantidad_acero ?coste_acero)))
    ; quitar carta del mazo
    (unmake-instance ?pertenencia_mazo)
    ; eliminar deseo
    (retract ?deseo)
    ; asignar la carta al jugador
    (make-instance of PARTICIPANTE_TIENE_CARTA (nombre_jugador ?nombre_jugador) (nombre_carta ?nombre_carta))
    ; Aumentar los atributos de jugador.
    (modify-instance ?jugador (riqueza (+ ?riqueza_jugador ?valor_barco)) (num_barcos (+ ?num_barcos 1)) (capacidad_envio (+ ?capacidad_total_envio ?capacidad_envio_barco)) (demanda_comida_cubierta (+ ?demanda_total_cubierta ?unidades_comida_genera_barco)))
    ; actualiza el numero de cartas en el mazo.
    (modify-instance ?ref_mazo (numero_cartas_en_mazo (- ?num_cartas_mazo 1)))
    ;generar hecho semáforo para reordenar el mazo
    (assert (actualizar_mazo ?id_mazo (- ?num_cartas_mazo 1) 2))
    ; semaforo final actividad principal.
    (assert(fin_actividad_principal ?nombre_jugador)) 
    ; relación para no permitir usar el mismo edificio dos veces.
    (modify-instance ?edificio_usado (nombre_edificio "MUELLE"))
    (printout t "El jugador <"?nombre_jugador"> ha usado el edificio <MUELLE> para construir el barco <"?nombre_carta"> empleando <"?coste_madera"> madera, <"?coste_hierro"> hierro y <"?coste_acero"> acero." crlf)
)

; Regla 44
(defrule PASAR_RONDA 
    ; Semáforo pasar ronda.
    ?cambiar <- (cambiar_ronda TRUE)
    ; selección de siguiente ronda
    ?ronda_actual <- (ronda_actual ?nombre_ronda_actual)
    ; ambos jugadores han pagado la comida.
    (object (is-a JUGADOR) (nombre ?nombre_jugador1))
    (object (is-a JUGADOR) (nombre ?nombre_jugador2))
    (test (neq ?nombre_jugador1 ?nombre_jugador2))
    ?cantidad_restante_j1 <- (cantidad_comida_demandada ?nombre_jugador1 ?nombre_ronda_actual 0)
    ?cantidad_restante_j2 <- (cantidad_comida_demandada ?nombre_jugador2 ?nombre_ronda_actual 0)
    ?ronda_siguiente <- (object (is-a RONDA) (nombre_ronda ?nombre_ronda_siguiente) (coste_comida ?coste_ronda))
    (siguiente_ronda ?nombre_ronda_actual ?nombre_ronda_siguiente)
    ; introducir barco
    ?introduce_barco <- (object (is-a RONDA_INTRODUCE_BARCO) (nombre_ronda ?nombre_ronda_actual) (nombre_carta ?nombre_barco))
    ; semáforo para que en las rondas impares asigne el edificio al ayuntamiento antes de pasar de ronda
    (or (test (eq ?nombre_ronda_actual RONDA_2))
        (test (eq ?nombre_ronda_actual RONDA_4))
        (test (eq ?nombre_ronda_actual RONDA_6))
        (test (eq ?nombre_ronda_actual RONDA_8))
        (edificio_entregado ?nombre_ronda_actual)
    )
    ; evita que se pase de ronda antes de actualizar el mazo cuando se entrega un edificio al ayuntamiento
    (not (actualizar_mazo ? ? ?))
    =>
    ; Actualizar el hecho de ronda actual. 
    (retract ?ronda_actual)
    (assert (ronda_actual ?nombre_ronda_siguiente))
    ; desactivar que se está produciendo un cambio de ronda.
    (retract ?cambiar)
    ; Introducir el nuevo barco.
    (assert (BARCO_DISPONIBLE (nombre_barco ?nombre_barco)))
    (unmake-instance ?introduce_barco)
    ; eliminar hechos auxiliares que llevaban el contador de demanda pagada.
    (retract ?cantidad_restante_j1)
    (retract ?cantidad_restante_j2)
    ; log
    (printout t"Nuevo Barco disponible para la nueva ronda: <" ?nombre_barco ">." crlf)
    (printout t"Se ha cambiado de Ronda: <"?nombre_ronda_actual "> a Ronda: <"?nombre_ronda_siguiente">." crlf)
)

; Regla 45
(defrule COMENZAR_RONDA_EXTRA_FINAL
    ; Comenzar la ronda extra final.
    (ronda_actual RONDA_EXTRA_FINAL)
    (object (is-a JUGADOR) (nombre ?nombre_jugador1))
    (object (is-a JUGADOR) (nombre ?nombre_jugador2))
    (test (neq ?nombre_jugador1 ?nombre_jugador2))
    ; evitar bucles.
    (not (bloquear True))
    =>
    (assert (bloquear True))
    ; generar hechos para permitir a los jugadores realizar una última acción.
    (assert (permitir_realizar_accion ?nombre_jugador1))
    (assert (permitir_realizar_accion ?nombre_jugador2))
    ; generar hecho para bloquear procesos decisión cuando se finalice la partida.
    (assert (turnos_restantes 1))
    ; informar de lo que ocurre en la ronda extra final.
    (printout t"Ha comenzado la RONDA EXTRA FINAL: " crlf)
    (printout t"    => Cada jugador puede realizar una última acción." crlf)
    (printout t"    => Los edificios pueden usarse por varios jugadores al mismo tiempo." crlf)
    (printout t"    => Ya no se pueden realizar más compras de edificios. " crlf)
    (printout t"    => Al finalizar la RONDA EXTRA FINAL las deudas serán pagadas automáticamente. " crlf)
)

; Regla 46
(defrule CALCULAR_RIQUEZA_JUGADOR
    ; ronda extra final
    (ronda_actual RONDA_EXTRA_FINAL)
    ; obtener los jugadores.
    (object (is-a JUGADOR) (nombre ?nombre_jugador1) (deudas ?num_deudas)(riqueza ?riqueza_jugador1))
    (object (is-a JUGADOR) (nombre ?nombre_jugador2) (riqueza ?riqueza_jugador2))
    (test (neq ?nombre_jugador1 ?nombre_jugador2))
    ; comprobar que ya han finalizado su actividad principal.
    ; (and 
    ;     (not (fin_actividad_principal ?nombre_jugador1))
    ;     (not (permitir_realizar_accion ?nombre_jugador1))
    ;     (not (fin_actividad_principal ?nombre_jugador2))
    ;     (not (permitir_realizar_accion ?nombre_jugador2))
    ; )
    (turnos_restantes 0)
    ; OBTENER TODOS LOS INGRESOS Y GASTOS DE CADA JUGADOR Y determinar la riqueza de cada jugador.
    (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador1) (recurso FRANCO) (cantidad ?cantidad_francos_jugador1))
    (not (riqueza ?nombre_jugador1 ?))
    =>
    (bind ?riqueza_total (- (+ ?riqueza_jugador1 ?cantidad_francos_jugador1) (* ?num_deudas 7)))
    (assert (riqueza ?nombre_jugador1 ?riqueza_total))
    (printout t"Riqueza del jugador: <" ?nombre_jugador1 "> calculada." crlf)
)

; Regla 47
(defrule MOSTRAR_RESULTADOS_PARTIDA
    (ronda_actual RONDA_EXTRA_FINAL)
    (object (is-a JUGADOR) (nombre ?nombre_jugador1))
    (object (is-a JUGADOR) (nombre ?nombre_jugador2))
    (test (neq ?nombre_jugador1 ?nombre_jugador2))
    ; obtener hechos auxiliares para posterior limpieza.
    ?ref_riqueza_j1 <- (riqueza ?nombre_jugador1 ?riqueza_j1)
    ?ref_riqueza_j2 <- (riqueza ?nombre_jugador2 ?riqueza_j2)
    ?flag_fin_partida <- (comienzo_partida SI)
    ?flag_ronda_extra_final <- (bloquear True)
    ?flag_restantes <- (turnos_restantes ?)
    ?limpieza_j1 <- (proceso_limpieza_finalizado ?nombre_jugador1)
    ?limpieza_j2 <- (proceso_limpieza_finalizado ?nombre_jugador2)
    ?eliminar_turno <- (turno ?nombre_jugador1)
    ?eliminar_fin_actividad_principal <- (fin_actividad_principal ?nombre_jugador1)
    =>
    (retract ?flag_fin_partida)
    (retract ?flag_ronda_extra_final)
    (retract ?ref_riqueza_j1)
    (retract ?ref_riqueza_j2)
    (retract ?flag_restantes)
    (retract ?limpieza_j1)
    (retract ?limpieza_j2)
    (retract ?eliminar_turno)
    (retract ?eliminar_fin_actividad_principal)
    ; Log resultados.
    (printout t"Resultados partida para 2 jugadores Le Havre:" crlf)
    (printout t"El Jugador: <" ?nombre_jugador1 "> ha obtenido una riqueza de: <" ?riqueza_j1 "> francos. " crlf)
    (printout t"El Jugador: <" ?nombre_jugador2 "> ha obtenido una riqueza de: <" ?riqueza_j2 "> francos. " crlf)
    (dribble-off)
    (halt)
)


; REGLAS ESTRATÉGICAS

; +=============================================================================================+
; |                                   REGLAS ESTRATÉGICAS                                       |
; +=============================================================================================+
; |                                                                                             |
; | A continuación se listan las reglas de la estrategia implementada para el juego.            |
; |                                                                                             |
; +=============================================================================================+

; Limpieza deseos al finalizar el turno de cada jugador.

; PUEDE darse el caso de que tome otra decisión que no requiera de tanta estrategia y por ende 
; se eliminen automáticamente aquellos hechos instanciados para representar su estrategia. 
; Por ende, habrá que permitir que continue el flow del juego.

; Regla 1
(defrule NO_NECESARIA_LIMPIEZA_ESTRATEGIA_DEL_TURNO_JUGADOR
    ; sigue siendo el turno del jugador.
    (turno ?nombre_jugador)
    ; acaba de terminar su actividad principal.
    (fin_actividad_principal ?nombre_jugador)
    ; han finalizado todas las actualizaciones del mazo
    (not (actualizar_mazo ? ? ?))
    ; No existen deseos estratégicos.
    (and
        (not (deseo_construccion ?nombre_jugador ?)) ; ok
        (not (deseo_entrar_edificio ?nombre_jugador ?)) ;OK
        (not (deseo_entrar_edificio ?nombre_jugador ? ? ?)) ; OK
        (not (deseo_generar_con_recurso ?nombre_jugador ? ? ?)) ;OK
        (not (deseo_conseguir_recurso ?nombre_jugador ? ?)) ;OK
        (not (deseo_coger_recurso ?nombre_jugador ?))   ;OK
        (not (objetivo_prioridad_generado ?nombre_jugador ?)) ;OK
        (not (recurso_construccion ?nombre_jugador ? ?))  ; ok
        (not (contador_recurso_construccion ?nombre_jugador ?)) ;OK
    )
    ; no existe proceso limpieza activo.
    (not (proceso_limpieza_activo ?nombre_jugador))
    =>
    (assert (proceso_limpieza_finalizado ?nombre_jugador))
    (printout t"No necesario el Proceso interno de limpieza razonamiento jugador." crlf)
)

; Regla 2
(defrule COMENZAR_LIMPIEZA_ESTRATEGIA_DEL_TURNO_JUGADOR
    ; sigue siendo el turno del jugador.
    (turno ?nombre_jugador)
    ; acaba de terminar su actividad principal.
    (fin_actividad_principal ?nombre_jugador)
    ; han finalizado todas las actualizaciones del mazo
    (not (actualizar_mazo ? ? ?))
    ; existe algún deseo instanciado que no ha sido empleado para su actividad principal.
    (or
        (deseo_construccion ?nombre_jugador ?)
        (deseo_entrar_edificio ?nombre_jugador ?)
        (deseo_entrar_edificio ?nombre_jugador ? ? ?)
        (deseo_generar_con_recurso ?nombre_jugador ? ? ?)
        (deseo_conseguir_recurso ?nombre_jugador ? ?)
        (deseo_coger_recurso ?nombre_jugador ?)
        (objetivo_prioridad_generado ?nombre_jugador ?)
        (recurso_construccion ?nombre_jugador ? ?)
        (contador_recurso_construccion ?nombre_jugador ?)
    )
    ; evitar bucle, sólo se ejecuta una vez.
    (not (proceso_limpieza_activo ?nombre_jugador))
    =>
    (assert (proceso_limpieza_activo ?nombre_jugador))
    (printout t"Comenzando proceso interno de limpieza razonamiento jugador..." crlf)
)

; Regla 3
(defrule FINALIZAR_LIMPIEZA_ESTRATEGIA_DEL_TURNO_JUGADOR
    ; proceso de limpieza activo
    ?proceso <- (proceso_limpieza_activo ?nombre_jugador)
    ; no existe ningún deseo intanciado para el jugador.
    (and
        (not (deseo_construccion ?nombre_jugador ?))
        (not (deseo_entrar_edificio ?nombre_jugador ?)) ;OK
        (not (deseo_entrar_edificio ?nombre_jugador ? ? ?)) ; OK
        (not (deseo_generar_con_recurso ?nombre_jugador ? ? ?)) ;OK
        (not (deseo_conseguir_recurso ?nombre_jugador ? ?)) ;OK
        (not (deseo_coger_recurso ?nombre_jugador ?))   ;OK
        (not (objetivo_prioridad_generado ?nombre_jugador ?)) ;OK
        (not (recurso_construccion ?nombre_jugador ? ?))  ; ok
        (not (contador_recurso_construccion ?nombre_jugador ?)) ;OK
    )
    =>
    (retract ?proceso)
    (assert (proceso_limpieza_finalizado ?nombre_jugador))
    (printout t"Proceso interno de limpieza razonamiento jugador finalizado." crlf)
)

; Regla 4
(defrule LIMPIAR_OBJETIVOS_CONSEGUIR_RECURSOS
    ; proceso de limpieza activo
    (proceso_limpieza_activo ?nombre_jugador)
    ?deseo <- (deseo_conseguir_recurso ?nombre_jugador ? ?)
    =>
    (retract ?deseo)
    (printout t"Deseo conseguir recurso eliminado tras no poder ser llevado a cabo durante el turno del jugador: <" ?nombre_jugador ">." crlf)
)

; Regla 5
(defrule LIMPIAR_DESEOS_ENTRAR_EDIFICIOS_SIMPLES
    ; proceso de limpieza activo
    (proceso_limpieza_activo ?nombre_jugador)
    ?deseo <- (deseo_entrar_edificio ?nombre_jugador ?ed)
    =>
    (retract ?deseo)
    (printout t"Deseo entrar edificio sin coste entrada eliminado tras no poder ser llevado a cabo durante el turno del jugador: <" ?nombre_jugador ">." crlf)
)

; Regla 6
(defrule LIMPIAR_DESEOS_ENTRAR_EDIFICIOS_COMPLEJOS
    ; proceso de limpieza activo
    (proceso_limpieza_activo ?nombre_jugador)
    ?deseo <- (deseo_entrar_edificio ?nombre_jugador ?ed ?tipo ?recurso)
    =>
    (retract ?deseo)
    (printout t"Deseo entrar edificio coste entrada eliminado tras no poder ser llevado a cabo durante el turno del jugador: <" ?nombre_jugador ">." crlf)
)

; Regla 7
(defrule LIMPIAR_DESEOS_GENERAR_CON_RECURSO
    ; proceso de limpieza activo
    (proceso_limpieza_activo ?nombre_jugador)
    ?deseo <- (deseo_generar_con_recurso ?nombre_jugador ?ed ?recurso ?cantidad)
    =>
    (retract ?deseo)
    (printout t"Deseo generar recurso en edificio eliminado tras no poder ser llevado a cabo durante el turno del jugador: <" ?nombre_jugador ">." crlf)
)

; Regla 8
(defrule LIMPIAR_DESEOS_COGER_RECURSO
    ; proceso de limpieza activo
    (proceso_limpieza_activo ?nombre_jugador)
    ?deseo <- (deseo_coger_recurso ?nombre_jugador ?)
    =>
    (retract ?deseo)
    (printout t"Deseo coger recurso de oferta eliminado tras no poder ser llevado a cabo durante el turno del jugador: <" ?nombre_jugador ">." crlf)
)

; Regla 9
(defrule LIMPIAR_DESEOS_CONSTRUCCION_SUELTOS
    ; proceso de limpieza activo
    (proceso_limpieza_activo ?nombre_jugador)
    ?deseo <- (deseo_construccion ?nombre_jugador ?nombre_edificio)
    =>
    (retract ?deseo)
    (printout t"Deseo construcción eliminado tras no poder ser llevado a cabo durante el turno del jugador: <" ?nombre_jugador ">." crlf)
)

; Regla 10
(defrule LIMPIAR_DESEO_CONSTRUIR_EDIFICIO_NO_PUEDE_PAGAR_ENTRADA_CONSTRUCTORA
    (turno ?nombre_jugador)
    ?deseo <-(deseo_construccion ?nombre_jugador ?nombre_edificio)
    
    ; obtener la constructora libre.
    (object (is-a PARTICIPANTE_TIENE_CARTA) (nombre_carta ?nombre_constructora) (nombre_jugador ?))
    (not (object (is-a JUGADOR_ESTA_EDIFICIO)(nombre_edificio ?nombre_constructora)(nombre_jugador ?)))
    (object (is-a COSTE_ENTRADA_CARTA) (nombre_carta ?nombre_constructora) (tipo COMIDA) (cantidad ?coste_entrada))
    ; tiene que ser un edificio constructor con coste entrada. 
    (or 
        (test (eq ?nombre_constructora "CONSTRUCTORA2"))
        (test (eq ?nombre_constructora "CONSTRUCTORA3"))
    )
    (object (is-a PARTICIPANTE_TIENE_RECURSO)(nombre_jugador ?nombre_jugador)(tipo COMIDA)(recurso PESCADO)(cantidad ?cantidad_pescado))
    (object (is-a PARTICIPANTE_TIENE_RECURSO)(nombre_jugador ?nombre_jugador)(tipo COMIDA)(recurso PESCADO_AHUMADO)(cantidad ?cantidad_pescado_ahumado))
    (object (is-a PARTICIPANTE_TIENE_RECURSO)(nombre_jugador ?nombre_jugador)(tipo COMIDA)(recurso CARNE)(cantidad ?cantidad_carne))
    (object (is-a PARTICIPANTE_TIENE_RECURSO)(nombre_jugador ?nombre_jugador)(tipo COMIDA)(recurso PAN)(cantidad ?cantidad_pan))
    (object (is-a RECURSO_ALIMENTICIO) (nombre PESCADO) (comida_genera ?ratio_pescado))
    (object (is-a RECURSO_ALIMENTICIO) (nombre PESCADO_AHUMADO) (comida_genera ?ratio_pescado_ahumado))
    (object (is-a RECURSO_ALIMENTICIO) (nombre PAN) (comida_genera ?ratio_pan))
    (object (is-a RECURSO_ALIMENTICIO) (nombre CARNE) (comida_genera ?ratio_carne))
    (test (< (* ?cantidad_pescado ?ratio_pescado) ?coste_entrada))
    (test (< (* ?cantidad_pescado_ahumado ?ratio_pescado_ahumado) ?coste_entrada))
    (test (< (* ?cantidad_pan ?ratio_pan) ?coste_entrada))
    (test (< (* ?cantidad_carne ?ratio_carne) ?coste_entrada))
      =>
    (retract ?deseo)
    (printout t"No se ha podido construir el edificio debido a escasez de recursos alimenticios." crlf)
    ; SE PODRÍA IMPLEMENTAR: puede pillar comida de la oferta.
)

; Regla 11
(defrule LIMPIAR_OBJETIVOS_PRIORIDADES
    ; proceso de limpieza activo
    (proceso_limpieza_activo ?nombre_jugador)
    ; último el eliminarse.
    (and
        (not (deseo_construccion ?nombre_jugador ?))
        (not (deseo_entrar_edificio ?nombre_jugador ?)) ;OK
        (not (deseo_entrar_edificio ?nombre_jugador ? ? ?)) ; OK
        (not (deseo_generar_con_recurso ?nombre_jugador ? ? ?)) ;OK
        (not (deseo_conseguir_recurso ?nombre_jugador ? ?)) ;OK
        (not (deseo_coger_recurso ?nombre_jugador ?))   ;OK
        (not (recurso_construccion ?nombre_jugador ? ?)) ;OK
        (not (contador_recurso_construccion ?nombre_jugador ?)) ;OK
    )
    ; tiene un objetivo prioritario activado
    ?objetivo <- (objetivo_prioridad_generado ?nombre_jugador ?)
    => 
    (retract ?objetivo)
    (printout t"Objetivo prioritario eliminado tras fin actividad principal o la desaparición del deseo de construcción del jugador: <" ?nombre_jugador ">." crlf)
)

; Regla 12
(defrule LIMPIAR_DESEO_RECURSO_CONSTRUCCION_VACIOS
    ; elimina aquellos deseos inutiles generados
    (turno ?nombre_jugador)
    ?deseo_inutil <- (recurso_construccion ?nombre_jugador ? 0)
    ?contador <- (contador_recurso_construccion ?nombre_jugador ?numero_restante)
    =>
    (retract ?deseo_inutil)
    (retract ?contador)
    (assert (contador_recurso_construccion ?nombre_jugador (- ?numero_restante 1)))
    (printout t"Deseo recurso construcción eliminado del jugador: <" ?nombre_jugador "> debido a que tenía 0 unidades de recurso." crlf)
)

; Regla 13
(defrule LIMPIAR_DESEO_RECURSO_CONSTRUCCION_RESTANTES_FIN_TURNO
    ; proceso de limpieza activo
    (proceso_limpieza_activo ?nombre_jugador)
    ?deseo <- (recurso_construccion ?nombre_jugador ? ?)
    ?contador <- (contador_recurso_construccion ?nombre_jugador ?numero_restante)
    (test (> ?numero_restante 0))
    =>
    (retract ?deseo)
    (retract ?contador)
    (assert (contador_recurso_construccion ?nombre_jugador (- ?numero_restante 1)))
    (printout t"Deseo recurso construcción eliminado del jugador: <" ?nombre_jugador "> debido a que se finalizó su turno." crlf)
)

; Regla 14
(defrule LIMPIAR_CONTADOR_RECURSO_CONSTRUCCION_FIN_TURNO
    ; proceso de limpieza activo
    (proceso_limpieza_activo ?nombre_jugador)
    ?contador <- (contador_recurso_construccion ?nombre_jugador 0)
    =>
    (retract ?contador)
    (printout t"Contador recursos construcción eliminado del jugador: <" ?nombre_jugador "> debido a que se finalizó su turno." crlf)
)

; Regla 15
(defrule GENERAR_DESEO_OBTENER_BARCO
    ; ronda actual no puede ser ronda final.
    (ronda_actual ?ronda)
    (test (neq ?ronda RONDA_EXTRA_FINAL))
    ; sea el turno del jugador.
    (object (is-a JUGADOR) (nombre ?nombre_jugador))
    (turno ?nombre_jugador)
    ; no ha terminado su actividad principal
    (not (fin_actividad_principal ?nombre_jugador))
    ; ejecutar cuando se hayan añadido los recursos a la oferta.
    (recursos_añadidos_loseta ?)
    ; comprobar que se encuentra Disponible
    (BARCO_DISPONIBLE (nombre_barco ?nombre_barco))
    (object (is-a CARTA_PERTENECE_A_MAZO) (nombre_carta ?nombre_barco) (posicion_en_mazo 1))
    ; obtener recursos del jugador.
    (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso MADERA) (cantidad ?cantidad_madera_jugador))
    (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso HIERRO) (cantidad ?cantidad_hierro_jugador))
    (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ACERO) (cantidad ?cantidad_acero_jugador))
    ; obtener coste construcción barco.
    (object (is-a COSTE_CONSTRUCCION_CARTA)(nombre_carta ?nombre_barco)(cantidad_madera ?cantidad_madera)(cantidad_hierro ?cantidad_hierro)(cantidad_acero ?cantidad_acero))
    ; Tiene suficientes recursos para construirlo.
    (test (>= ?cantidad_madera_jugador ?cantidad_madera))
    (test (>= ?cantidad_hierro_jugador ?cantidad_hierro))
    (test (>= ?cantidad_acero_jugador ?cantidad_acero))
    ; comprobar que el muelle esté disponible.
    (object (is-a PARTICIPANTE_TIENE_CARTA)(nombre_jugador ?)(nombre_carta "MUELLE"))
    (not (object (is-a JUGADOR_ESTA_EDIFICIO)(nombre_jugador ?)(nombre_edificio "MUELLE")))
    ; Comprobar que tiene recursos para poder entrar al muelle.
    (object (is-a COSTE_ENTRADA_CARTA) (nombre_carta "MUELLE")(tipo COMIDA) (cantidad ?coste_entrada))
    (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (tipo COMIDA) (recurso ?recurso) (cantidad ?cantidad_recurso))
    (object (is-a RECURSO_ALIMENTICIO) (nombre ?recurso) (comida_genera ?ratio))
    ; comprobar tiene suficiente.
    (test (>= (* ?cantidad_recurso ?ratio) ?coste_entrada))
    =>
    (assert (deseo_construccion ?nombre_jugador ?nombre_barco))
    (assert (deseo_entrar_edificio ?nombre_jugador "MUELLE" COMIDA ?recurso))
    (printout t"El jugador: <"?nombre_jugador"> ha generado el deseo de obtener el barco: <"?nombre_barco">." crlf)
)

; Regla 16
(defrule GENERAR_DESEO_DEUDAS
    ; SIEMPRE QUE PUEDA PAGARÁ UNA DEUDA.
    (object (is-a JUGADOR) (nombre ?nombre_jugador) (deudas ?num_deudas))
    (turno ?nombre_jugador)
    ; cuando haya terminado su acción principal.
    (fin_actividad_principal ?nombre_jugador)
    ; tiene que tener al menos una deuda.
    (test (> ?num_deudas 0))
    ; tiene que tener suficientes francos para pagar una deuda.
    (object (is-a PARTICIPANTE_TIENE_RECURSO)(nombre_jugador ?nombre_jugador)(recurso FRANCO)(cantidad ?cantidad_francos))
    (test (> ?cantidad_francos 4))
    =>
    (assert (deseo_pagar_deuda ?nombre_jugador 1))
    (printout t"El jugador: <"?nombre_jugador"> ha generado el deseo de pagar 1 deuda." crlf)
)

; ===============================================================================================================
; Inicialmente la decision será pagar con pescado porque es la cantidad que más tienes. 

; Regla 32
(defrule CAMBIAR_DECISION_PAGO_COMIDA_ENTRAR_EDIFICIOS
    (turno ?nombre_jugador)
    ?deseo <- (decision_pago_comida_entrar_edificios ?nombre_jugador ?recurso)
    ;(test (neq ?otro ?nombre_jugador))
    (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ?recurso) (cantidad ?cantidad_recurso_jugador))
    ; obtener otro recurso alimenticio.
    (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ?otro_recurso) (cantidad ?cantidad_otro_recurso_jugador))
    ; comprobar que no sean iguales.
    (test (neq ?recurso ?otro_recurso))
    ; comprobar que es un recurso energetico.
    (object (is-a RECURSO_ALIMENTICIO) (nombre ?otro_recurso) (comida_genera ?comida_genera_otro_recurso))
    (object (is-a RECURSO_ALIMENTICIO) (nombre ?recurso) (comida_genera ?comida_genera_recurso))
    ; el nuevo recurso deberá tener más cantidad. 
    (test (> (* ?comida_genera_otro_recurso ?cantidad_otro_recurso_jugador) (* ?comida_genera_recurso ?cantidad_recurso_jugador) ))
    =>
    (retract ?deseo)
    (assert (decision_pago_comida_entrar_edificios ?nombre_jugador ?otro_recurso))
    (printout t"El jugador ha cambiado su decisión de pago de comida del recurso: <"?recurso"> al recurso <"?otro_recurso"> para entrar a edificios." crlf)
)

; Regla 17
(defrule TRANSFORMAR_ALIMENTOS
    (turno ?nombre_jugador)
    ; solo puede ejecutarlo cuando no haya hecho su actividad principal.
    (not (fin_actividad_principal ?jugador))
    ; ejecutar cuando se hayan añadido los recursos a la oferta.
    (recursos_añadidos_loseta ?)
    (object (is-a PARTICIPANTE_TIENE_RECURSO)(tipo ?tipo)(nombre_jugador ?nombre_jugador)(recurso ?recurso_entrada)(cantidad ?cantidad_entrada))
    (or 
        (test (eq ?recurso_entrada PESCADO))
        (test (eq ?recurso_entrada GANADO))
        (test (eq ?recurso_entrada GRANO))
    )
    (object (is-a EDIFICIO_INPUT)(nombre_carta ?nombre_edificio)(recurso ?recurso_entrada)(cantidad_maxima ?cantidad_max))
    (object (is-a EDIFICIO_OUTPUT)(nombre_carta ?nombre_edificio)(recurso ?recurso_salida)(cantidad_min_generada_por_unidad ?ratio))
    ; Evitar que coja los francos al calcular el output si existen +1 output.
    (or
        (test (eq ?recurso_salida PESCADO_AHUMADO))
        (test (eq ?recurso_salida CARNE))
        (test (eq ?recurso_salida PAN))
    )
    ; Un umbral mayor a 4.
    (test (> ?cantidad_entrada 4))
    =>
    ; deseo generar recurso con input
    (assert (deseo_conseguir_recurso ?nombre_jugador ?recurso_salida (integer (min (* ?ratio ?cantidad_max) (* ?ratio ?cantidad_entrada)))))
    ; log
    (printout t"El jugador: <"?nombre_jugador"> quiere transformar un recurso alimenticio a través del deseo conseguir recurso. En concreto, quiere conseguir <" ?recurso_salida "> empleando: <"(integer (min (* ?ratio ?cantidad_max) (* ?ratio ?cantidad_entrada)))"> unidad(es) de <" ?recurso_entrada">" crlf)
)

; Regla 18
(defrule OBTENER_DESEOS_CONSTRUCCION_CARTA_PRIORIDAD_1

    ; sea el turno del jugador.
    (object (is-a JUGADOR) (nombre ?nombre_jugador))
    (turno ?nombre_jugador)
    ; no ha terminado su actividad principal
    (not (fin_actividad_principal ?nombre_jugador))

    ; ejecutar cuando se hayan añadido los recursos a la oferta.
    (recursos_añadidos_loseta ?)

    ; exite objetivo prioridad 1
    (objetivo_carta_jugador ?nombre_jugador ?nombre_carta 1)
    ; no se ha instanciado un objetivo de prioridad 1 --> evita que lance objetivos sin concretar ninguno
    (not (objetivo_prioridad_generado ?nombre_jugador 1))

    ; la carta está accesible para ser construida.
    (object (is-a CARTA) (nombre ?nombre_carta))
    (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?) (nombre_carta ?nombre_carta) (posicion_en_mazo 1))

    ; obtener recursos del jugador.
    ?madera_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso MADERA) (cantidad ?cantidad_madera))
    ?arcilla_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ARCILLA) (cantidad ?cantidad_arcilla))
    ?hierro_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso HIERRO) (cantidad ?cantidad_hierro))
    ?ladrillos_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso LADRILLOS) (cantidad ?cantidad_ladrillos))
    ?acero_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ACERO) (cantidad ?cantidad_acero))
    
    ; comprobar que tenga los recursos necesarios para poder construir el barco.
    (object (is-a COSTE_CONSTRUCCION_CARTA) (nombre_carta ?nombre_carta) (cantidad_madera ?coste_madera) (cantidad_arcilla ?coste_arcilla) (cantidad_ladrillo ?coste_ladrillo) (cantidad_hierro ?coste_hierro ) (cantidad_acero ?coste_acero))

    ; tiene recursos necesarios.
    (test (>= ?cantidad_madera ?coste_madera))
    (test (>= ?cantidad_arcilla ?coste_arcilla))
    (test (>= ?cantidad_hierro ?coste_hierro))
    (test (>= ?cantidad_ladrillos ?coste_ladrillo))
    (test (>= ?cantidad_acero ?coste_acero))

    =>
    (assert (deseo_construccion ?nombre_jugador ?nombre_carta))
    (assert (objetivo_prioridad_generado ?nombre_jugador 1))
    (printout t"El jugador con nombre: <" ?nombre_jugador "> ha generado el deseo de construcción para la carta: <" ?nombre_carta "> con prioridad: <1>." crlf) 
)

; Regla 19
(defrule OBTENER_RECURSOS_PARA_CONSTRUIR_PRIORIDAD_1
    (object (is-a JUGADOR) (nombre ?nombre_jugador))
    (turno ?nombre_jugador)
    ; solo puede ejecutarlo cuando no haya hecho su actividad principal.
    (not (fin_actividad_principal ?nombre_jugador))
    ; ejecutar cuando se hayan añadido los recursos a la oferta.
    (recursos_añadidos_loseta ?)
    ; solo puede ejecutarlo cuando no haya hecho su actividad principal.
    (not (fin_actividad_principal ?nombre_jugador))
    ; exite objetivo prioridad 1
    (objetivo_carta_jugador ?nombre_jugador ?nombre_carta 1)
    ; no se ha instanciado un objetivo de prioridad 1 --> evita que lance objetivos sin concretar ninguno
    (not (objetivo_prioridad_generado ?nombre_jugador 1))
    ; la carta está accesible para ser construida.
    (object (is-a CARTA) (nombre ?nombre_carta))
    (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?) (nombre_carta ?nombre_carta) (posicion_en_mazo 1))
    ; obtener recursos del jugador.
    ?madera_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso MADERA) (cantidad ?cantidad_madera))
    ?arcilla_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ARCILLA) (cantidad ?cantidad_arcilla))
    ?hierro_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso HIERRO) (cantidad ?cantidad_hierro))
    ?ladrillos_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso LADRILLOS) (cantidad ?cantidad_ladrillos))
    ?acero_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ACERO) (cantidad ?cantidad_acero))
    ; comprobar que NO tenga los recursos necesarios para poder construir el barco.
    (object (is-a COSTE_CONSTRUCCION_CARTA) (nombre_carta ?nombre_carta) (cantidad_madera ?coste_madera) (cantidad_arcilla ?coste_arcilla) (cantidad_ladrillo ?coste_ladrillo) (cantidad_hierro ?coste_hierro ) (cantidad_acero ?coste_acero))
    ; NO tiene recursos necesarios.
    (or 
        (test (< ?cantidad_madera ?coste_madera))
        (test (< ?cantidad_arcilla ?coste_arcilla))
        (test (< ?cantidad_hierro ?coste_hierro))
        (test (< ?cantidad_ladrillos ?coste_ladrillo))
        (test (< ?cantidad_acero ?coste_acero))
    )
    ; NO se haya ejecutado la regla añadiendo algún hecho recurso construccion.
    (not (recurso_construccion ?nombre_jugador ? ? ))
    =>
    ; Semáforo prioridades.
    (assert (objetivo_prioridad_generado ?nombre_jugador 1))
    (assert (recurso_construccion ?nombre_jugador MADERA (max 0 (- ?coste_madera ?cantidad_madera)) ) )
    (assert (recurso_construccion ?nombre_jugador ARCILLA (max 0 (- ?coste_arcilla ?cantidad_arcilla)) ) )
    (assert (recurso_construccion ?nombre_jugador HIERRO (max 0 (- ?coste_hierro ?cantidad_hierro)) ) )
    (assert (recurso_construccion ?nombre_jugador LADRILLOS (max 0 (- ?coste_ladrillo ?cantidad_ladrillos)) ) )
    (assert (recurso_construccion ?nombre_jugador ACERO (max 0 (- ?coste_acero ?cantidad_acero)) ) )
    (assert (contador_recurso_construccion ?nombre_jugador 5))
    (printout t"El jugador con nombre: <" ?nombre_jugador "> ha generado el deseo de obtener recursos para poder construir la carta: <" ?nombre_carta "> con prioridad: <1>." crlf) 
)

; Regla 20 
(defrule COMPROBAR_EXISTENCIA_RECURSOS_CONSTRUCCION_EN_OFERTA
    (turno ?nombre_jugador)
    ; obtiene el deseo del recurso a conseguir
    ?deseo_recurso_construccion <- (recurso_construccion ?nombre_jugador ?recurso ?cantidad_demandada)
    ?contador <- (contador_recurso_construccion ?nombre_jugador ?numero_restante)
    ; obtener el recurso de la oferta. 
    (OFERTA_RECURSO (recurso ?recurso) (cantidad ?cantidad_oferta))
    ; La cantidad demandada debe ser mayor que 0.
    (test (> ?cantidad_demandada 0))
    (test (>= ?cantidad_oferta ?cantidad_demandada))
    ; no debe existir un coger recurso.
    (not (deseo_coger_recurso ?nombre_jugador ?))
    =>
    (assert (deseo_coger_recurso ?nombre_jugador ?recurso))
    ; en este turno sólo cogerá de la oferta, por tanto deshacemos los deseos de construir edificios
    (retract ?deseo_recurso_construccion)
    (retract ?contador)
    (assert (contador_recurso_construccion ?nombre_jugador (- ?numero_restante 1)))
    (printout t"El jugador: <"?nombre_jugador"> ha generado el deseo de coger de la oferta el recurso: <"?recurso"> que necesitaba para la construcción de la carta." crlf)
)

; Regla 21
(defrule GENERAR_DESEO_CONSEGUIR_RECURSOS 
    ; Cuando no hay los recursos deseados en la oferta, se debe generar el semáforo que permite ejecutar las 
    ; reglas encargadas de generar el recurso a través del uso de edificios. 
    (turno ?nombre_jugador)
    ?deseo_recurso_construccion <- (recurso_construccion ?nombre_jugador ?recurso ?cantidad_demandada)
    ; no hay ningún edificio que genere madera (en el juego de 2 jugadores), por tanto, no debe ejecutarse esta regla para dicho recurso
    (test (neq ?recurso MADERA))
    (test (> ?cantidad_demandada 0))
    ?contador <- (contador_recurso_construccion ?nombre_jugador ?numero_restante)
    ; Comprueba que el recurso no está disponible en la oferta, ya sea porque hay menos cantidad de la necearia
    ; o porque directamente el recurso no existe en la oferta. 
    (or 
        (and 
            (OFERTA_RECURSO (recurso ?recurso) (cantidad ?cantidad_oferta))
            (test (< ?cantidad_oferta ?cantidad_demandada))
        )
        (not (OFERTA_RECURSO (recurso ?recurso)(cantidad ?)))
    )
    =>
    (assert (deseo_conseguir_recurso ?nombre_jugador ?recurso ?cantidad_demandada))
    ; como ahora se va a intentar obtener el recurso con edificios, el deseo de recurso construcción ya ha cumplido su labor
    (retract ?deseo_recurso_construccion)
    (retract ?contador)
    (assert (contador_recurso_construccion ?nombre_jugador (- ?numero_restante 1)))
    (printout t"El jugador: <"?nombre_jugador"> ha generado el deseo de conseguir el recurso: <"?recurso"> que necesitaba para la construcción de la carta. Puede ser debido a que es un producto elaborado o no hay suficiente cantidad en la oferta." crlf)
)

; INPUT COSTE_ENTRADA
    ;   -        x  (monticulo arcilla, herreria, mina carbon) OK
    ;   x        -  (carbon vegetal, peleteria)   OK
    ;   x        x  (panaderia, matadero, ahumador)
    ;   -        -  (piscifactoria, )  OK
    ;
; Le mandas directamente a obtener ese recurso.

; Regla 22
(defrule OBTENER_DESEO_ENTRAR_EDIFICIO_PARA_CONSEGUIR_RECURSO_SIN_INPUT_SIN_COSTE_ENTRADA
    ; INPUT COSTE_ENTRADA
    ;   -        -  (piscifactoria, ) ó si lo tiene pues no le cuesta dinero.
    (turno ?nombre_jugador)
    ; tiene el deseo de conseguir recurso. 
    ?deseo <- (deseo_conseguir_recurso ?nombre_jugador ?recurso ?cantidad)
    ; el edificio está accesible
    (object (is-a PARTICIPANTE_TIENE_CARTA) (nombre_carta ?nombre_edificio) (nombre_jugador ?))
    (not (object (is-a JUGADOR_ESTA_EDIFICIO)(nombre_edificio ?nombre_edificio)(nombre_jugador ?)))
    ; Existe un output para ese recurso.
    (object (is-a EDIFICIO_OUTPUT) (nombre_carta ?nombre_edificio) (recurso ?recurso)(cantidad_min_generada_por_unidad ?))
    ; No existe un input para ese edificio.
    (not (object (is-a EDIFICIO_INPUT) (nombre_carta ?nombre_edificio)(recurso ?otro_recurso) (cantidad_maxima ?max_input)))
    ; NO Tiene coste de entrada o le pertenece y está vacio.
    (or
        (not (object (is-a COSTE_ENTRADA_CARTA) (nombre_carta ?nombre_edificio) (tipo ?) (cantidad ?)))
        (and
            (not (object (is-a JUGADOR_ESTA_EDIFICIO)(nombre_edificio ?nombre_edificio)(nombre_jugador ?)))
            (object (is-a PARTICIPANTE_TIENE_CARTA) (nombre_carta ?nombre_edificio) (nombre_jugador ?nombre_jugador))
        )
    )
    =>
    (retract ?deseo)
    (assert (deseo_entrar_edificio ?nombre_jugador ?nombre_edificio))
    (printout t "El jugador: <"?nombre_jugador"> ha generado el deseo de entrar al edificio <" ?nombre_edificio "> para intentar conseguir recurso <" ?recurso ">." crlf)
)

; Regla 23
(defrule OBTENER_DESEO_ENTRAR_EDIFICIO_PARA_CONSEGUIR_RECURSO_CON_INPUT_SIN_COSTE_ENTRADA
    ; INPUT COSTE_ENTRADA
    ;   x        -  (carbon vegetal, peleteria) ó porque le pertenece el edificio.
    (turno ?nombre_jugador)
    ; tiene el deseo de conseguir recurso. 
    ?deseo <- (deseo_conseguir_recurso ?nombre_jugador ?recurso ?cantidad)
    ; el edificio está accesible
    (object (is-a PARTICIPANTE_TIENE_CARTA) (nombre_carta ?nombre_edificio) (nombre_jugador ?))
    (not (object (is-a JUGADOR_ESTA_EDIFICIO)(nombre_edificio ?nombre_edificio)(nombre_jugador ?)))
    ; Existe un output para ese recurso.
    (object (is-a EDIFICIO_OUTPUT) (nombre_carta ?nombre_edificio) (recurso ?recurso) (cantidad_min_generada_por_unidad ?ratio))
    ; Existe un input para ese edificio.
    (object (is-a EDIFICIO_INPUT) (nombre_carta ?nombre_edificio)(recurso ?recurso_entrada) (cantidad_maxima ?max_input))
    ; NO Tiene coste de entrada o le pertenece y está vacio.
    (or
        (not (object (is-a COSTE_ENTRADA_CARTA) (nombre_carta ?nombre_edificio) (tipo ?) (cantidad ?)))
        (and
            (not (object (is-a JUGADOR_ESTA_EDIFICIO)(nombre_edificio ?nombre_edificio)(nombre_jugador ?)))
            (object (is-a PARTICIPANTE_TIENE_CARTA) (nombre_carta ?nombre_edificio) (nombre_jugador ?nombre_jugador))
        )
    )
    ; obtener recurso jugador.
    ; obtener recurso input del jugador. 
    (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ?recurso_entrada) (cantidad ?cantidad_recurso_jugador))
    ; Tiene que ser mayor que 0.
    (test (> ?cantidad_recurso_jugador 0))
    =>
    (retract ?deseo)
    (bind ?cantidad_a_transformar (min (* ?max_input ?ratio) (* ?cantidad_recurso_jugador ?ratio)))
    (assert (deseo_entrar_edificio ?nombre_jugador ?nombre_edificio))
    (assert (deseo_generar_con_recurso ?nombre_jugador ?nombre_edificio ?recurso_entrada ?cantidad_a_transformar))
    (printout t "El jugador: <"?nombre_jugador"> ha generado el deseo de entrar al edificio <" ?nombre_edificio "> para intentar generar el recurso <" ?recurso "> empleando como recurso de entrada: <"?cantidad_a_transformar"> unidad(es) de <"?recurso_entrada">." crlf)
)

; Regla 24
(defrule OBTENER_DESEO_ENTRAR_EDIFICIO_PARA_CONSEGUIR_RECURSO_CON_INPUT_CON_COSTE_ENTRADA
    ; INPUT COSTE_ENTRADA
    ;   x        x  (panaderia, matadero, ahumador)

    (turno ?nombre_jugador)
    ; tiene el deseo de conseguir recurso. Donde el recurso es el material refinado.
    ?deseo <- (deseo_conseguir_recurso ?nombre_jugador ?recurso ?cantidad)
    ; el edificio está accesible: alguien tiene el edificio y no hay nadie dentro...
    (object (is-a PARTICIPANTE_TIENE_CARTA) (nombre_carta ?nombre_edificio) (nombre_jugador ?))
    (not (object (is-a JUGADOR_ESTA_EDIFICIO)(nombre_edificio ?nombre_edificio)(nombre_jugador ?)))

    ; Gestión Inputs.
    ; obtiene el edificio que le da el recurso deseado    
    ; Existe un output para ese recurso.
    (object (is-a EDIFICIO_OUTPUT) (nombre_carta ?nombre_edificio) (recurso ?recurso) (cantidad_min_generada_por_unidad ?ratio_output))
    ; Existe un input para ese edificio.
    (object (is-a EDIFICIO_INPUT) (nombre_carta ?nombre_edificio)(recurso ?recurso_entrada) (cantidad_maxima ?max_input))
    ; obtener recurso input del jugador. 
    (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ?recurso_entrada) (cantidad ?cantidad_recurso_jugador))

    ; Gestión costes entrada
    ; Tiene coste de entrada.
    (object (is-a COSTE_ENTRADA_CARTA) (nombre_carta ?nombre_edificio) (tipo ?tipo) (cantidad ?))
    (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (tipo ?tipo) (recurso ?recurso_usado_pagar))
    ; Tiene que ser mayor que 0.
    (test (> ?cantidad_recurso_jugador 0))
    =>
    (bind ?cantidad_a_transformar (min (* ?max_input ?ratio_output) (* ?cantidad_recurso_jugador ?ratio_output)))
    (retract ?deseo)
    ; le generamos el deseo para ir al edificio
    (assert (deseo_entrar_edificio ?nombre_jugador ?nombre_edificio ?tipo ?recurso_usado_pagar))
    (assert (deseo_generar_con_recurso ?nombre_jugador ?nombre_edificio ?recurso_entrada ?cantidad_a_transformar))

    (printout t"El jugador: <"?nombre_jugador"> ha generado el deseo de entrar al edificio <" ?nombre_edificio "> para intentar generar el recurso <" ?recurso "> empleando como recurso de entrada: <"?cantidad_a_transformar"> unidad(es) de <"?recurso_entrada"> empleando el recurso <"?recurso_usado_pagar"> como pago de tarifa del coste de entrada." crlf)

)

; Regla 25
(defrule OBTENER_DESEO_ENTRAR_EDIFICIO_PARA_CONSEGUIR_RECURSO_SIN_INPUT_CON_COSTE_ENTRADA
    ; INPUT COSTE_ENTRADA
    ;   -        x  (monticulo arcilla, herreria, mina carbon)
    (turno ?nombre_jugador)
    ; tiene el deseo de conseguir recurso. 
    ?deseo <- (deseo_conseguir_recurso ?nombre_jugador ?recurso ?cantidad)
    ; el edificio está accesible
    (object (is-a PARTICIPANTE_TIENE_CARTA) (nombre_carta ?nombre_edificio) (nombre_jugador ?))
    (not (object (is-a JUGADOR_ESTA_EDIFICIO)(nombre_edificio ?nombre_edificio)(nombre_jugador ?)))
    ; obtener el edificio que generar el recurso objetivo.
    (object (is-a EDIFICIO_OUTPUT) (nombre_carta ?nombre_edificio) (recurso ?recurso)(cantidad_min_generada_por_unidad ?))
    ; No existe un input para ese edificio.
    (not (object (is-a EDIFICIO_INPUT) (nombre_carta ?nombre_edificio)(recurso ?otro_recurso)))
    ; Tiene coste de entrada.
    (object (is-a COSTE_ENTRADA_CARTA) (nombre_carta ?nombre_edificio) (tipo ?tipo) (cantidad ?))
    (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (tipo ?tipo) (recurso ?recurso_usado_pagar))
    =>
    (retract ?deseo)
    ; le generamos el deseo para ir al edificio
    (assert (deseo_entrar_edificio ?nombre_jugador ?nombre_edificio ?tipo ?recurso_usado_pagar))
    (printout t"El jugador: <"?nombre_jugador"> ha generado el deseo de entrar al edificio <"?nombre_edificio"> para intentar obtener el recurso: <"?recurso"> empleando el recurso <"?recurso_usado_pagar"> como pago de tarifa del coste de entrada." crlf)
)

; Regla 26
(defrule OBTENER_DESEOS_CONSTRUCCION_CARTA_PRIORIDAD_2
    ;(object (is-a JUGADOR) (nombre ?nombre_jugador))
    (turno ?nombre_jugador)
    ; solo puede ejecutarlo cuando no haya hecho su actividad principal.
    (not (fin_actividad_principal ?nombre_jugador))
    ; ejecutar cuando se hayan añadido los recursos a la oferta.
    (recursos_añadidos_loseta ?)
    ; No existe una carta disponible prioridad 1.
    (not (objetivo_prioridad_generado ?nombre_jugador 1))
    (not
        (and 
            (object (is-a CARTA_PERTENECE_A_MAZO)(id_mazo ?)(nombre_carta ?carta_prioridad)(posicion_en_mazo 1))
            (objetivo_carta_jugador ?nombre_jugador ?carta_prioridad 1)
        )
    )
    ; no se ha instanciado un objetivo de prioridad 2 --> evita que lance objetivos sin concretar ninguno
    (not (objetivo_prioridad_generado ?nombre_jugador 2))

    ; exite objetivo prioridad 2
    (objetivo_carta_jugador ?nombre_jugador ?nombre_carta 2)
    ; la carta está accesible para ser construida.
    (object (is-a CARTA) (nombre ?nombre_carta))
    (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?) (nombre_carta ?nombre_carta) (posicion_en_mazo 1))
    ; obtener recursos del jugador.
    ?madera_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso MADERA) (cantidad ?cantidad_madera))
    ?arcilla_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ARCILLA) (cantidad ?cantidad_arcilla))
    ?hierro_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso HIERRO) (cantidad ?cantidad_hierro))
    ?ladrillos_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso LADRILLOS) (cantidad ?cantidad_ladrillos))
    ?acero_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ACERO) (cantidad ?cantidad_acero))
    ; comprobar que tenga los recursos necesarios para poder construir el barco.
    (object (is-a COSTE_CONSTRUCCION_CARTA) (nombre_carta ?nombre_carta) (cantidad_madera ?coste_madera) (cantidad_arcilla ?coste_arcilla) (cantidad_ladrillo ?coste_ladrillo) (cantidad_hierro ?coste_hierro ) (cantidad_acero ?coste_acero))
    ; tiene recursos necesarios.
    (test (>= ?cantidad_madera ?coste_madera))
    (test (>= ?cantidad_arcilla ?coste_arcilla))
    (test (>= ?cantidad_hierro ?coste_hierro))
    (test (>= ?cantidad_ladrillos ?coste_ladrillo))
    (test (>= ?cantidad_acero ?coste_acero))
    =>
    (assert (deseo_construccion ?nombre_jugador ?nombre_carta))
    (assert (objetivo_prioridad_generado ?nombre_jugador 2))
    (printout t"El jugador con nombre: <" ?nombre_jugador "> ha generado el deseo de construcción para la carta: <" ?nombre_carta "> con prioridad: <2>." crlf) 
)

; Regla 27
(defrule OBTENER_RECURSOS_PARA_CONSTRUIR_PRIORIDAD_2
    (turno ?nombre_jugador)
    ; solo puede ejecutarlo cuando no haya hecho su actividad principal.
    (not (fin_actividad_principal ?nombre_jugador))
    ; ejecutar cuando se hayan añadido los recursos a la oferta.
    (recursos_añadidos_loseta ?)
    ; no se ha instanciado un objetivo de prioridad 1
    (not (objetivo_prioridad_generado ?nombre_jugador 1))
    (not
        (and 
            (object (is-a CARTA_PERTENECE_A_MAZO)(id_mazo ?)(nombre_carta ?carta_prioridad)(posicion_en_mazo 1))
            (objetivo_carta_jugador ?nombre_jugador ?carta_prioridad 1)
        )
    )
    ; no se ha instanciado un objetivo de prioridad 2 --> evita que lance objetivos sin concretar ninguno
    (not (objetivo_prioridad_generado ?nombre_jugador 2))
    ; exite objetivo prioridad 2
    (objetivo_carta_jugador ?nombre_jugador ?nombre_carta 2)
    ; la carta está accesible para ser construida.
    (object (is-a CARTA) (nombre ?nombre_carta))
    (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?) (nombre_carta ?nombre_carta) (posicion_en_mazo 1))
    ; obtener recursos del jugador.
    ?madera_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso MADERA) (cantidad ?cantidad_madera))
    ?arcilla_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ARCILLA) (cantidad ?cantidad_arcilla))
    ?hierro_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso HIERRO) (cantidad ?cantidad_hierro))
    ?ladrillos_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso LADRILLOS) (cantidad ?cantidad_ladrillos))
    ?acero_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ACERO) (cantidad ?cantidad_acero))
    ; comprobar que NO tenga los recursos necesarios para poder construir el barco.
    (object (is-a COSTE_CONSTRUCCION_CARTA) (nombre_carta ?nombre_carta) (cantidad_madera ?coste_madera) (cantidad_arcilla ?coste_arcilla) (cantidad_ladrillo ?coste_ladrillo) (cantidad_hierro ?coste_hierro ) (cantidad_acero ?coste_acero))
    ; NO tiene recursos necesarios.
    (or 
        (test (< ?cantidad_madera ?coste_madera))
        (test (< ?cantidad_arcilla ?coste_arcilla))
        (test (< ?cantidad_hierro ?coste_hierro))
        (test (< ?cantidad_ladrillos ?coste_ladrillo))
        (test (< ?cantidad_acero ?coste_acero))
    )
    ; NO se haya ejecutado la regla añadiendo algún hecho recurso construccion.
    (not (recurso_construccion ?nombre_jugador ? ? ))
    =>
    ; Semáforo prioridades.
    (assert (objetivo_prioridad_generado ?nombre_jugador 2))
    (assert (recurso_construccion ?nombre_jugador MADERA (max 0 (- ?coste_madera ?cantidad_madera)) ) )
    (assert (recurso_construccion ?nombre_jugador ARCILLA (max 0 (- ?coste_arcilla ?cantidad_arcilla)) ) )
    (assert (recurso_construccion ?nombre_jugador HIERRO (max 0 (- ?coste_hierro ?cantidad_hierro)) ) )
    (assert (recurso_construccion ?nombre_jugador LADRILLOS (max 0 (- ?coste_ladrillo ?cantidad_ladrillos)) ) )
    (assert (recurso_construccion ?nombre_jugador ACERO (max 0 (- ?coste_acero ?cantidad_acero)) ) )
    (assert (contador_recurso_construccion ?nombre_jugador 5))
    (printout t"El jugador con nombre: <" ?nombre_jugador "> ha generado el deseo de obtener recursos para poder construir la carta: <" ?nombre_carta "> con prioridad: <2>." crlf) 

)

; Regla 28
(defrule OBTENER_DESEOS_CONSTRUCCION_CARTA_PRIORIDAD_3
    (object (is-a JUGADOR) (nombre ?nombre_jugador))
    (turno ?nombre_jugador)
    ; solo puede ejecutarlo cuando no haya hecho su actividad principal.
    (not (fin_actividad_principal ?nombre_jugador))
    ; ejecutar cuando se hayan añadido los recursos a la oferta.
    (recursos_añadidos_loseta ?)
    ; no se ha instanciado un objetivo ni de prioridad 1 ni 2
    ; No existe una carta disponible prioridad 1.
    (not (objetivo_prioridad_generado ?nombre_jugador 1))
    ; No existe una carta disponible prioridad 2.
    (not (objetivo_prioridad_generado ?nombre_jugador 2))
    ; no se ha instanciado un objetivo de prioridad 3 --> evita que lance objetivos sin concretar ninguno
    (not (objetivo_prioridad_generado ?nombre_jugador 3))
    ; ni tampoco cartas de prioridad 1,2 en los mazos accesibles.
    (not
        (and 
            (object (is-a CARTA_PERTENECE_A_MAZO)(id_mazo ?)(nombre_carta ?carta_prioridad1)(posicion_en_mazo 1))
            (objetivo_carta_jugador ?nombre_jugador ?carta_prioridad1 1)
        )
    )
    (not 
        (and 
            (object (is-a CARTA_PERTENECE_A_MAZO)(id_mazo ?)(nombre_carta ?carta_prioridad2)(posicion_en_mazo 1))
            (objetivo_carta_jugador ?nombre_jugador ?carta_prioridad2 2)
        )
    )
    
    ; exite objetivo prioridad 3
    (objetivo_carta_jugador ?nombre_jugador ?nombre_carta 3)

    ; la carta está accesible para ser construida.
    (object (is-a CARTA) (nombre ?nombre_carta))
    (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?) (nombre_carta ?nombre_carta) (posicion_en_mazo 1))

    ; obtener recursos del jugador.
    ?madera_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso MADERA) (cantidad ?cantidad_madera))
    ?arcilla_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ARCILLA) (cantidad ?cantidad_arcilla))
    ?hierro_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso HIERRO) (cantidad ?cantidad_hierro))
    ?ladrillos_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso LADRILLOS) (cantidad ?cantidad_ladrillos))
    ?acero_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ACERO) (cantidad ?cantidad_acero))
    
    ; comprobar que tenga los recursos necesarios para poder construir el barco.
    (object (is-a COSTE_CONSTRUCCION_CARTA) (nombre_carta ?nombre_carta) (cantidad_madera ?coste_madera) (cantidad_arcilla ?coste_arcilla) (cantidad_ladrillo ?coste_ladrillo) (cantidad_hierro ?coste_hierro ) (cantidad_acero ?coste_acero))

    ; tiene recursos necesarios.
    (test (>= ?cantidad_madera ?coste_madera))
    (test (>= ?cantidad_arcilla ?coste_arcilla))
    (test (>= ?cantidad_hierro ?coste_hierro))
    (test (>= ?cantidad_ladrillos ?coste_ladrillo))
    (test (>= ?cantidad_acero ?coste_acero))
    =>
    (assert (deseo_construccion ?nombre_jugador ?nombre_carta))
    (assert (objetivo_prioridad_generado ?nombre_jugador 3))
    (printout t"El jugador con nombre: <" ?nombre_jugador "> ha generado el deseo de construcción para la carta: <" ?nombre_carta "> con prioridad: <3>." crlf) 
)

; Regla 29
(defrule OBTENER_RECURSOS_PARA_CONSTRUIR_PRIORIDAD_3
    (object (is-a JUGADOR) (nombre ?nombre_jugador))
    (turno ?nombre_jugador)
    ; solo puede ejecutarlo cuando no haya hecho su actividad principal.
    (not (fin_actividad_principal ?nombre_jugador))
    ; ejecutar cuando se hayan añadido los recursos a la oferta.
    (recursos_añadidos_loseta ?)
    ; no se ha instanciado un objetivo ni de prioridad 1 ni 2
    (not (objetivo_prioridad_generado ?nombre_jugador 2))
    (not (objetivo_prioridad_generado ?nombre_jugador 1))
    (not
        (and 
            (object (is-a CARTA_PERTENECE_A_MAZO)(id_mazo ?)(nombre_carta ?carta_prioridad1)(posicion_en_mazo 1))
            (objetivo_carta_jugador ?nombre_jugador ?carta_prioridad1 1)
        )
    )
    (not 
        (and 
            (object (is-a CARTA_PERTENECE_A_MAZO)(id_mazo ?)(nombre_carta ?carta_prioridad2)(posicion_en_mazo 1))
            (objetivo_carta_jugador ?nombre_jugador ?carta_prioridad2 2)
        )
    )
    ; no se ha instanciado un objetivo de prioridad 3 --> evita que lance objetivos sin concretar ninguno
    (not (objetivo_prioridad_generado ?nombre_jugador 3))
    ; exite objetivo prioridad 3
    (objetivo_carta_jugador ?nombre_jugador ?nombre_carta 3)
    ; la carta está accesible para ser construida.
    (object (is-a CARTA) (nombre ?nombre_carta))
    (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?) (nombre_carta ?nombre_carta) (posicion_en_mazo 1))
    ; obtener recursos del jugador.
    ?madera_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso MADERA) (cantidad ?cantidad_madera))
    ?arcilla_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ARCILLA) (cantidad ?cantidad_arcilla))
    ?hierro_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso HIERRO) (cantidad ?cantidad_hierro))
    ?ladrillos_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso LADRILLOS) (cantidad ?cantidad_ladrillos))
    ?acero_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ACERO) (cantidad ?cantidad_acero))
    ; comprobar que NO tenga los recursos necesarios para poder construir el barco.
    (object (is-a COSTE_CONSTRUCCION_CARTA) (nombre_carta ?nombre_carta) (cantidad_madera ?coste_madera) (cantidad_arcilla ?coste_arcilla) (cantidad_ladrillo ?coste_ladrillo) (cantidad_hierro ?coste_hierro ) (cantidad_acero ?coste_acero))
    ; NO tiene recursos necesarios.
    (or 
        (test (< ?cantidad_madera ?coste_madera))
        (test (< ?cantidad_arcilla ?coste_arcilla))
        (test (< ?cantidad_hierro ?coste_hierro))
        (test (< ?cantidad_ladrillos ?coste_ladrillo))
        (test (< ?cantidad_acero ?coste_acero))
    )
    ; NO se haya ejecutado la regla añadiendo algún hecho recurso construccion.
    (not (recurso_construccion ?nombre_jugador ? ? ))
    =>
    ; Semáforo prioridades.
    (assert (objetivo_prioridad_generado ?nombre_jugador 3))
    (assert (recurso_construccion ?nombre_jugador MADERA (max 0 (- ?coste_madera ?cantidad_madera)) ) )
    (assert (recurso_construccion ?nombre_jugador ARCILLA (max 0 (- ?coste_arcilla ?cantidad_arcilla)) ) )
    (assert (recurso_construccion ?nombre_jugador HIERRO (max 0 (- ?coste_hierro ?cantidad_hierro)) ) )
    (assert (recurso_construccion ?nombre_jugador LADRILLOS (max 0 (- ?coste_ladrillo ?cantidad_ladrillos)) ) )
    (assert (recurso_construccion ?nombre_jugador ACERO (max 0 (- ?coste_acero ?cantidad_acero)) ) )
    (assert (contador_recurso_construccion ?nombre_jugador 5))
    (printout t"El jugador con nombre: <" ?nombre_jugador "> ha generado el deseo de obtener recursos para poder construir la carta: <" ?nombre_carta "> con prioridad: <3>." crlf) 
)

; TODO: pulir y dar prioridad a esto.
; Regla 30
(defrule OBTENER_DESEO_ENTRAR_EDIFICIO_CONSTRUCTOR_SIN_COSTE_ENTRADA
    (not (proceso_limpieza_activo ?nombre_jugador))
    ; obtener jugador y que sea su turno.
    (object (is-a JUGADOR) (nombre ?nombre_jugador))
    (turno ?nombre_jugador)
    ; se ha generado el deseo de construcción de un edificio.
    (deseo_construccion ?nombre_jugador ?)
    ; Comprobar que no haya jugadores en ese edificio.
    (object (is-a PARTICIPANTE_TIENE_CARTA) (nombre_carta "CONSTRUCTORA1") (nombre_jugador ?))
    (not (object (is-a JUGADOR_ESTA_EDIFICIO) (nombre_edificio "CONSTRUCTORA1")(nombre_jugador ?)))
    =>
    (assert (deseo_entrar_edificio ?nombre_jugador "CONSTRUCTORA1"))
    (printout t"El jugador: <"?nombre_jugador"> ha generado el deseo de entrar a la constructora SIN coste de entrada: <CONSTRUCTORA1>." crlf)
)

; Regla 31
(defrule OBTENER_DESEO_ENTRAR_EDIFICIO_CONSTRUCTOR_COSTE_ENTRADA
    (not (proceso_limpieza_activo ?nombre_jugador))
    ; obtener jugador y que sea su turno.
    (object (is-a JUGADOR) (nombre ?nombre_jugador))
    (turno ?nombre_jugador)
    ; se ha generado el deseo de construcción de un edificio.
    (deseo_construccion ?nombre_jugador ?)
    ; Se ha generado el deseo de pagar las entradas a un edificio
    (decision_pago_comida_entrar_edificios ?nombre_jugador ?recurso)
    ; obtener recurso del jugador
    (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ?recurso) (cantidad ?cantidad_recurso_jugador))
    ; obtener edificio constructor.
    (object (is-a CARTA) (nombre ?nombre_carta))
    (object (is-a COSTE_ENTRADA_CARTA) (nombre_carta ?nombre_carta) (tipo COMIDA) (cantidad ?coste_entrada))
     ; el edificio está accesible
    (object (is-a PARTICIPANTE_TIENE_CARTA) (nombre_carta ?nombre_carta) (nombre_jugador ?))
    (not (object (is-a JUGADOR_ESTA_EDIFICIO)(nombre_edificio ?nombre_carta)(nombre_jugador ?)))
    ; tiene que pertenecer a algún participante, no puede estar en el mazo. 
    (object (is-a PARTICIPANTE_TIENE_CARTA) (nombre_jugador ? ) (nombre_carta ?nombre_carta))
    ; tiene que ser un edificio constructor. 
    (or 
        (test (eq ?nombre_carta "CONSTRUCTORA2"))
        (test (eq ?nombre_carta "CONSTRUCTORA3"))
    )
    ; no se haya generado ya el deseo.
    (not (deseo_entrar_edificio ?nombre_jugador ?nombre_carta))
    ; comprobar que tenga suficiente cantidad.
    (test (>= ?cantidad_recurso_jugador ?coste_entrada))
    =>
    (assert (deseo_entrar_edificio ?nombre_jugador ?nombre_carta COMIDA ?recurso))
    (printout t"El jugador: <"?nombre_jugador"> ha generado el deseo de entrar a la constructora CON coste de entrada: <"?nombre_carta"> empleando el recurso: <"?recurso"> como pago de la tarifa de entrada." crlf)

)

; Regla 33
(defrule GENERAR_PAGOS_INDIVIDUALES
    ; obtener hecho sobre demanda de comida. 
    ?contador <- (contador_comida_demandada ?nombre_jugador ?nombre_ronda_actual ?cantidad_pendiente)
    ; obtener recurso preferente.
    (object (is-a RECURSO_ALIMENTICIO) (nombre ?recurso) (comida_genera ?ratio))
    (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ?recurso) (cantidad ?cantidad_recurso))
    ; evitar ejecutar bucle mismo recurso.
    (not (deseo_pago_ind ?recurso ?))
    (test (> ?cantidad_pendiente 0))
    (test (<> (mod (min (* ?cantidad_recurso ?ratio) ?cantidad_pendiente) ?ratio) 0))
    =>
    (bind ?cantidad (min (* ?cantidad_recurso ?ratio) ?cantidad_pendiente))
    (bind ?cantidad_optima (integer (+ (/ ?cantidad ?ratio) (- 1 (/ (mod ?cantidad ?ratio) ?ratio))))) ;redondea por exceso

    (retract ?contador)
    (assert (contador_comida_demandada ?nombre_jugador ?nombre_ronda_actual (- ?cantidad_pendiente ?cantidad)))
    (assert (deseo_pago_ind ?recurso ?cantidad_optima))
    (printout t"El jugador: <"?nombre_jugador"> ha generado el deseo individual de pagar la demanda de comida con: <"?cantidad_optima"> de <"?recurso">." crlf)
)

; Regla 34
(defrule GENERAR_PAGOS_INDIVIDUALES_PROBLEMAS_MODULO_0
    ; obtener hecho sobre demanda de comida. 
    ?contador <- (contador_comida_demandada ?nombre_jugador ?nombre_ronda_actual ?cantidad_pendiente)
    ; obtener recurso preferente.
    (object (is-a RECURSO_ALIMENTICIO) (nombre ?recurso) (comida_genera ?ratio))
    (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ?recurso) (cantidad ?cantidad_recurso))
    ; evitar ejecutar bucle mismo recurso.
    (not (deseo_pago_ind ?recurso ?))
    (test (> ?cantidad_pendiente 0))
    ; cuando la cantidad de recurso es 0, no se ha podido hacer una expresión matemática que obtenga el ceil por como está hecho CLIPS.
    (test (= (mod (min (* ?cantidad_recurso ?ratio) ?cantidad_pendiente) ?ratio) 0))
    =>
    (bind ?cantidad (min (* ?cantidad_recurso ?ratio) ?cantidad_pendiente))
    (bind ?cantidad_optima (integer (/ ?cantidad ?ratio)))
    (retract ?contador)
    (assert (contador_comida_demandada ?nombre_jugador ?nombre_ronda_actual (- ?cantidad_pendiente ?cantidad)))
    (assert (deseo_pago_ind ?recurso ?cantidad_optima))
    (printout t"El jugador: <"?nombre_jugador"> ha generado el deseo individual de pagar la demanda de comida con: <"?cantidad_optima"> de <"?recurso">." crlf)
)

; Regla 35
(defrule GENERAR_PAGOS_INDIVIDUALES_CUANDO_CONTADOR_YA_ES_0
    ; rellenar automáticamente los valores que falten.
    ?contador <- (contador_comida_demandada ?nombre_jugador ?nombre_ronda_actual 0)
    ; obtener recurso preferente.
    (object (is-a RECURSO_ALIMENTICIO) (nombre ?recurso) (comida_genera ?ratio))
    (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ?recurso) (cantidad ?cantidad_recurso))
    ; no exite
    (not (deseo_pago_ind ?recurso ?))
    =>
    (assert (deseo_pago_ind ?recurso 0))
    (printout t"El jugador: <"?nombre_jugador"> ha generado el deseo individual de pagar la demanda de comida con: <0> de <"?recurso">." crlf)
)

; Regla 36
(defrule GENERAR_PAGO_INDIVIDUAL_FRANCOS
    ; no exista ningun recurso de comida del jugador mayor que 0.
    ; asi se utilizará de última instancia. 
    (deseo_pago_ind PESCADO ?)
    (deseo_pago_ind PESCADO_AHUMADO ?)
    (deseo_pago_ind CARNE ?)
    (deseo_pago_ind PAN ?)
    ?contador <- (contador_comida_demandada ?nombre_jugador ?nombre_ronda_actual ?cantidad_pendiente)
    (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso FRANCO) (cantidad ?cantidad_recurso))
    (not (deseo_pago_ind FRANCO ?))
    =>
    (bind ?cantidad (min ?cantidad_recurso ?cantidad_pendiente))
    (assert (deseo_pago_ind FRANCO ?cantidad))
    (retract ?contador)
    (assert (contador_comida_demandada ?nombre_jugador ?nombre_ronda_actual (- ?cantidad_pendiente ?cantidad)))
    (printout t"El jugador: <"?nombre_jugador"> ha generado el deseo individual de pagar la demanda de comida con: <" ?cantidad "> de <FRANCO>. Último deseo, es costoso para el jugador emplear su liquidez." crlf)
)

; Regla 37
(defrule RELLENO_DESEO_PAGAR_DEMANDA
    ; obtener contador
    ?contador <- (contador_comida_demandada ?nombre_jugador ? ?)
    ; obtener pagos individuales.
    ?deseo_pescado <- (deseo_pago_ind PESCADO ?cantidad_pescado)
    ?deseo_pescado_ahumado <- (deseo_pago_ind PESCADO_AHUMADO ?cantidad_pescado_ahumado)
    ?deseo_pan <- (deseo_pago_ind PAN ?cantidad_pan)
    ?deseo_carne <- (deseo_pago_ind CARNE ?cantidad_carne)
    ?deseo_franco <- (deseo_pago_ind FRANCO ?cantidad_franco)
    =>
    (retract ?contador)
    (retract ?deseo_pescado)
    (retract ?deseo_pescado_ahumado)
    (retract ?deseo_pan)
    (retract ?deseo_carne)
    (retract ?deseo_franco)
    (assert (deseo_pagar_demanda ?nombre_jugador ?cantidad_pescado ?cantidad_pescado_ahumado ?cantidad_pan ?cantidad_carne ?cantidad_franco))
    (printout t"El jugador: <"?nombre_jugador"> ha generado el derecho de pagar demanda." crlf)
)

; MANTENER DERECHO A COSECHA
; Regla 38
(defrule MANTENER_DERECHO_COSECHA_GANADO 
    (turno ?nombre_jugador)
    ; solo puede ejecutarlo cuando no haya hecho su actividad principal.
    (not (fin_actividad_principal ?nombre_jugador))
    ; ejecutar cuando se hayan añadido los recursos a la oferta.
    (recursos_añadidos_loseta ?)
    ; Ejecutar solo si no puedes acceder a ningún edificio.  (se habrá borrado el deseo contrucción generado ó no existirá) 
    (not (deseo_construccion ?nombre_jugador ?))
    ;(objetivo_prioridad_generado ?nombre_jugador ?)
    (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador)(recurso GANADO)(cantidad ?cantidad_recurso))
    (test (< ?cantidad_recurso 2))
    (OFERTA_RECURSO (recurso GANADO)(cantidad ?cantidad_oferta))
    (test (> ?cantidad_oferta 1)) ; de esta manera, 2 vacas que coges + 1 de la cosecha son 3, que es el requisito para la generación de deseos de coger recursos de la oferta

    =>
    (assert (deseo_coger_recurso ?nombre_jugador GANADO))
    (printout t "El jugador: <"?nombre_jugador"> ha generado el deseo de coger GANADO para mantener su derecho de COSECHA." crlf)
)

; Regla 39
(defrule MANTENER_DERECHO_COSECHA_GRANO
    (turno ?nombre_jugador)
    ; solo puede ejecutarlo cuando no haya hecho su actividad principal.
    (not (fin_actividad_principal ?nombre_jugador))
    ; ejecutar cuando se hayan añadido los recursos a la oferta.
    (recursos_añadidos_loseta ?)
    ; Ejecutar solo si no puedes acceder a ningún edificio.  (se habrá borrado el deseo contrucción generado)
    (not (deseo_construccion ?nombre_jugador ?))
    ;(objetivo_prioridad_generado ?nombre_jugador ?)
    (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador)(recurso GRANO)(cantidad ?cantidad_recurso))
    (test (< ?cantidad_recurso 1))
    (OFERTA_RECURSO (recurso GRANO)(cantidad ?cantidad_oferta))
    (test (> ?cantidad_oferta 1)) ; de esta manera, 2 vacas que coges + 1 de la cosecha son 3, que es el requisito para la generación de deseos de coger recursos de la oferta
    =>
    (assert (deseo_coger_recurso ?nombre_jugador GRANO))
    (printout t "El jugador: <"?nombre_jugador"> ha generado el deseo de coger GRANO para mantener su derecho de COSECHA." crlf)
)

; para el montículo => se podría hacer que comprasen cualquier carta pero no nos interesará
; la liquidez preferible por si se tuviesen que endeudar...
; Regla 40
(defrule OBTENER_DESEO_COMPRAR_CARTA_NO_PUEDE_SER_CONSTRUIDA
    ; caso montículo de arcilla...
    (object (is-a JUGADOR) (nombre ?nombre_jugador))
    (turno ?nombre_jugador)
    ; solo puede ejecutarlo cuando haya hecho su actividad principal.
    (and
        (not (fin_actividad_principal ?nombre_jugador))
        (not (permitir_realizar_accion ?nombre_jugador))
    )
    ; ejecutar cuando se hayan añadido los recursos a la oferta.
    (recursos_añadidos_loseta ?)
    ; Cualquier prioridad de la carta pero que esta no pueda ser construida con materiales.
    (objetivo_carta_jugador ?nombre_jugador ?nombre_carta ?)
    ; Obtiene el coste de comprar el edificio
    (object (is-a CARTA) (nombre ?nombre_carta) (tipo ?) (valor ?valor_carta))
    ; NO TIENE BONUS y está encima de la pila de cartas.
    (not (object (is-a CARTA_TIENE_BONUS)(nombre_carta ?nombre_carta)(bonus ?)))
    (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?) (nombre_carta ?nombre_carta) (posicion_en_mazo 1))
    (not (object (is-a COSTE_CONSTRUCCION_CARTA) (nombre_carta ?nombre_carta)))
    ; Obtiene el dinero del jugador
    ?recurso_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso FRANCO) (cantidad ?cantidad_recurso))
    ; El jugador tiene suficiente dinero
    (test (>= ?cantidad_recurso ?valor_carta))
    ; el edificio no es el banco
    (test (neq ?nombre_carta "BANCO"))
    =>
    (assert (deseo_comprar_edificio ?nombre_jugador ?nombre_carta))
    (printout t"El jugador :<" ?nombre_jugador "> ha decidido comprar la carta: <" ?nombre_carta "> porque no existe forma de construirla con materiales." crlf)
)

; Regla 41
(defrule GENERAR_DESEO_COGER_OFERTA_PRIORITARIO
    ; Esperar a que termine el proceso de ejecución de cambio de ronda.
    ;(not (cambiar_ronda TRUE))
    (not (ronda_actual RONDA_EXTRA_FINAL))
    (turno ?nombre_jugador)
    ; solo puede ejecutarlo cuando no haya hecho su actividad principal. 
    (and
        (not (fin_actividad_principal ?nombre_jugador))
        (not (deseo_construccion ?nombre_jugador ?))
    )
    ; ejecutar cuando se hayan añadido los recursos a la oferta.
    (recursos_añadidos_loseta ?)
    (not (deseo_coger_recurso ?nombre_jugador ?recurso))
    (OFERTA_RECURSO (recurso ?recurso) (cantidad ?cantidad_oferta))
    (test (> ?cantidad_oferta 3))
    =>
    (assert (deseo_coger_recurso ?nombre_jugador ?recurso))
    (printout t"El jugador: <"?nombre_jugador"> ha generado el deseo de coger recurso: <"?recurso"> de la oferta PRIORITARIO." crlf)
)

; Regla 42
(defrule GENERAR_DESEO_COGER_OFERTA_PRIORITARIO_NO_PRIORITARIO
    ; Esperar a que termine el proceso de ejecución de cambio de ronda.
    
    (not (ronda_actual RONDA_EXTRA_FINAL))
    (turno ?nombre_jugador)
    ; solo puede ejecutarlo cuando no haya hecho su actividad principal. 
    ;(not (fin_actividad_principal ?nombre_jugador))
    (and
        (not (fin_actividad_principal ?nombre_jugador))
        (not (deseo_construccion ?nombre_jugador ?))
    )
    ; ejecutar cuando se hayan añadido los recursos a la oferta.
    (recursos_añadidos_loseta ?)
    (not (deseo_coger_recurso ?nombre_jugador ?recurso))
    (OFERTA_RECURSO (recurso ?recurso) (cantidad ?cantidad_oferta))
    (test (> ?cantidad_oferta 0))
    (test (<= ?cantidad_oferta 3))
    =>
    (assert (deseo_coger_recurso ?nombre_jugador ?recurso))
    (printout t"El jugador: <"?nombre_jugador"> ha generado el deseo de coger recurso: <"?recurso"> de la oferta NO PRIORITARIO." crlf)
)

; ESTRATEGIA RONDA_EXTRA_FINAL
; SIEMPRE SE VA A LA COMPAÑIA NAVIERA SI ESTA ESTÁ DISPONIBLE EN EL JUEGO.
; SINO, SE COGERÁ UN RECURSO DE LA OFERTA ALEATORIO.


; comprueba que se puede emplear la compañia naviera.
; Regla 43
(defrule OBTENER_DESEO_ENTRAR_COMPAÑIA_NAVIERA_NO_EN_PROPIEDAD
    ; es la ronda extra final.
    (ronda_actual RONDA_EXTRA_FINAL)
    ; obtener referencia jugador.
    (object (is-a JUGADOR) (nombre ?nombre_jugador) (capacidad_envio ?capacidad_envio))
    ; turno del jugador.
    (turno ?nombre_jugador)
    ; comprobar que la compañia está disponible en la partida, es decir, le pertenece a algún participante de la partida.
    ; además ver si tiene recursos suficientes para entrar o no.
    (object (is-a PARTICIPANTE_TIENE_CARTA) (nombre_jugador ?otro) (nombre_carta "COMPAÑIA NAVIERA"))
    (test (neq ?otro ?nombre_jugador))
    (object (is-a COSTE_ENTRADA_CARTA) (nombre_carta "COMPAÑIA NAVIERA") (tipo COMIDA) (cantidad ?coste_entrada))
    ; obtener la preferencia de pago para entrar a los edificios.
    (decision_pago_comida_entrar_edificios ?nombre_jugador ?recurso)
    (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ?recurso) (cantidad ?cantidad_recurso_jugador))
    (object (is-a RECURSO_ALIMENTICIO) (nombre ?recurso) (comida_genera ?ratio))
    (test (>= (* ?cantidad_recurso_jugador ?ratio) ?coste_entrada))
    ; no se ha instanciado ya el deseo.
    (not (deseo_usar_compañia_naviera ?nombre_jugador ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?))
    =>
    ; obtener el deseo de entrar al edificio
    (assert (deseo_entrar_edificio ?nombre_jugador "COMPAÑIA NAVIERA" COMIDA ?recurso))
    ; generar el contador para rellenar el deseo de la compañia.
    (assert (contador_envios_compañia_naviera ?nombre_jugador ?capacidad_envio))
    ; automáticamente generar este hecho para evitar que rellene con sus propios francos.
    (assert (comerciar_en_compañia ?nombre_jugador FRANCO 0))
    ; log
    (printout t"El jugador: <" ?nombre_jugador "> ha generado el deseo de entrar a la compañia naviera." crlf)
)

; Regla 44
(defrule OBTENER_DESEO_ENTRAR_COMPAÑIA_NAVIERA_EN_PROPIEDAD
    ; es la ronda extra final.
    (ronda_actual RONDA_EXTRA_FINAL)
    ; obtener referencia jugador.
    (object (is-a JUGADOR) (nombre ?nombre_jugador) (capacidad_envio ?capacidad_envio))
    ; turno del jugador.
    (turno ?nombre_jugador)
    ; Le pertenece el edificio.
    (object (is-a PARTICIPANTE_TIENE_CARTA) (nombre_jugador ?nombre_jugador) (nombre_carta "COMPAÑIA NAVIERA"))
    ; no se ha instanciado ya el deseo.
    (not (deseo_usar_compañia_naviera ?nombre_jugador ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?))
    =>
    ; obtener el deseo de entrar al edificio
    (assert (deseo_entrar_edificio ?nombre_jugador "COMPAÑIA NAVIERA"))
    ; generar el contador para rellenar el deseo de la compañia.
    (assert (contador_envios_compañia_naviera ?nombre_jugador ?capacidad_envio))
    ; automáticamente generar este hecho para evitar que rellene con sus propios francos.
    (assert (comerciar_en_compañia ?nombre_jugador FRANCO 0))
    ; log
    (printout t"El jugador: <" ?nombre_jugador "> ha generado el deseo de entrar a la compañia naviera." crlf)
)

; Regla 45
(defrule CAMBIAR_PRIORIDAD_RELLENAR_DESEO_COMPAÑIA_NAVIERA
    ; es la ronda extra final.
    (ronda_actual RONDA_EXTRA_FINAL)
    (turno ?nombre_jugador)
    ; si están instanciados todos los de una categoría pasar a la siguiente.
    ?contador_prioridades <- (CONTADOR_COMPAÑIA_NAVIERA (nombre ?nombre_jugador) (prioridad ?prioridad))
    (comerciar_en_compañia ?nombre_jugador ?recurso ?)
    (object (is-a RECURSO) (nombre ?recurso) (valor_unitario_en_compañia_naviera ?prioridad))
    (prioridad_compañia_naviera ?prioridad ?siguiente_prioridad)
    =>
    (modify ?contador_prioridades (prioridad ?siguiente_prioridad))
    (printout t"El jugador: <"?nombre_jugador"> cambia la prioridad de los recursos de: <"?prioridad"> a <"?siguiente_prioridad"> para rellenar el deseo de la compañia naviera." crlf)
)

; Regla 46
(defrule RELLENAR_DESEO_COMPAÑIA_NAVIERA_SIN_COSTE
    ; es la ronda extra final.
    (ronda_actual RONDA_EXTRA_FINAL)
    (turno ?nombre_jugador)
    ?capacidad_envio_restante <- (contador_envios_compañia_naviera ?nombre_jugador ?capacidad_envio)
    (CONTADOR_COMPAÑIA_NAVIERA (nombre ?nombre_jugador) (prioridad ?prioridad))
    ; Obtener el recurso de la prioridad y que no haya sido generado.
    (object (is-a RECURSO) (nombre ?recurso) (valor_unitario_en_compañia_naviera ?prioridad))
    (not (comerciar_en_compañia ?nombre_jugador ?recurso ?))
    ; obtener el recurso del jugador para conseguir su cantidad
    (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ?recurso) (cantidad ?cantidad_recurso_jugador))
    =>
    (bind ?cantidad_a_comerciar (min ?cantidad_recurso_jugador ?capacidad_envio))
    (assert (comerciar_en_compañia ?nombre_jugador ?recurso ?cantidad_a_comerciar))
    ; modificar las capacidades de envio.
    (retract ?capacidad_envio_restante)
    (assert (contador_envios_compañia_naviera ?nombre_jugador (- ?capacidad_envio ?cantidad_a_comerciar)))
    (printout t"El jugador: <"?nombre_jugador"> comerciará <" ?cantidad_a_comerciar"> de <"?recurso">." crlf)
)

; Regla 47
(defrule RELLENAR_DESEO_COMPAÑIA_NAVIERA_CON_COSTE
    ; es la ronda extra final.
    (ronda_actual RONDA_EXTRA_FINAL)
    (turno ?nombre_jugador)
    ?capacidad_envio_restante <- (contador_envios_compañia_naviera ?nombre_jugador ?capacidad_envio)
    (CONTADOR_COMPAÑIA_NAVIERA (nombre ?nombre_jugador) (prioridad ?prioridad))
    ; Obtener el recurso de la prioridad y que no haya sido generado.
    (object (is-a RECURSO) (nombre ?recurso) (valor_unitario_en_compañia_naviera ?prioridad))
    (not (comerciar_en_compañia ?nombre_jugador ?recurso ?))
    ; obtener el recurso del jugador para conseguir su cantidad
    (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ?recurso) (cantidad ?cantidad_recurso_jugador))
    ; que no sea el recurso con el que va a realizar el pago de la entrada.
    (deseo_entrar_edificio ?nombre_jugador "COMPAÑIA NAVIERA" COMIDA ?otro_recurso)
    (test (neq ?recurso ?otro_recurso))
    =>
    (bind ?cantidad_a_comerciar (min ?cantidad_recurso_jugador ?capacidad_envio))
    (assert (comerciar_en_compañia ?nombre_jugador ?recurso ?cantidad_a_comerciar))
    ; modificar las capacidades de envio.
    (retract ?capacidad_envio_restante)
    (assert (contador_envios_compañia_naviera ?nombre_jugador (- ?capacidad_envio ?cantidad_a_comerciar)))
    (printout t"El jugador: <"?nombre_jugador"> comerciará <" ?cantidad_a_comerciar"> de <"?recurso">." crlf)
)

; Regla 48
(defrule BLOQUEAR_RECURSO_EMPLEADO_PARA_PAGAR_ENTRADA_COMPAÑIA_NAVIERA
    ; es la ronda extra final.
    (ronda_actual RONDA_EXTRA_FINAL)
    (deseo_entrar_edificio ?nombre_jugador "COMPAÑIA NAVIERA" COMIDA ?recurso)
    (CONTADOR_COMPAÑIA_NAVIERA (nombre ?nombre_jugador) (prioridad ?prioridad))
    (object (is-a COSTE_ENTRADA_CARTA) (nombre_carta "COMPAÑIA NAVIERA") (tipo COMIDA) (cantidad ?coste_entrada))
    (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ?recurso) (cantidad ?cantidad_recurso_jugador))
    (object (is-a RECURSO_ALIMENTICIO) (nombre ?recurso) (comida_genera ?ratio) (valor_unitario_en_compañia_naviera ?prioridad))
    ?capacidad_envio_restante <- (contador_envios_compañia_naviera ?nombre_jugador ?capacidad_envio)
    (not (comerciar_en_compañia ?nombre_jugador ?recurso ?))
    =>
    (bind ?cantidad_bloqueada (+ 1 (integer (- ?cantidad_recurso_jugador (/ ?coste_entrada ?ratio)))))
    (bind ?cantidad_comerciar (min (- ?cantidad_recurso_jugador ?cantidad_bloqueada) ?capacidad_envio))
    (assert (comerciar_en_compañia ?nombre_jugador ?recurso ?cantidad_comerciar))
    (printout t"El jugador: <"?nombre_jugador"> bloquea <"?cantidad_bloqueada"> de <"?recurso"> ya que lo necesita para satisfacer la tarifa de entrada." crlf)
    (printout t"Sin embargo, el jugador: <"?nombre_jugador"> comerciará <" ?cantidad_comerciar"> de <"?recurso">." crlf)
)

; Regla 49
(defrule RELLENAR_DESEO_COMPAÑIA_NAVIERA_PARTE_2
    ; es la ronda extra final.
    (ronda_actual RONDA_EXTRA_FINAL)
    ; obtener turnos y contadores.
    (turno ?nombre_jugador)
    ?capacidad_envio_restante <- (contador_envios_compañia_naviera ?nombre_jugador ?)
    ?contador_prioridades <- (CONTADOR_COMPAÑIA_NAVIERA (nombre ?nombre_jugador) (prioridad 1))
    ; obtener comercios óptimos => de más costoso a menos para obtener el mayor
    ; beneficio posible en la compañia naviera.
    ?comercio_pescado <- (comerciar_en_compañia ?nombre_jugador PESCADO ?pescado)
    ?comercio_madera <- (comerciar_en_compañia ?nombre_jugador MADERA ?madera)
    ?comercio_arcilla <- (comerciar_en_compañia ?nombre_jugador ARCILLA ?arcilla)
    ?comercio_hierro <- (comerciar_en_compañia ?nombre_jugador HIERRO ?hierro)
    ?comercio_grano <- (comerciar_en_compañia ?nombre_jugador GRANO ?grano)
    ?comercio_ganado <- (comerciar_en_compañia ?nombre_jugador GANADO ?ganado)
    ?comercio_carbon <- (comerciar_en_compañia ?nombre_jugador CARBON ?carbon)
    ?comercio_piel <- (comerciar_en_compañia ?nombre_jugador PIEL ?piel)
    ?comercio_pescado_ahumado <- (comerciar_en_compañia ?nombre_jugador PESCADO_AHUMADO ?pescado_ahumado)
    ?comercio_cabon_vegetal <- (comerciar_en_compañia ?nombre_jugador CARBON_VEGETAL ?carbon_vegetal)
    ?comercio_ladrillos <- (comerciar_en_compañia ?nombre_jugador LADRILLOS ?ladrillos)
    ?comercio_acero <- (comerciar_en_compañia ?nombre_jugador ACERO ?acero)
    ?comercio_pan <- (comerciar_en_compañia ?nombre_jugador PAN ?pan)
    ?comercio_carne <- (comerciar_en_compañia ?nombre_jugador CARNE ?carne)
    ?comercio_coque <- (comerciar_en_compañia ?nombre_jugador COQUE ?coque)
    ?comercio_cuero <- (comerciar_en_compañia ?nombre_jugador CUERO ?cuero)
    ?comercio_franco <- (comerciar_en_compañia ?nombre_jugador FRANCO ?franco)
    =>
    ; eliminar contadores.
    (retract ?capacidad_envio_restante)
    (retract ?contador_prioridades)
    ; eliminar hechos temporales.
    (retract ?comercio_pescado)
    (retract ?comercio_madera)
    (retract ?comercio_arcilla)
    (retract ?comercio_hierro)
    (retract ?comercio_grano)
    (retract ?comercio_ganado)
    (retract ?comercio_carbon)
    (retract ?comercio_piel)
    (retract ?comercio_pescado_ahumado)
    (retract ?comercio_cabon_vegetal)
    (retract ?comercio_ladrillos)
    (retract ?comercio_acero)
    (retract ?comercio_pan)
    (retract ?comercio_carne)
    (retract ?comercio_coque)
    (retract ?comercio_cuero)
    (retract ?comercio_franco)
    ; generar deseo.
    (assert (deseo_usar_compañia_naviera ?nombre_jugador ?pescado ?madera ?arcilla ?hierro ?grano ?ganado ?carbon ?piel ?pescado_ahumado ?carbon_vegetal ?ladrillos ?acero ?pan ?carne ?coque ?cuero))
)

; TODO: integrar esto con coger recursos de la oferta tmbn, me ha dado problemas y no consigo unificarlos con ors.
; Regla 50
(defrule GENERAR_DESEO_COGER_OFERTA_RONDA_EXTRA_FINAL
    (turno ?nombre_jugador)
    (not (proceso_limpieza_finalizado ?nombre_jugador))
    (ronda_actual RONDA_EXTRA_FINAL)     
    (not (deseo_coger_recurso ?nombre_jugador ?recurso))
    (OFERTA_RECURSO (recurso ?recurso) (cantidad ?cantidad_oferta))
    (test (> ?cantidad_oferta 0))
    (test (<= ?cantidad_oferta 3))
    =>
    (assert (deseo_coger_recurso ?nombre_jugador ?recurso))
    (printout t"DESEO GENERADO" crlf)
)

; Coste: 1      Coste: 2        Coste: 3    Coste: 4    Coste: 5      Coste: 8
; pescado       hierro          ganado      cuero       coque         acero
; madera        piel            carbon
; arcilla       pescado. Ahum.  pan
; grano         carbon vegetal.
; Franco        Ladrillo
;               carne








; For the brave souls who get this far: You are the chosen ones,
; the valiant knights of programming who toil away, without rest,
; reading our most awful code. To you, true saviors, kings of men,
; I say this: never gonna give you up, never gonna let you down,
; never gonna run around and desert you. Never gonna make you cry,
; never gonna say goodbye. Never gonna tell a lie and hurt you.
