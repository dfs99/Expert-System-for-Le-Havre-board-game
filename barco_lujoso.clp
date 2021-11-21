(defrule CONSTRUIR_BARCO_LUJOSO
    (turnos_restantes ?)
    ; es la ronda extra final.
    (ronda_actual RONDA_EXTRA_FINAL)
    ; obtener referencia jugador.
    (object (is-a JUGADOR) (nombre ?nombre_jugador) (capacidad_envio ?capacidad_envio))
    ; turno del jugador.
    (turno ?nombre_jugador)
    ; el barco lujoso está disponible.
    (BARCO_DISPONIBLE (nombre_barco "BARCO_LUJOSO"))
    ; comprobar que se tiene suficientes recursos para construirlo.
    ; obtener los recursos del jugador.
    ?madera_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso MADERA) (cantidad ?cantidad_madera))
    ?arcilla_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ARCILLA) (cantidad ?cantidad_arcilla))
    ?ladrillo_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso LADRILLOS) (cantidad ?cantidad_ladrillos))
    ?hierro_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso HIERRO) (cantidad ?cantidad_hierro))
    ?acero_jugador <- (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ACERO) (cantidad ?cantidad_acero))
    ; obtener los costes de la carta.
    (object (is-a COSTE_CONSTRUCCION_CARTA) (cantidad_madera ?coste_madera) (cantidad_arcilla ?coste_arcilla) (cantidad_ladrillo ?coste_ladrillo) (cantidad_hierro ?coste_hierro) (cantidad_acero ?coste_acero))
    ; realizar las comprobaciones pertinentes.
    (test (>= ?cantidad_madera ?coste_madera))
    (test (>= ?cantidad_arcilla ?coste_arcilla))
    (test (>= ?cantidad_ladrillos ?coste_ladrillo))
    (test (>= ?cantidad_hierro ?coste_hierro))
    (test (>= ?cantidad_acero ?coste_acero))
    ; Debe tener suficiente comida para entrar en el muelle.
    (decision_pago_comida_entrar_edificios ?nombre_jugador ?recurso)
    (object (is-a RECURSO_ALIMENTICIO) (nombre ?recurso) (comida_genera ?ratio))
    (object (is-a PARTICIPANTE_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ?recurso) (cantidad ?cantidad_recurso_alimenticio))
    (object (is-a COSTE_ENTRADA_CARTA) (nombre_carta "MUELLE") (tipo COMIDA) (cantidad ?cantidad_coste_entrada))
    (test (>= (* ?cantidad_recurso_alimenticio ?ratio) ?cantidad_coste_entrada))
    ; no ha sido instanciado.
    (not (deseo_construccion ?nombre_jugador "BARCO_LUJOSO"))
    =>
    ; Se le manda directamente al muelle.
    (assert (deseo_entrar_edificio ?nombre_jugador "MUELLE" COMIDA ?recurso))
    (assert (deseo_construccion ?nombre_jugador "BARCO_LUJOSO"))
    ; log
    (printout t"El jugador: <"?nombre_jugador"> ha generado el deseo de construir el BARCO LUJOSO al finalizar la partida." crlf)
)