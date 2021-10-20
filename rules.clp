
; =======================================================================================
;       INFERENCIA 1 - TOMAR ELEMENTOS OFERTA.
; =======================================================================================

; Primero hay que generar una regla que produzca un hecho 
; El hecho tiene que ser "jugador puede tomar recurso de oferta" o similar.
; La regla se instanciaría cuando un recurso de la oferta tiene >=3 unidades

; Establecer la prioridad estratégica de recursos: (prioridad_recursos MADERA, )

(defrule generar_alternativas_tomar_recurso_oferta
    ?oferta <- (OFERTA_RECURSO (recurso ?recurso) (cantidad ?c))
    (test (>= ?c 3))
    =>
    (assert (oferta_suficiente_mas_igual_tres ?recurso))
)

(defrule tomar_recurso_oferta
    ; TODO: No implementado!
    ; El jugador debe de tener el turno.
    ; Decidir cual tomar en base a alguna estrategia? !!!!!!!!!!!!!!!
    ; ========================================================
    ; El jugador pertenece a la partida. 
    ; Se accede a la cantidad de recursos del jugador.
    ; Se accede a la oferta de recursos de la partida.
    ; Tendrá que haberse activado el hecho semáforo de oferta suficiente +3
    ?jugador <- (object (is-a JUGADOR) (nombre ?nombre_jugador))
    ?recursos_jugador <- (object (is-a JUGADOR_TIENE_RECURSOS) (nombre ?nombre_jugador) (recurso ?recurso) (cantidad ?cantidad_jugador))
    ?recurso_oferta <- (OFERTA_RECURSO (recurso ?recurso) (cantidad ?c))
    (oferta_suficiente_mas_igual_tres ?recurso)
    =>
    (modify ?recurso_oferta (cantidad 0))
    (modify-instance ?recursos_jugador (cantidad =(+ ?cantidad_jugador ?c)))
    (retract (oferta_suficiente_mas_igual_tres ?recurso))
    ; añadir q has finalizado turno.
    (assert (turno_finalizado ?nombre_jugador))
)

(defrule destapar_casilla_recurso 
    ; obtener casilla
    ?casilla <- (object (is-a CASILLA_RECURSO) (posicion ?pos) (visibilidad ?visible))
    ; comprobar que hay un jugador en la casilla
    ?posicion_jugador <- (object (is-a JUGADOR_ESTA_EN_CASILLA_RECURSO) (posicion ?pos))
    ; comprobar que la casilla está oculta    
    (test (eq ?visible FALSE))
    =>
    ; hacer casilla visible
    (modify-instance ?casilla (visibilidad TRUE))
)

(defrule añadir_recursos_casilla
    ; preguntar si es redundante el concepto partida!
    ?casilla <- (object (is-a CASILLA_RECURSO) (posicion ?pos) (visibilidad ?visible))
    (object (is-a JUGADOR_ESTA_EN_CASILLA_RECURSO) (posicion ?pos))
    ?oferta_recurso <- (OFERTA_RECURSO (recurso ?recurso) (cantidad ?cantidad_oferta))
    (test (eq ?visible TRUE))
    (forall (object (is-a CASILLA_RECURSO_TIENE_RECURSO) (posicion ?pos) (recurso ?recurso) (cantidad ?c)))
    => 
    ; añadir a la oferta.
    (modify ?oferta_recurso (cantidad =(+ cantidad_oferta c)))
)

(defrule pasar_turno
    ; pensar si debería haber alguna precondición o si simplemente por estar 
    ; en la posición que está la regla ya se asegura que sólo se instancia
    ; cuando el jugador no puede hacer nada más
    ?jugador1 <- (object (is-a JUGADOR) (nombre ?nombre_jugador1))
    ?jugador2 <- (object (is-a JUGADOR) (nombre ?nombre_jugador2))
    (test (neq ?jugador1 ?jugador2))
    ; IMPORTANTE!  ¿DÓNDE SE GENERA ESTE HECHO SEMÁFORO?????
    (turno_finalizado ?nombre_jugador1)
    =>
    (retract (turno_finalizado ?nombre_jugador1))
    (assert (turno ?nombre_jugador2))
)

