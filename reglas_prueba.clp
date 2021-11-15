; ESTO SE ACTIVA DESPUES DE TOMAR_RECURSO_OFERTA?????? POR QUÉ
(defrule DESTAPAR_LOSETA
    ; obtener casilla y que esté oculta.
    ?casilla <- (object (is-a LOSETA) (posicion ?pos) (visibilidad FALSE))
    ; comprobar que hay un jugador en la casilla
    ?posicion_jugador <- (object (is-a JUGADOR_ESTA_EN_LOSETA) (posicion ?pos) (nombre_jugador ?))
    =>
    ; hacer casilla visible
    (modify-instance ?casilla (visibilidad TRUE))
    (printout t"=====================================================================================================" crlf)
    (printout t"La loseta con posición : <" ?pos "> queda visible. " crlf)
)


(defrule ACTUALIZAR_DISPONIBILIDAD_BARCOS
    (ronda_actual ?nombre_ronda)
    ; esto falla ¿puede ser por la herencia??
    ;?barco <- (object (is-a BARCO) (nombre ?nombre_barco)(valor ?)(tipo ?)(coste ?)(uds_comida_genera ?)(capacidad_envio ?))
    ?introduce_barco <- (object (is-a RONDA_INTRODUCE_BARCO) (nombre_ronda ?nombre_ronda) (nombre_carta ?nombre_barco))
    =>
    ; TODO: NO SABEMOS EN Q ORDEN QUEDARÍAN LOS BARCOS DISPONIBLES. problema.!!!!!!!!!!!!!!!!!
    ; creo que el orden da igual porque al final sólo se puede comprar si es la primera carta del mazo, y los mazos ya están instanciados
    (assert (BARCO_DISPONIBLE (nombre_barco ?nombre_barco)))
    (unmake-instance ?introduce_barco)
)


(defrule ACTUALIZAR_MAZO_3
	(object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id) (nombre_carta ?nombre_carta) (posicion_en_mazo ?))
	?actualizacion_sobre_carta <- (carta_actualizada ?nombre_carta ?id)
    (not (actualizar_mazo ?id))
	=>
	(retract ?actualizacion_sobre_carta)
	(printout t"actualizando mazo..." crlf)
)

(defrule ACTUALIZAR_MAZO_1
	?carta_mazo1 <- (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id) (nombre_carta ?nombre_carta1) (posicion_en_mazo ?pos1))
	(test (> ?pos1 2))
	(actualizar_mazo ?id)
    (not (carta_actualizada ?nombre_carta1 ?id))
    =>
    (modify-instance ?carta_mazo1(posicion_en_mazo (- ?pos1 1)))
	(assert (carta_actualizada ?nombre_carta1 ?id))
    (printout t"El mazo <" ?id "> ha actualizado la posición de la carta <" ?nombre_carta1 ">, ahora se encuentra en la posción <" (- ?pos1 1) ">." crlf)
)


(defrule ACTUALIZAR_MAZO_2
	?carta_mazo <- (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id) (nombre_carta ?nombre_carta) (posicion_en_mazo ?pos))
	(test (> ?pos 1))
	?actualizar <- (actualizar_mazo ?id)
	(not (carta_actualizada ?nombre_carta ?id))
	=>
	(modify-instance ?carta_mazo (posicion_en_mazo (- ?pos 1)))
	(retract ?actualizar)
	(printout t"El mazo <" ?id "> ha actualizado la posición de la carta <" ?nombre_carta ">, ahora se encuentra en la posción <" (- ?pos 1) ">." crlf)
)

