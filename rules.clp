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

    
(defrule TOMAR_RECURSO_OFERTA
    ; ========================================================
    ; Se accede a la cantidad de recursos del jugador.
    ; Se accede a la oferta de recursos de la partida.
    ; Si la cantidad es mayor que cierto umbral (estrategia) en este caso ahora
    ; únicamente si es mayor q 0. 

    ; Obtener el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; Obtener al jugador [se podría eliminar!?]
    (object (is-a JUGADOR) (nombre ?nombre_jugador))
    ; Obtiene los datos del recurso del jugador
    ?recurso_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre ?nombre_jugador) (recurso ?recurso) (cantidad ?cantidad_recurso))
    ; Obtiene el recurso de la oferta que se va a tomar
    ?recurso_oferta <- (OFERTA_RECURSO (recurso ?recurso) (cantidad ?cantidad_oferta))
    ; Comprueba que el recurso de la oferta se pueda obtener
    (test (> ?cantidad_oferta 0))
    ; Hecho estratégico que implique coger recurso de la oferta
    (deseo_coger_recurso ?recurso)
    =>
    ; Actualiza rla cantidad de la oferta
    (modify ?recurso_oferta (cantidad 0))
    ; Actualizar los recursos del jugador
    (modify-instance ?recurso_jugador (cantidad =(+ ?cantidad_recurso ?cantidad_oferta)))
)

;   2-. Comprar edificio
;   Lo único que cambia de estas dos reglas es la pertenencia de la carta. 
; NO SE HA IMPLEMENTADO EL INCREMENTO DE BONUS AUN !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

; Siempre que no sea el banco. 
(defrule COMPRAR_EDIFICIO_AL_AYUNTO
    ; Se puede comprar en la ronda actual. [en todas las rondas excepto la última.]
    (ronda_actual ?nombre_ronda)
    (test (neq ?nombre_ronda RONDA_EXTRA_FINAL))
    ; Obtener el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; Obtener al jugador [se podría eliminar!?]
    (object (is-a JUGADOR) (nombre ?nombre_jugador))
    ; Obtener el edificio del deseo
    ?deseo <- (deseo_comprar_edificio ?nombre_edificio)
    ; El edificio es del ayuntamiento
    ?ayunto <- (EDIFICIO_AYUNTAMIENTO (nombre_edificio ?nombre_edificio))
    ; Obtiene el coste de comprar el edificio
    (object (is-a CARTA) (nombre ?nombre_edificio) (valor ?valor_edificio))
    ; Obtiene el dinero del jugador
    ?recurso_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre ?nombre_jugador) (recurso FRANCOS) (cantidad ?cantidad_recurso))
    ; El jugador tiene suficiente dinero
    (test (>= ?cantidad_recurso ?valor_edificio))
    =>
    ; Modificar el dinero del jugador
    (modify-instance ?recurso_jugador (cantidad =(- ?cantidad_recurso ?valor_edificio)))
    ; Quitar el edificio al ayuntamiento
    (retract ?ayunto)
    ; Asignar el edificio al jugador
    (make-instance (JUGADOR_TIENE_CARTA (nombre_jugador ?nombre_jugador) (nombre_carta ?nombre_edificio)))
    ; Eliminar el deseo de comprar el edificio
    (retract ?deseo)
)