(defrule cambio_ronda
    ; para cambiar de ronda se tiene que dar la siguiente situación
    ; | | | | | |2|1| y turno de 2
    ?jugador1 <- (object (is-a JUGADOR) (nombre ?nombre_jugador1))
    ?posicion_jugador1 <- (object (is-a JUGADOR_ESTA_EN_CASILLA_RECURSO) (posicion ?pos_jugador1) (nombre_jugador ?nombre_jugador1))
    ?jugador2 <- (object (is-a JUGADOR) (nombre ?nombre_jugador2))
    ?posicion_jugador2 <- (object (is-a JUGADOR_ESTA_EN_CASILLA_RECURSO) (posicion ?pos_jugador2) (nombre_jugador ?nombre_jugador2))
    (test (eq ?pos_jugador1 7))
    (test (eq ?pos_jugador2 6))
    (test (neq ?jugador ?jugador2))
    (turno ?nombre_jugador2)
    ; selección de siguiente ronda
    (ronda_actual ?nombre_ronda_actual)
    ?ronda_siguiente <- (object (is-a RONDA (nombre_ronda ?nombre_ronda_siguiente)))
    (siguiente_ronda ?nombre_ronda_actual ?nombre_ronda_siguiente)
    =>
    (retract ronda_actual ?nombre_ronda_actual)
    (assert ronda_actual ?nombre_ronda_siguiente)
)

(defrule asignar_edificio_ayuntamiento
    ; SE TIENE Q EJECUTAR NADA MÁS ACTUALIZAR LA RONDA!!!!!!!!!!!!!!!!! 
    (object (is-a RONDA (nombre_ronda ?nombre_ronda)))
    ?mazo <- (object (is-a MAZO) (id_mazo ?id))
    ; REVISAR LA CONCEPTUALIZACIÓN EDIFICIO, ES PSEUDOCÓDIGO!
    ?edificio <- (object (is-a EDIFICIO) (nombre ?nombre_edificio))
    ?pertenece <- (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id) (nombre_carta ?nombre_edificio))
    ?asignacion_edificio <- (object (is-a RONDA_ASIGNA_EDIFICIO) (nombre_ronda ?nombre_ronda) (id_mazo ?id) (nombre_edificio ?nombre_edificio))
    (ronda_actual ?nombre_ronda)
    =>
    (assert EDIFICIO_AYUNTAMIENTO(nombre_edificio ?nombre_edificio))
    (unmake-instance ?asignacion_edificio)
    (unmake-instance ?pertenece)
    ; Introducir un hecho semáforo adicional para disparar la actualización de posición
    ; en las cartas del mazo. Otra alternativa, jugar prioridad reglas. De momento lo dejamos 
    ; como hecho semáforo.
    (assert actualizar_mazo_edificios ?id)
)

(defrule actualizar_disponibilidad_barcos
    ; SE TIENE Q EJECUTAR NADA MÁS ACTUALIZAR LA RONDA!!!!!!!!!!!!!!!!! 
    (object (is-a RONDA (nombre_ronda ?nombre_ronda)))
    (ronda_actual ?nombre_ronda)
    ?mazo <- (object (is-a MAZO) (id_mazo ?id))
    ?barco <- (object (is-a BARCO) (nombre ?nombre_barco))
    ?pertenece <- (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id) (nombre_carta ?nombre_barco))
    ?introduce_barco <- (object (is-a RONDA_INTRODUCE_BARCO) (nombre_ronda ?nombre_ronda) (nombre_carta ?nombre_barco))
    =>
    ; TODO: NO SABEMOS EN Q ORDEN QUEDARÍAN LOS BARCOS DISPONIBLES. problema.!!!!!!!!!!!!!!!!!
    (BARCO_DISPONIBLE (nombre_barco ?nombre_barco))
    (unmake-instance ?introduce_barco)
)

(defrule jugador_adquiere_barco
    ; TODO: !AÑADIR ESTRATEGIA de COMPRA DE BARCO!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    ?mazo <- (object (is-a MAZO) (id_mazo ?id))
    ?barco <- (object (is-a BARCO) (nombre ?nombre_barco))
    ?pertenece <- (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id) (nombre_carta ?nombre_barco))
    ?disponibilidad <- (BARCO_DISPONIBLE (nombre_barco ?nombre_barco))
    =>
    (retract ?disponibilidad)
)

; Sería útil poder ejecutar la postcondición de cambiar de posición las cartas dentro del 
; mazo a través de un bucle en las postcondiciones de la regla "asignar_edificio_ayuntamiento".
; NO SABEMOS SI PODEMOS USAR UN BUCLE EN LAS POSTCONDICIONES
(defrule actualizar_posicion_cartas_mazo
    ?carta_mazo <- (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id) (nombre_carta ?nombre_carta) (posicion ?pos))
    (assert actualizar_mazo_edificios ?id)
    (forall (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id) (nombre_carta ?nombre_carta) (posicion ?pos)))
    =>
    (modify-instance ?carta_mazo(posicion (- ?pos 1))
)

(defrule mover_jugador
    ?jugador <- (object (is-a JUGADOR) (nombre ?nombre))
    (turno ?nombre)
    ?posicion_actual <- (object (is-a JUGADOR_ESTA_EN_CASILLA_RECURSO) (posicion ?pos) (nombre_jugador ?nombre))
    =>
    (modify-instance ?posicion_actual (posicion =(mod =(+ ?pos 2) 7)))
)
