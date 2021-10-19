
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

    (OFERTA_RECURSO (recurso ) (cantidad )
    (siguiente_barco_disponible BARCO_MADERA1 BARCO_MADERA2)
    (siguiente_barco_disponible BARCO_MADERA2 BARCO_MADERA3)
    )


; INSTANCIAS CARTAS EDIFICIO
(definstances situacion_inicial
    ([nombre] of EDIFICIO_GENERADOR
        (tipo OTRO)
        (nombre FISHERY)
        (coste_compra 6)
        (valor_proporciona 6)
        (tarifa_entrada_en_francos 0)
        (tarifa_entrada_uds_recurso 0)
        (tarifa_entrada_recurso)
        (recurso_genera)
        (num_recursos_genera)
        (plus_por_bonus)
    )
        (slot valor_proporciona (source composite))
    (slot tarifa_entrada_en_francos (type INTEGER) (access initialize-only) (create-accessor read))
    (slot tarifa_entrada_uds_recurso (type INTEGER) (access initialize-only) (create-accessor read))
    (slot tarifa_entrada_recurso (type SYMBOL) (access initialize-only) (create-accessor read))
    (slot recurso_genera (type SYMBOL) (access initialize-only) (create-accessor read))
    (slot num_recursos_genera (type INTEGER) (access initialize-only) (create-accessor read))
    (slot plus_por_bonus (type INTEGER) (access initialize-only) (create-accessor read))
    (slot bonus (type SYMBOL) 
)