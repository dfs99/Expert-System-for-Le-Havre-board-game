; INSTANCIAS
(definstances instancias_iniciales
    "se llaman igual?"
    ; ====== JUGADORES ========
    (Tablero of PARTICIPANTE (nombre "AYUNTAMIENTO"))
    (Diego of JUGADOR (nombre "DIEGO")(num_barcos 1)(capacidad_envio 2)(demanda_comida_cubierta 4))
    (Ricardo of JUGADOR (nombre "RICARDO")(num_barcos 1)(capacidad_envio 2)(demanda_comida_cubierta 4))

    ; ([Ayuntamiento] of JUGADOR (nombre AYUNTAMIENTO))
    ; ====== RECURSOS =========
    (franco of RECURSO (nombre FRANCO))
    (madera of RECURSO (nombre MADERA))
    (pescado of RECURSO (nombre PESCADO))
    (arcilla of RECURSO (nombre ARCILLA))
    (hierro of RECURSO (nombre HIERRO))
    (grano of RECURSO (nombre GRANO))
    (ganado of RECURSO (nombre GANADO))
    (carbon of RECURSO (nombre CARBON))
    (piel of RECURSO (nombre PIEL))
    (pescado_ahumado of RECURSO (nombre PESCADO_AHUMADO))
    (carbon_vegetal of RECURSO (nombre CARBON_VEGETAL))
    (ladrillos of RECURSO (nombre LADRILLOS))
    (acero of RECURSO (nombre ACERO))
    (pan of RECURSO (nombre PAN))
    (carne of RECURSO (nombre CARNE))
    (coque of RECURSO (nombre COQUE))
    (cuero of RECURSO (nombre CUERO))
    ; ====== MAZOS ======
    (mazo1 of MAZO (id_mazo 1) (numero_cartas_en_mazo 5))
    (mazo2 of MAZO (id_mazo 2) (numero_cartas_en_mazo 5))
    (mazo3 of MAZO (id_mazo 3) (numero_cartas_en_mazo 5))
    (mazo_barcos_madera of MAZO (id_mazo 4) (numero_cartas_en_mazo 3))
    (mazo_barcos_hierro of MAZO (id_mazo 5) (numero_cartas_en_mazo 2))
    (mazo_barcos_acero of MAZO (id_mazo 6) (numero_cartas_en_mazo 2))
    (mazo_barcos_lujosos of MAZO (id_mazo 7) (numero_cartas_en_mazo 1))
    ; ====== RONDA ======
    (ronda1 of RONDA (nombre_ronda RONDA_1) (coste_comida 4) (hay_cosecha TRUE))
    (ronda2 of RONDA (nombre_ronda RONDA_2) (coste_comida 7) (hay_cosecha TRUE))
    (ronda3 of RONDA (nombre_ronda RONDA_3) (coste_comida 9) (hay_cosecha TRUE))
    (ronda4 of RONDA (nombre_ronda RONDA_4) (coste_comida 13) (hay_cosecha TRUE))
    (ronda5 of RONDA (nombre_ronda RONDA_5) (coste_comida 15) (hay_cosecha TRUE))
    (ronda6 of RONDA (nombre_ronda RONDA_6) (coste_comida 17) (hay_cosecha TRUE))
    (ronda7 of RONDA (nombre_ronda RONDA_7) (coste_comida 18) (hay_cosecha TRUE))
    (ronda8 of RONDA (nombre_ronda RONDA_8) (coste_comida 20) (hay_cosecha FALSE))
    ; TODO: RONDA EXTRA FINAL, HACE COSAS DISTINTAS!
    (rondaExtraFinal of RONDA (nombre_ronda RONDA_EXTRA_FINAL) (coste_comida 0) (hay_cosecha FALSE))
    ; ======== LOSETAS =======
    (loseta0 of LOSETA (posicion 0))
    (loseta1 of LOSETA (posicion 1))
    (loseta2 of LOSETA (posicion 2))
    (loseta3 of LOSETA (posicion 3))
    (loseta4 of LOSETA (posicion 4))
    (loseta5 of LOSETA (posicion 5)(intereses TRUE))
    (loseta6 of LOSETA (posicion 6))
    ; ========= LOSETA TIENE RECURSO ========

    ; POSICION INICIAL  (recurso MADERA) (cantidad 1))
    (of LOSETA_TIENE_RECURSO (posicion 0)   (recurso MADERA)   (cantidad 1))
    (of LOSETA_TIENE_RECURSO (posicion 0)   (recurso GANADO)   (cantidad 1))
    (of LOSETA_TIENE_RECURSO (posicion 1)   (recurso MADERA)   (cantidad 1))
    (of LOSETA_TIENE_RECURSO (posicion 1)   (recurso FRANCO)   (cantidad 1))
    (of LOSETA_TIENE_RECURSO (posicion 2)   (recurso PESCADO)  (cantidad 1))
    (of LOSETA_TIENE_RECURSO (posicion 2)   (recurso ARCILLA)  (cantidad 1))
    (of LOSETA_TIENE_RECURSO (posicion 3)   (recurso HIERRO)   (cantidad 1))
    (of LOSETA_TIENE_RECURSO (posicion 3)   (recurso FRANCO)   (cantidad 1))
    (of LOSETA_TIENE_RECURSO (posicion 4)   (recurso MADERA)   (cantidad 1))
    (of LOSETA_TIENE_RECURSO (posicion 4)   (recurso ARCILLA)  (cantidad 1))
    (of LOSETA_TIENE_RECURSO (posicion 5)   (recurso MADERA)   (cantidad 1))
    (of LOSETA_TIENE_RECURSO (posicion 5)   (recurso PESCADO)  (cantidad 1))
    (of LOSETA_TIENE_RECURSO (posicion 6)   (recurso PESCADO)  (cantidad 1))
    (of LOSETA_TIENE_RECURSO (posicion 6)   (recurso GRANO)    (cantidad 1))

    ; POSICION INICIAL 
    (posicion_diego of JUGADOR_ESTA_EN_LOSETA (posicion 0) (nombre_jugador "DIEGO"))
    (posicion_ricardo of JUGADOR_ESTA_EN_LOSETA (posicion -1) (nombre_jugador "RICARDO"))

    ; Para evitar generar dos reglas para entrar a un edificio (una para cuando se entra a un 
    ; edificio por primera vez y otra para cuando se cambia de edificio), se generan estos
    ; hechos iniciales con el edificio vacío. 
    (edificio_diego of JUGADOR_ESTA_EDIFICIO (nombre_jugador "DIEGO")(nombre_edificio ""))
    (edificio_ricardo of JUGADOR_ESTA_EDIFICIO (nombre_jugador "RICARDO")(nombre_edificio ""))
    ; lo mismo ocurre con edificio_usado
    (edificio_usado_diego of JUGADOR_HA_USADO_EDIFICIO (nombre_jugador "DIEGO")(nombre_edificio ""))
    (edificio_usado_ricardo of JUGADOR_HA_USADO_EDIFICIO (nombre_jugador "RICARDO")(nombre_edificio ""))

    ; ========= RECURSOS INICIALES DE LOS JUGADORES =========
    ; AYUNTAMIENTO
    (francos_ayunto of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "AYUNTAMIENTO") (recurso FRANCO) (cantidad 0))
    (pescado_ayunto of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "AYUNTAMIENTO") (recurso PESCADO) (cantidad 0))
    (pescado_ahumado_ayunto of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "AYUNTAMIENTO") (recurso PESCADO_AHUMADO) (cantidad 0))
    (pan_ayunto of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "AYUNTAMIENTO") (recurso PAN) (cantidad 0))
    (carne_ayunto of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "AYUNTAMIENTO") (recurso CARNE) (cantidad 0))

    ; == DIEGO
    (francos_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (recurso FRANCO) (cantidad 100))
    (pescado_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (recurso PESCADO) (cantidad 20000))
    (madera_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (recurso MADERA) (cantidad 12))
    (arcilla_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (recurso ARCILLA) (cantidad 6))
    (hierro_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (recurso HIERRO) (cantidad 10))
    (grano_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (recurso GRANO) (cantidad 1))
    (ganado_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (recurso GANADO) (cantidad 0))
    (carbon_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (recurso CARBON) (cantidad 2))
    (piel_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (recurso PIEL) (cantidad 2))
    (pescado_ahumado_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (recurso PESCADO_AHUMADO) (cantidad 0))
    (carbon_vegetal_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (recurso CARBON_VEGETAL) (cantidad 0))
    (ladrillo_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (recurso LADRILLOS) (cantidad 10))
    (acero_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (recurso ACERO) (cantidad 0))
    (pan_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (recurso PAN) (cantidad 0))
    (carne_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (recurso CARNE) (cantidad 0))
    (coque_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (recurso COQUE) (cantidad 0))
    (cuero_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (recurso CUERO) (cantidad 0))
    ; == RICARDO
    (francos_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (recurso FRANCO) (cantidad 100))
    (pescado_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (recurso PESCADO) (cantidad 100000))
    (madera_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (recurso MADERA) (cantidad 5))
    (arcilla_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (recurso ARCILLA) (cantidad 20))
    (hierro_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (recurso HIERRO) (cantidad 10))
    (grano_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (recurso GRANO) (cantidad 3))
    (ganado_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (recurso GANADO) (cantidad 5))
    (carbon_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (recurso CARBON) (cantidad 2))
    (piel_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (recurso PIEL) (cantidad 2))
    (pescado_ahumado_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (recurso PESCADO_AHUMADO) (cantidad 0))
    (carbon_vegetal_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (recurso CARBON_VEGETAL) (cantidad 0))
    (ladrillos_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (recurso LADRILLOS) (cantidad 5))
    (acero_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (recurso ACERO) (cantidad 0))
    (pan_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (recurso PAN) (cantidad 0))
    (carne_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (recurso CARNE) (cantidad 0))
    (coque_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (recurso COQUE) (cantidad 5))
    (cuero_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (recurso CUERO) (cantidad 0))

    ; EDIFICIOS INICIALES.
    (constructora1 of PARTICIPANTE_TIENE_CARTA (nombre_jugador "AYUNTAMIENTO") (nombre_carta "CONSTRUCTORA1"))
    (constructora2 of PARTICIPANTE_TIENE_CARTA (nombre_jugador "AYUNTAMIENTO") (nombre_carta "CONSTRUCTORA2"))
    (constructora3 of PARTICIPANTE_TIENE_CARTA (nombre_jugador "AYUNTAMIENTO") (nombre_carta "CONSTRUCTORA3"))
    (mercado of PARTICIPANTE_TIENE_CARTA (nombre_jugador "AYUNTAMIENTO") (nombre_carta "MERCADO"))

     ; BARCOS INICIALES
    (barco_inicial1 of PARTICIPANTE_TIENE_CARTA (nombre_jugador "DIEGO")(nombre_carta "BARCO_MADERA_INICIAL1"))
    (barco_inicial1 of PARTICIPANTE_TIENE_CARTA (nombre_jugador "RICARDO")(nombre_carta "BARCO_MADERA_INICIAL2"))

    ; ======= BONUS ========
    (bonus_pescador of BONUS (nombre PESCADOR))
    (bonus_martillo of BONUS (nombre MARTILLO))
    ; ======= JUGADOR TIENE BONUS =======
    (bonus_pescador_diego of JUGADOR_TIENE_BONUS (nombre_jugador "DIEGO")(tipo PESCADOR)(cantidad 0))
    (bonus_martillo_diego of JUGADOR_TIENE_BONUS (nombre_jugador "DIEGO")(tipo MARTILLO)(cantidad 0))
    (bonus_pescador_ricardo of JUGADOR_TIENE_BONUS (nombre_jugador "RICARDO")(tipo PESCADOR)(cantidad 0))
    (bonus_martillo_diego of JUGADOR_TIENE_BONUS (nombre_jugador "RICARDO")(tipo MARTILLO)(cantidad 0))

     ; 3 MADERA, 2 HIERRO, 1 ACERO.
    ; CARTAS AYUNTO
    ; BASICO INDUSTRIAL COMERCIAL BARCO NINGUNO
    (of CARTA (nombre "CONSTRUCTORA1") (valor 4) (tipo BASICO))

    (of CARTA (nombre "CONSTRUCTORA2") (valor 6) (tipo BASICO))
    (of COSTE_ENTRADA_CARTA (nombre_carta "CONSTRUCTORA2") (tipo COMIDA) (cantidad 1))

    (of CARTA (nombre "CONSTRUCTORA3") (valor 8) (tipo INDUSTRIAL))
    (of COSTE_ENTRADA_CARTA (nombre_carta "CONSTRUCTORA3") (tipo COMIDA) (cantidad 2))

    (of CARTA (nombre "MERCADO") (valor 6) (tipo NINGUNO))
    (of COSTE_ENTRADA_CARTA (nombre_carta "MERCADO") (tipo DINERO) (cantidad 1))
    (of COSTE_ENTRADA_CARTA (nombre_carta "MERCADO") (tipo COMIDA) (cantidad 2))
    

    ; MAZO 1
    (of CARTA_EDIFICIO_GENERADOR (nombre "HORNO DE CARBON VEGETAL") (valor 8) (tipo BASICO) (numero_recursos_salida 1))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 1) (nombre_carta "HORNO DE CARBON VEGETAL") (posicion_en_mazo 1))
    (of EDIFICIO_INPUT (nombre_carta "HORNO DE CARBON VEGETAL") (recurso MADERA) (cantidad_maxima 1000))    
    (of EDIFICIO_OUTPUT (nombre_carta "HORNO DE CARBON VEGETAL") (recurso CARBON_VEGETAL) (cantidad_min_generada_por_unidad 1))
    ; cuesta fabricarlo 1 de arcilla
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "HORNO DE CARBON VEGETAL") (cantidad_arcilla 1))


    (of CARTA (nombre "MUELLE") (valor 14) (tipo INDUSTRIAL))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 1) (nombre_carta "MUELLE") (posicion_en_mazo 2))
    ; ---> Muelle (2 de comida)
    (of COSTE_ENTRADA_CARTA (nombre_carta "MUELLE")(tipo COMIDA)(cantidad 2))
    ; cuesta fabricarlo 2 de madera 2 de arcilla y 2 de hierro.
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "MUELLE")(cantidad_madera 2)(cantidad_arcilla 2)(cantidad_hierro 2))

    (of CARTA_EDIFICIO_GENERADOR (nombre "FABRICA DE LADRILLOS") (valor 14) (tipo INDUSTRIAL) (numero_recursos_salida 2))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 1) (nombre_carta "FABRICA DE LADRILLOS") (posicion_en_mazo 3))
    ; ---> Fábrica de ladrillos (1 de comida)
    (of COSTE_ENTRADA_CARTA (nombre_carta "FABRICA DE LADRILLOS")(tipo COMIDA)(cantidad 1))
    (of EDIFICIO_INPUT (nombre_carta "FABRICA DE LADRILLOS") (recurso ARCILLA) (cantidad_maxima 1000))
    (of EDIFICIO_OUTPUT (nombre_carta "FABRICA DE LADRILLOS") (recurso FRANCO) (cantidad_min_generada_por_unidad 0.5))
    (of EDIFICIO_OUTPUT (nombre_carta "FABRICA DE LADRILLOS") (recurso LADRILLOS) (cantidad_min_generada_por_unidad 1))
    (of COSTE_ENERGIA (nombre_carta "FABRICA DE LADRILLOS") (coste_unitario TRUE) (cantidad 0.5))
    ; cuesta fabricarlo 2 madera 1 arcilla 1 hierro
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "FABRICA DE LADRILLOS") (cantidad_madera 2)(cantidad_arcilla 1)(cantidad_hierro 1))
    ; coste energia 0.5 energia por arcilla transformado.
    (of COSTE_ENERGIA (nombre_carta "FABRICA DE LADRILLOS") (coste_unitario TRUE) (cantidad 0.5))


    (of CARTA_EDIFICIO_GENERADOR (nombre "COQUERIA") (valor 18) (tipo INDUSTRIAL) (numero_recursos_salida 2))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 1) (nombre_carta "COQUERIA") (posicion_en_mazo 4))
    ; ---> Coquería (1 franco)
    (of COSTE_ENTRADA_CARTA (nombre_carta "COQUERIA")(tipo DINERO)(cantidad 1))
    (of EDIFICIO_INPUT (nombre_carta "COQUERIA") (recurso CARBON) (cantidad_maxima 1000))
    (of EDIFICIO_OUTPUT (nombre_carta "COQUERIA") (recurso COQUE) (cantidad_min_generada_por_unidad 1))
    (of EDIFICIO_OUTPUT (nombre_carta "COQUERIA") (recurso FRANCO) (cantidad_min_generada_por_unidad 1))
    ; cuesta fabricarlo 2 ladrillos 2 hierro
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "COQUERIA") (cantidad_ladrillo 2) (cantidad_hierro 2))


    (of CARTA_BANCO (nombre "BANCO") (coste 40) (valor 16))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 1) (nombre_carta "BANCO") (posicion_en_mazo 5))
    ; cuesta fabricarlo 4 ladrillos 1 acero
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "BANCO") (cantidad_ladrillo 4) (cantidad_acero 1))


    ; MAZO 2
    (of CARTA_EDIFICIO_GENERADOR (nombre "PISCIFACTORIA") (valor 10) (tipo BASICO) (numero_recursos_salida 1))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 2) (nombre_carta "PISCIFACTORIA") (posicion_en_mazo 1))
    (of EDIFICIO_OUTPUT (nombre_carta "PISCIFACTORIA") (recurso PESCADO) (cantidad_min_generada_por_unidad 3))
    ; cuesta fabricarlo 1 madera 1 arcilla.
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "PISCIFACTORIA") (cantidad_madera 1)(cantidad_arcilla 1))
    ; bonus salida
    (of CARTA_OUTPUT_BONUS (nombre_carta "PISCIFACTORIA") (bonus PESCADOR) (cantidad_maxima_permitida 10000))


    (of CARTA_EDIFICIO_GENERADOR (nombre "PANADERIA") (valor 8) (tipo BASICO) (numero_recursos_salida 2))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 2) (nombre_carta "PANADERIA") (posicion_en_mazo 2))
    ; ---> Panadería (1 de comida)
    (of COSTE_ENTRADA_CARTA (nombre_carta "PANADERIA") (tipo COMIDA) (cantidad 1))
    (of EDIFICIO_INPUT (nombre_carta "PANADERIA") (recurso GRANO) (cantidad_maxima 1000))
    (of EDIFICIO_OUTPUT (nombre_carta "PANADERIA") (recurso PAN) (cantidad_min_generada_por_unidad 1))
    (of EDIFICIO_OUTPUT (nombre_carta "PANADERIA") (recurso FRANCO) (cantidad_min_generada_por_unidad 0.5))
    
    ; cuesta fabricarlo 2 arcilla
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "PANADERIA")(cantidad_arcilla 2))
    ; coste energia 0.5 energia por grano transformado.
    (of COSTE_ENERGIA (nombre_carta "PANADERIA") (coste_unitario TRUE) (cantidad 0.5))

    (of CARTA_EDIFICIO_GENERADOR (nombre "MONTICULO DE ARCILLA") (valor 2) (tipo NINGUNO) (numero_recursos_salida 1))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 2) (nombre_carta "MONTICULO DE ARCILLA") (posicion_en_mazo 3))
    ; ---> Montículo de arcilla (1 de comida)
    (of COSTE_ENTRADA_CARTA (nombre_carta "MONTICULO DE ARCILLA")(tipo COMIDA)(cantidad 1))
    (of EDIFICIO_OUTPUT (nombre_carta "MONTICULO DE ARCILLA") (recurso ARCILLA) (cantidad_min_generada_por_unidad 3))
    ; bonus salida
    (of CARTA_OUTPUT_BONUS (nombre_carta "MONTICULO DE ARCILLA") (bonus MARTILLO) (cantidad_maxima_permitida 10000))

    (of CARTA_EDIFICIO_GENERADOR (nombre "MINA DE CARBON") (valor 10) (tipo INDUSTRIAL) (numero_recursos_salida 1))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 2) (nombre_carta "MINA DE CARBON") (posicion_en_mazo 4))
    ; ---> Mina de carbón (2 de comida)
    (of COSTE_ENTRADA_CARTA (nombre_carta "MINA DE CARBON") (tipo COMIDA) (cantidad 2))
    (of EDIFICIO_OUTPUT (nombre_carta "MINA DE CARBON") (recurso CARBON) (cantidad_min_generada_por_unidad 3))
    ; cuesta fabricarlo 1 madera 3 arcilla
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "MINA DE CARBON")(cantidad_madera 1)(cantidad_arcilla 3))
    ; bonus salida
    (of CARTA_OUTPUT_BONUS (nombre_carta "MINA DE CARBON") (bonus MARTILLO) (cantidad_maxima_permitida 1))


    (of CARTA_EDIFICIO_GENERADOR (nombre "SIDERURGIA") (valor 22) (tipo INDUSTRIAL) (numero_recursos_salida 1))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 2) (nombre_carta "SIDERURGIA") (posicion_en_mazo 5))
    ; ---> Siderurgia (2 francos)
    (of COSTE_ENTRADA_CARTA (nombre_carta "SIDERURGIA")(tipo DINERO)(cantidad 2))
    (of EDIFICIO_INPUT (nombre_carta "SIDERURGIA") (recurso HIERRO) (cantidad_maxima 1000))
    (of EDIFICIO_OUTPUT (nombre_carta "SIDERURGIA") (recurso ACERO) (cantidad_min_generada_por_unidad 1))
    ; cuesta fabricarlo: 4 LADRILLOS Y 2 HIERRO
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "SIDERURGIA")(cantidad_ladrillo 4)(cantidad_hierro 2))
    ; coste energía 5 uds por acero generado.
    (of COSTE_ENERGIA (nombre_carta "SIDERURGIA") (coste_unitario TRUE) (cantidad 5))

    ; MAZO 3
    (of CARTA_EDIFICIO_GENERADOR (nombre "AHUMADOR") (valor 6) (tipo BASICO) (numero_recursos_salida 2))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 3) (nombre_carta "AHUMADOR") (posicion_en_mazo 1))
    ; ---> Ahumador (2 de comida o 1 franco)
    (of COSTE_ENTRADA_CARTA (nombre_carta "AHUMADOR")(tipo DINERO)(cantidad 1))
    (of COSTE_ENTRADA_CARTA (nombre_carta "AHUMADOR")(tipo COMIDA)(cantidad 2))
    (of EDIFICIO_INPUT (nombre_carta "AHUMADOR") (recurso PESCADO) (cantidad_maxima 6))
    (of EDIFICIO_OUTPUT (nombre_carta "AHUMADOR") (recurso PESCADO_AHUMADO) (cantidad_min_generada_por_unidad 1))
    (of EDIFICIO_OUTPUT (nombre_carta "AHUMADOR") (recurso FRANCO) (cantidad_min_generada_por_unidad 0.5))
    ; cuesta fabricarlo: 2 madera y 1 arcilla
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "AHUMADOR")(cantidad_madera 2)(cantidad_arcilla 1))
    ; coste energia, 1 ud por 1 - 6 pescados
    (of COSTE_ENERGIA (nombre_carta "AHUMADOR") (coste_unitario FALSE) (cantidad 1))

    (of CARTA_EDIFICIO_GENERADOR (nombre "MATADERO") (valor 8) (tipo BASICO) (numero_recursos_salida 2))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 3) (nombre_carta "MATADERO") (posicion_en_mazo 2))
     ; ---> Matedero
    (of COSTE_ENTRADA_CARTA (nombre_carta "MATADERO")(tipo DINERO)(cantidad 2))
    (of EDIFICIO_INPUT (nombre_carta "MATADERO") (recurso GANADO) (cantidad_maxima 1000))
    (of EDIFICIO_OUTPUT (nombre_carta "MATADERO") (recurso CARNE) (cantidad_min_generada_por_unidad 1))
    (of EDIFICIO_OUTPUT (nombre_carta "MATADERO") (recurso PIEL) (cantidad_min_generada_por_unidad 0.5))
    ; cuesta fabricarlo: 1 madera, 1 arcilla y 1 hierro.
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "MATADERO")(cantidad_madera 1)(cantidad_arcilla 1)(cantidad_hierro 1))

    (of CARTA (nombre "COMPAÑIA NAVIERA") (valor 10) (tipo COMERCIAL))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 3) (nombre_carta "COMPAÑIA NAVIERA") (posicion_en_mazo 3))
    ; ---> Compañía naviera (2 de comida)
    (of COSTE_ENTRADA_CARTA (nombre_carta "COMPAÑIA NAVIERA") (tipo COMIDA) (cantidad 2))
    ; cuesta fabricarlo: 2 madera y 3 ladrillos
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "COMPAÑIA NAVIERA")(cantidad_madera 2)(cantidad_ladrillo 3))
    ; coste energia: 3 uds por barco
    (of COSTE_ENERGIA (nombre_carta "COMPAÑIA NAVIERA") (coste_unitario TRUE) (cantidad 3))


    (of CARTA_EDIFICIO_GENERADOR (nombre "PELETERIA") (valor 12) (tipo BASICO) (numero_recursos_salida 2))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 3) (nombre_carta "PELETERIA") (posicion_en_mazo 4))
    (of EDIFICIO_INPUT (nombre_carta "PELETERIA") (recurso PIEL) (cantidad_maxima 4))
    (of EDIFICIO_OUTPUT (nombre_carta "PELETERIA") (recurso CUERO) (cantidad_min_generada_por_unidad 1))
    (of EDIFICIO_OUTPUT (nombre_carta "PELETERIA") (recurso FRANCO) (cantidad_min_generada_por_unidad 1))
    ; cuesta fabricarlo 1 madera y 1 ladrillo.
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "PELETERIA")(cantidad_madera 1)(cantidad_ladrillo 1))

    (of CARTA_EDIFICIO_GENERADOR (nombre "HERRERIA") (valor 12) (tipo INDUSTRIAL) (numero_recursos_salida 1))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 3) (nombre_carta "HERRERIA") (posicion_en_mazo 5))
    ; ---> Herrería (3 de comida o 1 franco, la comida represento todas las posibilidades?)
    (of COSTE_ENTRADA_CARTA (nombre_carta "HERRERIA")(tipo DINERO)(cantidad 1))
    (of COSTE_ENTRADA_CARTA (nombre_carta "HERRERIA")(tipo COMIDA)(cantidad 3))
    (of EDIFICIO_OUTPUT (nombre_carta "HERRERIA") (recurso HIERRO) (cantidad_min_generada_por_unidad 3))
    ; cuesta fabricarlo 3 madera y 2 ladrillo
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "HERRERIA")(cantidad_madera 3)(cantidad_ladrillo 2))


    (of CARTA_TIENE_BONUS (nombre_carta "PISCIFACTORIA")(bonus PESCADOR))
    (of CARTA_TIENE_BONUS (nombre_carta "AHUMADOR")(bonus PESCADOR))
    (of CARTA_TIENE_BONUS (nombre_carta "COMPAÑIA NAVIERA")(bonus PESCADOR))
    (of CARTA_TIENE_BONUS (nombre_carta "HERRERIA")(bonus MARTILLO))
    (of CARTA_TIENE_BONUS (nombre_carta "CONSTRUCTORA1")(bonus MARTILLO))
    (of CARTA_TIENE_BONUS (nombre_carta "CONSTRUCTORA2")(bonus MARTILLO))
    (of CARTA_TIENE_BONUS (nombre_carta "CONSTRUCTORA3")(bonus MARTILLO))

    ; BARCOS 
    ; Barcos iniciales de los jugadores
    (of BARCO (nombre "BARCO_MADERA_INICIAL1")(valor 2)(coste 14)(uds_comida_genera 4)(capacidad_envio 2))
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "BARCO_MADERA_INICIAL1")(cantidad_madera 5))

    (of BARCO (nombre "BARCO_MADERA_INICIAL2")(valor 2)(coste 14)(uds_comida_genera 4)(capacidad_envio 2))
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "BARCO_MADERA_INICIAL2")(cantidad_madera 5))
    ; Barcos en los mazos
    (of BARCO (nombre "BARCO_MADERA1") (valor 4) (coste 14) (uds_comida_genera 4) (capacidad_envio 2))
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "BARCO_MADERA1") (cantidad_madera 5))
    (of BARCO (nombre "BARCO_MADERA2") (valor 6) (coste 14) (uds_comida_genera 4) (capacidad_envio 2))
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "BARCO_MADERA2") (cantidad_madera 5))
    (of BARCO (nombre "BARCO_MADERA3") (valor 2) (coste 14) (uds_comida_genera 4) (capacidad_envio 2))
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "BARCO_MADERA3") (cantidad_madera 5))
    (of BARCO (nombre "BARCO_HIERRO1") (valor 6) (coste 20) (uds_comida_genera 5) (capacidad_envio 3))
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "BARCO_HIERRO1") (cantidad_hierro 4))
    (of BARCO (nombre "BARCO_HIERRO2") (valor 8) (coste 20) (uds_comida_genera 5) (capacidad_envio 3))
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "BARCO_HIERRO2") (cantidad_hierro 4))
    (of BARCO (nombre "BARCO_ACERO1") (valor 16) (coste 30) (uds_comida_genera 7) (capacidad_envio 4))
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "BARCO_ACERO1") (cantidad_acero 2))
    (of BARCO (nombre "BARCO_ACERO2") (valor 20) (coste 30) (uds_comida_genera 7) (capacidad_envio 4))
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "BARCO_ACERO2") (cantidad_acero 2))
    ; IMPORTANTE: el barco lujoso, al no reducir la comida necesaria al final de ronda 
    ; ni poderse comprar con francos (coste), es sencillamente una instancia de la 
    ; clase carta. 
    (of CARTA (nombre "BARCO_LUJOSO") (valor 30))
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "BARCO_LUJOSO") (cantidad_acero 3))
        ; Ronda introduce barco al final de la ronda.
    (of RONDA_INTRODUCE_BARCO (nombre_ronda RONDA_1) (nombre_carta "BARCO_MADERA1"))
    (of RONDA_INTRODUCE_BARCO (nombre_ronda RONDA_2) (nombre_carta "BARCO_MADERA2"))
    (of RONDA_INTRODUCE_BARCO (nombre_ronda RONDA_3) (nombre_carta "BARCO_MADERA3"))
    (of RONDA_INTRODUCE_BARCO (nombre_ronda RONDA_4) (nombre_carta "BARCO_HIERRO1"))
    (of RONDA_INTRODUCE_BARCO (nombre_ronda RONDA_5) (nombre_carta "BARCO_HIERRO2"))
    (of RONDA_INTRODUCE_BARCO (nombre_ronda RONDA_6) (nombre_carta "BARCO_ACERO1"))
    (of RONDA_INTRODUCE_BARCO (nombre_ronda RONDA_7) (nombre_carta "BARCO_ACERO2"))
    (of RONDA_INTRODUCE_BARCO (nombre_ronda RONDA_8) (nombre_carta "BARCO_LUJOSO"))

    (of CARTA_PERTENECE_A_MAZO (id_mazo 4) (nombre_carta "BARCO_MADERA1") (posicion_en_mazo 1))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 4) (nombre_carta "BARCO_MADERA2") (posicion_en_mazo 2))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 4) (nombre_carta "BARCO_MADERA3") (posicion_en_mazo 3))

    (of CARTA_PERTENECE_A_MAZO (id_mazo 5) (nombre_carta "BARCO_HIERRO1") (posicion_en_mazo 1))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 5) (nombre_carta "BARCO_HIERRO2") (posicion_en_mazo 2))

    (of CARTA_PERTENECE_A_MAZO (id_mazo 6) (nombre_carta "BARCO_ACERO1") (posicion_en_mazo 1))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 6) (nombre_carta "BARCO_ACERO2") (posicion_en_mazo 2))

    (of CARTA_PERTENECE_A_MAZO (id_mazo 7) (nombre_carta "BARCO_LUJOSO") (posicion_en_mazo 1))

    ; Ronda introduce primer edificio del mazo aleatoriamente.
    (of RONDA_ASIGNA_EDIFICIO (nombre_ronda RONDA_1) (id_mazo 1))
    (of RONDA_ASIGNA_EDIFICIO (nombre_ronda RONDA_3) (id_mazo 2))
    (of RONDA_ASIGNA_EDIFICIO (nombre_ronda RONDA_5) (id_mazo 3))
    (of RONDA_ASIGNA_EDIFICIO (nombre_ronda RONDA_7) (id_mazo 1))


    ;(of PARTICIPANTE_TIENE_CARTA (nombre_jugador "DIEGO")(nombre_carta "COMPAÑIA NAVIERA"))

)

