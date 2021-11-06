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
;                                          ╦ ╦╔═╗╔═╗╦ ╦╔═╗╔═╗
;                                          ╠═╣║╣ ║  ╠═╣║ ║╚═╗
;                                          ╩ ╩╚═╝╚═╝╩ ╩╚═╝╚═╝
;             +-----------------------------+--------------+-------------------------+
;             |           Authors           |     NIAS     |          Githubs        |
;             +-----------------------------+--------------+-------------------------+
;             | Ricardo Grande Cros         |  100386336   |      ricardograndecros  |
;             | Diego Fernandez Sebastian   |  100387203   |      dfs99              |
;             +-----------------------------+--------------+-------------------------+
;



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

    (EDIFICIO_AYUNTAMIENTO (nombre_edificio "CONSTRUCTORA1"))
    (EDIFICIO_AYUNTAMIENTO (nombre_edificio "CONSTRUCTORA2"))
    (EDIFICIO_AYUNTAMIENTO (nombre_edificio "CONSTRUCTORA3"))
    (EDIFICIO_AYUNTAMIENTO (nombre_edificio "MERCADO"))


    (siguiente_barco_disponible BARCO_MADERA1 BARCO_MADERA2)
    (siguiente_barco_disponible BARCO_MADERA2 BARCO_MADERA3)
    )

    
    

