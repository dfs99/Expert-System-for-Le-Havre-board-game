


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

(defrule PAGAR_INTERESES_FRANCOS
    ; obtiene el jugador
    ?jugador <- (object(is-a JUGADOR)(nombre ?nombre)(deudas ?deudas))
    ; obtiene los recursos del jugador
    ?jugador_recursos <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre) (recurso FRANCO) (cantidad ?cantidad_francos))
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
    (printout t"=====================================================================================================" crlf)
    (printout t"El jugador <" ?nombre "> ha pagado intereses por sus deudas." crlf)
)

(defrule PAGAR_INTERESES_ENDEUDANDOSE
     ; obtiene el jugador
     ?jugador <- (object(is-a JUGADOR)(nombre ?nombre)(deudas ?deudas))
     ; obtiene los recursos del jugador
     ?jugador_recursos <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre) (recurso FRANCO)(cantidad ?cantidad_francos))
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
     (printout t"=====================================================================================================" crlf)
     (printout t"El jugador <" ?nombre "> ha pagado intereses por sus deudas, ¡endeudándose aún más! " crlf)

)
(defrule ACTUALIZAR_MAZO
	?ref <- (actualizar_mazo ?id ?numero_actualizaciones_restante ?pos1)
    ?carta_mazo1 <- (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id) (nombre_carta ?nombre_carta) (posicion_en_mazo ?pos1))
	;(not (carta_actualizada ?nombre_carta1 ?id ?pos1))
	(test (> ?numero_actualizaciones_restante 0))
	=>
	(modify-instance ?carta_mazo1(posicion_en_mazo (- ?pos1 1)))
	(retract ?ref)
	(assert (actualizar_mazo ?id (- ?numero_actualizaciones_restante 1) (+ ?pos1 1)))
	;(assert (carta_actualizada ?nombre_carta1 ?id ?pos1))
    (printout t"El mazo <" ?id "> ha actualizado la posición de la carta <" ?nombre_carta ">, ahora se encuentra en la posción <" (- ?pos1 1) ">." crlf)
)

(defrule FIN_ACTUALIZAR_MAZO
	(object (is-a MAZO) (id_mazo ?id) (numero_cartas_en_mazo ?num_cartas_en_mazo))
	?ref <- (actualizar_mazo ?id 0 ?)
	=>
	(retract ?ref)
	(printout t"mazo finalizado" crlf)
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
    (make-instance of JUGADOR_TIENE_CARTA (nombre_jugador ?nombre_jugador) (nombre_carta ?nombre_edificio))
    ; Eliminar el deseo de comprar el edificio
    (retract ?deseo)
    ; Generar hecho semáforo para actualizar el orden de las cartas del mazo
    (assert (actualizar_mazo ?id_mazo))
    ; actualizar 
    (modify-instance ?mazo (numero_cartas_en_mazo (- ?cartas_en_mazo 1)))
    (printout t"El jugador: <" ?nombre_jugador "> ha comprado el edificio: <" ?nombre_edificio "> por <" ?valor_edificio "> francos al mazo." crlf)
)

(defrule COMPRAR_EDIFICIO_BANCO_DEL_MAZO
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
    (object (is-a CARTA_BANCO) (nombre ?nombre_edificio) (coste ?valor_edificio) (valor ?))
    ; Obtiene el dinero del jugador
    ?recurso_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso FRANCO) (cantidad ?cantidad_recurso))
    ; El jugador tiene suficiente dinero
    (test (>= ?cantidad_recurso ?valor_edificio))
    ; obtener el mazo y actualizarlo.
    ?mazo <- (object (is-a MAZO) (id_mazo ?id_mazo) (numero_cartas_en_mazo ?cartas_en_mazo))
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
    ; actualizar mazo
    (modify-instance ?mazo (numero_cartas_en_mazo (- ?cartas_en_mazo 1)))
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