(deffacts hechos_iniciales
    
    (ronda_actual RONDA_1)
    ; hechos semáforo para cambiar de jugador
    (siguiente_jugador "DIEGO" "RICARDO")
    (siguiente_jugador "RICARDO" "DIEGO")
    ; turno
    (turno "DIEGO")
    ; hechos semaforo para cambiar de rondas.
    (siguiente_ronda RONDA_1 RONDA_2)
    (siguiente_ronda RONDA_2 RONDA_3)
    (siguiente_ronda RONDA_3 RONDA_4)
    (siguiente_ronda RONDA_4 RONDA_5)
    (siguiente_ronda RONDA_5 RONDA_6)
    (siguiente_ronda RONDA_6 RONDA_7)
    (siguiente_ronda RONDA_7 RONDA_8)
    (siguiente_ronda RONDA_8 RONDA_EXTRA_FINAL)
    ; oferta recursos inicial partida corta 2 jugadores
    (OFERTA_RECURSO (recurso FRANCO) (cantidad 3))
    (OFERTA_RECURSO (recurso PESCADO) (cantidad 3))
    (OFERTA_RECURSO (recurso MADERA) (cantidad 3))
    (OFERTA_RECURSO (recurso ARCILLA) (cantidad 2))
    (OFERTA_RECURSO (recurso HIERRO) (cantidad 1))
    (OFERTA_RECURSO (recurso GRANO) (cantidad 1))
    (OFERTA_RECURSO (recurso GANADO) (cantidad 2))

   


    ; Asignación barcos a mazos para poder devolverlos a su mazo tras ser vendidos
    (barco_pertenece_mazo "BARCO_MADERA1" 4)
    (barco_pertenece_mazo "BARCO_MADERA2" 4)
    (barco_pertenece_mazo "BARCO_MADERA3" 4)
    (barco_pertenece_mazo "BARCO_MADERA_INICIAL1" 4)
    (barco_pertenece_mazo "BARCO_MADERA_INICIAL2" 4)

    (barco_pertenece_mazo "BARCO_HIERRO1" 5)
    (barco_pertenece_mazo "BARCO_HIERRO2" 5)
    
    (barco_pertenece_mazo "BARCO_ACERO1" 6)
    (barco_pertenece_mazo "BARCO_ACERO2" 6)

    (barco_pertenece_mazo "BARCO_LUJOSO" 7)


    (edificio_usado "" "DIEGO")
    (edificio_usado "" "RICARDO")


    ; COSAS QUE VAMOS METIENDO
    ;(deseo_coger_recurso "DIEGO" GANADO)
    ;(deseo_coger_recurso "DIEGO" GRANO)
    ;(deseo_coger_recurso "DIEGO" FRANCO)
    ;(deseo_coger_recurso "DIEGO" MADERA)
    ;(deseo_coger_recurso "DIEGO" HIERRO)
    ;(deseo_coger_recurso "DIEGO" ARCILLA)
    ;(deseo_coger_recurso "DIEGO" PESCADO)

    ;(deseo_coger_recurso "RICARDO" ARCILLA)
    ;(deseo_coger_recurso "RICARDO" FRANCO)
    ;(deseo_coger_recurso "RICARDO" MADERA)
    ;(deseo_coger_recurso "RICARDO" HIERRO)
    ;(deseo_coger_recurso "RICARDO" GRANO)
    ;(deseo_coger_recurso "RICARDO" PESCADO)
    ;(deseo_coger_recurso "RICARDO" GANADO)
    ;(fin_actividad_principal "DIEGO")
    ;(deseo_comprar_edificio "DIEGO" "CONSTRUCTORA2")
    (deseo_comprar_edificio "DIEGO" "HORNO DE CARBON VEGETAL")
    (deseo_comprar_edificio "RICARDO" "MUELLE")
    ;(deseo_vender_carta "DIEGO" "CONSTRUCTORA1")
    ;(deseo_comprar_edificio "RICARDO" "CONSTRUCTORA2")
    ;(deseo_comprar_edificio "DIEGO" "BANCO")


    (BARCO_DISPONIBLE (nombre_barco "BARCO_MADERA1"))
    ;(deseo_comprar_barco "DIEGO" "BARCO_MADERA1")
    ;(deseo_comprar_barco "RICARDO" "BARCO_MADERA2")

    ;(deseo_vender_barco "DIEGO" "BARCO_MADERA1")
    ; pagar con pescado
    (deseo_pagar_demanda "DIEGO" 40 0 0 0 0)
    (deseo_pagar_demanda "RICARDO" 40 0 0 0 0)

    ;(deseo_pagar_deuda "DIEGO" 5)
    ;(deseo_pagar_deuda "DIEGO" 2)

    (deseo_entrar_edificio "DIEGO" "MUELLE" COMIDA PESCADO)
    (deseo_construccion "DIEGO" "BARCO_MADERA1")
    ;(deseo_entrar_edificio "RICARDO" "COMPAÑIA NAVIERA" COMIDA PESCADO)
    ;(deseo_entrar_edificio "RICARDO" "SIDERURGIA" DINERO FRANCO )
    ;(deseo_construccion "DIEGO" "FABRICA DE LADRILLOS")
    ;(deseo_construccion "RICARDO" "FABRICA DE LADRILLOS")

    
    ;(deseo_usar_compañia_naviera "RICARDO" 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0)
    ;(deseo_generar_con_recurso "RICARDO" "MATADERO" GANADO 5)
    ;(deseo_emplear_energia "RICARDO" "AHUMADOR" 1 0 0 0)
    ;(deseo_emplear_energia ?nombre_jugador ?nombre_edificio ?cantidad_madera ?cantidad_carbon_vegetal ?cantidad_carbon ?cantidad_coque)
)
