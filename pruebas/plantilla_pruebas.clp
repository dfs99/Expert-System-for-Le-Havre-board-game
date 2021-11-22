; Plantilla de pruebas para que cualquiera pueda introducir valores y generar sus propias pruebas.


(definstances instancias_iniciales

    
    (Tablero of PARTICIPANTE (nombre "AYUNTAMIENTO"))
    (Diego of JUGADOR (nombre "DIEGO")(num_barcos 1)(capacidad_envio 2)(demanda_comida_cubierta 4))
    (Ricardo of JUGADOR (nombre "RICARDO")(num_barcos 1)(capacidad_envio 2)(demanda_comida_cubierta 4))

    
    (franco of RECURSO (nombre FRANCO) (valor_unitario_en_compañia_naviera 1)) 
    (madera of RECURSO (nombre MADERA) (valor_unitario_en_compañia_naviera 1)) 
    (pescado of RECURSO_ALIMENTICIO (nombre PESCADO) (comida_genera 1) (valor_unitario_en_compañia_naviera 1)) 
    (arcilla of RECURSO (nombre ARCILLA)(valor_unitario_en_compañia_naviera 1)) 
    (hierro of RECURSO (nombre HIERRO) (valor_unitario_en_compañia_naviera 2)) 
    (grano of RECURSO (nombre GRANO) (valor_unitario_en_compañia_naviera 1)) 
    (ganado of RECURSO (nombre GANADO) (valor_unitario_en_compañia_naviera 3)) 
    (carbon of RECURSO (nombre CARBON)(valor_unitario_en_compañia_naviera 3)) 
    (piel of RECURSO (nombre PIEL) (valor_unitario_en_compañia_naviera 2)) 
    (pescado_ahumado of RECURSO_ALIMENTICIO (nombre PESCADO_AHUMADO) (comida_genera 2) (valor_unitario_en_compañia_naviera 2)) 
    (carbon_vegetal of RECURSO (nombre CARBON_VEGETAL) (valor_unitario_en_compañia_naviera 2)) 
    (ladrillos of RECURSO (nombre LADRILLOS) (valor_unitario_en_compañia_naviera 2)) 
    (acero of RECURSO (nombre ACERO) (valor_unitario_en_compañia_naviera 8)) 
    (pan of RECURSO_ALIMENTICIO (nombre PAN) (comida_genera 3) (valor_unitario_en_compañia_naviera 3)) 
    (carne of RECURSO_ALIMENTICIO (nombre CARNE) (comida_genera 3) (valor_unitario_en_compañia_naviera 2)) 
    (coque of RECURSO (nombre COQUE) (valor_unitario_en_compañia_naviera 5)) 
    (cuero of RECURSO (nombre CUERO)(valor_unitario_en_compañia_naviera 4)) 
    
    (mazo1 of MAZO (id_mazo 1) (numero_cartas_en_mazo 5))
    (mazo2 of MAZO (id_mazo 2) (numero_cartas_en_mazo 5))
    (mazo3 of MAZO (id_mazo 3) (numero_cartas_en_mazo 5))
    (mazo_barcos_madera of MAZO (id_mazo 4) (numero_cartas_en_mazo 3))
    (mazo_barcos_hierro of MAZO (id_mazo 5) (numero_cartas_en_mazo 2))
    (mazo_barcos_acero of MAZO (id_mazo 6) (numero_cartas_en_mazo 2))
    (mazo_barcos_lujosos of MAZO (id_mazo 7) (numero_cartas_en_mazo 1))
    
    (ronda1 of RONDA (nombre_ronda RONDA_1) (coste_comida 4) (hay_cosecha TRUE))
    (ronda2 of RONDA (nombre_ronda RONDA_2) (coste_comida 7) (hay_cosecha TRUE))
    (ronda3 of RONDA (nombre_ronda RONDA_3) (coste_comida 9) (hay_cosecha TRUE))
    (ronda4 of RONDA (nombre_ronda RONDA_4) (coste_comida 13) (hay_cosecha TRUE))
    (ronda5 of RONDA (nombre_ronda RONDA_5) (coste_comida 15) (hay_cosecha TRUE))
    (ronda6 of RONDA (nombre_ronda RONDA_6) (coste_comida 17) (hay_cosecha TRUE))
    (ronda7 of RONDA (nombre_ronda RONDA_7) (coste_comida 18) (hay_cosecha TRUE))
    (ronda8 of RONDA (nombre_ronda RONDA_8) (coste_comida 20) (hay_cosecha FALSE))
    (rondaExtraFinal of RONDA (nombre_ronda RONDA_EXTRA_FINAL) (coste_comida 0) (hay_cosecha FALSE))
    
    (loseta0 of LOSETA (posicion 0))
    (loseta1 of LOSETA (posicion 1))
    (loseta2 of LOSETA (posicion 2))
    (loseta3 of LOSETA (posicion 3))
    (loseta4 of LOSETA (posicion 4))
    (loseta5 of LOSETA (posicion 5)(intereses TRUE))
    (loseta6 of LOSETA (posicion 6))
    

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


    (posicion_diego of JUGADOR_ESTA_EN_LOSETA (posicion 0) (nombre_jugador "DIEGO"))
    (posicion_ricardo of JUGADOR_ESTA_EN_LOSETA (posicion -1) (nombre_jugador "RICARDO"))

    (edificio_diego of JUGADOR_ESTA_EDIFICIO (nombre_jugador "DIEGO")(nombre_edificio ""))
    (edificio_ricardo of JUGADOR_ESTA_EDIFICIO (nombre_jugador "RICARDO")(nombre_edificio ""))

    (edificio_usado_diego of JUGADOR_HA_USADO_EDIFICIO (nombre_jugador "DIEGO")(nombre_edificio ""))
    (edificio_usado_ricardo of JUGADOR_HA_USADO_EDIFICIO (nombre_jugador "RICARDO")(nombre_edificio ""))

    
    (francos_ayunto of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "AYUNTAMIENTO") (tipo DINERO) (recurso FRANCO) (cantidad 0))
    (pescado_ayunto of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "AYUNTAMIENTO") (tipo COMIDA) (recurso PESCADO) (cantidad 0))
    (pescado_ahumado_ayunto of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "AYUNTAMIENTO") (tipo COMIDA) (recurso PESCADO_AHUMADO) (cantidad 0))
    (pan_ayunto of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "AYUNTAMIENTO") (tipo COMIDA) (recurso PAN) (cantidad 0))
    (carne_ayunto of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "AYUNTAMIENTO") (tipo COMIDA) (recurso CARNE) (cantidad 0))

    (francos_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (tipo DINERO) (recurso FRANCO) (cantidad 5))
    (pescado_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (tipo COMIDA) (recurso PESCADO) (cantidad 2))
    (madera_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (tipo OTRO) (recurso MADERA) (cantidad 2))
    (arcilla_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (tipo OTRO) (recurso ARCILLA) (cantidad 2))
    (hierro_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (tipo OTRO) (recurso HIERRO) (cantidad 2))
    (grano_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (tipo OTRO) (recurso GRANO) (cantidad 0))
    (ganado_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (tipo OTRO) (recurso GANADO) (cantidad 1))
    (carbon_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (tipo OTRO) (recurso CARBON) (cantidad 2))
    (piel_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (tipo OTRO) (recurso PIEL) (cantidad 2))
    (pescado_ahumado_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (tipo COMIDA) (recurso PESCADO_AHUMADO) (cantidad 0))
    (carbon_vegetal_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (tipo OTRO) (recurso CARBON_VEGETAL) (cantidad 0))
    (ladrillo_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (tipo OTRO) (recurso LADRILLOS) (cantidad 0))
    (acero_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (tipo OTRO) (recurso ACERO) (cantidad 0))
    (pan_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (tipo COMIDA) (recurso PAN) (cantidad 0))
    (carne_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (tipo COMIDA) (recurso CARNE) (cantidad 0))
    (coque_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (tipo OTRO) (recurso COQUE) (cantidad 0))
    (cuero_diego of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "DIEGO") (tipo OTRO) (recurso CUERO) (cantidad 0))
    
    (francos_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (tipo DINERO) (recurso FRANCO) (cantidad 5))
    (pescado_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (tipo COMIDA) (recurso PESCADO) (cantidad 2))
    (madera_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (tipo OTRO) (recurso MADERA) (cantidad 2))
    (arcilla_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (tipo OTRO) (recurso ARCILLA) (cantidad 2))
    (hierro_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (tipo OTRO) (recurso HIERRO) (cantidad 2))
    (grano_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (tipo OTRO) (recurso GRANO) (cantidad 0))
    (ganado_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (tipo OTRO) (recurso GANADO) (cantidad 1))
    (carbon_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (tipo OTRO) (recurso CARBON) (cantidad 2))
    (piel_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (tipo OTRO) (recurso PIEL) (cantidad 2))
    (pescado_ahumado_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (tipo COMIDA) (recurso PESCADO_AHUMADO) (cantidad 0))
    (carbon_vegetal_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (tipo OTRO) (recurso CARBON_VEGETAL) (cantidad 0))
    (ladrillos_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (tipo OTRO) (recurso LADRILLOS) (cantidad 0))
    (acero_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (tipo OTRO) (recurso ACERO) (cantidad 0))
    (pan_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (tipo COMIDA) (recurso PAN) (cantidad 0))
    (carne_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (tipo COMIDA) (recurso CARNE) (cantidad 0))
    (coque_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (tipo OTRO) (recurso COQUE) (cantidad 0))
    (cuero_ricardo of PARTICIPANTE_TIENE_RECURSO (nombre_jugador "RICARDO") (tipo OTRO) (recurso CUERO) (cantidad 0))

    
    (constructora1 of PARTICIPANTE_TIENE_CARTA (nombre_jugador "AYUNTAMIENTO") (nombre_carta "CONSTRUCTORA1"))
    (constructora2 of PARTICIPANTE_TIENE_CARTA (nombre_jugador "AYUNTAMIENTO") (nombre_carta "CONSTRUCTORA2"))
    (constructora3 of PARTICIPANTE_TIENE_CARTA (nombre_jugador "AYUNTAMIENTO") (nombre_carta "CONSTRUCTORA3"))
    (mercado of PARTICIPANTE_TIENE_CARTA (nombre_jugador "AYUNTAMIENTO") (nombre_carta "MERCADO"))

    
    (barco_inicial1 of PARTICIPANTE_TIENE_CARTA (nombre_jugador "DIEGO")(nombre_carta "BARCO_MADERA_INICIAL1"))
    (barco_inicial1 of PARTICIPANTE_TIENE_CARTA (nombre_jugador "RICARDO")(nombre_carta "BARCO_MADERA_INICIAL2"))

    
    (bonus_pescador of BONUS (nombre PESCADOR))
    (bonus_martillo of BONUS (nombre MARTILLO))
    
    (bonus_pescador_diego of JUGADOR_TIENE_BONUS (nombre_jugador "DIEGO")(tipo PESCADOR)(cantidad 0))
    (bonus_martillo_diego of JUGADOR_TIENE_BONUS (nombre_jugador "DIEGO")(tipo MARTILLO)(cantidad 0))
    (bonus_pescador_ricardo of JUGADOR_TIENE_BONUS (nombre_jugador "RICARDO")(tipo PESCADOR)(cantidad 0))
    (bonus_martillo_ricardo of JUGADOR_TIENE_BONUS (nombre_jugador "RICARDO")(tipo MARTILLO)(cantidad 0))

    
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
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "HORNO DE CARBON VEGETAL") (cantidad_arcilla 1))


    (of CARTA (nombre "MUELLE") (valor 14) (tipo INDUSTRIAL))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 1) (nombre_carta "MUELLE") (posicion_en_mazo 2))
    (of COSTE_ENTRADA_CARTA (nombre_carta "MUELLE")(tipo COMIDA)(cantidad 2))
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "MUELLE")(cantidad_madera 2)(cantidad_arcilla 2)(cantidad_hierro 2))

    (of CARTA_EDIFICIO_GENERADOR (nombre "FABRICA DE LADRILLOS") (valor 14) (tipo INDUSTRIAL) (numero_recursos_salida 2))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 1) (nombre_carta "FABRICA DE LADRILLOS") (posicion_en_mazo 3))
    (of COSTE_ENTRADA_CARTA (nombre_carta "FABRICA DE LADRILLOS")(tipo COMIDA)(cantidad 1))
    (of EDIFICIO_INPUT (nombre_carta "FABRICA DE LADRILLOS") (recurso ARCILLA) (cantidad_maxima 1000))
    (of EDIFICIO_OUTPUT (nombre_carta "FABRICA DE LADRILLOS") (recurso FRANCO) (cantidad_min_generada_por_unidad 0.5))
    (of EDIFICIO_OUTPUT (nombre_carta "FABRICA DE LADRILLOS") (recurso LADRILLOS) (cantidad_min_generada_por_unidad 1))
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "FABRICA DE LADRILLOS") (cantidad_madera 2)(cantidad_arcilla 1)(cantidad_hierro 1))


    (of CARTA_EDIFICIO_GENERADOR (nombre "COQUERIA") (valor 18) (tipo INDUSTRIAL) (numero_recursos_salida 2))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 1) (nombre_carta "COQUERIA") (posicion_en_mazo 4))
    (of COSTE_ENTRADA_CARTA (nombre_carta "COQUERIA")(tipo DINERO)(cantidad 1))
    (of EDIFICIO_INPUT (nombre_carta "COQUERIA") (recurso CARBON) (cantidad_maxima 1000))
    (of EDIFICIO_OUTPUT (nombre_carta "COQUERIA") (recurso COQUE) (cantidad_min_generada_por_unidad 1))
    (of EDIFICIO_OUTPUT (nombre_carta "COQUERIA") (recurso FRANCO) (cantidad_min_generada_por_unidad 1))
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "COQUERIA") (cantidad_ladrillo 2) (cantidad_hierro 2))

    (of CARTA_BANCO (nombre "BANCO") (coste 40) (valor 16))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 1) (nombre_carta "BANCO") (posicion_en_mazo 5))
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "BANCO") (cantidad_ladrillo 4) (cantidad_acero 1))


    ; MAZO 2
    (of CARTA_EDIFICIO_GENERADOR (nombre "PISCIFACTORIA") (valor 10) (tipo BASICO) (numero_recursos_salida 1))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 2) (nombre_carta "PISCIFACTORIA") (posicion_en_mazo 1))
    (of EDIFICIO_OUTPUT (nombre_carta "PISCIFACTORIA") (recurso PESCADO) (cantidad_min_generada_por_unidad 3))
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "PISCIFACTORIA") (cantidad_madera 1)(cantidad_arcilla 1))
    (of CARTA_OUTPUT_BONUS (nombre_carta "PISCIFACTORIA") (bonus PESCADOR) (cantidad_maxima_permitida 10000))


    (of CARTA_EDIFICIO_GENERADOR (nombre "PANADERIA") (valor 8) (tipo BASICO) (numero_recursos_salida 2))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 2) (nombre_carta "PANADERIA") (posicion_en_mazo 2))
    (of COSTE_ENTRADA_CARTA (nombre_carta "PANADERIA") (tipo COMIDA) (cantidad 1))
    (of EDIFICIO_INPUT (nombre_carta "PANADERIA") (recurso GRANO) (cantidad_maxima 1000))
    (of EDIFICIO_OUTPUT (nombre_carta "PANADERIA") (recurso PAN) (cantidad_min_generada_por_unidad 1))
    (of EDIFICIO_OUTPUT (nombre_carta "PANADERIA") (recurso FRANCO) (cantidad_min_generada_por_unidad 0.5))
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "PANADERIA")(cantidad_arcilla 2))

    (of CARTA_EDIFICIO_GENERADOR (nombre "MONTICULO DE ARCILLA") (valor 2) (tipo NINGUNO) (numero_recursos_salida 1))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 2) (nombre_carta "MONTICULO DE ARCILLA") (posicion_en_mazo 3))
    (of COSTE_ENTRADA_CARTA (nombre_carta "MONTICULO DE ARCILLA")(tipo COMIDA)(cantidad 1))
    (of EDIFICIO_OUTPUT (nombre_carta "MONTICULO DE ARCILLA") (recurso ARCILLA) (cantidad_min_generada_por_unidad 3))
    (of CARTA_OUTPUT_BONUS (nombre_carta "MONTICULO DE ARCILLA") (bonus MARTILLO) (cantidad_maxima_permitida 10000))

    (of CARTA_EDIFICIO_GENERADOR (nombre "MINA DE CARBON") (valor 10) (tipo INDUSTRIAL) (numero_recursos_salida 1))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 2) (nombre_carta "MINA DE CARBON") (posicion_en_mazo 4))
    (of COSTE_ENTRADA_CARTA (nombre_carta "MINA DE CARBON") (tipo COMIDA) (cantidad 2))
    (of EDIFICIO_OUTPUT (nombre_carta "MINA DE CARBON") (recurso CARBON) (cantidad_min_generada_por_unidad 3))
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "MINA DE CARBON")(cantidad_madera 1)(cantidad_arcilla 3))
    (of CARTA_OUTPUT_BONUS (nombre_carta "MINA DE CARBON") (bonus MARTILLO) (cantidad_maxima_permitida 1))


    (of CARTA_EDIFICIO_GENERADOR (nombre "SIDERURGIA") (valor 22) (tipo INDUSTRIAL) (numero_recursos_salida 1))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 2) (nombre_carta "SIDERURGIA") (posicion_en_mazo 5))
    (of COSTE_ENTRADA_CARTA (nombre_carta "SIDERURGIA")(tipo DINERO)(cantidad 2))
    (of EDIFICIO_INPUT (nombre_carta "SIDERURGIA") (recurso HIERRO) (cantidad_maxima 1000))
    (of EDIFICIO_OUTPUT (nombre_carta "SIDERURGIA") (recurso ACERO) (cantidad_min_generada_por_unidad 1))
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "SIDERURGIA")(cantidad_ladrillo 4)(cantidad_hierro 2))
    
    ; MAZO 3
    (of CARTA_EDIFICIO_GENERADOR (nombre "AHUMADOR") (valor 6) (tipo BASICO) (numero_recursos_salida 2))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 3) (nombre_carta "AHUMADOR") (posicion_en_mazo 1))
    (of COSTE_ENTRADA_CARTA (nombre_carta "AHUMADOR")(tipo DINERO)(cantidad 1))
    (of COSTE_ENTRADA_CARTA (nombre_carta "AHUMADOR")(tipo COMIDA)(cantidad 2))
    (of EDIFICIO_INPUT (nombre_carta "AHUMADOR") (recurso PESCADO) (cantidad_maxima 6))
    (of EDIFICIO_OUTPUT (nombre_carta "AHUMADOR") (recurso PESCADO_AHUMADO) (cantidad_min_generada_por_unidad 1))
    (of EDIFICIO_OUTPUT (nombre_carta "AHUMADOR") (recurso FRANCO) (cantidad_min_generada_por_unidad 0.5))
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "AHUMADOR")(cantidad_madera 2)(cantidad_arcilla 1))
    
    (of CARTA_EDIFICIO_GENERADOR (nombre "MATADERO") (valor 8) (tipo BASICO) (numero_recursos_salida 2))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 3) (nombre_carta "MATADERO") (posicion_en_mazo 2))
    (of COSTE_ENTRADA_CARTA (nombre_carta "MATADERO")(tipo DINERO)(cantidad 2))
    (of EDIFICIO_INPUT (nombre_carta "MATADERO") (recurso GANADO) (cantidad_maxima 1000))
    (of EDIFICIO_OUTPUT (nombre_carta "MATADERO") (recurso CARNE) (cantidad_min_generada_por_unidad 1))
    (of EDIFICIO_OUTPUT (nombre_carta "MATADERO") (recurso PIEL) (cantidad_min_generada_por_unidad 0.5))
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "MATADERO")(cantidad_madera 1)(cantidad_arcilla 1)(cantidad_hierro 1))

    (of CARTA (nombre "COMPAÑIA NAVIERA") (valor 10) (tipo COMERCIAL))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 3) (nombre_carta "COMPAÑIA NAVIERA") (posicion_en_mazo 3))
    (of COSTE_ENTRADA_CARTA (nombre_carta "COMPAÑIA NAVIERA") (tipo COMIDA) (cantidad 2))
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "COMPAÑIA NAVIERA")(cantidad_madera 2)(cantidad_ladrillo 3))

    (of CARTA_EDIFICIO_GENERADOR (nombre "PELETERIA") (valor 12) (tipo BASICO) (numero_recursos_salida 2))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 3) (nombre_carta "PELETERIA") (posicion_en_mazo 4))
    (of EDIFICIO_INPUT (nombre_carta "PELETERIA") (recurso PIEL) (cantidad_maxima 4))
    (of EDIFICIO_OUTPUT (nombre_carta "PELETERIA") (recurso CUERO) (cantidad_min_generada_por_unidad 1))
    (of EDIFICIO_OUTPUT (nombre_carta "PELETERIA") (recurso FRANCO) (cantidad_min_generada_por_unidad 1))
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "PELETERIA")(cantidad_madera 1)(cantidad_ladrillo 1))

    (of CARTA_EDIFICIO_GENERADOR (nombre "HERRERIA") (valor 12) (tipo INDUSTRIAL) (numero_recursos_salida 1))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 3) (nombre_carta "HERRERIA") (posicion_en_mazo 5))
    (of COSTE_ENTRADA_CARTA (nombre_carta "HERRERIA")(tipo DINERO)(cantidad 1))
    (of COSTE_ENTRADA_CARTA (nombre_carta "HERRERIA")(tipo COMIDA)(cantidad 3))
    (of EDIFICIO_OUTPUT (nombre_carta "HERRERIA") (recurso HIERRO) (cantidad_min_generada_por_unidad 3))
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "HERRERIA")(cantidad_madera 3)(cantidad_ladrillo 2))


    (of CARTA_TIENE_BONUS (nombre_carta "PISCIFACTORIA")(bonus PESCADOR))
    (of CARTA_TIENE_BONUS (nombre_carta "AHUMADOR")(bonus PESCADOR))
    (of CARTA_TIENE_BONUS (nombre_carta "COMPAÑIA NAVIERA")(bonus PESCADOR))
    (of CARTA_TIENE_BONUS (nombre_carta "HERRERIA")(bonus MARTILLO))
    (of CARTA_TIENE_BONUS (nombre_carta "CONSTRUCTORA1")(bonus MARTILLO))
    (of CARTA_TIENE_BONUS (nombre_carta "CONSTRUCTORA2")(bonus MARTILLO))
    (of CARTA_TIENE_BONUS (nombre_carta "CONSTRUCTORA3")(bonus MARTILLO))


    (of BARCO (nombre "BARCO_MADERA_INICIAL1")(valor 2)(coste 14)(uds_comida_genera 4)(capacidad_envio 2))
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "BARCO_MADERA_INICIAL1")(cantidad_madera 5))
    (of BARCO (nombre "BARCO_MADERA_INICIAL2")(valor 2)(coste 14)(uds_comida_genera 4)(capacidad_envio 2))
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "BARCO_MADERA_INICIAL2")(cantidad_madera 5))
    
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
    (of CARTA (nombre "BARCO_LUJOSO") (valor 30))
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "BARCO_LUJOSO") (cantidad_acero 3))
    
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

    (of RONDA_ASIGNA_EDIFICIO (nombre_ronda RONDA_1) (id_mazo 1))
    (of RONDA_ASIGNA_EDIFICIO (nombre_ronda RONDA_3) (id_mazo 2))
    (of RONDA_ASIGNA_EDIFICIO (nombre_ronda RONDA_5) (id_mazo 3))
    (of RONDA_ASIGNA_EDIFICIO (nombre_ronda RONDA_7) (id_mazo 1))

)

