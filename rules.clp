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
;                                          ╦═╗╔═╗╔═╗╦  ╔═╗╔═╗
;                                          ╠╦╝║╣ ║ ╦║  ╠═╣╚═╗
;                                          ╩╚═╚═╝╚═╝╩═╝╩ ╩╚═╝
;             +-----------------------------+--------------+-------------------------+
;             |           Authors           |     NIAS     |          Githubs        |
;             +-----------------------------+--------------+-------------------------+
;             | Ricardo Grande Cros         |  100386336   |      ricardograndecros  |
;             | Diego Fernandez Sebastian   |  100387203   |      dfs99              |
;             +-----------------------------+--------------+-------------------------+
;




; 
;   Reglas Juego: (+generalizar)
;
;   1-. Tomar elemento de la oferta (solo eso).


; OK
; (defrule TOMAR_RECURSO_OFERTA
;     ; si loseta oculta no se puede tomar recurso de la oferta.
;     (object (is-a LOSETA) (posicion ?pos_jugador) (visibilidad TRUE))
;     (object (is-a JUGADOR_ESTA_EN_LOSETA) (posicion ?pos_jugador) (nombre_jugador ?nombre_jugador))
;     ; El jugador q esté en la loseta tiene que tener su turno.
;     (turno ?nombre_jugador)
;     ; Obtiene los datos del recurso del jugador
;     ?recurso_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ?recurso_deseado) (cantidad ?cantidad_recurso))
;     ; Obtiene el recurso de la oferta que se va a tomar
;     ?recurso_oferta <- (OFERTA_RECURSO (recurso ?recurso_deseado) (cantidad ?cantidad_oferta))
;     ; Comprueba que el recurso de la oferta se pueda obtener
;     (test (> ?cantidad_oferta 0))
;     ; Hecho estratégico que implique coger recurso de la oferta
;     ?deseo <- (deseo_coger_recurso ?nombre_jugador ?recurso_deseado)
;     =>
;     ; eliminar deseo
;     (retract ?deseo)
;     ; Actualizar la cantidad de la oferta
;     (modify ?recurso_oferta (cantidad 0))
;     ; Actualizar los recursos del jugador
;     (modify-instance ?recurso_jugador (cantidad (+ ?cantidad_recurso ?cantidad_oferta)))
;     ; fin actividad principal
;     (assert (fin_actividad_principal ?nombre_jugador))
;     (printout t"=====================================================================================================" crlf)
;     (printout t"El jugador: <" ?nombre_jugador "> ha tomado de la oferta: <" ?cantidad_oferta "> de <" ?recurso_deseado ">. " crlf)
; )

; las de comprar edificio OK
;   2-. Comprar edificio
;   Lo único que cambia de estas dos reglas es la pertenencia de la carta. 
; NO SE HA IMPLEMENTADO EL INCREMENTO DE BONUS AUN !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

; Siempre que no sea el banco. 
; (defrule COMPRAR_EDIFICIO_AL_AYUNTO
;     ; Se puede comprar en la ronda actual. [en todas las rondas excepto la última.]
;     (ronda_actual ?nombre_ronda)
;     (test (neq ?nombre_ronda RONDA_EXTRA_FINAL))
;     ; Obtener el turno del jugador
;     ?turno <- (turno ?nombre_jugador)
;     ; Obtener el edificio del deseo
;     ?deseo <- (deseo_comprar_edificio ?nombre_jugador ?nombre_edificio)
;     ; Ha finalizado su actividad principal dentro de su turno.
;     (fin_actividad_principal ?nombre_jugador)
;     ; El edificio es del ayuntamiento
;     ?ayunto <- (EDIFICIO_AYUNTAMIENTO (nombre_edificio ?nombre_edificio))
;     ; Obtiene el coste de comprar el edificio
;     (object (is-a CARTA) (nombre ?nombre_edificio) (valor ?valor_edificio))
;     ; Obtiene el dinero del jugador
;     ?recurso_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso FRANCO) (cantidad ?cantidad_recurso))
;     ; El jugador tiene suficiente dinero
;     (test (>= ?cantidad_recurso ?valor_edificio))
;     =>
;     ; Modificar el dinero del jugador
;     (modify-instance ?recurso_jugador (cantidad (- ?cantidad_recurso ?valor_edificio)))
;     ; Quitar el edificio al ayuntamiento
;     (retract ?ayunto)
;     ; Asignar el edificio al jugador
;     (make-instance of JUGADOR_TIENE_CARTA (nombre_jugador ?nombre_jugador) (nombre_carta ?nombre_edificio))
;     ; Eliminar el deseo de comprar el edificio
;     (retract ?deseo)
;     (printout t"El jugador: <" ?nombre_jugador "> ha comprado el edificio: <" ?nombre_edificio "> por <" ?valor_edificio "> francos al ayuntamiento." crlf)
; )

; (defrule COMPRAR_EDIFICIO_AL_MAZO
;     ; Se puede comprar en la ronda actual. [en todas las rondas excepto la última.]
;     (ronda_actual ?nombre_ronda)
;     (test (neq ?nombre_ronda RONDA_EXTRA_FINAL))
;     ; Obtener el turno del jugador
;     ?turno <- (turno ?nombre_jugador)
;     ; Obtener el edificio del deseo
;     ?deseo <- (deseo_comprar_edificio ?nombre_jugador ?nombre_edificio)
;     ; Ha finalizado su actividad principal dentro de su turno.
;     (fin_actividad_principal ?nombre_jugador)
;     ; El edificio es del mazo
;     ?carta_en_mazo <- (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id_mazo) (nombre_carta ?nombre_edificio) (posicion_en_mazo 1))
;     ; Obtiene el coste de comprar el edificio
;     (object (is-a CARTA) (nombre ?nombre_edificio) (tipo ?) (valor ?valor_edificio))
;     ; Obtiene el dinero del jugador
;     ?recurso_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso FRANCO) (cantidad ?cantidad_recurso))
;     ; El jugador tiene suficiente dinero
;     (test (>= ?cantidad_recurso ?valor_edificio))
;     =>
;     ; Modificar el dinero del jugador
;     (modify-instance ?recurso_jugador (cantidad (- ?cantidad_recurso ?valor_edificio)))
;     ; Quitar la carta del mazo y mover todas las cartas 1 posición
;     (unmake-instance ?carta_en_mazo)
;     ; Asignar el edificio al jugador
;     (make-instance of JUGADOR_TIENE_CARTA (nombre_jugador ?nombre_jugador) (nombre_carta ?nombre_edificio))
;     ; Eliminar el deseo de comprar el edificio
;     (retract ?deseo)
;     ; Generar hecho semáforo para actualizar el orden de las cartas del mazo
;     (assert (actualizar_mazo ?id_mazo))
;     (printout t"El jugador: <" ?nombre_jugador "> ha comprado el edificio: <" ?nombre_edificio "> por <" ?valor_edificio "> francos al mazo." crlf)
; )


; (defrule COMPRAR_EDIFICIO_BANCO_DEL_AYUNTO
;     ; Se puede comprar en la ronda actual. [en todas las rondas excepto la última.]
;     (ronda_actual ?nombre_ronda)
;     (test (neq ?nombre_ronda RONDA_EXTRA_FINAL))
;     ; Obtener el turno del jugador
;     ?turno <- (turno ?nombre_jugador)
;     ; Obtener el edificio del deseo
;     ?deseo <- (deseo_comprar_edificio ?nombre_edificio)
;     ; Ha finalizado su actividad principal dentro de su turno.
;     (fin_actividad_principal ?nombre_jugador)
;     ; El edificio es del ayuntamiento
;     ?ayunto <- (EDIFICIO_AYUNTAMIENTO (nombre_edificio ?nombre_edificio))
;     ; Obtiene el coste de comprar el banco.
;     (object (is-a CARTA_BANCO) (nombre ?nombre_edificio) (coste ?valor_edificio) (valor ?))
;     ; Obtiene el dinero del jugador
;     ?recurso_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso FRANCOS) (cantidad ?cantidad_recurso))
;     ; El jugador tiene suficiente dinero
;     (test (>= ?cantidad_recurso ?valor_edificio))
;     =>
;     ; Modificar el dinero del jugador
;     (modify-instance ?recurso_jugador (cantidad (- ?cantidad_recurso ?valor_edificio)))
;     ; Quitar el edificio al ayuntamiento
;     (retract ?ayunto)
;     ; Asignar el edificio al jugador
;     (make-instance of JUGADOR_TIENE_CARTA (nombre_jugador ?nombre_jugador) (nombre_carta ?nombre_edificio))
;     ; Eliminar el deseo de comprar el edificio
;     (retract ?deseo)
;     ; Print final
;     printout t"El jugador: <" ?nombre_jugador "> ha comprado el edificio: <" ?nombre_edificio "> por <" ?valor_edificio "> francos al ayuntamiento." crlf)
; )
; )

; (defrule COMPRAR_EDIFICIO_BANCO_DEL_MAZO
;     ; Se puede comprar en la ronda actual. [en todas las rondas excepto la última.]
;     (ronda_actual ?nombre_ronda)
;     (test (neq ?nombre_ronda RONDA_EXTRA_FINAL))
;     ; Obtener el turno del jugador
;     ?turno <- (turno ?nombre_jugador)
;     ; Obtener el edificio del deseo
;     ?deseo <- (deseo_comprar_edificio ?nombre_edificio)
;     ; Ha finalizado su actividad principal dentro de su turno.
;     (fin_actividad_principal ?nombre_jugador)
;     ; El edificio es del mazo
;     ?carta_en_mazo <- (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id_mazo) (nombre_carta ?nombre_edificio) (posicion_en_mazo 1))
;     ; Obtiene el coste de comprar el edificio
;     (object (is-a CARTA_BANCO) (nombre ?nombre_edificio) (coste ?valor_edificio) (valor ?))
;     ; Obtiene el dinero del jugador
;     ?recurso_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso FRANCOS) (cantidad ?cantidad_recurso))
;     ; El jugador tiene suficiente dinero
;     (test (>= ?cantidad_recurso ?valor_edificio))
;     =>
;     ; Modificar el dinero del jugador
;     (modify-instance ?recurso_jugador (cantidad (- ?cantidad_recurso ?valor_edificio)))
;     ; Quitar la carta del mazo y mover todas las cartas 1 posición
;     (unmake-instance ?carta_en_mazo)
;     ; Asignar el edificio al jugador
;     (make-instance of JUGADOR_TIENE_CARTA (nombre_jugador ?nombre_jugador) (nombre_carta ?nombre_edificio))
;     ; Eliminar el deseo de comprar el edificio
;     (retract ?deseo)
;     ; Generar hecho semáforo para actualizar el orden de las cartas del mazo
;     (assert (actualizar_mazo ?id_mazo))
;     (printout t"El jugador: <" ?nombre_jugador "> ha comprado el edificio: <" ?nombre_edificio "> por <" ?valor_edificio "> francos al mazo." crlf)
; )