(defrule COMPRAR_EDIFICIO_AL_MAZO
    ; Se puede comprar en la ronda actual. [en todas las rondas excepto la última.]
    (ronda_actual ?nombre_ronda)
    (test (neq ?nombre_ronda RONDA_EXTRA_FINAL))
    ; Obtener el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; Obtener al jugador [se podría eliminar!?]
    (object (is-a JUGADOR) (nombre ?nombre_jugador))
    ; Obtener el edificio del deseo
    ?deseo <- (deseo_comprar_edificio ?nombre_edificio)
    ; El edificio es del mazo
    ?carta_en_mazo <- (of CARTA_PERTENECE_A_MAZO (id_mazo ?) (nombre_carta ?nombre_edificio) (posicion 1))
    ; Obtiene el coste de comprar el edificio
    (object (is-a CARTA) (nombre ?nombre_edificio) (valor ?valor_edificio))
    ; Obtiene el dinero del jugador
    ?recurso_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre ?nombre_jugador) (recurso FRANCOS) (cantidad ?cantidad_recurso))
    ; El jugador tiene suficiente dinero
    (test (>= ?cantidad_recurso ?valor_edificio))
    =>
    ; Modificar el dinero del jugador
    (modify-instance ?recurso_jugador (cantidad =(- ?cantidad_recurso ?valor_edificio)))
    ; Quitar la carta del mazo y mover todas las cartas 1 posición
    (unmake-instance ?carta_en_mazo)
    ; Asignar el edificio al jugador
    (make-instance (JUGADOR_TIENE_CARTA (nombre_jugador ?nombre_jugador) (nombre_carta ?nombre_edificio)))
    ; Eliminar el deseo de comprar el edificio
    (retract ?deseo)
    ; Generar hecho semáforo para actualizar el orden de las cartas del mazo
    (actualizar_mazo ?id_mazo)
)

(defrule COMPRAR_EDIFICIO_BANCO_DEL_AYUNTO
    ; Se puede comprar en la ronda actual. [en todas las rondas excepto la última.]
    (ronda_actual ?nombre_ronda)
    (test (neq ?nombre_ronda RONDA_EXTRA_FINAL))
    ; Obtener el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; Obtener al jugador [se podría eliminar!?]
    (object (is-a JUGADOR) (nombre ?nombre_jugador))
    ; Obtener el edificio del deseo
    ?deseo <- (deseo_comprar_edificio ?nombre_edificio)
    ; El edificio es del ayuntamiento
    ?ayunto <- (EDIFICIO_AYUNTAMIENTO (nombre_edificio ?nombre_edificio))
    ; Obtiene el coste de comprar el banco.
    (object (is-a CARTA_BANCO) (nombre ?nombre_edificio) (coste ?valor_edificio) (valor ?))
    ; Obtiene el dinero del jugador
    ?recurso_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre ?nombre_jugador) (recurso FRANCOS) (cantidad ?cantidad_recurso))
    ; El jugador tiene suficiente dinero
    (test (>= ?cantidad_recurso ?valor_edificio))
    =>
    ; Modificar el dinero del jugador
    (modify-instance ?recurso_jugador (cantidad =(- ?cantidad_recurso ?valor_edificio)))
    ; Quitar el edificio al ayuntamiento
    (retract ?ayunto)
    ; Asignar el edificio al jugador
    (make-instance (JUGADOR_TIENE_CARTA (nombre_jugador ?nombre_jugador) (nombre_carta ?nombre_edificio)))
    ; Eliminar el deseo de comprar el edificio
    (retract ?deseo)
)

(defrule COMPRAR_EDIFICIO_BANCO_DEL_MAZO
    ; Se puede comprar en la ronda actual. [en todas las rondas excepto la última.]
    (ronda_actual ?nombre_ronda)
    (test (neq ?nombre_ronda RONDA_EXTRA_FINAL))
    ; Obtener el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; Obtener al jugador [se podría eliminar!?]
    (object (is-a JUGADOR) (nombre ?nombre_jugador))
    ; Obtener el edificio del deseo
    ?deseo <- (deseo_comprar_edificio ?nombre_edificio)
    ; El edificio es del mazo
    ?carta_en_mazo <- (of CARTA_PERTENECE_A_MAZO (id_mazo ?) (nombre_carta ?nombre_edificio) (posicion 1))
    ; Obtiene el coste de comprar el edificio
    (object (is-a CARTA_BANCO) (nombre ?nombre_edificio) (coste ?valor_edificio) (valor ?))
    ; Obtiene el dinero del jugador
    ?recurso_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre ?nombre_jugador) (recurso FRANCOS) (cantidad ?cantidad_recurso))
    ; El jugador tiene suficiente dinero
    (test (>= ?cantidad_recurso ?valor_edificio))
    =>
    ; Modificar el dinero del jugador
    (modify-instance ?recurso_jugador (cantidad =(- ?cantidad_recurso ?valor_edificio)))
    ; Quitar la carta del mazo y mover todas las cartas 1 posición
    (unmake-instance ?carta_en_mazo)
    ; Asignar el edificio al jugador
    (make-instance (JUGADOR_TIENE_CARTA (nombre_jugador ?nombre_jugador) (nombre_carta ?nombre_edificio)))
    ; Eliminar el deseo de comprar el edificio
    (retract ?deseo)
    ; Generar hecho semáforo para actualizar el orden de las cartas del mazo
    (actualizar_mazo ?id_mazo)
)