; NO SE AÑADE AL MAZO....
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
    ?barco <- (object (is-a BARCO)(nombre ?nombre_barco)(coste ?coste_barco)(valor ?valor_barco)(uds_comida_genera ?uds_comida_genera)(capacidad_envio ?capacidad_envio_barco))
    ; Obtiene el dinero del jugador
    ?recurso_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso FRANCO) (cantidad ?cantidad_recurso))
    ; se obtiene al jugador
    ?jugador <- (object (is-a JUGADOR)(nombre ?nombre_jugador)(num_barcos ?num_barcos)(capacidad_envio ?capacidad_envio_jugador)(demanda_comida_cubierta ?demanda_comida_cubierta))
    ; Obtener el mazo del barco
    (barco_pertenece_mazo ?nombre_barco ?id_mazo)
    ?mazo_barco <- (object(is-a MAZO)(id_mazo ?id_mazo)(numero_cartas_en_mazo ?num_cartas_mazo))

    =>
    ; Elimina el barco del jugador
    (unmake-instance ?jugador_tiene_barco)
    ; Actualiza los valores relacionados con el barco en el jugador
    (modify-instance ?jugador (num_barcos (- ?num_barcos 1)) (capacidad_envio (- ?capacidad_envio_jugador ?capacidad_envio_barco)) (demanda_comida_cubierta (- ?demanda_comida_cubierta ?uds_comida_genera)))
    ; Actualiza el dinero del jugador
    (modify-instance ?recurso_jugador (cantidad (+ ?cantidad_recurso (/ ?valor_barco 2))))
    ; Insertar el barco en el mazo
    (make-instance of CARTA_PERTENECE_A_MAZO (?nombre_barco)(?id_mazo))
    (modify-instance ?mazo_barco (numero_cartas_en_mazo (+ ?num_cartas_mazo 1)))
    ; Elimina el deseo
    (retract ?deseo)
)


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
    ?jugador_dinero <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso FRANCO) (cantidad ?cantidad_francos))
    ;(bind cantidad_a_pagar (min (* 5 ?deudas) ?cantidad_deuda))
    (test (> ?cantidad_francos (* 5 ?numero_deudas_deseo)))
    =>
    (modify-instance ?jugador_dinero (cantidad (- ?cantidad_francos (* 5 ?numero_deudas_deseo))))
    (modify-instance ?jugador (deudas (- ?numero_deudas ?numero_deudas_deseo)))
    (retract ?deseo)
    (printout t"El jugador <" ?nombre_jugador "> ha pagado <" ?numero_deudas_deseo "> por un valor de <" (* 5 ?numero_deudas_deseo) ">." crlf)
)

(defrule AÑADIR_CARTA_AYUNTO_FINAL_RONDA
    ; encontrarse en el cambio de ronda.
    (cambiar_ronda TRUE)
    ; ronda actual
    (ronda_actual ?nombre_ronda_actual)
    ; la ronda actual asigna un edificio al ayunto.
    ?asignacion_edificio <- (object (is-a RONDA_ASIGNA_EDIFICIO) (nombre_ronda ?nombre_ronda_actual) (id_mazo ?id_mazo))
    ; el mazo tiene que tener más de 1 carta.
    ?ref_mazo <- (object (is-a MAZO) (id_mazo ?id_mazo) (numero_cartas_en_mazo ?num_cartas_en_mazo))
    ; seleccionar la primera carta del mazo.
    ?carta_en_mazo <- (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id_mazo) (nombre_carta ?nombre_edificio) (posicion_en_mazo 1))
    =>
    ; Eliminar carta mazo.
    (unmake-instance ?carta_en_mazo)
    ; indicar que el edificio se encuentra ahora en el ayunto.
    (assert (EDIFICIO_AYUNTAMIENTO (nombre_edificio ?nombre_edificio)))
    ; actualiza el numero de cartas en el mazo.
    (modify-instance ?ref_mazo (numero_cartas_en_mazo (- ?num_cartas_en_mazo 1)))
    ; Generar hecho semáforo para actualizar el orden de las cartas del mazo
    (assert (actualizar_mazo ?id_mazo (- ?num_cartas_en_mazo 1) 2))
    ; Elimina la instancia de ronda_asigna_edificio
    (unmake-instance ?asignacion_edificio)
    ; semáforo para pasar de ronda 
    (assert (edificio_entregado ?nombre_ronda_actual))
    (printout t"Se ha añadido el edificio: <" ?nombre_edificio "> al Ayuntamiento desde el mazo <" ?id_mazo ">." crlf)
)