; OK
;   3-. Vender Carta (otorga mitad de valor) [tanto edificio como barco, todos igual.]
; (defrule VENDER_CARTA
;     ; No existe precondición de ronda! 
;     ; Existe un deseo de vender un edificio
;     ?deseo <- (deseo_vender_edificio ?nombre_edificio)
;     ; Ha finalizado su actividad principal dentro de su turno.
;     (fin_actividad_principal ?nombre_jugador)
;     ; Es el turno del jugador
;     ?turno <- (turno ?nombre_jugador)
;     ; El jugador tiene la carta. 
;     ?edificio_jugador <- (object (is-a JUGADOR_TIENE_CARTA) (nombre_jugador ?nombre_jugador)(nombre_carta ?nombre_carta))
;     ; referencia de la carta para obtener su valor. 
;     ?carta <- (object (is-a CARTA) (nombre ?nombre_carta) (valor ?valor_carta))
;     ; referencia del recurso del jugador.
;     ?recurso_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso FRANCOS) (cantidad ?cantidad_recurso))
;     ; obtener el beneficio de la venta de la carta.
;     (bind ?ingreso =(/ ?valor_carta 2))
;     =>
;     ; Modificar el dinero del jugador
;     (modify-instance ?recurso_jugador (cantidad (+ ?cantidad_recurso ?ingreso)))
;     ; Asignar edificio al ayuntamiento
;     (assert (EDIFICIO_AYUNTAMIENTO (nombre_edificio ?nombre_edificio)))
;     ; Quitarle el edificio al jugador
;     (unmake-instance ?edificio_jugador)
;     ; quitar el deseo.
;     (retract ?deseo)
;     ; print final
;     (printout t"El jugador: <" ?nombre_jugador "> ha vendido el edificio: <" ?nombre_edificio "> por <" ?ingreso "> francos." crlf)
; )


; OK
;   3-. Entrar Edificio
; que pasa si no tiene coste de entrada? => otra regla?


(defrule ENTRAR_EDIFICIO_GRATIS_RONDAS

    ; Se puede entrar de uno en uno en el resto de las rondas.
    (ronda_actual ?nombre_ronda)
    (test (neq ?nombre_ronda RONDA_EXTRA_FINAL))
    ; Existe un deseo de entrar a un edificio, este tiene el tipo de recurso que quiere usar para pagar y su nombre
    ?deseo <- (deseo_entrar_edificio ?nombre_edificio ?tipo_recurso ?nombre_recurso)
    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; obtener nombre de la carta. 
    (object (is-a CARTA) (nombre ?nombre_carta) (valor ?))
    ; no exista un jugador en ese edificio.

    ?pos_jugador <- (JUGADOR_ESTA_EDIFICIO (nombre_edificio ?edificio_actual) (nombre_jugador ?nombre_jugador))
    (JUGADOR_ESTA_EDIFICIO (nombre_edificio ?nombre_carta) (nombre_jugador ?otro_jugador))
    (test (neq ?nombre_jugador ?otro_jugador))
    (test (neq ?edificio_actual ?nombre_edificio))

    ; No tiene coste de entrada y pertence a otro jugador o pertenece al jugador y entra gratis. 
    (
        (   
            (not (object (is-a COSTE_ENTRADA_CARTA) (nombre_carta ?nombre_carta) (tipo ?) (cantidad ?))) 
                and 
            (object (is-a JUGADOR_TIENE_CARTA (nombre_jugador ?nombre_jugador2) (nombre_carta ?nombre_carta)))
        ) 
        or 
        (object (is-a JUGADOR_TIENE_CARTA (nombre_jugador ?nombre_jugador) (nombre_carta ?nombre_carta)))
    )
    
    =>
    ; indicar que el jugador está en el edificio.
    (modify ?pos_jugador (nombre_edificio ?nombre_carta))
    ; quitar el deseo.
    (retract ?deseo)
    (printout t"El jugador: <" ?nombre_jugador "> ha entrado al edificio: <" ?nombre_carta "> sin coste de entrada o porque le pertenece." crlf)
)

(defrule ENTRAR_EDIFICIO_GRATIS_RONDA_FINAL
; Se puede entrar de uno en uno en el resto de las rondas.
    (ronda_actual RONDA_EXTRA_FINAL)
    ; Existe un deseo de entrar a un edificio, este tiene el tipo de recurso que quiere usar para pagar y su nombre
    ?deseo <- (deseo_entrar_edificio ?nombre_edificio ?tipo_recurso ?nombre_recurso)
    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)

    ; comprobar que el jugador no se encuentre ya en el edificio. 
    ?pos_jugador <- (JUGADOR_ESTA_EDIFICIO (nombre_edificio ?edificio_actual) (nombre_jugador ?nombre_jugador))
    (test (neq ?edificio_actual ?nombre_carta))

    ; obtener nombre de la carta. 
    (object (is-a CARTA) (nombre ?nombre_carta) (valor ?))
    
    ; No tiene coste de entrada y pertence a otro jugador o pertenece al jugador y entra gratis. 
    (
        (   
            (not (object (is-a COSTE_ENTRADA_CARTA) (nombre_carta ?nombre_carta) (tipo ?) (cantidad ?))) 
                and 
            (object (is-a JUGADOR_TIENE_CARTA (nombre_jugador ?nombre_jugador2) (nombre_carta ?nombre_carta)))
        ) 
        or 
        (object (is-a JUGADOR_TIENE_CARTA (nombre_jugador ?nombre_jugador) (nombre_carta ?nombre_carta)))
    )

    =>
    ; indicar que el jugador está en el edificio.
    (modify ?pos_jugador (nombre_edificio ?nombre_carta))

    ; quitar el deseo.
    (retract ?deseo)
    (printout t"El jugador: <" ?nombre_jugador "> ha entrado al edificio: <" ?nombre_carta "> sin coste de entrada en la ronda final." crlf)


)

(defrule ENTRAR_EDIFICIO_CON_COSTE_ENTRADA_RONDAS
    ; Se puede entrar de uno en uno en el resto de las rondas.
    (ronda_actual ?nombre_ronda)
    (test (neq ?nombre_ronda RONDA_EXTRA_FINAL))
    ; Existe un deseo de entrar a un edificio, este tiene el tipo de recurso que quiere usar para pagar y su nombre
    ?deseo <- (deseo_entrar_edificio ?nombre_edificio ?tipo_recurso ?nombre_recurso)
    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; obtener nombre de la carta. 
    (object (is-a CARTA) (nombre ?nombre_carta) (valor ?))
    ; no exista un jugador en ese edificio.
    
    ;(not (JUGADOR_ESTA_EDIFICIO (nombre_edificio ?nombre_carta) (nombre_jugador ?)))
    
    ?pos_jugador <- (JUGADOR_ESTA_EDIFICIO (nombre_edificio ?edificio_actual) (nombre_jugador ?nombre_jugador))
    (JUGADOR_ESTA_EDIFICIO (nombre_edificio ?nombre_carta) (nombre_jugador ?otro_jugador))
    (test (neq ?nombre_jugador ?otro_jugador))
    (test (neq ?edificio_actual ?nombre_edificio))
    
    
    ; Tiene coste de entrada.
    (object (is-a COSTE_ENTRADA_CARTA) (nombre_carta ?nombre_carta) (tipo ?tipo_recurso) (cantidad ?coste_entrada))
    ; comprobar que tenga recursos suficientes para entrar.
    ?recurso_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ?nombre_recurso) (cantidad ?cantidad_recurso))
    (test (>= ?cantidad_recurso ?coste_entrada))
    =>
    ; Modificar el dinero del jugador
    (modify-instance ?recurso_jugador (cantidad =(- ?cantidad_recurso ?coste_entrada) ))
    ; indicar que el jugador está en el edificio.
    ;(assert (JUGADOR_ESTA_EDIFICIO (nombre_edificio ?nombre_carta) (nombre_jugador ?nombre_jugador)))

    (modify ?pos_jugador (nombre_edificio ?nombre_carta))
    
    ; quitar el deseo.
    (retract ?deseo)
    ; Print final
    (printout t"El jugador: <" ?nombre_jugador "> ha entrado al edificio: <" ?nombre_carta "> por <" ?coste_entrada "> " ?tipo_recurso "." crlf)
)

;(defrule ENTRAR_EDIFICIO_SIN_COSTE_ENTRADA_RONDAS
    ; Se puede entrar de uno en uno en el resto de las rondas.
;    (ronda_actual ?nombre_ronda)
;    (test (neq ?nombre_ronda RONDA_EXTRA_FINAL))
    ; Existe un deseo de entrar a un edificio, este tiene el tipo de recurso que quiere usar para pagar y su nombre
;    ?deseo <- (deseo_entrar_edificio ?nombre_edificio ?tipo_recurso ?nombre_recurso)
    ; Es el turno del jugador
;    ?turno <- (turno ?nombre_jugador)
    ; obtener nombre de la carta. 
;    (object (is-a CARTA) (nombre ?nombre_carta) (valor ?))
    ; no exista un jugador en ese edificio.
    ;(not (JUGADOR_ESTA_EDIFICIO (nombre_edificio ?nombre_carta) (nombre_jugador ?)))

;    ?pos_jugador <- (JUGADOR_ESTA_EDIFICIO (nombre_edificio ?edificio_actual) (nombre_jugador ?nombre_jugador))
;    (JUGADOR_ESTA_EDIFICIO (nombre_edificio ?nombre_carta) (nombre_jugador ?otro_jugador))
;    (test (neq ?nombre_jugador ?otro_jugador))
;    (test (neq ?edificio_actual ?nombre_edificio))


    ; No tiene coste de entrada.
;    (not (object (is-a COSTE_ENTRADA_CARTA) (nombre_carta ?nombre_carta) (tipo ?) (cantidad ?)))
;    =>
    ; indicar que el jugador está en el edificio.
    ; (assert (JUGADOR_ESTA_EDIFICIO (nombre_edificio ?nombre_carta) (nombre_jugador ?nombre_jugador)))
    
;    (modify ?pos_jugador (nombre_edificio ?nombre_carta))

    ; quitar el deseo.
;    (retract ?deseo)
;    (printout t"El jugador: <" ?nombre_jugador "> ha entrado al edificio: <" ?nombre_carta "> sin coste de entrada." crlf)
;)

(defrule ENTRAR_EDIFICIO_CON_COSTE_ENTRADA_RONDA_FINAL
    ; Se puede entrar de uno en uno en el resto de las rondas.
    (ronda_actual RONDA_EXTRA_FINAL)
    ; Existe un deseo de entrar a un edificio, este tiene el tipo de recurso que quiere usar para pagar y su nombre
    ?deseo <- (deseo_entrar_edificio ?nombre_carta ?tipo_recurso ?nombre_recurso)
    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; comprobar que el jugador no se encuentre ya en el edificio. 
    ?pos_jugador <- (JUGADOR_ESTA_EDIFICIO (nombre_edificio ?edificio_actual) (nombre_jugador ?nombre_jugador))
    (test (neq ?edificio_actual ?nombre_carta))

    ; obtener nombre de la carta. 
    (object (is-a CARTA) (nombre ?nombre_carta) (valor ?))
    ; Tiene coste de entrada.
    (object (is-a COSTE_ENTRADA_CARTA) (nombre_carta ?nombre_carta) (tipo ?tipo_recurso) (cantidad ?coste_entrada))
    ; comprobar que tenga recursos suficientes para entrar.
    ?recurso_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ?nombre_recurso) (cantidad ?cantidad_recurso))
    (test (>= ?cantidad_recurso ?coste_entrada))
    =>
    ; Modificar el dinero del jugador
    (modify-instance ?recurso_jugador (cantidad (- ?cantidad_recurso ?coste_entrada)))
    ; indicar que el jugador está en el edificio.
    ; (assert (JUGADOR_ESTA_EDIFICIO (nombre_edificio ?nombre_carta) (nombre_jugador ?nombre_jugador)))

    (modify ?pos_jugador (nombre_edificio ?nombre_carta))

    ; quitar el deseo.
    (retract ?deseo)
    (printout t"El jugador: <" ?nombre_jugador "> ha entrado al edificio: <" ?nombre_carta "> por <" ?coste_entrada "> " ?tipo_recurso "." crlf)
)