;   3-. Vender Carta (otorga mitad de valor) [tanto edificio como barco, todos igual.]
(defrule VENDER_CARTA
    ; No existe precondición de ronda! 
    ; Existe un deseo de vender un edificio
    ?deseo <- (deseo_vender_edificio ?nombre_edificio)
    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; Obtener al jugador [se podría eliminar!?]
    (object (is-a JUGADOR) (nombre ?nombre_jugador))
    ; El jugador tiene la carta. 
    ?edificio_jugador <- (object (is-a JUGADOR_TIENE_CARTA) (nombre_jugador ?nombre_jugador)(nombre_carta ?nombre_carta))
    ; referencia de la carta para obtener su valor. [DUDA!!!!!: ESTO FUNCIONARÁ CON BARCOS!!!]!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    ?carta <- (object (is-a CARTA) (nombre ?nombre_carta) (valor ?valor_carta))
    ; referencia del recurso del jugador.
    ?recurso_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre ?nombre_jugador) (recurso FRANCOS) (cantidad ?cantidad_recurso))
    =>
    ; Modificar el dinero del jugador
    (modify-instance ?recurso_jugador (cantidad =(+ =(/ ?valor_carta 2) ?cantidad_recurso) )
    ; Asignar edificio al ayuntamiento
    (assert (EDIFICIO_AYUNTAMIENTO (nombre_edificio ?nombre_edificio)))
    ; Quitarle el edificio al jugador
    (unmake-instance ?edificio_jugador)
    ; quitar el deseo.
    (retract ?deseo)
)

;   3-. Entrar Edificio
; que pasa si no tiene coste de entrada? => otra regla?

(defrule ENTRAR_EDIFICIO_CON_COSTE_ENTRADA_RONDAS
    ; Se puede entrar de uno en uno en el resto de las rondas.
    (ronda_actual ?nombre_ronda)
    (test (neq ?nombre_ronda RONDA_EXTRA_FINAL))
    ; Existe un deseo de entrar a un edificio, este tiene el tipo de recurso que quiere usar para pagar y su nombre
    ?deseo <- (deseo_entrar_edificio ?nombre_edificio ?tipo_recurso ?nombre_recurso)
    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; Obtener al jugador [se podría eliminar!?]
    (object (is-a JUGADOR) (nombre ?nombre_jugador))
    ; obtener nombre de la carta. 
    (object (is-a CARTA) (nombre ?nombre_carta) (valor ?))
    ; no exista un jugador en ese edificio.
    (not (JUGADOR_ESTA_EDIFICIO (nombre_edificio ?nombre_carta) (nombre_jugador ?)))
    ; Tiene coste de entrada.
    (object (is-a COSTE_ENTRADA_CARTA) (nombre_carta ?nombre_carta) (tipo ?tipo_recurso) (cantidad ?coste_entrada))
    ; comprobar que tenga recursos suficientes para entrar.
    ?recurso_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre ?nombre_jugador) (recurso ?nombre_recurso) (cantidad ?cantidad_recurso))
    (test (>= ?cantidad_recurso ?coste_entrada))
    =>
    ; Modificar el dinero del jugador
    (modify-instance ?recurso_jugador (cantidad =(- ?cantidad_recurso ?coste_entrada) )
    ; indicar que el jugador está en el edificio.
    (assert (JUGADOR_ESTA_EDIFICIO (nombre_edificio ?nombre_carta) (nombre_jugador ?nombre_jugador)))
    ; quitar el deseo.
    (retract ?deseo)
)