;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
; Si el nº de barcos y satisface la demanda de comida, ninguna regla de pagar demanda se inicializa
; posible crear una regla que solo indique ese caso específico para hacer un log por completitud!

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
    ?jugador_pescado <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso PESCADO) (cantidad ?cantidad_pescado))
    ?jugador_pescado_ahumado <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso PESCADO_AHUMADO) (cantidad ?cantidad_pescado_ahumado))
    ?jugador_pan <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso PAN) (cantidad ?cantidad_pan))
    ?jugador_carne <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso CARNE) (cantidad ?cantidad_carne))
    ?jugador_francos <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso FRANCO) (cantidad ?cantidad_francos))
    ; obtener contador de pagar comida.
    ?comida_restante <- (cantidad_comida_demandada ?nombre_jugador ?ronda ?cantidad_queda_por_pagar)
    ; queda por pagar una cantidad distinta de 0.
    (test (> ?cantidad_queda_por_pagar 0))     
    =>
    (bind ?total_recursos_para_pagar (+ (* ?cantidad_pescado 1) (* ?cantidad_pescado_ahumado 2)  (* ?cantidad_pan 3) (* ?cantidad_carne 3) (* ?cantidad_francos 1) ))
    (modify-instance ?jugador_pescado (cantidad (- ?cantidad_pescado ?deseo_pagar_pescado)))
    (modify-instance ?jugador_pescado_ahumado (cantidad (- ?cantidad_pescado_ahumado ?deseo_pagar_pescado_ahumado)))
    (modify-instance ?jugador_pan (cantidad (- ?cantidad_pan ?deseo_pagar_pan)))
    (modify-instance ?jugador_carne (cantidad (- ?cantidad_carne ?deseo_pagar_carne)))
    (modify-instance ?jugador_francos (cantidad (- ?cantidad_francos ?deseo_pagar_francos)))

    ; restar a comida por pagar la cantidad que el jugador pueda pagar con sus propios recursos
    (retract ?comida_restante )
    (assert (cantidad_comida_demandada ?nombre_jugador ?ronda (- ?cantidad_queda_por_pagar ?total_recursos_para_pagar)))
    ; eliminar deseo.
    (retract ?deseo)
    (printout t"Coste de ronda: <" ?coste_ronda "> y recursos disponibles jugador: <" ?total_recursos_para_pagar">." crlf)
    (printout t"El jugador <" ?nombre_jugador "> ha pagado la demanda de comida de la ronda <" ?ronda ">. Le queda por pagar <" (- ?cantidad_queda_por_pagar ?total_recursos_para_pagar)"> unidad(es)." crlf)
)

