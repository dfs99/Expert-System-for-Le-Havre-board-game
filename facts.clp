
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

)
