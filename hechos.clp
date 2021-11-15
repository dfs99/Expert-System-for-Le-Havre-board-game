(deffacts actualizacion

    (actualizar_mazo 1)
)

(definstances actualizar_cartas 

    (of CARTA (nombre "MUELLE") (valor 14) (tipo INDUSTRIAL))
    (of CARTA_PERTENECE_A_MAZO (id_mazo 1) (nombre_carta "MUELLE") (posicion_en_mazo 2))
    ; ---> Muelle (2 de comida)
    (of COSTE_ENTRADA_CARTA (nombre_carta "MUELLE")(tipo COMIDA)(cantidad 2))
    ; cuesta fabricarlo 2 de madera 2 de arcilla y 2 de hierro.
    (of COSTE_CONSTRUCCION_CARTA (nombre_carta "MUELLE")(cantidad_madera 2)(cantidad_arcilla 2)(cantidad_hierro 2))

    (of CARTA (nombre "FABRICA DE LADRILLOS") (valor 14) (tipo INDUSTRIAL))
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


    (of CARTA (nombre "COQUERIA") (valor 18) (tipo INDUSTRIAL))
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

)