; comprobar
(defrule PAGAR_COMIDA_ENDEUDANDOSE
    ; se está en medio de un cambio de ronda.
    (cambiar_ronda TRUE)
    ; obtener los datos del jugador.
    ?jugador <- (object (is-a JUGADOR) (nombre ?nombre_jugador)(deudas ?deudas))
    ; obtener los datos de la ronda.
    (ronda_actual ?ronda)
    ; obtener los recursos del jugador.
    ?jugador_pescado <- (object (is-a JUGADOR_TIENE_RECURSO)(nombre_jugador ?nombre_jugador) (recurso PESCADO) (cantidad 0))
    ?jugador_pescado_ahumado <- (object (is-a JUGADOR_TIENE_RECURSO)(nombre_jugador ?nombre_jugador) (recurso PESCADO_AHUMADO) (cantidad 0))
    ?jugador_pan <- (object (is-a JUGADOR_TIENE_RECURSO)(nombre_jugador ?nombre_jugador) (recurso PAN) (cantidad 0))
    ?jugador_carne <- (object (is-a JUGADOR_TIENE_RECURSO)(nombre_jugador ?nombre_jugador) (recurso CARNE) (cantidad 0))
    ?jugador_francos <- (object (is-a JUGADOR_TIENE_RECURSO)(nombre_jugador ?nombre_jugador) (recurso FRANCO) (cantidad 0))
    
    ; obtener contador de pagar comida.
    ?comida_restante <- (cantidad_comida_demandada ?nombre_jugador ?ronda ?cantidad_queda_por_pagar)
     ; queda por pagar una cantidad distinta de 0.
    (test (> ?cantidad_queda_por_pagar 0))
    =>
    ; Calcular cuántos préstamos hay que tomar para poder pagar toda la comida
    ; IMPLEMENTA LA FUNCIÓN CEIL: c = comida a pagar, v = valor deuda :
    ;       préstamos a tomar = (c / v)+(1-((c mod v) / v))
    (bind ?deudas_a_obtener (+ (/ ?cantidad_queda_por_pagar 4) (- 1 (/ (mod ?cantidad_queda_por_pagar 4) 4))))

    (modify-instance ?jugador (deudas (+ ?deudas ?deudas_a_obtener)))
    (modify-instance ?jugador_francos (cantidad (- (* ?deudas_a_obtener 4) ?cantidad_queda_por_pagar)))
    ; actualizar hecho de cantidad comida demandada.
    (retract ?comida_restante)
    (assert (cantidad_comida_demandada ?nombre_jugador ?ronda 0))

    (printout t"<"?nombre_jugador"> ha tomado <"?deudas_a_obtener"> deuda(s) para poder pagar <"?cantidad_queda_por_pagar"> unidad(es) de comida demandada restante(s)." crlf)
)

(defrule AÑADIR_GANADO_POR_COSECHA
    (ronda_actual ?nombre_ronda_actual)
    ; precondiciones de ejecución: se ejecutará por cada jugador que se le añada algo.
    (object (is-a RONDA) (nombre_ronda ?nombre_ronda_actual) (hay_cosecha TRUE))
    ; cuando ambos jugadores hayan pagado su demanda, se añadirá la cosecha
    (object (is-a JUGADOR) (nombre ?nombre_jugador1) )
    (object (is-a JUGADOR) (nombre ?nombre_jugador2) )
    (test (neq ?nombre_jugador1 ?nombre_jugador2))
    
    ; iniciar contadores para llevar registro de la comida que falta por pagar.
    (cantidad_comida_demandada ?nombre_jugador1 ?nombre_ronda_actual ?cantidad_pendiente_jugador1)
    (cantidad_comida_demandada ?nombre_jugador2 ?nombre_ronda_actual ?cantidad_pendiente_jugador2)
    
    (test (<= ?cantidad_pendiente_jugador1 0))
    (test (<= ?cantidad_pendiente_jugador2 0))

    ; no haya pillado cosecha
    (not (cosechado ?nombre_jugador1 ?nombre_ronda_actual GANADO))
    ; recursos jugador.  
    ?ganado_jugador1 <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador1) (recurso GANADO) (cantidad ?cantidad_ganado))
    ; comprobar cantidades.
    (test (> ?cantidad_ganado 1))
    =>
    (modify-instance ?ganado_jugador1 (cantidad (+ ?cantidad_ganado 1)))
    ; bloquear que se ejecute varias veces.
    (assert (cosechado ?nombre_jugador1 ?nombre_ronda_actual GANADO))
    (printout t"El jugador <" ?nombre_jugador1 "> ha recibido de la cosecha +1 GANADO." crlf)
)