; INSTANCIAS
(definstances situacion_inicial
    ; ====== JUGADORES ========
    ([Diego] of JUGADOR (nombre DIEGO))
    ([Ricardo] of JUGADOR (nombre RICARDO))
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
    ([pescado_ahumado] of RECURSO (nombre PESCADO_AHUMADO))
    ([carbon_vegetal] of RECURSO (nombre CARBON_VEGETAL))
    ([ladrillos] of RECURSO (nombre LADRILLOS))
    ([acero] of RECURSO (nombre ACERO))
    ([pan] of RECURSO (nombre PAN))
    ([carne] of RECURSO (nombre CARNE))
    ([coque] of RECURSO (nombre COQUE))
    ([cuero] of RECURSO (nombre CUERO))
    ; ====== MAZOS ======
    ([mazo1] of MAZO (id_mazo 1))
    ([mazo2] of MAZO (id_mazo 2))
    ([mazo3] of MAZO (id_mazo 3))
    ; ====== RONDA ======
    ([ronda1] of RONDA (nombre_ronda RONDA_1)(coste_comida 4)(hay_cosecha TRUE))
    ([ronda2] of RONDA (nombre_ronda RONDA_2)(coste_comida 7)(hay_cosecha TRUE))
    ([ronda3] of RONDA (nombre_ronda RONDA_3)(coste_comida 9)(hay_cosecha TRUE))
    ([ronda4] of RONDA (nombre_ronda RONDA_4)(coste_comida 13)(hay_cosecha TRUE))
    ([ronda5] of RONDA (nombre_ronda RONDA_5)(coste_comida 15)(hay_cosecha TRUE))
    ([ronda6] of RONDA (nombre_ronda RONDA_6)(coste_comida 17)(hay_cosecha TRUE))
    ([ronda7] of RONDA (nombre_ronda RONDA_7)(coste_comida 18)(hay_cosecha TRUE))
    ([ronda8] of RONDA (nombre_ronda RONDA_8)(coste_comida 20)(hay_cosecha FALSE))
    ; TODO: RONDA EXTRA FINAL, HACE COSAS DISTINTAS!
    ([rondaExtraFinal] of RONDA (nombre_ronda RONDA_EXTRA_FINAL)(coste_comida 0)(hay_cosecha FALSE))
    ; ======== LOSETAS =======
    ([loseta1] of LOSETA (posicion 1))
    ([loseta2] of LOSETA (posicion 2))
    ([loseta3] of LOSETA (posicion 3))
    ([loseta4] of LOSETA (posicion 4))
    ([loseta5] of LOSETA (posicion 5))
    ([loseta6] of LOSETA (posicion 6))
    ([loseta7] of LOSETA (posicion 7))
    ; ========= LOSETA TIENE RECURSO ========
    (of LOSETA_TIENE_RECURSO (posicion 1)(recurso MADERA)(cantidad 1))
    (of LOSETA_TIENE_RECURSO (posicion 1)(recurso GANADO)(cantidad 1))
    (of LOSETA_TIENE_RECURSO (posicion 2)(recurso MADERA)(cantidad 1))
    (of LOSETA_TIENE_RECURSO (posicion 2)(recurso FRANCO)(cantidad 1))
    (of LOSETA_TIENE_RECURSO (posicion 3)(recurso PESCADO)(cantidad 1))
    (of LOSETA_TIENE_RECURSO (posicion 3)(recurso ARCILLA)(cantidad 1))
    (of LOSETA_TIENE_RECURSO (posicion 4)(recurso HIERRO)(cantidad 1))
    (of LOSETA_TIENE_RECURSO (posicion 4)(recurso FRANCO)(cantidad 1))
    (of LOSETA_TIENE_RECURSO (posicion 5)(recurso MADERA)(cantidad 1))
    (of LOSETA_TIENE_RECURSO (posicion 5)(recurso ARCILLA)(cantidad 1))
    (of LOSETA_TIENE_RECURSO (posicion 6)(recurso MADERA)(cantidad 1))
    (of LOSETA_TIENE_RECURSO (posicion 6)(recurso PESCADO)(cantidad 1))
    (of LOSETA_TIENE_RECURSO (posicion 7)(recurso PESCADO)(cantidad 1))
    (of LOSETA_TIENE_RECURSO (posicion 7)(recurso GRANO)(cantidad 1))
    ; ========= RECURSOS INICIALES DE LOS JUGADORES =========
    ; == DIEGO
    ([pescado_diego] of JUGADOR_TIENE_RECURSO (nombre_jugador DIEGO) (recurso PESCADO) (cantidad 2))
    ([madera_diego] of JUGADOR_TIENE_RECURSO (nombre_jugador DIEGO) (recurso MADERA) (cantidad 2))
    ([arcilla_diego] of JUGADOR_TIENE_RECURSO (nombre_jugador DIEGO) (recurso ARCILLA) (cantidad 2))
    ([hierro_diego] of JUGADOR_TIENE_RECURSO (nombre_jugador DIEGO) (recurso HIERRO) (cantidad 2))
    ([grano_diego] of JUGADOR_TIENE_RECURSO (nombre_jugador DIEGO) (recurso GRANO) (cantidad 0))
    ([ganado_diego] of JUGADOR_TIENE_RECURSO (nombre_jugador DIEGO) (recurso GANADO) (cantidad 1))
    ([carbon_diego] of JUGADOR_TIENE_RECURSO (nombre_jugador DIEGO) (recurso CARBON) (cantidad 2))
    ([piel_diego] of JUGADOR_TIENE_RECURSO (nombre_jugador DIEGO) (recurso PIEL) (cantidad 2))
    ([pescado_ahumado_diego] of JUGADOR_TIENE_RECURSO (nombre_jugador DIEGO) (recurso PESCADO_AHUMADO) (cantidad 0))
    ([carbon_vegetal_diego] of JUGADOR_TIENE_RECURSO (nombre_jugador DIEGO) (recurso CARBON_VEGETAL) (cantidad 0))
    ([ladrillo_diego] of JUGADOR_TIENE_RECURSO (nombre_jugador DIEGO) (recurso LADRILLOS) (cantidad 0))
    ([acero_diego] of JUGADOR_TIENE_RECURSO (nombre_jugador DIEGO) (recurso ACERO) (cantidad 0))
    ([pan_diego] of JUGADOR_TIENE_RECURSO (nombre_jugador DIEGO) (recurso PAN) (cantidad 0))
    ([carne_diego] of JUGADOR_TIENE_RECURSO (nombre_jugador DIEGO) (recurso CARNE) (cantidad 0))
    ([coque_diego] of JUGADOR_TIENE_RECURSO (nombre_jugador DIEGO) (recurso COQUE) (cantidad 0))
    ([cuero_diego] of JUGADOR_TIENE_RECURSO (nombre_jugador DIEGO) (recurso CUERO) (cantidad 0))
    ; == RICARDO
    ([pescado_ricardo] of JUGADOR_TIENE_RECURSO (nombre_jugador RICARDO) (recurso PESCADO) (cantidad 2))
    ([madera_ricardo] of JUGADOR_TIENE_RECURSO (nombre_jugador RICARDO) (recurso MADERA) (cantidad 2))
    ([arcilla_ricardo] of JUGADOR_TIENE_RECURSO (nombre_jugador RICARDO) (recurso ARCILLA) (cantidad 2))
    ([hierro_ricardo] of JUGADOR_TIENE_RECURSO (nombre_jugador RICARDO) (recurso HIERRO) (cantidad 2))
    ([grano_ricardo] of JUGADOR_TIENE_RECURSO (nombre_jugador RICARDO) (recurso GRANO) (cantidad 0))
    ([ganado_ricardo] of JUGADOR_TIENE_RECURSO (nombre_jugador RICARDO) (recurso GANADO) (cantidad 1))
    ([carbon_ricardo] of JUGADOR_TIENE_RECURSO (nombre_jugador RICARDO) (recurso CARBON) (cantidad 2))
    ([piel_ricardo] of JUGADOR_TIENE_RECURSO (nombre_jugador RICARDO) (recurso PIEL) (cantidad 2))
    ([pescado_ahumado_ricardo] of JUGADOR_TIENE_RECURSO (nombre_jugador RICARDO) (recurso PESCADO_AHUMADO) (cantidad 0))
    ([carbon_vegetal_ricardo] of JUGADOR_TIENE_RECURSO (nombre_jugador RICARDO) (recurso CARBON_VEGETAL) (cantidad 0))
    ([ladrillos_ricardo] of JUGADOR_TIENE_RECURSO (nombre_jugador RICARDO) (recurso LADRILLOS) (cantidad 0))
    ([acero_ricardo] of JUGADOR_TIENE_RECURSO (nombre_jugador RICARDO) (recurso ACERO) (cantidad 0))
    ([pan_ricardo] of JUGADOR_TIENE_RECURSO (nombre_jugador RICARDO) (recurso PAN) (cantidad 0))
    ([carne_ricardo] of JUGADOR_TIENE_RECURSO (nombre_jugador RICARDO) (recurso CARNE) (cantidad 0))
    ([coque_ricardo] of JUGADOR_TIENE_RECURSO (nombre_jugador RICARDO) (recurso COQUE) (cantidad 0))
    ([cuero_ricardo] of JUGADOR_TIENE_RECURSO (nombre_jugador RICARDO) (recurso CUERO) (cantidad 0))

    ; ======= BONUS ========
    ([bonus_pescador] of BONUS (nombre PESCADOR))
    ([bonus_martillo] of BONUS (nombre MARTILLO))
    ; ======= JUGADOR TIENE BONUS =======
    ([bonus_pescador_diego] of JUGADOR_TIENE_BONUS (nombre_jugador DIEGO)(tipo PESCADOR)(cantidad 0))
    ([bonus_martillo_diego] of JUGADOR_TIENE_BONUS (nombre_jugador DIEGO)(tipo MARTILLO)(cantidad 0))
    ([bonus_pescador_ricardo] of JUGADOR_TIENE_BONUS (nombre_jugador RICARDO)(tipo PESCADOR)(cantidad 0))
    ([bonus_martillo_diego] of JUGADOR_TIENE_BONUS (nombre_jugador RICARDO)(tipo MARTILLO)(cantidad 0))

    ; 3 MADERA, 2 HIERRO, 1 ACERO.
    ; CARTAS AYUNTO
    (of CARTA (nombre "CONSTRUCTORA1") (valor 4))

    (of CARTA (nombre "CONSTRUCTORA2") (valor 6))
    (of COSTE_ENTRADA_CARTA (nombre_carta "CONSTRUCTORA2") (tipo COMIDA) (cantidad 1))

    (of CARTA (nombre "CONSTRUCTORA3") (valor 8))
    (of COSTE_ENTRADA_CARTA (nombre_carta "CONSTRUCTORA3") (tipo COMIDA) (cantidad 2))

    (of CARTA (nombre "MERCADO") (valor 6))
    (of COSTE_ENTRADA_CARTA (nombre_carta "MERCADO") (tipo DINERO) (cantidad 1))
    (of COSTE_ENTRADA_CARTA (nombre_carta "MERCADO") (tipo COMIDA) (cantidad 2))
    

    ; MAZO 1
    (of CARTA (nombre "HORNO DE CARBON VEGETAL") (valor 8))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 1) (nombre_carta "HORNO DE CARBON VEGETAL") (posicion 1))
    (of EDIFICIO_INPUT (nombre_carta "HORNO DE CARBON VEGETAL") (recurso MADERA) (cantidad_maxima -1))    
    (of EDIFICIO_OUTPUT (nombre_carta "HORNO DE CARBON VEGETAL") (recurso CARBON_VEGETAL) (cantidad_min_generada_por_unidad 1))

    (of CARTA (nombre "MUELLE") (valor 14))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 1) (nombre_carta "MUELLE") (posicion 2))
    ; ---> Muelle (2 de comida)
    (of COSTE_ENTRADA_CARTA (nombre_carta "MUELLE")(tipo COMIDA)(cantidad 2))


    (of CARTA (nombre "FABRICA DE LADRILLOS") (valor 14))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 1) (nombre_carta "FABRICA DE LADRILLOS") (posicion 3))
    ; ---> Fábrica de ladrillos (1 de comida)
    (of COSTE_ENTRADA_CARTA (nombre_carta "FABRICA DE LADRILLOS")(tipo COMIDA)(cantidad 1))
    (of EDIFICIO_INPUT (nombre_carta "FABRICA DE LADRILLOS") (recurso ARCILLA) (cantidad_maxima -1))
    (of EDIFICIO_OUTPUT (nombre_carta "FABRICA DE LADRILLOS") (recurso FRANCOS) (cantidad_min_generada_por_unidad 0.5))
    (of EDIFICIO_OUTPUT (nombre_carta "FABRICA DE LADRILLOS") (recurso LADRILLOS) (cantidad_min_generada_por_unidad 1))
    (of COSTE_ENERGIA (nombre_carta "FABRICA DE LADRILLOS") (coste_unitario TRUE) (cantidad 0.5))

    (of CARTA (nombre "COQUERIA") (valor 18))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 1) (nombre_carta "COQUERIA") (posicion 4))
    ; ---> Coquería (1 franco)
    (of COSTE_ENTRADA_CARTA (nombre_carta "COQUERIA")(tipo DINERO)(cantidad 1))
    (of EDIFICIO_INPUT (nombre_carta "COQUERIA") (recurso CARBON) (cantidad_maxima -1))
    (of EDIFICIO_OUTPUT (nombre_carta "COQUERIA") (recurso COQUE) (cantidad_min_generada_por_unidad 1))