(defrule COMPRAR_EDIFICIO_AL_AYUNTO
    ; Se puede comprar en la ronda actual. [en todas las rondas excepto la última.]
    (ronda_actual ?nombre_ronda)
    (test (neq ?nombre_ronda RONDA_EXTRA_FINAL))
    ; Obtener el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; Obtener el edificio del deseo
    ?deseo <- (deseo_comprar_edificio ?nombre_jugador ?nombre_edificio)
    ; Ha finalizado su actividad principal dentro de su turno.
    (fin_actividad_principal ?nombre_jugador)
    ; El edificio es del ayuntamiento
    ?ayunto <- (EDIFICIO_AYUNTAMIENTO (nombre_edificio ?nombre_edificio))
    ; Obtiene el coste de comprar el edificio
    (object (is-a CARTA) (nombre ?nombre_edificio) (valor ?valor_edificio))
    ; Obtiene el dinero del jugador
    ?recurso_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso FRANCO) (cantidad ?cantidad_recurso))
    ; El jugador tiene suficiente dinero
    (test (>= ?cantidad_recurso ?valor_edificio))
    =>
    ; Modificar el dinero del jugador
    (modify-instance ?recurso_jugador (cantidad (- ?cantidad_recurso ?valor_edificio)))
    ; Quitar el edificio al ayuntamiento
    (retract ?ayunto)
    ; Asignar el edificio al jugador
    (make-instance of JUGADOR_TIENE_CARTA (nombre_jugador ?nombre_jugador) (nombre_carta ?nombre_edificio))
    ; Eliminar el deseo de comprar el edificio
    (retract ?deseo)
    (printout t"El jugador: <" ?nombre_jugador "> ha comprado el edificio: <" ?nombre_edificio "> por <" ?valor_edificio "> francos al ayuntamiento." crlf)
)

;   4-. Comprar barco
(defrule COMPRAR_BARCO
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
    (object (is-a BARCO) (nombre ?nombre_barco) (coste ?coste_barco) (valor ?)(uds_comida_genera ?uds_comida_genera)(capacidad_envio ?capacidad_envio_barco))
    ; Obtiene el dinero del jugador
    ?recurso_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso FRANCO) (cantidad ?cantidad_recurso))
    ; El jugador tiene suficiente dinero
    (test (>= ?cantidad_recurso ?coste_barco))
    ; se obtiene al jugador
    ?jugador <- (object (is-a JUGADOR)(nombre ?nombre_jugador)(num_barcos ?num_barcos)(capacidad_envio ?capacidad_envio_jugador)(demanda_comida_cubierta ?demanda_comida_cubierta))
    =>
    ; Modificar el dinero del jugador
    (modify-instance ?recurso_jugador (cantidad (- ?cantidad_recurso ?coste_barco)))
    ; Quitar la carta del mazo
    (unmake-instance ?barco_en_mazo)
    ; Asignar el barco al jugador
    (make-instance of JUGADOR_TIENE_CARTA (nombre_jugador ?nombre_jugador) (nombre_carta ?nombre_barco))
    ; Actualiza los valores relacionados con el barco en el jugador
    (modify-instance ?jugador (num_barcos (+ ?num_barcos 1)) (capacidad_envio (+ ?capacidad_envio_jugador ?capacidad_envio_barco)) (demanda_comida_cubierta (+ ?demanda_comida_cubierta ?uds_comida_genera)))
    ; Eliminar el deseo de comprar el barco
    (retract ?deseo)
    ; Quitar el barco de disponibles
    (retract ?disponible)
    ; Generar hecho semáforo para actualizar el orden de las cartas del mazo
    (assert (actualizar_mazo ?id_mazo))
)