(defrule AÑADIR_GRANO_POR_COSECHA
    (ronda_actual ?nombre_ronda_actual)
    ; precondiciones de ejecución: se ejecutará por cada jugador que se le añada algo.
    (object (is-a RONDA) (nombre_ronda ?nombre_ronda_actual) (hay_cosecha TRUE))
    ; cuando ambos jugadores hayan pagado su demanda, se añadirá la cosecha
    (object (is-a JUGADOR) (nombre ?nombre_jugador1) )
    (object (is-a JUGADOR) (nombre ?nombre_jugador2) )
    ; ambos jugadores han pagado.
    (cantidad_comida_demandada ?nombre_jugador1 ?nombre_ronda_actual ?cantidad_pendiente_jugador1)
    (cantidad_comida_demandada ?nombre_jugador2 ?nombre_ronda_actual ?cantidad_pendiente_jugador2)  
    (test (<= ?cantidad_pendiente_jugador1 0))
    (test (<= ?cantidad_pendiente_jugador2 0))
    ; jugadores distintos.
    (test (neq ?nombre_jugador1 ?nombre_jugador2))
    ; no haya pillado cosecha
    (not (cosechado ?nombre_jugador1 ?nombre_ronda_actual GRANO))
    ; recursos jugador.  
    ?grano_jugador1 <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador1) (recurso GRANO) (cantidad ?cantidad_grano))
    ; comprobar cantidades.
    (test (> ?cantidad_grano 0))
    =>
    (modify-instance ?grano_jugador1 (cantidad (+ ?cantidad_grano 1)))
    (assert (cosechado ?nombre_jugador1 ?nombre_ronda_actual GRANO))
    
    (printout t"El jugador <" ?nombre_jugador1 "> ha recibido de la cosecha +1 GRANO." crlf)
)


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
    ; generar hecho turno j2.
    (assert (turno ?nombre_jugador2))
    ; modifica la posición del jugador 2
    (modify-instance ?posicion_jugador2 (posicion (mod ?nueva_posicion 7)))
    ; eliminar semaforo
    (retract ?semaforo)
    ; añadir semaforo
    (assert (cambiar_ronda TRUE))

    ; iniciar contadores para llevar registro de la comida que falta por pagar.
    (assert (cantidad_comida_demandada ?nombre_jugador1 ?nombre_ronda_actual (- ?coste_comida ?demanda_comida_cubierta_jugador1)))
    (assert (cantidad_comida_demandada ?nombre_jugador2 ?nombre_ronda_actual (- ?coste_comida ?demanda_comida_cubierta_jugador2)))
    
    (printout t"=====================================================================================================" crlf)
    (printout t"El jugador: <" ?nombre_jugador1 "> ha finalizado su turno. " crlf)
    (printout t"El jugador: <" ?nombre_jugador2 "> ha empezado su turno en la posicion <" (mod ?nueva_posicion 7) ">. " crlf)

    (printout t"Produciendose el Cambio de Ronda..." crlf)
    ;(printout t"Cambiando de Ronda: <"?nombre_ronda_actual "> a Ronda: <"?nombre_ronda_siguiente">..." crlf)
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


(defrule AÑADIR_RECURSOS_OFERTA
    ; Esperar a que termine el proceso de ejecución de cambio de ronda.
    (not (cambiar_ronda TRUE))
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
    (assert (permitir_realizar_accion ?nombre_jugador))
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
    ; debe haberse activado la autorización de realizar acción
    ?permiso <- (permitir_realizar_accion ?nombre_jugador)
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
    (retract ?permiso)
    ; Actualizar la cantidad de la oferta
    (modify ?recurso_oferta (cantidad 0))
    ; Actualizar los recursos del jugador
    (modify-instance ?recurso_jugador (cantidad (+ ?cantidad_recurso ?cantidad_oferta)))
    ; fin actividad principal
    (assert (fin_actividad_principal ?nombre_jugador))
    (printout t"=====================================================================================================" crlf)
    (printout t"El jugador: <" ?nombre_jugador "> ha tomado de la oferta: <" ?cantidad_oferta "> de <" ?recurso_deseado ">. " crlf)
)