;(defrule ENTRAR_EDIFICIO_SIN_COSTE_ENTRADA_RONDA_FINAL
    ; Se puede entrar de uno en uno en el resto de las rondas.
;    (ronda_actual RONDA_EXTRA_FINAL)
    ; Existe un deseo de entrar a un edificio, este tiene el tipo de recurso que quiere usar para pagar y su nombre
;    ?deseo <- (deseo_entrar_edificio ?nombre_edificio ?tipo_recurso ?nombre_recurso)
    ; Es el turno del jugador
;    ?turno <- (turno ?nombre_jugador)

    ; comprobar que el jugador no se encuentre ya en el edificio. 
;    ?pos_jugador <- (JUGADOR_ESTA_EDIFICIO (nombre_edificio ?edificio_actual) (nombre_jugador ?nombre_jugador))
;    (test (neq ?edificio_actual ?nombre_carta))

    ; obtener nombre de la carta. 
;    (object (is-a CARTA) (nombre ?nombre_carta) (valor ?))
    ; NO tiene coste de entrada.
;    (not (object (is-a COSTE_ENTRADA_CARTA) (nombre_carta ?nombre_carta) (tipo ?) (cantidad ?)))
;    =>
    ; indicar que el jugador está en el edificio.
    ;(assert (JUGADOR_ESTA_EDIFICIO (nombre_edificio ?nombre_carta) (nombre_jugador ?nombre_jugador)))

;    (modify ?pos_jugador (nombre_edificio ?nombre_carta))

    ; quitar el deseo.
;    (retract ?deseo)
;    (printout t"El jugador: <" ?nombre_jugador "> ha entrado al edificio: <" ?nombre_carta "> sin coste de entrada en la ronda final." crlf)
;)



;   3bis-. Utilizar Edificio 
;   => contruir
;      => Edificio desde un edificio constructora.
;      => Barco desde el muelle. 
;   => generar
;      => Recurso
;   => Transformar
;      => Recurso
;   => Comerciar (compañia naviera y mercado, seguramente dos reglas)
;   
;
; CASUISTICA
; 
;   TODO: TENER EN CUENTA SI COMPROBAR AQUI O EN LOS DESEOS SI EL JUGADOR DISPONE DE LA CANTIDAD SUFICIENTE PARA
;           TRANSFORMAR RECURSO.
;
;   INPUTS          OUTPUT          BONUS   ENERGIA     edificios
;      0               1              1        0        (pescaderia, arcilla, colliery [* máximo 1 ud con bonuses])
;      1               1              0        0        (Carbon vegetal, ironworks)
;      1               1              0        1        (steel meel 5 energia por cada output.)
;      1               2              0        0        (matadero, peleteria y coqueria)
;      1               2              0        1        (ahumador (1 total), ladrillos (por ud), panaderia (por ud))
;
;   
;      0               1              0        1        (1 ud adicional por cada 6 energia extra) SIMPLIFICAMOS!

; edificio generar recurso
;       el jugador está en el edificio
;       es el turno del jugador
;       obtener recursos que otorga el edificio
;       =>
;       añadir recursos al jugador

(defrule EDIFICIO_GENERA_RECURSO_CASO1
    ;   INPUTS          OUTPUT          BONUS   ENERGIA     EDIFICIOS
    ;      0               1              1        0        (pescaderia, arcilla, colliery [* máximo 1 ud con bonuses])
    (JUGADOR_ESTA_EDIFICIO (nombre_edificio ?nombre_edificio)(nombre_jugador ?nombre_jugador))
    ; el jugador no ha usado anteriormente el edificio
    ;(not (edificio_usado ?nombre_edificio ?nombre_jugador))
    ;(edificio_usado "" diego)
    
    ; el jugador no ha usado anteriormente el edificio
    ?ha_usado_edificio <- (edificio_usado ?ed ?nombre_jugador)
    (test (neq ?nombre_edificio ?ed))
    
    (turno ?nombre_jugador)
    (not (object (is-a EDIFICIO_INPUT) (nombre_carta ?nombre_edificio) (recurso ?) (cantidad_maxima ?)))
    (EDIFICIO_OUTPUT (nombre_carta ?nombre_edificio)(recurso ?recurso)(cantidad_min_generada_por_unidad ?cantidad_output))
    ; obtener el tipo de bonus de output de la carta
    (object (is-a CARTA_OUTPUT_BONUS)(nombre_carta ?nombre_edificio)(bonus ?tipo_bonus) (cantidad_maxima_permitida ?cantidad_max_permitida)
    ; obtener los bonus del mismo tipo que el output que tiene el jugador
    (object (is-a) JUGADOR_TIENE_BONUS (nombre_jugador ?nombre_jugador)(bonus ?tipo_bonus)(cantidad ?cantidad_bonus))
    ; obtener los recursos del jugador que otorga el edificio
    ?recurso_jugador <- (object (is-a JUGADOR_TIENE_RECURSO)(nombre_jugador ?nombre_jugador)(recurso ?recurso)(cantidad ?cantidad_recurso))
    (bind ?cantidad_proporciona_bonus =(min ?cantidad_bonus ?cantidad_max_permitida))
    =>
    ; añadir recursos al jugador 
    (modify-instance ?recurso_jugador (cantidad (+ ?cantidad_recurso ( + ?cantidad_output ?cantidad_proporciona_bonus))))
    ; Ha finalizado su actividad principal dentro de su turno.
    (assert (fin_actividad_principal ?nombre_jugador))
    (printout t"El jugador: <" ?nombre_jugador "> ha generado en el edificio: <" ?nombre_edificio "> un total de <" =( + ?cantidad_output ?cantidad_proporciona_bonus) "> recursos de <" ?recurso ">. Los cuales <" ?cantidad_output "> son por entrar y <" ?cantidad_proporciona_bonus "> por los bonus que tiene." crlf)
    ; flag para no permitir usar el mismo edificio dos veces.
    (retract ?ha_usado_edificio)
    (assert (edificio_usado ?nombre_edificio ?nombre_jugador))
)


(defrule EDIFICIO_GENERA_RECURSO_CASO2
;   INPUTS          OUTPUT          BONUS   ENERGIA     EDIFICIOS
;      1               1              0        0        (Carbon vegetal, ironworks)
    ; el jugador está dentro del edificio
    (JUGADOR_ESTA_EDIFICIO (nombre_edificio ?nombre_edificio) (nombre_jugador ?nombre_jugador))

    ; el jugador no ha usado anteriormente el edificio
    ?ha_usado_edificio <- (edificio_usado ?ed ?nombre_jugador)
    (test (neq ?nombre_edificio ?ed))

    ; turno del jugador
    (turno ?nombre_jugador)
    ; el edificio tiene 1 input como recurso.
    (object (is-a EDIFICIO_INPUT) (nombre_carta ?nombre_edificio) (recurso ?recurso_entrada) (cantidad_maxima ?cantidad_maxima))
    ; el jugador tiene el deseo de generar X recursos outputs empleando Y recursos inputs.
    (deseo_generar_con_recurso ?nombre_jugador ?nombre_edificio ?recurso_entrada ?cantidad_a_transformar)  
    ; el eficio tiene 1 output como recurso.  
    (object (is-a EDIFICIO_OUTPUT) (nombre_carta ?nombre_edificio) (recurso ?recurso_salida) (cantidad_min_generada_por_unidad ?cantidad_unitaria))
    ; el edificio no genera recursos adicionales por bonus.
    (not (object (is-a CARTA_OUTPUT_BONUS) (nombre_carta ?nombre_edificio) (bonus ?)))
    ; referencia los recursos del jugador
    ?recurso_jugador_entrada <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ?recurso_entrada) (cantidad ?cantidad_recurso_entrada_jugador))
    ?recurso_jugador_salida <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ?recurso_salida) (cantidad ?cantidad_recurso_salida_jugador))
    ; comprobar que tenga los recursos necesarios.
    (test (>= ?cantidad_recurso_entrada_jugador ?cantidad_a_transformar))
    ; obtener la cantidad que ha transformado del recurso de salida.
    (bind ?cantidad_transformada =(* ?cantidad_a_transformar ?cantidad_unitaria))
    =>
    (modify-instance ?recurso_jugador_entrada (cantidad (- ?cantidad_recurso_entrada ?cantidad_a_transformar)))
    (modify-instance ?recurso_jugador_salida (cantidad (+ ?cantidad_recurso_salida ?cantidad_transformada)))
    ; Ha finalizado su actividad principal dentro de su turno.
    (assert (fin_actividad_principal ?nombre_jugador))
    ; flag para no permitir usar el mismo edificio dos veces.
    (retract ?ha_usado_edificio)
    (assert (edificio_usado ?nombre_edificio ?nombre_jugador))
    (printout t"El jugador: <" ?nombre_jugador "> ha transformado en el edificio: <" ?nombre_edificio "> <" ?cantidad_a_transformar "> recursos de <" ?recurso_entrada "> en <" ?cantidad_transformada "> recursos de <" ?recurso_salida ">." crlf)
)

(defrule EDIFICIO_GENERA_RECURSO_CASO3
;   INPUTS          OUTPUT          BONUS   ENERGIA     EDIFICIOS
;      1               1              0        1        (steel meel 5 energia por cada output.)
; ENERGIA VARIABLE...

    ; el jugador está dentro del edificio
    (JUGADOR_ESTA_EDIFICIO (nombre_edificio ?nombre_edificio) (nombre_jugador ?nombre_jugador))
    ; el jugador no ha usado anteriormente el edificio
    ?ha_usado_edificio <- (edificio_usado ?ed ?nombre_jugador)
    (test (neq ?nombre_edificio ?ed))
    ; es el turno del jugador
    (turno ?nombre_jugador)
    ; el jugador tiene el deseo de usar el edificio empleando X recursos de entrada
    ?deseo_generar <- (deseo_generar_con_recurso ?nombre_jugador ?nombre_edificio ?recurso_entrada ?cantidad_a_transformar)
    ?deseo_pago_energia <- (deseo_emplear_energia ?nombre_jugador ?nombre_edificio ? ?cantidad_madera ? ?cantidad_carbon_vegetal ? ?cantidad_carbon ? ?cantidad_coque)
    ; obtiene el input del edificio 
    (object (is-a EDIFICIO_INPUT) (nombre_carta ?nombre_edificio) (recurso ?) (cantidad_maxima ?))
    ;obtiene el output del edificio
    (object (is-a EDIFICIO_OUTPUT) (nombre_carta ?nombre_edificio) (recurso ?recurso_salida) (cantidad_min_generada_por_unidad ?cantidad_unitaria))
    ; obtiene el coste energético del edificio
    (object (is-a COSTE_ENERGIA) (coste_unitario TRUE) (cantidad ?coste_energia))
    ; el edificio no tiene bonus
    (not (object (is-a CARTA_OUTPUT_BONUS) (nombre_carta ?nombre_edificio) (bonus ?)))
    ; obtiene los recursos del jugador del mismo tipo que el input
    ?recurso_jugador_entrada <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ?recurso_entrada) (cantidad ?cantidad_recurso_entrada_jugador))
    ; obtiene los recursos del jugador del mismo tipo que el output
    ?recurso_jugador_salida <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso ?recurso_salida) (cantidad ?cantidad_recurso_salida_jugador))
    ; comprueba que el jugador tiene suficiente input
    (test (> ?recurso_jugador_entrada ?recurso_entrada))
    ; calcula la cantidad generada
    (bind ?cantidad_transformada =(* ?cantidad_unitaria ?cantidad_a_transformar))
    ; calcula la cantidad de energía empleada
    (bind ?cantidad_energia_empleada =(* ?cantidad_a_transformar ?coste_energia))
    ; obtener los recursos de energia del jugador.
    ?madera_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso MADERA) (cantidad ?cantidad_madera_jugador))
    ?carbon_vegetal_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso CARBON_VEGETAL) (cantidad ?cantidad_carbon_vegetal_jugador))
    ?carbon_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso CARBON) (cantidad ?cantidad_cabon_jugador))
    ?coque_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso COQUE) (cantidad ?cantidad_coque_jugador))
    ;comprueba que el jugador tiene suficiente energía
    (test (> =(+ =(* ?cantidad_madera 1) =(* ?cantidad_carbon_vegetal 3) =(* ?cantidad_carbon 3) =(* ?cantidad_coque 10)) ?cantidad_energia_empleada))
    =>
    ; modifica los inputs del jugador
    (modify-instance ?recurso_jugador_entrada (cantidad (- ?cantidad_recurso_entrada_jugador ?cantidad_a_transformar)))
    ; modifica los outputs del jugador
    (modify-instance ?recurso_jugador_salida (cantidad (+ ?cantidad_recurso_salida_jugador ?cantidad_transformada)))
    ; modifica los recursos energéticos del jugador.
    (modify-instance ?madera_jugador (cantidad (- ?cantidad_madera_jugador ?cantidad_madera)))
    (modify-instance ?carbon_vegetal_jugador (cantidad (- ?cantidad_carbon_vegetal_jugador ?cantidad_carbon_vegetal)))
    (modify-instance ?carbon_jugador (cantidad (- ?cantidad_cabon_jugador ?cantidad_carbon)))
    (modify-instance ?coque_jugador (cantidad (- ?cantidad_coque_jugador ?cantidad_coque)))
    ; Ha finalizado su actividad principal dentro de su turno.
    (assert (fin_actividad_principal ?nombre_jugador))
    ; eliminar deseos
    (retract ?deseo_generar)
    (retract ?deseo_pago_energia)
    ; flag para no permitir usar el mismo edificio dos veces.
    (retract ?ha_usado_edificio)
    (assert (edificio_usado ?nombre_edificio ?nombre_jugador))
)