(defrule COMPRAR_EDIFICIO_AL_MAZO
    ; Se puede comprar en la ronda actual. [en todas las rondas excepto la última.]
    (ronda_actual ?nombre_ronda)
    (test (neq ?nombre_ronda RONDA_EXTRA_FINAL))
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
    ; Obtiene el dinero del jugador
    ?recurso_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso FRANCO) (cantidad ?cantidad_recurso))
    ; El jugador tiene suficiente dinero
    (test (>= ?cantidad_recurso ?valor_edificio))
    =>
    ; Modificar el dinero del jugador
    (modify-instance ?recurso_jugador (cantidad (- ?cantidad_recurso ?valor_edificio)))
    ; Quitar la carta del mazo y mover todas las cartas 1 posición
    (unmake-instance ?carta_en_mazo)
    ; Asignar el edificio al jugador
    (make-instance of JUGADOR_TIENE_CARTA (nombre_jugador ?nombre_jugador) (nombre_carta ?nombre_edificio))
    ; Eliminar el deseo de comprar el edificio
    (retract ?deseo)
    ; Generar hecho semáforo para actualizar el orden de las cartas del mazo
    (assert (actualizar_mazo ?id_mazo))
    (printout t"El jugador: <" ?nombre_jugador "> ha comprado el edificio: <" ?nombre_edificio "> por <" ?valor_edificio "> francos al mazo." crlf)
)

(defrule VENDER_CARTA
    ; No existe precondición de ronda! 
    ; Existe un deseo de vender un edificio
    ?deseo <- (deseo_vender_carta ?nombre_jugador ?nombre_carta)
    ; Ha finalizado su actividad principal dentro de su turno.
    (fin_actividad_principal ?nombre_jugador)
    ; Es el turno del jugador
    (turno ?nombre_jugador)
    ; El jugador tiene la carta. 
    ?edificio_jugador <- (object (is-a JUGADOR_TIENE_CARTA) (nombre_jugador ?nombre_jugador)(nombre_carta ?nombre_carta))
    ; referencia de la carta para obtener su valor. 
    ?carta <- (object (is-a CARTA) (nombre ?nombre_carta) (valor ?valor_carta))
    ; referencia del recurso del jugador.
    ?recurso_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso FRANCO) (cantidad ?cantidad_recurso))
    =>
    ; obtener el beneficio de la venta de la carta.
    (bind ?ingreso (/ ?valor_carta 2))
    ; Modificar el dinero del jugador
    (modify-instance ?recurso_jugador (cantidad (+ ?cantidad_recurso ?ingreso)))
    ; Asignar edificio al ayuntamiento
    (assert (EDIFICIO_AYUNTAMIENTO (nombre_edificio ?nombre_carta)))
    ; Quitarle el edificio al jugador
    (unmake-instance ?edificio_jugador)
    ; quitar el deseo.
    (retract ?deseo)
    ; print final
    (printout t"El jugador: <" ?nombre_jugador "> ha vendido el edificio: <" ?nombre_carta "> por <" ?ingreso "> francos." crlf)
)

(defrule VENDER_BARCO
    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; Existe el deseo de vender el barco
    ?deseo <- (deseo_vender_barco ?nombre_jugador ?nombre_barco)
    ; Ha finalizado su actividad principal dentro de su turno.
    (fin_actividad_principal ?nombre_jugador)
    ; El barco es del jugador
    ?jugador_tiene_barco <- (object (is-a JUGADOR_TIENE_CARTA) (nombre_jugador ?nombre_jugador)(nombre_carta ?nombre_barco))
    ; Obtiene el valor del barco
    ?barco <- (object (is-a BARCO)(coste ?coste_barco)(valor ?valor_barco)(uds_comida_genera ?uds_comida_genera)(capacidad_envio ?capacidad_envio_barco))
    ; Obtiene el dinero del jugador
    ?recurso_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso FRANCO) (cantidad ?cantidad_recurso))
    ; se obtiene al jugador
    ?jugador <- (object (is-a JUGADOR)(nombre ?nombre_jugador)(num_barcos ?num_barcos)(capacidad_envio ?capacidad_envio_jugador)(demanda_comida_cubierta ?demanda_comida_cubierta))
    =>
    ; Elimina el barco del jugador
    (unmake-instance ?jugador_tiene_barco)
    ; Actualiza los valores relacionados con el barco en el jugador
    (modify-instance ?jugador (num_barcos (- ?num_barcos 1)) (capacidad_envio (- ?capacidad_envio_jugador ?capacidad_envio_barco)) (demanda_comida_cubierta (- ?demanda_comida_cubierta ?uds_comida_genera)))
    ; Actualiza el dinero del jugador
    (modify-instance ?recurso_jugador (cantidad (+ ?cantidad_recurso (/ ?valor_barco 2))))
    ; Elimina el deseo
    (retract ?deseo)
)