; OK :)
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
    ; (test (neq ?nombre_jugador ?otro_jugador))
    ;(test (neq ?edificio_actual ?nombre_edificio))

    ; No tiene coste de entrada y pertence a otro jugador o pertenece al jugador y entra gratis. 
    (or
       (not (object (is-a COSTE_ENTRADA_CARTA) (nombre_carta ?nombre_edificio) (tipo ?) (cantidad ?))) 
       (object (is-a JUGADOR_TIENE_CARTA) (nombre_jugador ?nombre_jugador) (nombre_carta ?nombre_edificio))
    )
    
    =>
    ; indicar que el jugador está en el edificio.
    (modify-instance ?pos_jugador (nombre_edificio ?nombre_edificio))
    ; quitar el deseo.
    (retract ?deseo)
    (retract ?permiso)
    ; Acción principal terminada
    ; MODIFICACIÓN: CREO QUE ESTO DEBERÍA IR DESPUÉS DE USAR EL EDIFICIO
    ;(assert (fin_actividad_principal ?nombre_jugador))
    (assert (jugador_entra_edificio ?nombre_jugador ?nombre_edificio))
    
    (printout t"El jugador: <" ?nombre_jugador "> ha entrado al edificio: <" ?nombre_edificio "> sin coste de entrada o porque le pertenece." crlf)
)

; OK :)
(defrule ENTRAR_EDIFICIO_CON_COSTE_ENTRADA_RONDAS
    ; Se puede entrar de uno en uno en el resto de las rondas.
    (ronda_actual ?nombre_ronda)
    (test (neq ?nombre_ronda RONDA_EXTRA_FINAL))
    ; Existe un deseo de entrar a un edificio, este tiene el tipo de recurso que quiere usar para pagar y su nombre
    ?deseo <- (deseo_entrar_edificio ?nombre_jugador ?nombre_edificio ?tipo_recurso ?nombre_recurso)
    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; se le permite realizar una acción
    ?permiso <- (permitir_realizar_accion ?nombre_jugador)
    ; no exista un jugador en ese edificio.
     (not (object (is-a JUGADOR_ESTA_EDIFICIO) (nombre_edificio ?nombre_edificio)(nombre_jugador ?)))
    ; obtiene la posición del jugador
    ?pos_jugador <- (object (is-a JUGADOR_ESTA_EDIFICIO) (nombre_edificio ?edificio_actual) (nombre_jugador ?nombre_jugador))
    (test (neq ?edificio_actual ?nombre_edificio))
    
    
    ; Tiene coste de entrada.
    (object (is-a COSTE_ENTRADA_CARTA) (nombre_carta ?nombre_edificio) (tipo ?tipo_recurso) (cantidad ?coste_entrada))
    ; comprobar que tenga recursos suficientes para entrar.
    ?recurso_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ?nombre_recurso) (cantidad ?cantidad_recurso))
    (test (>= ?cantidad_recurso ?coste_entrada))
    =>
    ; Modificar el recurso del jugador
    (modify-instance ?recurso_jugador (cantidad (- ?cantidad_recurso ?coste_entrada) ))
    ; indicar que el jugador está en el edificio.
    (modify-instance ?pos_jugador (nombre_edificio ?nombre_edificio))

    (assert (jugador_entra_edificio ?nombre_jugador ?nombre_edificio))
    ; quitar el deseo.
    (retract ?deseo)
    (retract ?permiso)
    ; Print final
    (printout t"El jugador: <" ?nombre_jugador "> ha entrado al edificio: <" ?nombre_edificio "> por <" ?coste_entrada "> " ?tipo_recurso "." crlf)
)

