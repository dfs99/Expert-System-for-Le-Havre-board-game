; faltan las cartas, por problemas imprevistos de tiempo nos ha sido imposible
; reconceptualizar las cartas y no las hemos instanciado.
(deffacts situacion_inicial

    (ronda_actual RONDA_1)
    ; hechos semáforo para cambiar de jugador
    (siguiente_jugador DIEGO, RICARDO)
    (siguiente_jugador RICARDO, DIEGO)
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

    
    

; INSTANCIAS
(definstances situacion_inicial
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
    (of MAZO (id_mazo 1))
    (of MAZO (id_mazo 2))
    (of MAZO (id_mazo 3))
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
    ; ========= RECURSOS INICIALES DE LOS JUGADORES =========
    ; == DIEGO
    (of JUGADOR_TIENE_RECURSO (nombre_jugador DIEGO) (recurso PESCADO) (cantidad 2))
    (of JUGADOR_TIENE_RECURSO (nombre_jugador DIEGO) (recurso MADERA) (cantidad 2))
    (of JUGADOR_TIENE_RECURSO (nombre_jugador DIEGO) (recurso ARCILLA) (cantidad 2))
    (of JUGADOR_TIENE_RECURSO (nombre_jugador DIEGO) (recurso HIERRO) (cantidad 2))
    (of JUGADOR_TIENE_RECURSO (nombre_jugador DIEGO) (recurso GRANO) (cantidad 0))
    (of JUGADOR_TIENE_RECURSO (nombre_jugador DIEGO) (recurso GANADO) (cantidad 1))
    (of JUGADOR_TIENE_RECURSO (nombre_jugador DIEGO) (recurso CARBON) (cantidad 2))
    (of JUGADOR_TIENE_RECURSO (nombre_jugador DIEGO) (recurso PIEL) (cantidad 2))
    (of JUGADOR_TIENE_RECURSO (nombre_jugador DIEGO) (recurso PESCADO_AHUMADO) (cantidad 0))
    (of JUGADOR_TIENE_RECURSO (nombre_jugador DIEGO) (recurso CARBON_VEGETAL) (cantidad 0))
    (of JUGADOR_TIENE_RECURSO (nombre_jugador DIEGO) (recurso LADRILLOS) (cantidad 0))
    (of JUGADOR_TIENE_RECURSO (nombre_jugador DIEGO) (recurso ACERO) (cantidad 0))
    (of JUGADOR_TIENE_RECURSO (nombre_jugador DIEGO) (recurso PAN) (cantidad 0))
    (of JUGADOR_TIENE_RECURSO (nombre_jugador DIEGO) (recurso CARNE) (cantidad 0))
    (of JUGADOR_TIENE_RECURSO (nombre_jugador DIEGO) (recurso COQUE) (cantidad 0))
    (of JUGADOR_TIENE_RECURSO (nombre_jugador DIEGO) (recurso CUERO) (cantidad 0))
    ; == RICARDO
    (of JUGADOR_TIENE_RECURSO (nombre_jugador RICARDO) (recurso PESCADO) (cantidad 2))
    (of JUGADOR_TIENE_RECURSO (nombre_jugador RICARDO) (recurso MADERA) (cantidad 2))
    (of JUGADOR_TIENE_RECURSO (nombre_jugador RICARDO) (recurso ARCILLA) (cantidad 2))
    (of JUGADOR_TIENE_RECURSO (nombre_jugador RICARDO) (recurso HIERRO) (cantidad 2))
    (of JUGADOR_TIENE_RECURSO (nombre_jugador RICARDO) (recurso GRANO) (cantidad 0))
    (of JUGADOR_TIENE_RECURSO (nombre_jugador RICARDO) (recurso GANADO) (cantidad 1))
    (of JUGADOR_TIENE_RECURSO (nombre_jugador RICARDO) (recurso CARBON) (cantidad 2))
    (of JUGADOR_TIENE_RECURSO (nombre_jugador RICARDO) (recurso PIEL) (cantidad 2))
    (of JUGADOR_TIENE_RECURSO (nombre_jugador RICARDO) (recurso PESCADO_AHUMADO) (cantidad 0))
    (of JUGADOR_TIENE_RECURSO (nombre_jugador RICARDO) (recurso CARBON_VEGETAL) (cantidad 0))
    (of JUGADOR_TIENE_RECURSO (nombre_jugador RICARDO) (recurso LADRILLOS) (cantidad 0))
    (of JUGADOR_TIENE_RECURSO (nombre_jugador RICARDO) (recurso ACERO) (cantidad 0))
    (of JUGADOR_TIENE_RECURSO (nombre_jugador RICARDO) (recurso PAN) (cantidad 0))
    (of JUGADOR_TIENE_RECURSO (nombre_jugador RICARDO) (recurso CARNE) (cantidad 0))
    (of JUGADOR_TIENE_RECURSO (nombre_jugador RICARDO) (recurso COQUE) (cantidad 0))
    (of JUGADOR_TIENE_RECURSO (nombre_jugador RICARDO) (recurso CUERO) (cantidad 0))
    ; ======= BONUS ========
    (of BONUS (nombre PESCADOR))
    (of BONUS (nombre MARTILLO))
    ; ======= JUGADOR TIENE BONUS =======
    (of JUGADOR_TIENE_BONUS (nombre_jugador DIEGO)(tipo PESCADOR)(cantidad 0))
    (of JUGADOR_TIENE_BONUS (nombre_jugador DIEGO)(tipo MARTILLO)(cantidad 0))
    (of JUGADOR_TIENE_BONUS (nombre_jugador RICARDO)(tipo PESCADOR)(cantidad 0))
    (of JUGADOR_TIENE_BONUS (nombre_jugador RICARDO)(tipo MARTILLO)(cantidad 0))

    // 3 MADERA, 2 HIERRO, 1 
    ; CARTAS AYUNTO
    (of CARTA (nombre "CONSTRUCTORA1") (coste_francos 4) (valor_proporciona 4))
    (of CARTA (nombre "CONSTRUCTORA2") (coste_francos 6) (valor_proporciona 6))
    (of CARTA (nombre "CONSTRUCTORA3") (coste_francos 8) (valor_proporciona 8))
    (of CARTA (nombre "MERCADO") (coste_francos 6) (valor_proporciona 6))
    

    ; MAZO 1
    (of CARTA (nombre "HORNO DE CARBON VEGETAL") (coste_francos 8) (valor_proporciona 8))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 1) (nombre_carta "HORNO DE CARBON VEGETAL") (posicion 1))

    (of CARTA (nombre "MUELLE") (coste_francos 14) (valor_proporciona 14))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 1) (nombre_carta "MUELLE") (posicion 2))

    (of CARTA (nombre "FABRICA DE LADRILLOS") (coste_francos 14) (valor_proporciona 14))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 1) (nombre_carta "FABRICA DE LADRILLOS") (posicion 3))

    (of CARTA (nombre "COQUERIA") (coste_francos 18) (valor_proporciona 18))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 1) (nombre_carta "COQUERIA") (posicion 4))

    (of CARTA (nombre "BANCO") (coste_francos 40) (valor_proporciona 16))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 1) (nombre_carta "BANCO") (posicion 5))

    ; MAZO 2
    (of CARTA (nombre "PISCIFACTORIA") (coste_francos 10) (valor_proporciona 10))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 2) (nombre_carta "PISCIFACTORIA") (posicion 1))

    (of CARTA (nombre "PANADERIA") (coste_francos 8) (valor_proporciona 8))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 2) (nombre_carta "PANADERIA") (posicion 2))

    (of CARTA (nombre "MONTICULO DE ARCILLA") (coste_francos 2) (valor_proporciona 2))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 2) (nombre_carta "MONTICULO DE ARCILLA") (posicion 3))

    (of CARTA (nombre "MINA DE CARBON") (coste_francos 10) (valor_proporciona 10))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 2) (nombre_carta "MINA DE CARBON") (posicion 4))

    (of CARTA (nombre "SIDERURGIA") (coste_francos 22) (valor_proporciona 22))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 2) (nombre_carta "SIDERURGIA") (posicion 5))
    ; MAZO 3
    (of CARTA (nombre "AHUMADOR") (coste_francos 6) (valor_proporciona 6))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 3) (nombre_carta "AHUMADOR") (posicion 1))

    (of CARTA (nombre "MATADERO") (coste_francos 8) (valor_proporciona 8))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 3) (nombre_carta "MATADERO") (posicion 2))

    (of CARTA (nombre "COMPAÑIA NAVIERA") (coste_francos 10) (valor_proporciona 10))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 3) (nombre_carta "COMPAÑIA NAVIERA") (posicion 3))

    (of CARTA (nombre "PELETERIA") (coste_francos 12) (valor_proporciona 12))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 3) (nombre_carta "PELETERIA") (posicion 4))

    (of CARTA (nombre "HERRERIA") (coste_francos 12) (valor_proporciona 12))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 3) (nombre_carta "HERRERIA") (posicion 5))
    
)