(deffacts hechos_iniciales
    (comienzo_partida NO)
    (ronda_actual RONDA_1)
    (siguiente_jugador "DIEGO" "RICARDO")
    (siguiente_jugador "RICARDO" "DIEGO")
    (turno "DIEGO")
    (siguiente_ronda RONDA_1 RONDA_2)
    (siguiente_ronda RONDA_2 RONDA_3)
    (siguiente_ronda RONDA_3 RONDA_4)
    (siguiente_ronda RONDA_4 RONDA_5)
    (siguiente_ronda RONDA_5 RONDA_6)
    (siguiente_ronda RONDA_6 RONDA_7)
    (siguiente_ronda RONDA_7 RONDA_8)
    (siguiente_ronda RONDA_8 RONDA_EXTRA_FINAL)
    (OFERTA_RECURSO (recurso FRANCO) (cantidad 3))
    (OFERTA_RECURSO (recurso PESCADO) (cantidad 3))
    (OFERTA_RECURSO (recurso MADERA) (cantidad 3))
    (OFERTA_RECURSO (recurso ARCILLA) (cantidad 2))
    (OFERTA_RECURSO (recurso HIERRO) (cantidad 1))
    (OFERTA_RECURSO (recurso GRANO) (cantidad 1))
    (OFERTA_RECURSO (recurso GANADO) (cantidad 2))

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

    ; **** AQUI PODRÁ MODIFICAR LOS OBJETIVOS DEL JUGADOR ****
    ; El nº determina la prioridad que se le quiere dar. 
    ; Deberá ser un número {1, 2, 3}
    
    (objetivo_carta_jugador "DIEGO" "FABRICA DE LADRILLOS" 1)
    (objetivo_carta_jugador "DIEGO" "MUELLE" 1)
    (objetivo_carta_jugador "DIEGO" "MONTICULO DE ARCILLA" 1)
    (objetivo_carta_jugador "DIEGO" "MATADERO" 1)
    (objetivo_carta_jugador "DIEGO" "AHUMADOR" 1)
    (objetivo_carta_jugador "DIEGO" "PANADERIA" 2)
    (objetivo_carta_jugador "DIEGO" "PISCIFACTORIA" 2)
    (objetivo_carta_jugador "DIEGO" "HORNO DE CARBON VEGETAL" 2)
    (objetivo_carta_jugador "DIEGO" "COQUERIA" 3)
    (objetivo_carta_jugador "DIEGO" "BANCO" 3)
    (objetivo_carta_jugador "DIEGO" "MINA DE CARBON" 3)
    (objetivo_carta_jugador "DIEGO" "SIDERURGIA" 3)
    (objetivo_carta_jugador "DIEGO" "COMPAÑIA NAVIERA" 3)
    (objetivo_carta_jugador "DIEGO" "PELETERIA" 3)
    (objetivo_carta_jugador "DIEGO" "HERRERIA" 3)

 
    (objetivo_carta_jugador "RICARDO" "FABRICA DE LADRILLOS" 1)
    (objetivo_carta_jugador "RICARDO" "MUELLE" 1)
    (objetivo_carta_jugador "RICARDO" "MONTICULO DE ARCILLA" 1)
    (objetivo_carta_jugador "RICARDO" "MATADERO" 1)
    (objetivo_carta_jugador "RICARDO" "AHUMADOR" 1)
    (objetivo_carta_jugador "RICARDO" "PANADERIA" 2)
    (objetivo_carta_jugador "RICARDO" "PISCIFACTORIA" 2)
    (objetivo_carta_jugador "RICARDO" "HORNO DE CARBON VEGETAL" 2)
    (objetivo_carta_jugador "RICARDO" "COQUERIA" 3)
    (objetivo_carta_jugador "RICARDO" "BANCO" 3)
    (objetivo_carta_jugador "RICARDO" "MINA DE CARBON" 3)
    (objetivo_carta_jugador "RICARDO" "SIDERURGIA" 3)
    (objetivo_carta_jugador "RICARDO" "COMPAÑIA NAVIERA" 3)
    (objetivo_carta_jugador "RICARDO" "PELETERIA" 3)
    (objetivo_carta_jugador "RICARDO" "HERRERIA" 3)

    (decision_pago_comida_entrar_edificios "DIEGO" PESCADO)
    (decision_pago_comida_entrar_edificios "RICARDO" PESCADO)

    (prioridad_compañia_naviera 8 5)
    (prioridad_compañia_naviera 5 4)
    (prioridad_compañia_naviera 4 3)
    (prioridad_compañia_naviera 3 2)
    (prioridad_compañia_naviera 2 1)
    (CONTADOR_COMPAÑIA_NAVIERA (nombre "DIEGO") (prioridad 8))
    (CONTADOR_COMPAÑIA_NAVIERA (nombre "RICARDO") (prioridad 8))
)