;(defrule PAGAR_DEUDA
    ; obtiene las deudas del jugador
   ; ?jugador <- (object (is-a JUGADOR)(nombre_jugador ?nombre)(deudas ?deudas))
    ; deseo de pagar deudas
    ; todo: el jugador en una regla estratégica deberá comprobar cuanta deuda quiere pagar.
    ;?deseo <- (DESEO_PAGAR_DEUDA ?nombre ?cantidad_deuda)
    ; Obtener los francos del jugador
    ;?jugador_dinero <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre)(recurso FRANCO) (cantidad ?cantidad_francos))
    ;(bind cantidad_a_pagar (min (* 5 ?deudas) ?cantidad_deuda)
    ;=>
    ;(modify-instance ?jugador_dinero (cantidad (?cantidad_francos ?cantidad_deuda)))
    ;()
;)


(defrule PASAR_TURNO_Y_RONDA
    ; para cambiar de ronda se tiene que dar la siguiente situación
    ;1| |1| |1|2|1|   y turno de 2
    ;0|1|2|3|4|5|6|0
    ?jugador1 <- (object (is-a JUGADOR) (nombre ?nombre_jugador1))
    ?posicion_jugador1 <- (object (is-a JUGADOR_ESTA_EN_LOSETA) (posicion ?pos_jugador1) (nombre_jugador ?nombre_jugador1))
    ?jugador2 <- (object (is-a JUGADOR) (nombre ?nombre_jugador2))
    ?posicion_jugador2 <- (object (is-a JUGADOR_ESTA_EN_LOSETA) (posicion ?pos_jugador2) (nombre_jugador ?nombre_jugador2))
    (test (eq ?pos_jugador1 6))
    (test (eq ?pos_jugador2 5))
    (test (neq ?jugador1 ?jugador2))
    
    ; Ha finalizado su actividad principal dentro de su turno.
    ?turno_finalizado <- (fin_actividad_principal ?nombre_jugador1)
    ?turno_j1 <- (turno ?nombre_jugador1)
    ; selección de siguiente ronda
    ?ronda_actual <- (ronda_actual ?nombre_ronda_actual)
    ?ronda_siguiente <- (object (is-a RONDA) (nombre_ronda ?nombre_ronda_siguiente))
    (siguiente_ronda ?nombre_ronda_actual ?nombre_ronda_siguiente)
    ; eliminar el semaforo de la restriccion de añadir recurso a la oferta.
    ?semaforo <- (recursos_añadidos_loseta ?)
    =>
    (bind ?nueva_posicion (+ ?pos_jugador2 2))
    ; deshace el hecho semaforo del turno.
    (retract ?turno_finalizado)
    ; eliminar turno jugador 1
    (retract ?turno_j1)
    ; generar hecho turno j2.
    (assert (turno ?nombre_jugador2))
    ; modifica la posición del jugador 2
    (modify-instance ?posicion_jugador2 (posicion (mod ?nueva_posicion 7)))
    ; eliminar semaforo
    (retract ?semaforo)
    (retract ?ronda_actual)
    (assert (ronda_actual ?nombre_ronda_siguiente))
    
    (retract ?semaforo)
    (printout t"=====================================================================================================" crlf)
    (printout t"El jugador: <" ?nombre_jugador1 "> ha finalizado su turno. " crlf)
    (printout t"El jugador: <" ?nombre_jugador2 "> ha empezado su turno en la posicion <" (mod ?nueva_posicion 7) ">. " crlf)

    (printout t"Cambio de ronda: <"?nombre_ronda_actual "> ==> <"?nombre_ronda_siguiente">." crlf)
)

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
    ; Generalización: mueve al otro jugador
    ?posicion_actual_jugador2 <- (object (is-a JUGADOR_ESTA_EN_LOSETA) (posicion ?pos_jugador2) (nombre_jugador ?nombre_jugador2))
    ; eliminar el semaforo de la restriccion de añadir recurso a la oferta.
    ?semaforo <- (recursos_añadidos_loseta ?)
    =>
    (bind ?nueva_posicion (+ ?pos_jugador2 2))
    ; deshace el hecho semaforo del turno.
    (retract ?turno_finalizado)
    ; eliminar turno jugador 1
    (retract ?turno_j1)
    ; generar hecho turno j2.
    (assert (turno ?nombre_jugador2))
    ; modifica la posición del jugador 2
    (modify-instance ?posicion_actual_jugador2 (posicion (mod ?nueva_posicion 7)))
    ; eliminar semaforo
    (retract ?semaforo)osicion_en_mazo
    (printout t"=====================================================================================================" crlf)
    (printout t"El jugador: <" ?nombre_jugador1 "> ha finalizado su turno. " crlf)
    (printout t"El jugador: <" ?nombre_jugador2 "> ha empezado su turno en la posicion <" (mod ?nueva_posicion 7) ">. " crlf)


)