(defrule EDIFICIO_GENERA_RECURSO_CASO4
;   INPUTS          OUTPUT          BONUS   ENERGIA     EDIFICIOS
;      1               2              0        0        (matadero, peleteria y coqueria)
    ; el jugador está dentro del edificio
    (JUGADOR_ESTA_EDIFICIO (nombre_edificio ?nombre_edificio)(nombre_jugador ?nombre_jugador))
    ; el jugador no ha usado anteriormente el edificio
    ?ha_usado_edificio <- (edificio_usado ?ed ?nombre_jugador)
    (test (neq ?nombre_edificio ?ed))
    ; es el turno del jugador
    (turno ?nombre_jugador)
    ; el jugador tiene el deseo de usar el edificio empleando X recursos de entrada
    (deseo_generar_con_recurso ?nombre_jugador ?nombre_edificio ?recurso_entrada ?cantidad_a_transformar)
    ; obtiene el input del edificio 
    (object (is-a EDIFICIO_INPUT) (nombre_carta ?nombre_edificio) (recurso ?recurso_entrada) (cantidad_maxima ?cantidad_maxima))
    ; obtiene el primer output del edificio
    (object (is-a EDIFICIO_OUTPUT) (nombre_carta ?nombre_edificio) (recurso ?recurso_salida1) (cantidad_min_generada_por_unidad ?cantidad_unitaria1))
    (object (is-a EDIFICIO_OUTPUT) (nombre_carta ?nombre_edificio) (recurso ?recurso_salida2) (cantidad_min_generada_por_unidad ?cantidad_unitaria2))
    
    ; el edificio no tiene bonus
    (not (object (is-a CARTA_OUTPUT_BONUS) (nombre_carta ?nombre_edificio) (bonus ?)))
    ; el edificio no tiene coste energético
    (not (object (is-a COSTE_ENERGIA) (nombre_carta ?nombre_edificio) (coste_unitario ?) (cantidad ?) ))
    ; obtiene los recursos del jugador del mismo tipo que el input y output
    ?recurso_jugador_entrada <- (object (is-a JUGADOR_TIENE_RECURSO)(nombre_jugador ?nombre_jugador) (recurso ?recurso_entrada) (cantidad ?cantidad_recurso_entrada_jugador))
    ?recurso_jugador_salida1 <- (object (is-a JUGADOR_TIENE_RECURSO)(nombre_jugador ?nombre_jugador) (recurso ?recurso_salida1) (cantidad ?cantidad_recurso_salida1_jugador))
    ?recurso_jugador_salida2 <- (object (is-a JUGADOR_TIENE_RECURSO)(nombre_jugador ?nombre_jugador) (recurso ?recurso_salida2) (cantidad ?cantidad_recurso_salida2_jugador))
    ; comprueba que el jugador tiene suficiente input
    (test (>= ?canditad_recurso_entrada_jugador ?cantidad_a_transformar))
    ; calcula la cantidad a transformar
    (bind ?cantidad_transformada_recurso_salida1 (min (* ?cantidad_maxima ?cantidad_unitaria1) (* ?cantidad_a_transformar ?cantidad_unitaria1)))
    (bind ?cantidad_transformada_recurso_salida2 (min (* ?cantidad_maxima ?cantidad_unitaria2) (* ?cantidad_a_transformar ?cantidad_unitaria2)))
    =>
    ; modifica el recurso input del jugador
    (modify-instance ?recurso_jugador_entrada (cantidad (- ?cantidad_recurso_entrada_jugador ?cantidad_a_transformar)))
    ; modifica el primer output del jugador
    (modify-instance ?recurso_jugador_salida1 (cantidad (+ ?cantidad_recurso_salida1_jugador ?cantidad_transformada_recurso_salida1)))
    ; modifica el segundo output del jugador
    (modify-instance ?recurso_jugador_salida2 (cantidad (+ ?cantidad_recurso_salida2_jugador ?cantidad_transformada_recurso_salida2)))
    ; Ha finalizado su actividad principal dentro de su turno.
    (assert (fin_actividad_principal ?nombre_jugador))
    ; flag para no permitir usar el mismo edificio dos veces.
    (retract ?ha_usado_edificio)
    (assert (edificio_usado ?nombre_edificio ?nombre_jugador))
)

(defrule EDIFICIO_GENERA_RECURSO_CASO5
    ;   INPUTS          OUTPUT          BONUS   ENERGIA     edificios
    ;      1               2              0        1        (ahumador (1 total), ladrillos (por ud), panaderia (por ud))
    ; el jugador está dentro del edificio
    (JUGADOR_ESTA_EDIFICIO (nombre_edificio ?nombre_edificio)(nombre_jugador ?nombre_jugador))
    ; el jugador no ha usado anteriormente el edificio
    ?ha_usado_edificio <- (edificio_usado ?ed ?nombre_jugador)
    (test (neq ?nombre_edificio ?ed))
    ; es el turno del jugador
    (turno ?nombre_jugador)
    ; el jugador tiene el deseo de usar el edificio empleando X recursos de entrada
    (deseo_generar_con_recurso ?nombre_jugador ?nombre_edificio ?recurso_entrada ?cantidad_a_transformar)
    
    ?deseo_pago_energia <- (deseo_emplear_energia ?nombre_jugador ?nombre_edificio ? ?cantidad_madera ? ?cantidad_carbon_vegetal ? ?cantidad_carbon ? ?cantidad_coque)
    
    ; obtiene el input del edificio 
    (object (is-a EDIFICIO_INPUT) (nombre_carta ?nombre_edificio) (recurso ?recurso_entrada) (cantidad_maxima ?cantidad_maxima))
    ; obtiene el primer output del edificio
    (object (is-a EDIFICIO_OUTPUT) (nombre_carta ?nombre_edificio) (recurso ?recurso_salida1) (cantidad_min_generada_por_unidad ?cantidad_unitaria1))
    (object (is-a EDIFICIO_OUTPUT) (nombre_carta ?nombre_edificio) (recurso ?recurso_salida2) (cantidad_min_generada_por_unidad ?cantidad_unitaria2))
    
    ; obtiene el coste energético del edificio
    (object (is-a COSTE_ENERGIA) (coste_unitario TRUE) (cantidad ?coste_energia))

    ; el edificio no tiene bonus
    (not (object (is-a CARTA_OUTPUT_BONUS) (nombre_carta ?nombre_edificio) (bonus ?)))
    ; obtiene los recursos del jugador del mismo tipo que el input y output
    ?recurso_jugador_entrada <- (object (is-a JUGADOR_TIENE_RECURSO)(nombre_jugador ?nombre_jugador) (recurso ?recurso_entrada) (cantidad ?cantidad_recurso_entrada_jugador))
    ?recurso_jugador_salida1 <- (object (is-a JUGADOR_TIENE_RECURSO)(nombre_jugador ?nombre_jugador) (recurso ?recurso_salida1) (cantidad ?cantidad_recurso_salida1_jugador))
    ?recurso_jugador_salida2 <- (object (is-a JUGADOR_TIENE_RECURSO)(nombre_jugador ?nombre_jugador) (recurso ?recurso_salida2) (cantidad ?cantidad_recurso_salida2_jugador))
    ; comprueba que el jugador tiene suficiente input
    (test (>= ?canditad_recurso_entrada_jugador ?cantidad_a_transformar))
    ; calcula la cantidad a transformar
    (bind ?cantidad_transformada_recurso_salida1 (min (* ?cantidad_maxima ?cantidad_unitaria1) (* ?cantidad_a_transformar ?cantidad_unitaria1)))
    (bind ?cantidad_transformada_recurso_salida2 (min (* ?cantidad_maxima ?cantidad_unitaria2) (* ?cantidad_a_transformar ?cantidad_unitaria2)))

    ; calcula la cantidad de energía empleada
    (bind ?cantidad_energia_empleada (* ?cantidad_a_transformar ?coste_energia))
    ; obtener los recursos de energia del jugador.
    ?madera_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso MADERA) (cantidad ?cantidad_madera_jugador))
    ?carbon_vegetal_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso CARBON_VEGETAL) (cantidad ?cantidad_carbon_vegetal_jugador))
    ?carbon_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso CARBON) (cantidad ?cantidad_cabon_jugador))
    ?coque_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso COQUE) (cantidad ?cantidad_coque_jugador))
    ;comprueba que el jugador tiene suficiente energía
    (test (> =(+ =(* ?cantidad_madera 1) (* ?cantidad_carbon_vegetal 3) (* ?cantidad_carbon 3) (* ?cantidad_coque 10)) ?cantidad_energia_empleada))

    =>
    ; modifica el recurso input del jugador
    (modify-instance ?recurso_jugador_entrada (cantidad (- ?cantidad_recurso_entrada_jugador ?cantidad_a_transformar)))
    ; modifica el primer output del jugador
    (modify-instance ?recurso_jugador_salida1 (cantidad (+ ?cantidad_recurso_salida1_jugador ?cantidad_transformada_recurso_salida1)))
    ; modifica el segundo output del jugador
    (modify-instance ?recurso_jugador_salida2 (cantidad (+ ?cantidad_recurso_salida2_jugador ?cantidad_transformada_recurso_salida2)))

    ; modifica los recursos energéticos del jugador.
    (modify-instance ?madera_jugador (cantidad (- ?cantidad_madera_jugador ?cantidad_madera)))
    (modify-instance ?carbon_vegetal_jugador (cantidad (- ?cantidad_carbon_vegetal_jugador ?cantidad_carbon_vegetal)))
    (modify-instance ?carbon_jugador (cantidad (- ?cantidad_cabon_jugador ?cantidad_carbon)))
    (modify-instance ?coque_jugador (cantidad (- ?cantidad_coque_jugador ?cantidad_coque)))
    ; Ha finalizado su actividad principal dentro de su turno.
    (assert (fin_actividad_principal ?nombre_jugador))
    ; eliminar deseos
    (retract ?deseo_generar)
    (retract ?deseo_pago_energia)
    ; flag para no permitir usar el mismo edificio dos veces.
    (retract ?ha_usado_edificio)
    (assert (edificio_usado ?nombre_edificio ?nombre_jugador))

)
(defrule EDIFICIO_GENERA_RECURSO_CASO5_BIS
    ;   INPUTS          OUTPUT          BONUS   ENERGIA     edificios
    ;      1               2              0        1        (ahumador (1 total), ladrillos (por ud), panaderia (por ud))
    ; el jugador está dentro del edificio
    (JUGADOR_ESTA_EDIFICIO (nombre_edificio ?nombre_edificio)(nombre_jugador ?nombre_jugador))
    ; el jugador no ha usado anteriormente el edificio
    ?ha_usado_edificio <- (edificio_usado ?ed ?nombre_jugador)
    (test (neq ?nombre_edificio ?ed))
    ; es el turno del jugador
    (turno ?nombre_jugador)
    ; el jugador tiene el deseo de usar el edificio empleando X recursos de entrada
    (deseo_generar_con_recurso ?nombre_jugador ?nombre_edificio ?recurso_entrada ?cantidad_a_transformar)
    
    ?deseo_pago_energia <- (deseo_emplear_energia ?nombre_jugador ?nombre_edificio ? ?cantidad_madera ? ?cantidad_carbon_vegetal ? ?cantidad_carbon ? ?cantidad_coque)
    
    ; obtiene el input del edificio 
    (object (is-a EDIFICIO_INPUT) (nombre_carta ?nombre_edificio) (recurso ?recurso_entrada) (cantidad_maxima ?cantidad_maxima))
    ; obtiene el primer output del edificio
    (object (is-a EDIFICIO_OUTPUT) (nombre_carta ?nombre_edificio) (recurso ?recurso_salida1) (cantidad_min_generada_por_unidad ?cantidad_unitaria1))
    (object (is-a EDIFICIO_OUTPUT) (nombre_carta ?nombre_edificio) (recurso ?recurso_salida2) (cantidad_min_generada_por_unidad ?cantidad_unitaria2))
    
    ; obtiene el coste energético del edificio
    (object (is-a COSTE_ENERGIA) (coste_unitario FALSE) (cantidad ?coste_energia))

    ; el edificio no tiene bonus
    (not (object (is-a CARTA_OUTPUT_BONUS) (nombre_carta ?nombre_edificio) (bonus ?)))
    ; obtiene los recursos del jugador del mismo tipo que el input y output
    ?recurso_jugador_entrada <- (object (is-a JUGADOR_TIENE_RECURSO)(nombre_jugador ?nombre_jugador) (recurso ?recurso_entrada) (cantidad ?cantidad_recurso_entrada_jugador))
    ?recurso_jugador_salida1 <- (object (is-a JUGADOR_TIENE_RECURSO)(nombre_jugador ?nombre_jugador) (recurso ?recurso_salida1) (cantidad ?cantidad_recurso_salida1_jugador))
    ?recurso_jugador_salida2 <- (object (is-a JUGADOR_TIENE_RECURSO)(nombre_jugador ?nombre_jugador) (recurso ?recurso_salida2) (cantidad ?cantidad_recurso_salida2_jugador))
    ; comprueba que el jugador tiene suficiente input
    (test (>= ?canditad_recurso_entrada_jugador ?cantidad_a_transformar))
    ; calcula la cantidad a transformar
    (bind ?cantidad_transformada_recurso_salida1 =(min =(* ?cantidad_maxima ?cantidad_unitaria1) =(* ?cantidad_a_transformar ?cantidad_unitaria1)))
    (bind ?cantidad_transformada_recurso_salida2 =(min =(* ?cantidad_maxima ?cantidad_unitaria2) =(* ?cantidad_a_transformar ?cantidad_unitaria2)))

    ; obtener los recursos de energia del jugador.
    ?madera_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso MADERA) (cantidad ?cantidad_madera_jugador))
    ?carbon_vegetal_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso CARBON_VEGETAL) (cantidad ?cantidad_carbon_vegetal_jugador))
    ?carbon_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso CARBON) (cantidad ?cantidad_cabon_jugador))
    ?coque_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso COQUE) (cantidad ?cantidad_coque_jugador))
    ;comprueba que el jugador tiene suficiente energía
    (test (> =(+ =(* ?cantidad_madera 1) =(* ?cantidad_carbon_vegetal 3) =(* ?cantidad_carbon 3) =(* ?cantidad_coque 10)) ?coste_energia))

    =>
    ; modifica el recurso input del jugador
    (modify-instance ?recurso_jugador_entrada (cantidad (- ?cantidad_recurso_entrada_jugador ?cantidad_a_transformar)))
    ; modifica el primer output del jugador
    (modify-instance ?recurso_jugador_salida1 (cantidad (+ ?cantidad_recurso_salida1_jugador ?cantidad_transformada_recurso_salida1)))
    ; modifica el segundo output del jugador
    (modify-instance ?recurso_jugador_salida2 (cantidad (+ ?cantidad_recurso_salida2_jugador ?cantidad_transformada_recurso_salida2)))

    ; modifica los recursos energéticos del jugador.
    (modify-instance ?madera_jugador (cantidad (- ?cantidad_madera_jugador ?cantidad_madera)))
    (modify-instance ?carbon_vegetal_jugador (cantidad (- ?cantidad_carbon_vegetal_jugador ?cantidad_carbon_vegetal)))
    (modify-instance ?carbon_jugador (cantidad (- ?cantidad_cabon_jugador ?cantidad_carbon)))
    (modify-instance ?coque_jugador (cantidad (- ?cantidad_coque_jugador ?cantidad_coque)))
    ; Ha finalizado su actividad principal dentro de su turno.
    (assert (fin_actividad_principal ?nombre_jugador))
    ; eliminar deseos
    (retract ?deseo_generar)
    (retract ?deseo_pago_energia)
    ; flag para no permitir usar el mismo edificio dos veces.
    (retract ?ha_usado_edificio)
    (assert (edificio_usado ?nombre_edificio ?nombre_jugador))

)