(defrule ENTRAR_EDIFICIO_GRATIS_RONDA_FINAL
; Se puede entrar de uno en uno en el resto de las rondas.
    (ronda_actual RONDA_EXTRA_FINAL)
    ; Existe un deseo de entrar a un edificio, este tiene el tipo de recurso que quiere usar para pagar y su nombre
    ?deseo <- (deseo_entrar_edificio ?nombre_jugador ?nombre_edificio)
    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; obtener nombre de la carta. 
    (object (is-a CARTA) (nombre ?nombre_carta) (valor ?))
    ; comprobar que el jugador no se encuentre ya en el edificio. 
    ?pos_jugador <- (object (is-a JUGADOR_ESTA_EDIFICIO) (nombre_edificio ?edificio_actual) (nombre_jugador ?nombre_jugador))
    (test (neq ?edificio_actual ?nombre_carta))

    (object (is-a JUGADOR)(nombre ?otro_jugador))
    (test (neq ?nombre_jugador ?otro_jugador))

    ; No tiene coste de entrada y pertence a otro jugador o pertenece al jugador y entra gratis. 
    (or
        (and
            (not (object (is-a COSTE_ENTRADA_CARTA) (nombre_carta ?nombre_carta) (tipo ?) (cantidad ?))) 
                 
            (object (is-a JUGADOR_TIENE_CARTA)(nombre_jugador ?otro_jugador) (nombre_carta ?nombre_carta))
        ) 
         
        (object (is-a JUGADOR_TIENE_CARTA) (nombre_jugador ?nombre_jugador) (nombre_carta ?nombre_carta))
    )

    =>
    ; indicar que el jugador está en el edificio.
    (modify-instance ?pos_jugador (nombre_edificio ?nombre_carta))

    ; quitar el deseo.
    (retract ?deseo)
    (printout t"El jugador: <" ?nombre_jugador "> ha entrado al edificio: <" ?nombre_carta "> sin coste de entrada en la ronda final." crlf)


)

;OK
(defrule UTILIZAR_EDIFICIO_CONSTRUCTOR
    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; El jugador debe estar en el edificio.
    (object (is-a JUGADOR_ESTA_EDIFICIO) (nombre_edificio ?nombre_edificio) (nombre_jugador ?nombre_jugador))
    ; el jugador no ha usado anteriormente el edificio sin haber entrado a otro antes
    ?edificio_usado <- (object (is-a JUGADOR_HA_USADO_EDIFICIO)(nombre_edificio ?ed)(nombre_jugador ?nombre_jugador))
    (test (neq ?nombre_edificio ?ed))

    ; existe un deseo de construir una carta.
    ?deseo <- (deseo_construccion ?nombre_jugador ?nombre_carta)
    ; el edificio puede construir. 
    (or 
        (test (eq ?nombre_edificio "CONSTRUCTORA1"))
        (test (eq ?nombre_edificio "CONSTRUCTORA2"))
        (test (eq ?nombre_edificio "CONSTRUCTORA3"))
    )
    
    ; comprobar que se encuentra en la parte superior del mazo.
    ?pertenencia_mazo <- (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id_mazo) (nombre_carta ?nombre_carta) (posicion_en_mazo 1))
    (object (is-a MAZO)(id_mazo ?id_mazo)(numero_cartas_en_mazo ?num_cartas_mazo))
    ; obtener el coste de la carta
    ?coste_carta <- (object (is-a COSTE_CONSTRUCCION_CARTA) (nombre_carta ?nombre_carta) (cantidad_madera ?coste_madera) (cantidad_arcilla ?coste_arcilla) (cantidad_ladrillo ?coste_ladrillos) (cantidad_hierro ?coste_hierro) (cantidad_acero ?coste_acero))
    ; comprobar que el jugador tiene suficientes recursos para construirla.
    ?recurso_jugador_madera <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso MADERA) (cantidad ?cantidad_madera))
    ?recurso_jugador_arcilla <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ARCILLA) (cantidad ?cantidad_arcilla))
    ?recurso_jugador_ladrillos <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso LADRILLOS) (cantidad ?cantidad_ladrillos))
    ?recurso_jugador_hierro <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso HIERRO) (cantidad ?cantidad_hierro))
    ?recurso_jugador_acero <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ACERO) (cantidad ?cantidad_acero))
    
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
    (make-instance of JUGADOR_TIENE_CARTA (nombre_jugador ?nombre_jugador) (nombre_carta ?nombre_carta))
    ;generar hecho semáforo para reordenar el mazo
    (assert (actualizar_mazo ?id_mazo (- ?num_cartas_mazo 1) 2))
    ; semaforo final actividad principal.
    (assert(fin_actividad_principal ?nombre_jugador)) 
    ; relación para no permitir usar el mismo edificio dos veces.
    (modify-instance ?edificio_usado (nombre_edificio ?nombre_edificio))

    (printout t"El jugador <"?nombre_jugador"> ha usado el edificio <"?nombre_edificio"> para construir la carta <"?nombre_carta"> empleando <"?coste_madera"> madera, <"?coste_arcilla"> arcilla, <"?coste_ladrillos"> ladrillos, <"?coste_hierro"> hierro y <"?coste_acero"> acero." crlf)
)