(defrule ENTRAR_EDIFICIO_SIN_COSTE_ENTRADA_RONDAS
    ; Se puede entrar de uno en uno en el resto de las rondas.
    (ronda_actual ?nombre_ronda)
    (test (neq ?nombre_ronda RONDA_EXTRA_FINAL))
    ; Existe un deseo de entrar a un edificio, este tiene el tipo de recurso que quiere usar para pagar y su nombre
    ?deseo <- (deseo_entrar_edificio ?nombre_edificio ?tipo_recurso ?nombre_recurso)
    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; Obtener al jugador [se podría eliminar!?]
    (object (is-a JUGADOR) (nombre ?nombre_jugador))
    ; obtener nombre de la carta. 
    (object (is-a CARTA) (nombre ?nombre_carta) (valor ?))
    ; no exista un jugador en ese edificio.
    (not (JUGADOR_ESTA_EDIFICIO (nombre_edificio ?nombre_carta) (nombre_jugador ?)))
    ; No tiene coste de entrada.
    (not (object (is-a COSTE_ENTRADA_CARTA) (nombre_carta ?nombre_carta) (tipo ?) (cantidad ?)))
    =>
    ; indicar que el jugador está en el edificio.
    (assert (JUGADOR_ESTA_EDIFICIO (nombre_edificio ?nombre_carta) (nombre_jugador ?nombre_jugador)))
    ; quitar el deseo.
    (retract ?deseo)
)

(defrule ENTRAR_EDIFICIO_CON_COSTE_ENTRADA_RONDA_FINAL
    ; Se puede entrar de uno en uno en el resto de las rondas.
    (ronda_actual ?nombre_ronda)
    (test (eq ?nombre_ronda RONDA_EXTRA_FINAL))
    ; Existe un deseo de entrar a un edificio, este tiene el tipo de recurso que quiere usar para pagar y su nombre
    ?deseo <- (deseo_entrar_edificio ?nombre_edificio ?tipo_recurso ?nombre_recurso)
    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; Obtener al jugador [se podría eliminar!?]
    (object (is-a JUGADOR) (nombre ?nombre_jugador))
    ; obtener nombre de la carta. 
    (object (is-a CARTA) (nombre ?nombre_carta) (valor ?))
    ; Tiene coste de entrada.
    (object (is-a COSTE_ENTRADA_CARTA) (nombre_carta ?nombre_carta) (tipo ?tipo_recurso) (cantidad ?coste_entrada))
    ; comprobar que tenga recursos suficientes para entrar.
    ?recurso_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre ?nombre_jugador) (recurso ?nombre_recurso) (cantidad ?cantidad_recurso))
    (test (>= ?cantidad_recurso ?coste_entrada))
    =>
    ; Modificar el dinero del jugador
    (modify-instance ?recurso_jugador (cantidad =(- ?cantidad_recurso ?coste_entrada) )
    ; indicar que el jugador está en el edificio.
    (assert (JUGADOR_ESTA_EDIFICIO (nombre_edificio ?nombre_carta) (nombre_jugador ?nombre_jugador)))
    ; quitar el deseo.
    (retract ?deseo)
)

(defrule ENTRAR_EDIFICIO_SIN_COSTE_ENTRADA_RONDA_FINAL
    ; Se puede entrar de uno en uno en el resto de las rondas.
    (ronda_actual ?nombre_ronda)
    (test (eq ?nombre_ronda RONDA_EXTRA_FINAL))
    ; Existe un deseo de entrar a un edificio, este tiene el tipo de recurso que quiere usar para pagar y su nombre
    ?deseo <- (deseo_entrar_edificio ?nombre_edificio ?tipo_recurso ?nombre_recurso)
    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; Obtener al jugador [se podría eliminar!?]
    (object (is-a JUGADOR) (nombre ?nombre_jugador))
    ; obtener nombre de la carta. 
    (object (is-a CARTA) (nombre ?nombre_carta) (valor ?))
    ; NO tiene coste de entrada.
    (not (object (is-a COSTE_ENTRADA_CARTA) (nombre_carta ?nombre_carta) (tipo ?) (cantidad ?)))
    =>
    ; indicar que el jugador está en el edificio.
    (assert (JUGADOR_ESTA_EDIFICIO (nombre_edificio ?nombre_carta) (nombre_jugador ?nombre_jugador)))
    ; quitar el deseo.
    (retract ?deseo)
)