; TODO: FALTA MODELADO DE ENERGIA.
(defrule UTILIZAR_EDIFICIO_CONSTRUCTOR
    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; Obtener la referencia de la carta.
    (object (is-a CARTA) (nombre ?nombre_carta) (valor ?))
    ; El jugador debe estar en el edificio.
    (JUGADOR_ESTA_EDIFICIO (nombre_edificio ?nombre_carta) (nombre_jugador ?nombre_jugador))
    ; el jugador no ha usado anteriormente el edificio
    ?ha_usado_edificio <- (edificio_usado ?ed ?nombre_jugador)
    (test (neq ?nombre_edificio ?ed))

    ; el edificio puede construir. 
    (test (eq ?nombre_carta "CONSTRUCTORA1") or (eq ?nombre_carta "CONSTRUCTORA2") or (eq ?nombre_carta "CONSTRUCTORA3"))
    ; existe un deseo de construir una carta.
    ?deseo <- (deseo_construccion ?nombre_carta)
    ; comprobar que se encuentra en la parte superior del mazo.
    ?pertenencia_mazo <- (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id_mazo) (nombre_carta ?nombre_carta) (posicion 1))
    ; obtener el coste de la carta
    ?coste_carta <- (object (is-a COSTE_CONSTRUCCION_CARTA) (nombre_carta ?nombre_carta) (cantidad_madera ?coste_madera) (cantidad_arcilla ?coste_arcilla) (cantidad_ladrillos ?coste_ladrillos) (cantidad_hierro ?coste_hierro) (cantidad_acero ?coste_acero))
    ; comprobar que el jugador tiene suficientes recursos para construirla.
    ?recurso_jugador_madera <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre ?nombre_jugador) (recurso MADERA) (cantidad ?cantidad_madera))
    ?recurso_jugador_arcilla <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre ?nombre_jugador) (recurso ARCILLA) (cantidad ?cantidad_arcilla))
    ?recurso_jugador_ladrillos <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre ?nombre_jugador) (recurso LADRILLOS) (cantidad ?cantidad_ladrillos))
    ?recurso_jugador_hierro <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre ?nombre_jugador) (recurso HIERRO) (cantidad ?cantidad_hierro))
    ?recurso_jugador_acero <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre ?nombre_jugador) (recurso ACERO) (cantidad ?cantidad_acero))
    
    (test (>= ?cantidad_madera ?coste_madera))
    (test (>= ?cantidad_arcilla ?coste_arcilla))
    (test (>= ?cantidad_ladrillos ?coste_ladrillos))
    (test (>= ?cantidad_hierro ?coste_hierro))
    (test (>= ?cantidad_acero ?coste_acero))
    =>
    ; modificar cantidad de materiales del jugador
    (modify-instance ?recurso_jugador_madera (cantidad (- ?cantidad_madera ?coste_madera)))
    (modify-instance ?recurso_jugador_arcilla (cantidad (- ?cantidad_arcilla ?coste_arcilla)))
    (modify-instance ?recurso_jugador_ladrillos (cantidad (- ?cantidad_ladrillos ?coste_ladrillos)))
    (modify-instance ?recurso_jugador_hierro (cantidad (- ?cantidad_hierro ?coste_hierro)))
    (modify-instance ?recurso_jugador_acero (cantidad (- ?cantidad_acero ?coste_acero)))
    ; quitar carta del mazo
    (unmake-instance ?pertenencia_mazo)
    ; eliminar deseo
    (retract ?deseo)
    ; asignar la carta al jugador
    (make-instance of JUGADOR_TIENE_CARTA (nombre_jugador ?nombre_jugador) (nombre_carta ?nombre_carta))
    ;generar hecho semáforo para reordenar el mazo
    (assert (actualizar_mazo ?id_mazo))
    ; semaforo final actividad principal.
    (assert(fin_actividad_principal ?nombre_jugador)) 
    ; flag para no permitir usar el mismo edificio dos veces.
    (retract ?ha_usado_edificio)
    (assert (edificio_usado ?nombre_edificio ?nombre_jugador))
)


; CARNE 2 francos
; PESCADO AHUMADO 2 francos
; CARBON_VEGETAL 2 francos
; PIEL 2 francos
; LADRILLO 2 francos
; HIERRO 2 FRANCOS
; GANADO 3 francos
; PAN 3 francos
; CARBON 3 francos
; CUERO 4 francos
; COQUE 5 francos
; ACERO 8 francos
; OTRO (pez madera arcilla grano) 1 franco