; FUNCIONA!


(defrule AÑADIR_RECURSOS_OFERTA
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
    (assert (recursos_añadidos_loseta ?pos))
    (printout t"=====================================================================================================" crlf)
    (printout t"Se han añadido a la OFERTA los recursos de la loseta con posición: <" ?pos ">" crlf)
    (printout t"  La cantidad <" ?cantidad_recurso1 "> de recurso <" ?recurso1 ">." crlf)
    (printout t"  La cantidad <" ?cantidad_recurso2 "> de recurso <" ?recurso2 ">." crlf)
)

(defrule TOMAR_RECURSO_OFERTA
    ; si loseta oculta no se puede tomar recurso de la oferta.
    (object (is-a LOSETA) (posicion ?pos_jugador) (visibilidad TRUE))
    (object (is-a JUGADOR_ESTA_EN_LOSETA) (posicion ?pos_jugador) (nombre_jugador ?nombre_jugador))
    ; El jugador q esté en la loseta tiene que tener su turno.
    (turno ?nombre_jugador)
    ; Obtiene los datos del recurso del jugador
    ?recurso_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ?recurso_deseado) (cantidad ?cantidad_recurso))
    ; Obtiene el recurso de la oferta que se va a tomar
    ?recurso_oferta <- (OFERTA_RECURSO (recurso ?recurso_deseado) (cantidad ?cantidad_oferta))
    ; Comprueba que el recurso de la oferta se pueda obtener
    (test (> ?cantidad_oferta 0))
    ; Hecho estratégico que implique coger recurso de la oferta
    ?deseo <- (deseo_coger_recurso ?nombre_jugador ?recurso_deseado)
    =>
    ; eliminar deseo
    (retract ?deseo)
    ; Actualizar la cantidad de la oferta
    (modify ?recurso_oferta (cantidad 0))
    ; Actualizar los recursos del jugador
    (modify-instance ?recurso_jugador (cantidad (+ ?cantidad_recurso ?cantidad_oferta)))
    ; fin actividad principal
    (assert (fin_actividad_principal ?nombre_jugador))
    (printout t"=====================================================================================================" crlf)
    (printout t"El jugador: <" ?nombre_jugador "> ha tomado de la oferta: <" ?cantidad_oferta "> de <" ?recurso_deseado ">. " crlf)
)


(defrule GENERAR_DESEO
    (turno ?jugador)
    (not (deseo_coger_recurso ?jugador ?recurso))
    (OFERTA_RECURSO (recurso ?recurso) (cantidad ?cantidad_oferta))
    (test (> ?cantidad_oferta 0))
    =>
    (assert (deseo_coger_recurso ?jugador ?recurso))
    (printout t"DESEO GENERADO" crlf)
)