;   3bis-. Utilizar Edificio 
;   => contruir
;      => Edificio desde un edificio constructora.
;      => Barco desde el muelle. 
;   => generar
;      => Recurso
;   => Transformar
;      => Recurso
;   => Comerciar (compañia naviera)
;
;

(defrule UTILIZAR_EDIFICIO_CONSTRUCTOR
    ;TODO: FALTA MODELAR EL COSTE DE CONSTRUCCIÓN!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; Obtener al jugador [se podría eliminar!?]
    (object (is-a JUGADOR) (nombre ?nombre_jugador))
    ; Obtener la referencia de la carta.
    (object (is-a CARTA) (nombre ?nombre_carta) (valor ?))
    ; El jugador debe estar en el edificio.
    (JUGADOR_ESTA_EDIFICIO (nombre_edificio ?nombre_carta) (nombre_jugador ?nombre_jugador))
    ; Se encuentra en un edificio de construcción. !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    (not )
    ; existe un deseo de construir una carta.
    (deseo_construccion ?nombre_carta_objetivo)
    ; comprobar que no pertenece a nadie
    (not (EDIFICIO_AYUNTAMIENTO (nombre_edificio ?nombre_carta_objetivo)))
    (not (object (is-a JUGADOR_TIENE_CARTA) (nombre_jugador ?) (nombre_carta ?nombre_carta_objetivo)))
    ; comprobar que se encuentra en la parte superior del mazo.
    (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?) (nombre_carta ?nombre_carta_objetivo) (posicion 1))
    ; comprobar que el jugador tiene suficientes recursos para construirla.
    ?recurso_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre ?nombre_jugador) (recurso ?nombre_recurso) (cantidad ?cantidad_recurso))
    (test (>= ?cantidad_recurso ?coste_entrada))
    =>

)


;   4-. Comprar barco
(defrule COMPRAR_BARCO
    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; Existe el deseo de comprar el barco
    ?deseo <- (deseo_comprar_barco ?nombre_barco)
    ; El barco está disponible
    ?disponible <- (BARCO_DISPONIBLE (nombre_barco ?nombre_barco))
    ; El barco es el primero de su mazo
    ?barco_en_mazo <- (of CARTA_PERTENECE_A_MAZO (id_mazo ?id_mazo) (nombre_carta ?nombre_barco) (posicion 1))
    ; El jugador tiene dinero para comprarlo
    ; Obtiene el coste de comprar el barco
    (object (is-a BARCO) (nombre ?nombre_barco) (coste ?coste_barco) (valor ?))
    ; Obtiene el dinero del jugador
    ?recurso_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre ?nombre_jugador) (recurso FRANCOS) (cantidad ?cantidad_recurso))
    ; El jugador tiene suficiente dinero
    (test (>= ?cantidad_recurso ?coste_barco))

    =>
    ; Modificar el dinero del jugador
    (modify-instance ?recurso_jugador (cantidad =(- ?cantidad_recurso ?coste_barco)))
    ; Quitar la carta del mazo
    (unmake-instance ?barco_en_mazo)
    ; Asignar el barco al jugador
    (make-instance (JUGADOR_TIENE_CARTA (nombre_jugador ?nombre_jugador) (nombre_carta ?nombre_barco)))
    ; Eliminar el deseo de comprar el barco
    (retract ?deseo)
    ; Quitar el barco de disponibles
    (retract ?disponible)
    ; Generar hecho semáforo para actualizar el orden de las cartas del mazo
    (actualizar_mazo ?id_mazo)
)