; REGLAS PARA COMERCIAR. SE INCLUYE UNA REGLA PARA EL MERCADO Y OTRA PARA LA COMPAÑÍA NAVIERA
(defrule COMERCIAR_EN_COMPAÑIA_NAVIERA
    ; jugador dentro del edificio
    (JUGADOR_ESTA_EDIFICIO (nombre_edificio "COMPAÑIA NAVIERA") (nombre_jugador ?nombre_jugador))
    ; el jugador no ha usado anteriormente el edificio
    ?ha_usado_edificio <- (edificio_usado ?ed ?nombre_jugador)
    (test (neq ?nombre_edificio ?ed))
    ; existe el deseo de usar la compañía naviera (contiene qué objetos vender)
    ?deseo <- (deseo_usar_compañia_naviera ?nombre_jugador ?pescado ?madera ?arcilla ?hierro ?grano ?ganado ?carbon ?piel ?pescado_ahumado ?carbon_vegetal ?ladrillos ?acero ?pan ?carne ?coque ?cuero)
    (bind ?unidades_comerciar =(+ ?pescado ?madera ?arcilla ?hierro ?grano ?ganado ?carbon ?piel ?pescado_ahumado ?carbon_vegetal ?ladrillos ?acero ?pan ?carne ?coque ?cuero)
    ; obtiene los datos del jugador.
    ?jugador <- (object (is-a JUGADOR)(nombre ?nombre_jugador)(deudas ?)(num_barcos ?)(capacidad_envio ?capacidad_envio)(demanda_comida_cubierta ?))
    ; comprobar que la suma no excede la capacidad de los barcos
    (test (<= ?unidades_comerciar ?capacidad_envio))
    ; obtencion numero de recursos del jugador.
    ?pescado_jugador <- (JUGADOR_TIENE_RECURSO (nombre_jugador ?nombre_jugador) (recurso PESCADO) (cantidad ?cantidad_pescado))
    ?madera_jugador <- (JUGADOR_TIENE_RECURSO (nombre_jugador ?nombre_jugador) (recurso MADERA) (cantidad ?cantidad_madera))
    ?arcilla_jugador <- (JUGADOR_TIENE_RECURSO (nombre_jugador ?nombre_jugador) (recurso ARCILLA) (cantidad ?cantidad_arcilla))
    ?hierro_jugador <- (JUGADOR_TIENE_RECURSO (nombre_jugador ?nombre_jugador) (recurso HIERRO) (cantidad ?cantidad_hierro))
    ?grano_jugador <- (JUGADOR_TIENE_RECURSO (nombre_jugador ?nombre_jugador) (recurso GRANO) (cantidad ?cantidad_grano))
    ?ganado_jugador <- (JUGADOR_TIENE_RECURSO (nombre_jugador ?nombre_jugador) (recurso GANADO) (cantidad ?cantidad_ganado))
    ?carbon_jugador <- (JUGADOR_TIENE_RECURSO (nombre_jugador ?nombre_jugador) (recurso CARBON) (cantidad ?cantidad_carbon))
    ?piel_jugador <- (JUGADOR_TIENE_RECURSO (nombre_jugador ?nombre_jugador) (recurso PIEL) (cantidad ?cantidad_piel))
    ?pescado_ahumado_jugador <- (JUGADOR_TIENE_RECURSO (nombre_jugador ?nombre_jugador) (recurso PESCADO_AHUMADO) (cantidad ?cantidad_pescado_ahumado))
    ?carbon_vegetal_jugador <- (JUGADOR_TIENE_RECURSO (nombre_jugador ?nombre_jugador) (recurso CARBON_VEGETAL) (cantidad ?cantidad_carbon_vegetal))
    ?ladrillos_jugador <- (JUGADOR_TIENE_RECURSO (nombre_jugador ?nombre_jugador) (recurso LADRILLOS) (cantidad ?cantidad_ladrillos))
    ?acero_jugador <- (JUGADOR_TIENE_RECURSO (nombre_jugador ?nombre_jugador) (recurso ACERO) (cantidad ?cantidad_acero))
    ?pan_jugador <- (JUGADOR_TIENE_RECURSO (nombre_jugador ?nombre_jugador) (recurso PAN) (cantidad ?cantidad_pan))
    ?carne_jugador <- (JUGADOR_TIENE_RECURSO (nombre_jugador ?nombre_jugador) (recurso CARNE) (cantidad ?cantidad_carne))
    ?coque_jugador <- (JUGADOR_TIENE_RECURSO (nombre_jugador ?nombre_jugador) (recurso COQUE) (cantidad ?cantidad_coque))
    ?cuero_jugador <- (JUGADOR_TIENE_RECURSO (nombre_jugador ?nombre_jugador) (recurso CUERO) (cantidad ?cantidad_cuero))
    ; las cantidades quedan comprobadas en el deseo.
    ; obtener la referencia de los francos para el jugador.
    ?francos_jugador <- (JUGADOR_TIENE_RECURSO (nombre_jugador ?nombre_jugador) (recurso FRANCO) (cantidad ?cantidad_francos))
    ; obtener la cantidad generada por el deseo.
    (bind ?ingresos_comercio (+ (* ?pescado 1) (* ?madera 1) (* ?arcilla 1) (* ?hierro 2) (* ?grano 1) (* ?ganado 3) (* ?carbon 3) (* ?piel 2)
                                (* ?pescado_ahumado 2) (* ?carbon_vegetal 2) (* ?ladrillo 2) (* ?acero 8)
                                (* ?pan 3) (* ?carne 2) (* ?coque 5) (* ?cuero 4) ))
    =>
    ; restar cantidades vendidas
    (modify-instance ?pescado_jugador (cantidad (- ?cantidad_pescado ?pescado)))
    (modify-instance ?madera_jugador (cantidad (- ?madera_jugador ?pescado)))
    (modify-instance ?arcilla_jugador (cantidad (- ?arcilla_jugador ?pescado)))
    (modify-instance ?hierro_jugador (cantidad (- ?hierro_jugador ?pescado)))
    (modify-instance ?grano_jugador (cantidad (- ?grano_jugador ?pescado)))
    (modify-instance ?ganado_jugador (cantidad (- ?ganado_jugador ?pescado)))
    (modify-instance ?carbon_jugador (cantidad (- ?carbon_jugador ?pescado)))
    (modify-instance ?piel_jugador (cantidad (- ?piel_jugador ?pescado)))
    (modify-instance ?pescado_ahumado_jugador (cantidad (- ?pescado_ahumado_jugador ?pescado)))
    (modify-instance ?carbon_vegetal_jugador (cantidad (- ?carbon_vegetal_jugador ?pescado)))
    (modify-instance ?ladrillos_jugador (cantidad (- ?ladrillos_jugador ?pescado)))
    (modify-instance ?acero_jugador (cantidad (- ?acero_jugador ?pescado)))
    (modify-instance ?pan_jugador (cantidad (- ?pan_jugador ?pescado)))
    (modify-instance ?carne_jugador (cantidad (- ?carne_jugador ?pescado)))
    (modify-instance ?coque_jugador (cantidad (- ?coque_jugador ?pescado)))
    (modify-instance ?cuero_jugador (cantidad (- ?cuero_jugador ?pescado)))

    ; añadir francos al jugador
    (modify-instance ?francos_jugador (cantidad (+ ?francos_jugador ?ingresos_comercio)))
    ; eliminar deseo
    (retract ?deseo)
    ; semaforo final actividad principal.
    (assert (fin_actividad_principal ?nombre_jugador))
    ; flag para no permitir usar el mismo edificio dos veces.
    (retract ?ha_usado_edificio)
    (assert (edificio_usado ?nombre_edificio ?nombre_jugador))
    ; log
    (printout t"El jugador <" ?nombre_jugador "> ha obtenido <" ?ingresos_comercio"> francos comerciando con sus barcos." crlf)
)

(defrule COMERCIAR_MERCADO
    ; El jugador está en el mercado

    ; el jugador no ha usado anteriormente el edificio
    ?ha_usado_edificio <- (edificio_usado ?ed ?nombre_jugador)
    (test (neq ?nombre_edificio ?ed))
    ; SOLO PUEDE TOMAR UNA UNIDAD DE CADA RECURSO QUE HAY EN EL MERCADO (POR CADA VEZ).
    ; UN MINIMO DE 2 VECES Y UN MÁXIMO DE 8
    ; rECURSOS: 1 de pescado, madera, arcilla, hierro, grano, ganado, carbon, piel

    ; PROBLEMA ECONTRADO: COMO RECORRER LOS EDIFICIOS DEL JUGADOR PARA OBTENER EL Nº DE EDIFICOS BASICOS.
    =>

    ; flag para no permitir usar el mismo edificio dos veces.
    (retract ?ha_usado_edificio)
    (assert (edificio_usado ?nombre_edificio ?nombre_jugador))
)






; OK
;   4-. Comprar barco
; (defrule COMPRAR_BARCO
;     ; Es el turno del jugador
;     ?turno <- (turno ?nombre_jugador)
;     ; Existe el deseo de comprar el barco
;     ?deseo <- (deseo_comprar_barco ?nombre_barco)
;     ; Ha finalizado su actividad principal dentro de su turno.
;     (fin_actividad_principal ?nombre_jugador)
;     ; El barco está disponible
;     ?disponible <- (BARCO_DISPONIBLE (nombre_barco ?nombre_barco))
;     ; El barco es el primero de su mazo
;     ?barco_en_mazo <- (object  (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id_mazo) (nombre_carta ?nombre_barco) (posicion_en_mazo 1))
;     ; El jugador tiene dinero para comprarlo
;     ; Obtiene el coste de comprar el barco
;     (object (is-a BARCO) (nombre ?nombre_barco) (coste ?coste_barco) (valor ?)(uds_comida_genera ?uds_comida_genera)(capacidad_envio ?capacidad_envio_barco))
;     ; Obtiene el dinero del jugador
;     ?recurso_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso FRANCOS) (cantidad ?cantidad_recurso))
;     ; El jugador tiene suficiente dinero
;     (test (>= ?cantidad_recurso ?coste_barco))
;     ; se obtiene al jugador
;     ?jugagor <- (object (is-a JUGADOR)(nombre ?nombre_jugador)(num_barcos ?num_barcos)(capacidad_envio ?capacidad_envio_jugador)(demanda_comida_cubierta ?demanda_comida_cubierta))
;     =>
;     ; Modificar el dinero del jugador
;     (modify-instance ?recurso_jugador (cantidad (- ?cantidad_recurso ?coste_barco)))
;     ; Quitar la carta del mazo
;     (unmake-instance ?barco_en_mazo)
;     ; Asignar el barco al jugador
;     (make-instance of JUGADOR_TIENE_CARTA (nombre_jugador ?nombre_jugador) (nombre_carta ?nombre_barco))
;     ; Actualiza los valores relacionados con el barco en el jugador
;     (modify-instance JUGADOR (num_barcos (+ ?num_barcos 1) (capacidad_envio (+ ?capacidad_envio_jugador ?capacidad_envio_barco) (demanda_comida_cubierta (+ ?demanda_comida_cubierta ?uds_comida_genera)))))
;     ; Eliminar el deseo de comprar el barco
;     (retract ?deseo)
;     ; Quitar el barco de disponibles
;     (retract ?disponible)
;     ; Generar hecho semáforo para actualizar el orden de las cartas del mazo
;     (assert (actualizar_mazo ?id_mazo))
; )

; OK
;   5-. Vender barco (otorga mitad de valor)
; (defrule VENDER_BARCO
;     ; Es el turno del jugador
;     ?turno <- (turno ?nombre_jugador)
;     ; Existe el deseo de vender el barco
;     ?deseo <- (deseo_vender_barco ?nombre_barco)
;     ; Ha finalizado su actividad principal dentro de su turno.
;     (fin_actividad_principal ?nombre_jugador)
;     ; El barco es del jugador
;     ?jugador_tiene_barco <- (object (is-a JUGADOR_TIENE_CARTA) (nombre_jugador ?nombre_jugador)(nombre_carta ?nombre_barco))
;     ; Obtiene el valor del barco
;     ?barco <- (object (is-a BARCO)(coste ?coste_barco)(valor ?valor_barco)(uds_comida_genera ?uds_comida_genera)(capacidad_envio ?capacidad_envio_barco))
;     ; Obtiene el dinero del jugador
;     ?recurso_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso FRANCOS) (cantidad ?cantidad_recurso))
;     ; se obtiene al jugador
;     ?jugagor <- (object (is-a JUGADOR)(nombre ?nombre_jugador)(num_barcos ?num_barcos)(capacidad_envio ?capacidad_envio_jugador)(demanda_comida_cubierta ?demanda_comida_cubierta))
;     =>
;     ; Elimina el barco del jugador
;     (unmake-instance ?jugador_tiene_barco)
;     ; Actualiza los valores relacionados con el barco en el jugador
;     (modify-instance JUGADOR (num_barcos (- ?num_barcos 1) (capacidad_envio =(- ?capacidad_envio_jugador ?capacidad_envio_barco) (demanda_comida_cubierta (- ?demanda_comida_cubierta ?uds_comida_genera)))))
;     ; Actualiza el dinero del jugador
;     (modify-instance ?recurso_jugador (cantidad (+ ?cantidad_recurso =(/ ?valor_barco 2))))
;     ; Elimina el deseo
;     (retract ?deseo)
; )

