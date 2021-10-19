
(deffacts situacion_inicial

    (ronda_actual RONDA_1)
    ; hechos semaforo para cambiar de rondas.
    (siguiente_ronda RONDA_1, RONDA_2)
    (siguiente_ronda RONDA_2, RONDA_3)
    (siguiente_ronda RONDA_3, RONDA_4)
    (siguiente_ronda RONDA_4, RONDA_5)
    (siguiente_ronda RONDA_5, RONDA_6)
    (siguiente_ronda RONDA_6, RONDA_7)
    (siguiente_ronda RONDA_7, RONDA_8)
    (siguiente_ronda RONDA_8, RONDA_EXTRA_FINAL)
    ; oferta recursos inicial partida corta 2 jugadores
    (OFERTA_RECURSO (recurso FRANCO) (cantidad 3))
    (OFERTA_RECURSO (recurso PESCADO) (cantidad 3))
    (OFERTA_RECURSO (recurso MADERA) (cantidad 3))
    (OFERTA_RECURSO (recurso ARCILLA) (cantidad 2))
    (OFERTA_RECURSO (recurso HIERRO) (cantidad 1))
    (OFERTA_RECURSO (recurso GRANO) (cantidad 1))
    (OFERTA_RECURSO (recurso GANADO) (cantidad 2))


    (siguiente_barco_disponible BARCO_MADERA1 BARCO_MADERA2)
    (siguiente_barco_disponible BARCO_MADERA2 BARCO_MADERA3)
    )

    
    

; INSTANCIAS CARTAS EDIFICIO
(definstances situacion_inicial
    ;([nombre] of EDIFICIO_GENERADOR
    ;    (tipo OTRO)
    ;    (nombre FISHERY)
    ;    (coste_compra 6)
    ;    (valor_proporciona 6)
    ;    (tarifa_entrada_en_francos 0)
    ;    (tarifa_entrada_uds_recurso 0)
    ;    (tarifa_entrada_recurso)
    ;    (recurso_genera)
    ;    (num_recursos_genera)
    ;    (plus_por_bonus)
    ;)
    ; ====== JUGADORES ========
    ( of JUGADOR (nombre DIEGO))
    ( of JUGADOR (nombre RICARDO))
    ; ====== RECURSOS =========
    ([franco] of RECURSO (nombre FRANCO))
    ([madera] of RECURSO (nombre MADERA))
    ([pescado] of RECURSO (nombre PESCADO))
    ([arcilla] of RECURSO (nombre ARCILLA))
    ([hierro] of RECURSO (nombre HIERRO))
    ([grano] of RECURSO (nombre GRANO))
    ([ganado] of RECURSO (nombre GANADO))
    ([carbon] of RECURSO (nombre CARBON))
    ([piel] of RECURSO (nombre PIEL))
    ([pescado-ahumado] of RECURSO (nombre PESCADO_AHUMADO))
    ([carbon_vegetal] of RECURSO (nombre CARBON_VEGETAL))
    ([ladrillos] of RECURSO (nombre LADRILLOS))
    ([acero] of RECURSO (nombre ACERO))
    ([pan] of RECURSO (nombre PAN))
    ([carne] of RECURSO (nombre CARNE))
    ([coque] of RECURSO (nombre COQUE))
    ([cuero] of RECURSO (nombre CUERO))
    ; ====== MAZOS ======
    (of MAZO (id_mazo 1)))
    (of MAZO (id_mazo 2)))
    (of MAZO (id_mazo 3)))
    ; ====== RONDA ======
    (of RONDA (nombre_ronda RONDA_1)(coste_comida 4)(hay_cosecha TRUE))
    (of RONDA (nombre_ronda RONDA_2)(coste_comida 7)(hay_cosecha TRUE))
    (of RONDA (nombre_ronda RONDA_3)(coste_comida 9)(hay_cosecha TRUE))
    (of RONDA (nombre_ronda RONDA_4)(coste_comida 13)(hay_cosecha TRUE))
    (of RONDA (nombre_ronda RONDA_5)(coste_comida 15)(hay_cosecha TRUE))
    (of RONDA (nombre_ronda RONDA_6)(coste_comida 17)(hay_cosecha TRUE))
    (of RONDA (nombre_ronda RONDA_7)(coste_comida 18)(hay_cosecha TRUE))
    (of RONDA (nombre_ronda RONDA_8)(coste_comida 20)(hay_cosecha FALSE))
    ; ======== CASILLAS DE RECURSO =======
    (of CASILLA_RECURSO (posicion 1))
    (of CASILLA_RECURSO (posicion 2))
    (of CASILLA_RECURSO (posicion 3))
    (of CASILLA_RECURSO (posicion 4))
    (of CASILLA_RECURSO (posicion 5))
    (of CASILLA_RECURSO (posicion 6))
    (of CASILLA_RECURSO (posicion 7))
    ; ========= CASILLA RECURSO TIENE RECURSO ========
    (of CASILLA_RECURSO_TIENE_RECURSO (posicion 1)(recurso MADERA)(cantidad 1))
    (of CASILLA_RECURSO_TIENE_RECURSO (posicion 1)(recurso GANADO)(cantidad 1))
    (of CASILLA_RECURSO_TIENE_RECURSO (posicion 2)(recurso MADERA)(cantidad 1))
    (of CASILLA_RECURSO_TIENE_RECURSO (posicion 2)(recurso FRANCO)(cantidad 1))
    (of CASILLA_RECURSO_TIENE_RECURSO (posicion 3)(recurso PESCADO)(cantidad 1))
    (of CASILLA_RECURSO_TIENE_RECURSO (posicion 3)(recurso ARCILLA)(cantidad 1))
    (of CASILLA_RECURSO_TIENE_RECURSO (posicion 4)(recurso HIERRO)(cantidad 1))
    (of CASILLA_RECURSO_TIENE_RECURSO (posicion 4)(recurso FRANCO)(cantidad 1))
    (of CASILLA_RECURSO_TIENE_RECURSO (posicion 5)(recurso MADERA)(cantidad 1))
    (of CASILLA_RECURSO_TIENE_RECURSO (posicion 5)(recurso ARCILLA)(cantidad 1))
    (of CASILLA_RECURSO_TIENE_RECURSO (posicion 6)(recurso MADERA)(cantidad 1))
    (of CASILLA_RECURSO_TIENE_RECURSO (posicion 6)(recurso PESCADO)(cantidad 1))
    (of CASILLA_RECURSO_TIENE_RECURSO (posicion 7)(recurso PESCADO)(cantidad 1))
    (of CASILLA_RECURSO_TIENE_RECURSO (posicion 7)(recurso GRANO)(cantidad 1))