(of EDIFICIO_OUTPUT (nombre_carta "COQUERIA") (recurso FRANCO) (cantidad_min_generada_por_unidad 1))

    (of CARTA_BANCO (nombre "BANCO") (coste 40) (valor 16))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 1) (nombre_carta "BANCO") (posicion 5))

    ; MAZO 2
    (of CARTA (nombre "PISCIFACTORIA") (valor 10))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 2) (nombre_carta "PISCIFACTORIA") (posicion 1))
    (of EDIFICIO_OUTPUT (nombre_carta "PISCIFACTORIA") (recurso PESCADO) (cantidad_min_generada_por_unidad 3))

    (of CARTA (nombre "PANADERIA") (valor 8))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 2) (nombre_carta "PANADERIA") (posicion 2))
    ; ---> Panadería (1 de comida)
    (of COSTE_ENTRADA_CARTA (nombre_carta "PANADERIA") (tipo COMIDA) (cantidad 1))
    (of EDIFICIO_INPUT (nombre_carta "PANADERIA") (recurso GRANO) (cantidad_maxima -1))
    (of EDIFICIO_OUTPUT (nombre_carta "PANADERIA") (recurso PAN) (cantidad_min_generada_por_unidad 1))
    (of EDIFICIO_OUTPUT (nombre_carta "PANADERIA") (recurso FRANCO) (cantidad_min_generada_por_unidad 0.5))
    (of COSTE_ENERGIA (nombre_carta "PANADERIA") (coste_unitario TRUE) (cantidad 0.5))

    (of CARTA (nombre "MONTICULO DE ARCILLA") (valor 2))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 2) (nombre_carta "MONTICULO DE ARCILLA") (posicion 3))
    ; ---> Montículo de arcilla (1 de comida)
    (of COSTE_ENTRADA_CARTA (nombre_carta "MONTICULO DE ARCILLA")(tipo COMIDA)(cantidad 1))
    (of EDIFICIO_OUTPUT (nombre_carta "MONTICULO DE ARCILLA") (recurso ARCILLA) (cantidad_min_generada_por_unidad 3))

    (of CARTA (nombre "MINA DE CARBON") (valor 10))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 2) (nombre_carta "MINA DE CARBON") (posicion 4))
    ; ---> Mina de carbón (2 de comida)
    (of COSTE_ENTRADA_CARTA (nombre_carta "MINA DE CARBON") (tipo COMIDA) (cantidad 2))
    (of EDIFICIO_OUTPUT (nombre_carta "MINA DE CARBON") (recurso CARBON) (cantidad_min_generada_por_unidad 3))

    (of CARTA (nombre "SIDERURGIA") (valor 22))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 2) (nombre_carta "SIDERURGIA") (posicion 5))
    ; ---> Siderurgia (2 francos)
    (of COSTE_ENTRADA_CARTA (nombre_carta "SIDERURGIA")(tipo DINERO)(cantidad 2))
    (of EDIFICIO_INPUT (nombre_carta "SIDERURGIA") (recurso HIERRO) (cantidad_maxima -1))
    (of EDIFICIO_OUTPUT (nombre_carta "SIDERURGIA") (recurso ACERO) (cantidad_min_generada_por_unidad 1))
    (of COSTE_ENERGIA (nombre_carta "SIDERURGIA") (coste_unitario FALSE) (cantidad 5))

    ; MAZO 3
    (of CARTA (nombre "AHUMADOR") (valor 6))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 3) (nombre_carta "AHUMADOR") (posicion 1))
    ; ---> Ahumador (2 de comida o 1 franco)
    (of COSTE_ENTRADA_CARTA (nombre_carta "AHUMADOR")(tipo DINERO)(cantidad 1))
    (of COSTE_ENTRADA_CARTA (nombre_carta "AHUMADOR")(tipo COMIDA)(cantidad 2))
     (of EDIFICIO_INPUT (nombre_carta "AHUMADOR") (recurso PESCADO) (cantidad_maxima 6))
    (of EDIFICIO_OUTPUT (nombre_carta "AHUMADOR") (recurso PESCADO_AHUMADO) (cantidad_min_generada_por_unidad 1))
    (of EDIFICIO_OUTPUT (nombre_carta "AHUMADOR") (recurso FRANCO) (cantidad_min_generada_por_unidad 0.5))
    (of COSTE_ENERGIA (nombre_carta "AHUMADOR") (coste_unitario FALSE) (cantidad 0.5))

    (of CARTA (nombre "MATADERO") (valor 8))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 3) (nombre_carta "MATADERO") (posicion 2))
     ; ---> Matedero
    (of COSTE_ENTRADA_CARTA (nombre_carta "MATADERO")(tipo DINERO)(cantidad 2))
     (of EDIFICIO_INPUT (nombre_carta "MATADERO") (recurso GANADO) (cantidad_maxima -1))
    (of EDIFICIO_OUTPUT (nombre_carta "MATADERO") (recurso CARNE) (cantidad_min_generada_por_unidad 1))
    (of EDIFICIO_OUTPUT (nombre_carta "MATADERO") (recurso PIEL) (cantidad_min_generada_por_unidad 0.5))


    (of CARTA (nombre "COMPAÑIA NAVIERA") (valor 10))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 3) (nombre_carta "COMPAÑIA NAVIERA") (posicion 3))
    ; ---> Compañía naviera (2 de comida)
    (of COSTE_ENTRADA_CARTA (nombre_carta "COMPAÑIA NAVIERA") (tipo COMIDA) (cantidad 2))
    (of COSTE_ENERGIA (nombre_carta "COMPAÑIA NAVIERA") (coste_unitario TRUE) (cantidad 3))

    (of CARTA (nombre "PELETERIA") (valor 12))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 3) (nombre_carta "PELETERIA") (posicion 4))
     (of EDIFICIO_INPUT (nombre_carta "PELETERIA") (recurso PIEL) (cantidad_maxima 4))
    (of EDIFICIO_OUTPUT (nombre_carta "PELETERIA") (recurso CUERO) (cantidad_min_generada_por_unidad 1))
    (of EDIFICIO_OUTPUT (nombre_carta "PELETERIA") (recurso FRANCO) (cantidad_min_generada_por_unidad 1))

    (of CARTA (nombre "HERRERIA") (valor 12))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 3) (nombre_carta "HERRERIA") (posicion 5))
    ; ---> Herrería (3 de comida o 1 franco, la comida represento todas las posibilidades?)
    (of COSTE_ENTRADA_CARTA (nombre_carta "HERRERIA")(tipo DINERO)(cantidad 1))
    (of COSTE_ENTRADA_CARTA (nombre_carta "HERRERIA")(tipo COMIDA)(cantidad 3))
    (of EDIFICIO_OUTPUT (nombre_carta "HERRERIA") (recurso HIERRO) (cantidad_min_generada_por_unidad 3))
    

    ;=================================================================
    ; BARCOS ?? lo de valor proporciona lo cambiamos al final o cómo???
    (of BARCO_MADERA (tipo MADERA) (nombre "BARCO_MADERA1") (valor 6))

    ; ======= RELACIONES CARTAS =======
    ; Carta tiene bonus
    (of CARTA_TIENE_BONUS (nombre_carta "PISCIFACTORIA")(bonus PESCADOR))
    (of CARTA_TIENE_BONUS (nombre_carta "MINA DE CARBON")(bonus MARTILLO))
    (of CARTA_TIENE_BONUS (nombre_carta "MONTICULO DE ARCILLA")(bonus MARTILLO))
    ; Ronda introduce barco ??? rellenar números de ronda
    (of RONDA_INTRODUCE_BARCO (nombre_ronda )(nombre_carta "BARCO_MADERA"))
    (of RONDA_INTRODUCE_BARCO (nombre_ronda )(nombre_carta "BARCO_HIERRO"))
    (of RONDA_INTRODUCE_BARCO (nombre_ronda )(nombre_carta "BARCO_ACERO"))


    

    

    

    

    






)