; (defrule PASAR_TURNO_Y_RONDA
;     ; para cambiar de ronda se tiene que dar la siguiente situación
;     ;1| |1| |1|2|1|   y turno de 2
;     ;0|1|2|3|4|5|6|0
;     ?jugador1 <- (object (is-a JUGADOR) (nombre ?nombre_jugador1))
;     ?posicion_jugador1 <- (object (is-a JUGADOR_ESTA_EN_LOSETA) (posicion ?pos_jugador1) (nombre_jugador ?nombre_jugador1))
;     ?jugador2 <- (object (is-a JUGADOR) (nombre ?nombre_jugador2))
;     ?posicion_jugador2 <- (object (is-a JUGADOR_ESTA_EN_LOSETA) (posicion ?pos_jugador2) (nombre_jugador ?nombre_jugador2))
;     (test (eq ?pos_jugador1 6))
;     (test (eq ?pos_jugador2 5))
;     (test (neq ?jugador1 ?jugador2))
    
;     ; Ha finalizado su actividad principal dentro de su turno.
;     ?turno_finalizado <- (fin_actividad_principal ?nombre_jugador1)
;     ?turno_j1 <- (turno ?nombre_jugador1)
;     ; selección de siguiente ronda
;     ?ronda_actual <- (ronda_actual ?nombre_ronda_actual)
;     ?ronda_siguiente <- (object (is-a RONDA) (nombre_ronda ?nombre_ronda_siguiente))
;     (siguiente_ronda ?nombre_ronda_actual ?nombre_ronda_siguiente)
;     ; eliminar el semaforo de la restriccion de añadir recurso a la oferta.
;     ?semaforo <- (recursos_añadidos_loseta ?)
;     =>
;     (bind ?nueva_posicion (+ ?pos_jugador2 2))
;     ; deshace el hecho semaforo del turno.
;     (retract ?turno_finalizado)
;     ; eliminar turno jugador 1
;     (retract ?turno_j1)
;     ; generar hecho turno j2.
;     (assert (turno ?nombre_jugador2))
;     ; modifica la posición del jugador 2
;     (modify-instance ?posicion_jugador2 (posicion (mod ?nueva_posicion 7)))
;     ; eliminar semaforo
;     (retract ?semaforo)
;     (retract ?ronda_actual)
;     (assert (ronda_actual ?nombre_ronda_siguiente))
    
;     (retract ?semaforo)
;     (printout t"=====================================================================================================" crlf)
;     (printout t"El jugador: <" ?nombre_jugador1 "> ha finalizado su turno. " crlf)
;     (printout t"El jugador: <" ?nombre_jugador2 "> ha empezado su turno en la posicion <" (mod ?nueva_posicion 7) ">. " crlf)

;     (printout t"Cambio de ronda: <"?nombre_ronda_actual "> ==> <"?nombre_ronda_siguiente">." crlf)
; )

; (defrule PASAR_TURNO
;     ; pensar si debería haber alguna precondición o si simplemente por estar 
;     ; en la posición que está la regla ya se asegura que sólo se instancia
;     ; cuando el jugador no puede hacer nada más
;     ?jugador1 <- (object (is-a JUGADOR) (nombre ?nombre_jugador1))
;     ?jugador2 <- (object (is-a JUGADOR) (nombre ?nombre_jugador2))
;     ?posicion_jugador1 <- (object (is-a JUGADOR_ESTA_EN_LOSETA) (posicion ?pos_jugador1) (nombre_jugador ?nombre_jugador1))
;     ?posicion_jugador2 <- (object (is-a JUGADOR_ESTA_EN_LOSETA) (posicion ?pos_jugador2) (nombre_jugador ?nombre_jugador2))
;     (test (neq ?jugador1 ?jugador2))
;     (test (neq ?pos_jugador1 6))
;     ; Ha finalizado su actividad principal dentro de su turno.
;     ?turno_finalizado <- (fin_actividad_principal ?nombre_jugador1)
;     ?turno_j1 <- (turno ?nombre_jugador1)
;     ; Generalización: mueve al otro jugador
;     ?posicion_actual_jugador2 <- (object (is-a JUGADOR_ESTA_EN_LOSETA) (posicion ?pos_jugador2) (nombre_jugador ?nombre_jugador2))
;     ; eliminar el semaforo de la restriccion de añadir recurso a la oferta.
;     ?semaforo <- (recursos_añadidos_loseta ?)
;     =>
;     (bind ?nueva_posicion (+ ?pos_jugador2 2))
;     ; deshace el hecho semaforo del turno.
;     (retract ?turno_finalizado)
;     ; eliminar turno jugador 1
;     (retract ?turno_j1)
;     ; generar hecho turno j2.
;     (assert (turno ?nombre_jugador2))
;     ; modifica la posición del jugador 2
;     (modify-instance ?posicion_actual_jugador2 (posicion (mod ?nueva_posicion 7)))
;     ; eliminar semaforo
;     (retract ?semaforo)osicion_en_mazo
;     (printout t"=====================================================================================================" crlf)
;     (printout t"El jugador: <" ?nombre_jugador1 "> ha finalizado su turno. " crlf)
;     (printout t"El jugador: <" ?nombre_jugador2 "> ha empezado su turno en la posicion <" (mod ?nueva_posicion 7) ">. " crlf)


; )


;   8-. Actualizar cartas mazos
; Modifica la posición de todas las cartas de un mazo restándoles 1. 
; PREGUNTAR SI ESTO SE PUEDE HACER ASÍ => deberá tener máxima prioridad!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
; (defrule ACTUALIZAR_POSICION_CARTAS_MAZO
;     ?carta_mazo <- (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id) (nombre_carta ?nombre_carta) (posicion ?pos))
;     ?actualizacion <- (actualizar_mazo ?id)
;     (forall (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id) (nombre_carta ?nombre_carta) (posicion ?pos)))
;     =>
;     (modify-instance ?carta_mazo(posicion (- ?pos 1))
;     (retract ?actualizacion)
; )

;   9-. Dar vuelta losetas
; (defrule DESTAPAR_LOSETA
;     ; obtener casilla
;     ?casilla <- (object (is-a LOSETA) (posicion ?pos) (visibilidad ?visible))
;     ; comprobar que hay un jugador en la casilla
;     ?posicion_jugador <- (object (is-a JUGADOR_ESTA_EN_LOSETA) (posicion ?pos))
;     ; comprobar que la casilla está oculta    
;     (test (eq ?visible FALSE))
;     =>
;     ; hacer casilla visible
;     (modify-instance ?casilla (visibilidad TRUE))
; )

;   10-. Añadir recursos de las losetas a la oferta.

; (defrule AÑADIR_RECURSOS_OFERTA
;     ; no añadir dos veces 
;     (not (recursos_añadidos_loseta ?pos))
;     ; obtiene la loseta con visibilidad TRUE
;     ?loseta <- (object (is-a LOSETA) (posicion ?pos) (visibilidad TRUE))
;     ; el jugador está en la loseta
;     (object (is-a JUGADOR_ESTA_EN_LOSETA) (posicion ?pos) (nombre_jugador ?nombre_jugador))
;     ; y turno jugador
;     (turno ?nombre_jugador)
;     ; Obtiene la oferta
;     ?oferta_recurso1 <- (OFERTA_RECURSO (recurso ?recurso1) (cantidad ?cantidad_oferta1))
;     ?oferta_recurso2 <- (OFERTA_RECURSO (recurso ?recurso2) (cantidad ?cantidad_oferta2))
;     ; Por cada recurso de la loseta...
;     ?ref_recurso1 <- (object (is-a LOSETA_TIENE_RECURSO) (posicion ?pos) (recurso ?recurso1) (cantidad ?cantidad_recurso1))
;     ?ref_recurso2 <- (object (is-a LOSETA_TIENE_RECURSO) (posicion ?pos) (recurso ?recurso2) (cantidad ?cantidad_recurso2))
;     (test (neq ?ref_recurso1 ?ref_recurso2))
;     => 
;     ; añadir a la oferta.
;     (modify ?oferta_recurso1 (cantidad (+ ?cantidad_oferta1 ?cantidad_recurso1)))
;     (modify ?oferta_recurso2 (cantidad (+ ?cantidad_oferta2 ?cantidad_recurso2)))
;     (assert (recursos_añadidos_loseta ?pos))
;     (printout t"=====================================================================================================" crlf)
;     (printout t"Se han añadido a la OFERTA los recursos de la loseta con posición: <" ?pos ">" crlf)
;     (printout t"  La cantidad <" ?cantidad_recurso1 "> de recurso <" ?recurso1 ">." crlf)
;     (printout t"  La cantidad <" ?cantidad_recurso2 "> de recurso <" ?recurso2 ">." crlf)
; )

; SIN ACABAR !!! HAY QUE MODELAR LAS DEUDAS!!!!
; hay que tener en cuenta que el jugador puede tener suficiente dinero
; puede tener sólo parte del dinero o puede no tener nada. 
; Si tiene suficiente, se paga y listo. Si no tiene suficiente pero tiene
; algo, se paga parte y se endeuda el resto. Si no tiene nada se endeuda
; con todo. 
; 11-. Hacer pagar intereses
; (defrule PAGAR_INTERESES_FRANCOS
;     ; obtiene el jugador
;     ?jugador <- (object(is-a JUGADOR)(nombre_jugador ?nombre)(deudas ?deudas))
;     ; obtiene los recursos del jugador
;     ?jugador_recursos <- (object (is-a JUGADOR_TIENE_RECURSO)(nombre_jugador ?nombre)(recurso FRANCOS)(cantidad ?cantidad_francos))
;     ; obtiene la posición del jugador
;     ?jugador_loseta <- (object (is-a JUGADOR_ESTA_EN_LOSETA)(posicion ?pos)(nombre_jugador ?nombre))
;     ; la loseta tiene pago de intereses
;     ?loseta <- (object (is-a LOSETA)(posicion ?pos)(visibilidad TRUE)(intereses TRUE))
;     ; el jugador tiene deudas 
;     (test (> ?deudas 0))
;     ; el jugador tiene dinero para pagarlo
;     (test (> ?cantidad_francos 0))
;     =>
;     ; restar dinero al jugador
;     (modify-instance ?jugador_recursos (cantidad (- ?cantidad_francos 1)))
; )
; (defrule PAGAR_INTERESES_ENDEUDANDOSE
;     ; obtiene el jugador
;     ?jugador <- (object(is-a JUGADOR)(nombre_jugador ?nombre)(deudas ?deudas))
;     ; obtiene los recursos del jugador
;     ?jugador_recursos <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre) (recurso FRANCOS)(cantidad ?cantidad_francos))
;     ; obtiene la posición del jugador
;     ?jugador_loseta <- (object (is-a JUGADOR_ESTA_EN_LOSETA)(posicion ?pos)(nombre_jugador ?nombre))
;     ; la loseta tiene pago de intereses
;     ?loseta <- (object (is-a LOSETA)(posicion ?pos)(visibilidad TRUE)(intereses TRUE))
;     ; el jugador tiene al menos una deuda.
;     (test (> ?deudas 0))
;     ; el jugador NO tiene dinero para pagarlo
;     (test (< ?cantidad_francos 1))
;     =>
;     ; aumentar deuda del jugador en 1
;     (modify-instance ?jugador (deudas (+ ?deudas 1)))
;     ; una deuda otorga 4 francos, pero al necesitarla para pagar 
;     (modify-instance ?jugador_recursos (cantidad (+ ?cantidad_francos 3)))
    