;   5-. Vender barco (otorga mitad de valor)
(defrule VENDER_BARCO
    ; Es el turno del jugador
    ?turno <- (turno ?nombre_jugador)
    ; Existe el deseo de vender el barco
    ?deseo <- (deseo_vender_barco ?nombre_barco)
    ; El barco es del jugador
    ?jugador_tiene_barco <- (object (is-a) JUGADOR_TIENE_CARTA (nombre_jugador ?nombre_jugador)(nombre_carta ?nombre_barco))
    ; Obtiene el valor del barco
    ?barco <- (object (is-a BARCO)(coste ?coste_barco)(valor ?valor_barco)(uds_comida_genera ?)(capacidad_envio ?))
    ; Obtiene el dinero del jugador
    ?recurso_jugador <- (object (is-a JUGADOR_TIENE_RECURSO) (nombre ?nombre_jugador) (recurso FRANCOS) (cantidad ?cantidad_recurso))

    =>
    ; Elimina el barco del jugador
    (unmake-instance ?jugador_tiene_barco)
    ; Actualiza el dinero del jugador
    (modify-instance ?recurso_jugador (cantidad =(+ ?cantidad_recurso ?valor_barco)))
    ; Elimina el deseo
    (retract ?deseo)

)
;   6-. Final ronda (cambiar)
;   7-. Cambiar turno jugadores
;   8-. Actualizar cartas mazos
; Modifica la posición de todas las cartas de un mazo restándoles 1. 
; PREGUNTAR SI ESTO SE PUEDE HACER ASÍ => deberá tener máxima prioridad!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
(defrule ACTUALIZAR_POSICION_CARTAS_MAZO
    ?carta_mazo <- (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id) (nombre_carta ?nombre_carta) (posicion ?pos))
    (actualizar_mazo ?id)
    (forall (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id) (nombre_carta ?nombre_carta) (posicion ?pos)))
    =>
    (modify-instance ?carta_mazo(posicion (- ?pos 1))
)

;   9-. Dar vuelta losetas
(defrule destapar_loseta 
    ; obtener casilla
    ?casilla <- (object (is-a LOSETA) (posicion ?pos) (visibilidad ?visible))
    ; comprobar que hay un jugador en la casilla
    ?posicion_jugador <- (object (is-a JUGADOR_ESTA_EN_LOSETA) (posicion ?pos))
    ; comprobar que la casilla está oculta    
    (test (eq ?visible FALSE))
    =>
    ; hacer casilla visible
    (modify-instance ?casilla (visibilidad TRUE))
)

;   10-. Añadir recursos de las losetas a la oferta.

(defrule AÑADIR_RECURSOS_OFERTA
    ; obtiene la loseta
    ?loseta <- (object (is-a LOSETA) (posicion ?pos) (visibilidad ?visible))
    ; el jugador está en la loseta
    (object (is-a JUGADOR_ESTA_EN_LOSETA) (posicion ?pos))
    ; Obtiene la oferta
    ?oferta_recurso <- (OFERTA_RECURSO (recurso ?recurso) (cantidad ?cantidad_oferta))
    ; comprueba que la oferta esté visible
    (test (eq ?visible TRUE))
    ; Por cada recurso de la loseta...
    (forall (object (is-a LOSETA_TIENE_RECURSO) (posicion ?pos) (recurso ?recurso) (cantidad ?c)))
    => 
    ; añadir a la oferta.
    (modify ?oferta_recurso (cantidad =(+ cantidad_oferta c)))
)

; 11-. Hacer pagar intereses
    

; 12-. Pagar comida final ronda (se pueden endeudar)




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

(defrule pasar_turno
    ; pensar si debería haber alguna precondición o si simplemente por estar 
    ; en la posición que está la regla ya se asegura que sólo se instancia
    ; cuando el jugador no puede hacer nada más
    ?jugador1 <- (object (is-a JUGADOR) (nombre ?nombre_jugador1))
    ?jugador2 <- (object (is-a JUGADOR) (nombre ?nombre_jugador2))
    (test (neq ?jugador1 ?jugador2))
    ; IMPORTANTE!  ¿DÓNDE SE GENERA ESTE HECHO SEMÁFORO?????
    (turno_finalizado ?nombre_jugador1)
    =>
    (retract (turno_finalizado ?nombre_jugador1))
    (assert (turno ?nombre_jugador2))
)