(defrule PASAR_RONDA 
    ; Semáforo pasar ronda.
    ?cambiar <- (cambiar_ronda TRUE)

    ; selección de siguiente ronda
    ?ronda_actual <- (ronda_actual ?nombre_ronda_actual)

    ; ambos jugadores han pagado la comida.
    (object (is-a JUGADOR) (nombre ?nombre_jugador1))
    (object (is-a JUGADOR) (nombre ?nombre_jugador2))
    (test (neq ?nombre_jugador1 ?nombre_jugador2))
    ?cantidad_restante_j1 <- (cantidad_comida_demandada ?nombre_jugador1 ?nombre_ronda_actual ?cantidad_pendiente_jugador1)
    ?cantidad_restante_j2 <- (cantidad_comida_demandada ?nombre_jugador2 ?nombre_ronda_actual ?cantidad_pendiente_jugador2)
    (test (<= ?cantidad_pendiente_jugador1 0))
    (test (<= ?cantidad_pendiente_jugador2 0))
    
    ?ronda_siguiente <- (object (is-a RONDA) (nombre_ronda ?nombre_ronda_siguiente))
    (siguiente_ronda ?nombre_ronda_actual ?nombre_ronda_siguiente)
    ; introducir barco
    ?introduce_barco <- (object (is-a RONDA_INTRODUCE_BARCO) (nombre_ronda ?nombre_ronda_actual) (nombre_carta ?nombre_barco))
    ; semáforo para que en las rondas impares asigne el edificio al ayuntamiento antes de pasar de ronda
    (or (eq ?nombre_ronda_actual RONDA_2)
        (eq ?nombre_ronda_actual RONDA_4)
        (eq ?nombre_ronda_actual RONDA_6)
        (eq ?nombre_ronda_actual RONDA_8)
        (edificio_entregado ?nombre_ronda_actual)
    )
    
    ; evita que se pase de ronda antes de actualizar el mazo cuando se entrega un edificio al ayuntamiento
    ;(not (actualizar_mazo ?))
    (not (actualizar_mazo ? ? ?))
     =>
     
    (retract ?ronda_actual)
    (assert (ronda_actual ?nombre_ronda_siguiente))
    (retract ?cambiar)

    (assert (BARCO_DISPONIBLE (nombre_barco ?nombre_barco)))
    (unmake-instance ?introduce_barco)

    (retract ?cantidad_restante_j1)
    (retract ?cantidad_restante_j2)

    (printout t"Nuevo Barco disponible para la nueva ronda: <" ?nombre_barco ">." crlf)
    (printout t"Se ha cambiado de Ronda: <"?nombre_ronda_actual "> a Ronda: <"?nombre_ronda_siguiente">." crlf)
)

; (defrule GENERAR_DESEO
;     ; Esperar a que termine el proceso de ejecución de cambio de ronda.
;     (not (cambiar_ronda TRUE))
;     (turno ?jugador)
;     (not (deseo_coger_recurso ?jugador ?recurso))
;     (OFERTA_RECURSO (recurso ?recurso) (cantidad ?cantidad_oferta))
;     (test (> ?cantidad_oferta 0))
;     =>
;     (assert (deseo_coger_recurso ?jugador ?recurso))
;     (printout t"DESEO GENERADO" crlf)
; )