; )
; (defrule PAGAR_DEUDA
;     ; obtiene las deudas del jugador
;     ?jugador <- (object (is-a JUGADOR)(nombre_jugador ?nombre)(deudas ?deudas))
;     ; deseo de pagar deudas
;     ; todo: el jugador en una regla estratégica deberá comprobar cuanta deuda quiere pagar.
;     ?deseo <- (DESEO_PAGAR_DEUDA (nombre_jugador ?nombre)  (cantidad_deudas ?cantidad_deuda)
;     ; Obtener los francos del jugador
;     ?jugador_dinero <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre)(recurso FRANCOS) (cantidad ?cantidad_francos))
;     =>
;     (modify-instance ?jugador_dinero (cantidad =(?cantidad_francos ?cantidad_deuda)))
; )
; ; 12-. Pagar comida final ronda (se pueden endeudar)
; ; 12A-. El jugador tiene suficientes recursos para pagar la comida
; (defrule PAGAR_COMIDA
;     ; todo: asumir que el deseo introduce las cantidades correctamente.
;     ; semáforo cambiar ronda
;     (cambiar_ronda TRUE)
;     ; el jugador aún no ha pagado
;     (not (demanda_pagada ?nombre_jugador ?ronda))
;     ; obtener los datos del jugador.
;     (object (is-a JUGADOR) (nombre ?nombre_jugador) (demanda_comida_cubierta ?cantidad_comida_cubierta))
;     ; obtener los datos de la ronda.
;     (object (is-a RONDA) (nombre_ronda ?ronda) (coste_comida ?coste_ronda))
;     ; deseo de pagar la demanda de la ronda.
;     ?deseo <- (deseo_pagar_demanda ?nombre_jugador ?deseo_pagar_pescado ?deseo_pagar_pescado_ahumado ?deseo_pagar_pan ?deseo_pagar_carne ?deseo_pagar_francos)
;     ; obtener los recursos del jugador.
;     ?jugador_pescado <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso PESCADO) (cantidad ?cantidad_pescado))
;     ?jugador_pescado_ahumado <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso PESCADO_AHUMADO) (cantidad ?cantidad_pescado_ahumado))
;     ?jugador_pan <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso PAN) (cantidad ?cantidad_pan))
;     ?jugador_carne <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso CARNE) (cantidad ?cantidad_carne))
;     ?jugador_francos <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre_jugador ?nombre_jugador) (recurso FRANCOS) (cantidad ?cantidad_francos))
    
;     (test (< ?coste_ronda (+ ?cantidad_comida_cubierta (* ?cantidad_pescado 1) (* ?cantidad_pescado_ahumado 2)  (* ?cantidad_pan 3) (* ?cantidad_carne 3) (* ?cantidad_francos 1) )))
    
;     =>
;     (assert (demanda_pagada ?nombre_jugador ?ronda))
;     (modify-instance ?jugador_pescado (cantidad (- ?cantidad_pescado ?deseo_pagar_pescado)))
;     (modify-instance ?jugador_pescado_ahumado (cantidad (- ?cantidad_pescado ?deseo_pagar_pescado_ahumado)))
;     (modify-instance ?jugador_pan (cantidad (- ?cantidad_pan ?deseo_pagar_pan)))
;     (modify-instance ?jugador_carne (cantidad (- ?cantidad_carne ?deseo_pagar_carne)))
;     (modify-instance ?jugador_francos (cantidad (- ?cantidad_francos ?deseo_pagar_francos)))
;     (retract ?deseo)
;     (printout t"El jugador <" ?nombre_jugador "> ha pagado la demanda de comida de la ronda <" ?ronda ">." crlf)
;  )

;  (defrule PAGAR_COMIDA_CON_DEUDA
;     ; El jugador primero se tiene que quedar seco de recursos, como última instancia se deberá endeudar.

;     ; hecho semáforo para pagar comida
;     (PAGAR_COMIDA (nombre_jugador ?nombre) (ronda ?ronda))
;     ; deseo de pagar la oferta de la ronda.
;     (deseo pagar_demanda ?nombre PESCADO ?deseo_pagar_pescado PESCADO_AHUMADO ?deseo_pagar_pescado_ahumado PAN ?deseo_pagar_pan CARNE ?deseo_pagar_carne FRANCOS ?deseo_pagar_francos)
;     ?ronda <- (object (is-a RONDA) (nombre_ronda ?ronda) (coste_comida ?coste_ronda) (hay_cosecha ?))
;     ?jugador_pescado <- (object (is-a JUGADOR_TIENE_RECURSO)(nombre_jugador ?nombre) (recurso PESCADO) (cantidad ?cantidad_pescado))
;     ?jugador_pescado_ahumado <- (object (is-a JUGADOR_TIENE_RECURSO)(nombre_jugador ?nombre) (recurso PESCADO_AHUMADO) (cantidad ?cantidad_pescado_ahumado))
;     ?jugador_pan <- (object (is-a JUGADOR_TIENE_RECURSO)(nombre_jugador ?nombre) (recurso PAN) (cantidad ?cantidad_pan))
;     ?jugador_carne <- (object (is-a JUGADOR_TIENE_RECURSO)(nombre_jugador ?nombre) (recurso CARNE) (cantidad ?cantidad_carne))
;     ?jugador_francos <- (object (is-a JUGADOR_TIENE_RECURSO)(nombre_jugador ?nombre) (recurso FRANCOS) (cantidad ?cantidad_francos))
;     ; se puede hacer un sumatorio de una serie de productos? canditad_recurso*uds_proporciona
;     test(< (+ (* ?cantidad_pescado 1) (* ?cantidad_pescado_ahumado 2) (* ?cantidad_pan 3) (* ?cantidad_carne 3) (* ?cantidad_francos 1)) ?coste_ronda)
;     ?numero_creditos <- (- ?coste_ronda (+ =(* ?cantidad_pescado 1) (* ?cantidad_pescado_ahumado 2) (* ?cantidad_pan 3) (* ?cantidad_carne 3) (* ?cantidad_francos 1)))
;     bind(?numero_creditos =(mod (- ?coste_ronda (+ =(* ?cantidad_pescado 1) (* ?cantidad_pescado_ahumado 2) (* ?cantidad_pan 3) (* ?cantidad_carne 3) (* ?cantidad_francos 1)))
;  4))
;     =(mod =() 4)
    
;  =>
;     (modify-instance ?jugador_pescado (cantidad (- ?cantidad_pescado ?deseo_pagar_pescado)))
;     (modify-instance ?jugador_pescado_ahumado (cantidad (- ?cantidad_pescado ?deseo_pagar_pescado_ahumado)))
;     (modify-instance ?jugador_pan (cantidad (- ?cantidad_pan ?deseo_pagar_pan)))
;     (modify-instance ?jugador_carne (cantidad (- ?cantidad_carne ?deseo_pagar_carne)))
;     (modify-instance ?jugador_francos (cantidad (- ?cantidad_francos ?deseo_pagar_francos)))
    
;  )

;  (defrule PAGAR_COMIDA_CON_RECURSOS
;     ; hecho semáforo para pagar comida
;     ?pago_comida <- (PAGAR_COMIDA (nombre_jugador ?nombre)(cantidad ?cantidad))
;     ; recursos de comida
;     ?jugador_recurso <- (object (is-a JUGADOR_TIENE_RECURSO)(nombre_jugador ?nombre)(recurso ?recurso)(cantidad ?cantidad_recurso))
;     ; probar que sea comida o dinero
;     (test (eq ?recurso PESCADO) or (eq ?recurso PESCADO_AHUMADO) or (eq ?recurso PAN) or (eq ?recurso CARNE) or (eq ?recurso FRANCOS))
;     (?cantidad_pagada (min(?cantidad_recurso ?cantidad)))
;     =>
;     (modify-instance ?pago_comida (cantidad (- ?cantidad ?cantidad_pagada))

;  )
;  (defrule PAGAR_COMIDA_ENDEUDANDOSE
;     ?jugador_pescado <- (object (is-a JUGADOR_TIENE_RECURSO)(nombre_jugador ?nombre) (recurso PESCADO) (cantidad 0))
;     ?jugador_pescado_ahumado <- (object (is-a JUGADOR_TIENE_RECURSO)(nombre_jugador ?nombre) (recurso PESCADO_AHUMADO) (cantidad 0))
;     ?jugador_pan <- (object (is-a JUGADOR_TIENE_RECURSO)(nombre_jugador ?nombre) (recurso PAN) (cantidad 0))
;     ?jugador_carne <- (object (is-a JUGADOR_TIENE_RECURSO)(nombre_jugador ?nombre) (recurso CARNE) (cantidad 0))
;     ?jugador_francos <- (object (is-a JUGADOR_TIENE_RECURSO)(nombre_jugador ?nombre) (recurso FRANCOS) (cantidad 0))
;     ?pago_comida <- (PAGAR_COMIDA (nombre_jugador ?nombre)(cantidad ?cantidad))
;     (test (> ?cantidad 0))
;     (bind (?deudas_a_obtener (+ (?cantidad 5) 1)))
;     ?jugador <- (object (is-a JUGADOR)(nombre_jugador ?nombre)(deudas ?deudas))
;     =>
;     (modify-instance ?jugador (deudas (+ ?deudas ?deudas_a_obtener)))
;     (modify-instance ?jugador_francos (cantidad (- (* ?deudas_a_obtener 5) ?cantidad))
;     (modify-instance ?pago_comida (cantidad (0)))
;     ; ACABAR LOGICA DIVIDIR CANTIDAD A PAGAR ENTRE 5, eso da el número de deudas a coger. 
;     ; con ese valor se puede calcular qué cantidad de francos añadir y restar el correspondiente del coste de comida

;  )

;  (defrule PAGAR_COMIDA_CON_RECURSOS_FIN
;     ?pago_comida <- (PAGAR_COMIDA (nombre_jugador ?nombre)(cantidad 0))
;     =>
;     (unmake-instance ?pago_comida)
; )
; ; ===========================================================================================================

; (defrule ASIGNAR_EDIFICIO_AYUNTO
;     ?edificio <- (object (is-a CARTA) (nombre ?nombre_edificio))
;     ?pertenece <- (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id_mazo) (nombre_carta ?nombre_edificio) (posicion_en_mazo 1))
;     ?asignacion_edificio <- (object (is-a RONDA_ASIGNA_EDIFICIO) (nombre_ronda ?nombre_ronda) (id_mazo ?id_mazo) (nombre_edificio ?nombre_edificio))
;     (ronda_actual ?nombre_ronda)
;     =>
;     (assert EDIFICIO_AYUNTAMIENTO (nombre_edificio ?nombre_edificio))
;     (unmake-instance ?asignacion_edificio)
;     (unmake-instance ?pertenece)
;     ; Introducir un hecho semáforo adicional para disparar la actualización de posición
;     ; en las cartas del mazo. Otra alternativa, jugar prioridad reglas. De momento lo dejamos 
;     ; como hecho semáforo.
;     (assert actualizar_mazo_edificios ?id_mazo)
; )

; (defrule ACTUALIZAR_DISPONIBILIDAD_BARCOS
;     (ronda_actual ?nombre_ronda)
;     ?barco <- (object (is-a BARCO) (nombre ?nombre_barco)(coste ?)(uds_comida_genera ?)(capacidad_envio ?))
;     ?pertenece <- (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id) (nombre_carta ?nombre_barco))
;     ?introduce_barco <- (object (is-a RONDA_INTRODUCE_BARCO) (nombre_ronda ?nombre_ronda) (nombre_carta ?nombre_barco))
;     =>
;     ; TODO: NO SABEMOS EN Q ORDEN QUEDARÍAN LOS BARCOS DISPONIBLES. problema.!!!!!!!!!!!!!!!!!
;     (assert (BARCO_DISPONIBLE (nombre_barco ?nombre_barco)))
;     (unmake-instance ?introduce_barco)
; )

(defrule FINALIZAR_PARTIDA
    (ronda_actual RONDA_EXTRA_FINAL)
     =>
    ; imprimir puntuaciones
    ; recorrer todas las cartas y sumar su valor
    ; restar deudas
    ; sumar francos de los recursos
    (halt)
)


prioridad de edificios => 












;Creditos:
; prestan 4, devolver 5, si lo devuelves al final de la partida 7 ptos. 

;
;   Reglas Estratégicas
;   (deseo_coger_recurso ?recurso)
;   (deseo_comprar_edificios ?ed)
;
;
;
;
;
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