(defrule cambio_ronda
    ; para cambiar de ronda se tiene que dar la siguiente situación
    ; | | | | | |2|1| y turno de 2
    ?jugador1 <- (object (is-a JUGADOR) (nombre ?nombre_jugador1))
    ?posicion_jugador1 <- (object (is-a JUGADOR_ESTA_EN_CASILLA_RECURSO) (posicion ?pos_jugador1) (nombre_jugador ?nombre_jugador1))
    ?jugador2 <- (object (is-a JUGADOR) (nombre ?nombre_jugador2))
    ?posicion_jugador2 <- (object (is-a JUGADOR_ESTA_EN_CASILLA_RECURSO) (posicion ?pos_jugador2) (nombre_jugador ?nombre_jugador2))
    (test (eq ?pos_jugador1 7))
    (test (eq ?pos_jugador2 6))
    (test (neq ?jugador ?jugador2))
    (turno ?nombre_jugador2)
    ; selección de siguiente ronda
    (ronda_actual ?nombre_ronda_actual)
    ?ronda_siguiente <- (object (is-a RONDA (nombre_ronda ?nombre_ronda_siguiente)))
    (siguiente_ronda ?nombre_ronda_actual ?nombre_ronda_siguiente)
    =>
    (retract ronda_actual ?nombre_ronda_actual)
    (assert ronda_actual ?nombre_ronda_siguiente)
)

(defrule asignar_edificio_ayuntamiento
    ; SE TIENE Q EJECUTAR NADA MÁS ACTUALIZAR LA RONDA!!!!!!!!!!!!!!!!! 
    (object (is-a RONDA (nombre_ronda ?nombre_ronda)))
    ?mazo <- (object (is-a MAZO) (id_mazo ?id))
    ; REVISAR LA CONCEPTUALIZACIÓN EDIFICIO, ES PSEUDOCÓDIGO!
    ?edificio <- (object (is-a EDIFICIO) (nombre ?nombre_edificio))
    ?pertenece <- (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id) (nombre_carta ?nombre_edificio))
    ?asignacion_edificio <- (object (is-a RONDA_ASIGNA_EDIFICIO) (nombre_ronda ?nombre_ronda) (id_mazo ?id) (nombre_edificio ?nombre_edificio))
    (ronda_actual ?nombre_ronda)
    =>
    (assert EDIFICIO_AYUNTAMIENTO(nombre_edificio ?nombre_edificio))
    (unmake-instance ?asignacion_edificio)
    (unmake-instance ?pertenece)
    ; Introducir un hecho semáforo adicional para disparar la actualización de posición
    ; en las cartas del mazo. Otra alternativa, jugar prioridad reglas. De momento lo dejamos 
    ; como hecho semáforo.
    (assert actualizar_mazo_edificios ?id)
)

(defrule actualizar_disponibilidad_barcos
    ; SE TIENE Q EJECUTAR NADA MÁS ACTUALIZAR LA RONDA!!!!!!!!!!!!!!!!! 
    (object (is-a RONDA (nombre_ronda ?nombre_ronda)))
    (ronda_actual ?nombre_ronda)
    ?mazo <- (object (is-a MAZO) (id_mazo ?id))
    ?barco <- (object (is-a BARCO) (nombre ?nombre_barco))
    ?pertenece <- (object (is-a CARTA_PERTENECE_A_MAZO) (id_mazo ?id) (nombre_carta ?nombre_barco))
    ?introduce_barco <- (object (is-a RONDA_INTRODUCE_BARCO) (nombre_ronda ?nombre_ronda) (nombre_carta ?nombre_barco))
    =>
    ; TODO: NO SABEMOS EN Q ORDEN QUEDARÍAN LOS BARCOS DISPONIBLES. problema.!!!!!!!!!!!!!!!!!
    (BARCO_DISPONIBLE (nombre_barco ?nombre_barco))
    (unmake-instance ?introduce_barco)
)

(defrule mover_jugador
    ?jugador <- (object (is-a JUGADOR) (nombre ?nombre))
    (turno ?nombre)
    ?posicion_actual <- (object (is-a JUGADOR_ESTA_EN_CASILLA_RECURSO) (posicion ?pos) (nombre_jugador ?nombre))
    =>
    (modify-instance ?posicion_actual (posicion =(mod =(+ ?pos 2) 7)))
)
