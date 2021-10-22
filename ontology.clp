


; CONCEPTOS
(defclass RECURSO
    (is-a USER)
    (role concrete)
    (slot nombre (type SYMBOL)
        (allowed-values FRANCO, MADERA, PESCADO, ARCILLA, HIERRO, GRANO, GANADO, CARBON, PIEL,
            PESCADO_AHUMADO, CARBON_VEGETAL, LADRILLOS, ACERO, PAN, CARNE, COQUE, CUERO)
        (access initialize-only) (create-accessor read))
)

(defclass BONUS
    (is-a USER)
    (role concrete)
    (slot nombre (type SYMBOL)
        (allowed-values PESCADOR, MARTILLO) (access initialize-only) (create-accessor read)    )
)


(deftemplate OFERTA_RECURSO
    (slot recurso (type SYMBOL)
        (allowed-values FRANCO, MADERA, PESCADO, ARCILLA, HIERRO, GRANO, GANADO)
        (access initialize-only) (create-accessor read))
    (slot cantidad (type INTEGER) (access read-write) (create-accessor read-write))
)

; Representar la información de que en la partida el edificio con nombre X (el nombre será 
; único) corresponde al edificio. Creemos que es mejor alternativa a emplear conceptos.
(deftemplate EDIFICIO_AYUNTAMIENTO
    (slot nombre_edificio (type STRING) (access initialize-only) (create-accessor read))
)

; representar la información de q el barco ahora queda disponible y se podrá adquirir.
; La disposición de los barcos en el mazo queda predeterminada inicialmente en los hechos
; iniciales por la relacion de mazo_tiene_carta. Cuando se active este deftemplate se podrá
; adquirir el barco.
(deftemplate BARCO_DISPONIBLE
    (slot nombre_barco (type STRING) (access initialize-only) (create-accessor read))    
)


(defclass MAZO 
    (is-a USER)
    (role concrete)
    (slot id_mazo (type INTEGER) (access initialize-read) (create-accessor read))
)


; Validada sintácticamente en CLIPS.
(defclass RONDA
    (is-a USER)
    (role concrete)
    (slot nombre_ronda (type SYMBOL) 
        (allowed-values RONDA_1, RONDA_2, RONDA_3, RONDA_4, RONDA_5, RONDA_6, RONDA_7, RONDA_8, RONDA_EXTRA_FINAL)
        (access initialize-only) (create-accessor read))
    (slot coste_comida (type INTEGER) (access initialize-only) (create-accessor read))
    (slot hay_cosecha (type SYMBOL) (allowed-values TRUE, FALSE) (access initialize-only) (create-accessor read))
)

; Validada sintácticamente en CLIPS.
(defclass JUGADOR
    (is-a USER)
    (role concrete)
    (slot nombre (type STRING) (access initialize-only) (create-accessor read))
)

; Validada sintácticamente en CLIPS.
(defclass CARTA
    (is-a USER)
    (role abstract)
    (slot nombre (type STRING) (access initialize-only) (create-accessor read))
    (slot coste_francos (type INTEGER) (access initialize-only) (create-accessor read))
    (slot valor_proporciona (type INTEGER) (access initialize-only) (create-accessor read))
)

; Validada sintácticamente en CLIPS.
(defclass BARCO
    (is-a CARTA)
    (role abstract)
    ; en el nombre indicar q es el barco de acero.
    (slot nombre (source composite))
    (slot coste_francos (source composite))
    (slot valor_proporciona (source composite))
    (slot uds_comida_genera (type INTEGER) (access initialize-only) (create-accessor read))
    (slot num_energia_necesaria (type INTEGER) (access initialize-only) (create-accessor read))
)

(defclass BARCO_MADERA
    (is-a BARCO)
    (slot tipo (source composite))
    (slot nombre (source composite))
    (slot coste_francos (source composite))
    (slot valor_proporciona (source composite))
    (slot uds_comida_genera (source composite))
    (slot num_energia_necesaria (source composite))
    (slot unidades_madera (type INTEGER) (access initialize-only) (create-accessor read))
)

(defclass BARCO_HIERRO
    (is-a BARCO)
    (slot tipo (source composite))
    (slot nombre (source composite))
    (slot coste_francos (source composite))
    (slot valor_proporciona (source composite))
    (slot comida_genera (source composite))
    (slot num_energia_necesaria (source composite))
    (slot unidades_hierro (type INTEGER) (access initialize-only) (create-accessor read))
)

(defclass BARCO_ACERO
    (is-a BARCO)
    (slot tipo (source composite))
    (slot nombre (source composite))
    (slot coste_francos (source composite))
    (slot valor_proporciona (source composite))
    (slot comida_genera (source composite))
    (slot num_energia_necesaria (source composite))
    (slot unidades_acero (type INTEGER) (access initialize-only) (create-accessor read))
)


; Validada sintácticamente en CLIPS.
(defclass CASILLA_RECURSO
    (is-a USER)
    (role concrete)
    (slot posicion (type INTEGER) (access initialize-only) (create-accessor read))
    ;(slot recurso_proporciona1 (type SYMBOL) (access initialize-only) (create-accessor read))
    ;(slot num_recursos_proporciona1 (type INTEGER) (access initialize-only) (create-accessor read))
    ;(slot recurso_proporciona2 (type SYMBOL) (access initialize-only) (create-accessor read))
    ;(slot num_recursos_proporciona2 (type INTEGER) (access initialize-only) (create-accessor read))
    (slot visibilidad (type SYMBOL)
        (allowed-values TRUE, FALSE)
        (default FALSE)
        (access read-write) (create-accessor read-write))
    (slot intereses (type SYMBOL)
        (allowed-values TRUE, FALSE)
        (default FALSE)
        (access initialize-only) (create-accessor read))
)

(defclass JUGADOR_TIENE_RECURSO
    (is-a USER)
    (slot nombre_jugador (type STRING))
    (slot recurso (type SYMBOL)
        (allowed-values FRANCOS, MADERA, PESCADO, ARCILLA, HIERRO, GRANO, GANADO, CARBON, PIEL,
            PESCADO_AHUMADO, CARBON_VEGETAL, LADRILLOS, ACERO, PAN, CARNE, COQUE, CUERO)
        (access initialize-only) (create-accessor read))
    (slot cantidad (type INTEGER) (access read-write) (create-accessor read-write))
)

(defclass JUGADOR_TIENE_BONUS
    (is-a USER)
    (slot nombre_jugador (type STRING))
    (slot bonus (type SYMBOL) (allowed-values PESCADOR MARTILLO) (access initialize-only) (create-accessor read))
    (slot cantidad (type INTEGER) (access read-write) (create-accessor read-write))
)

(defclass JUGADOR_TOMA_RECURSOS_OFERTA
    (is-a USER)
    (slot id_partida (type INTEGER))
    (slot nombre_jugador (type STRING))
    (slot recurso (type SYMBOL))
    (slot num_recursos (type INTEGER))
)

(defclass CASILLA_RECURSO_TIENE_RECURSO
    (is-a USER)
    (slot posicion (type INTEGER))
    (slot recurso (type SYMBOL))
    (slot cantidad (type INTEGER))
)

(defclass JUGADOR_ESTA_EN_CASILLA_RECURSO
    (is-a USER)
    (slot posicion (type INTEGER))
    (slot nombre_jugador (type STRING))
)

;===================== CARTAS =================
(defclass CARTA_TIENE_BONUS
    (slot nombre_carta (type STRING) (access initialize-only) (create-accessor read))
    (slot bonus (type SYMBOL) (allowed-values PESCADOR MARTILLO) (access initialize-only) (create-accessor read))
)

(defclass JUGADOR_TIENE_CARTA
    (is-a USER)
    (slot nombre_jugador (type STRING))
    (slot nombre_carta (type STRING) (access initialize-only) (create-accessor read))
)

(defclass CARTA_PERTENECE_A_MAZO
    (is-a USER)
    (role concrete)
    (slot id_mazo (type INTEGER) (access initialize-read) (create-accessor read))
    (slot nombre_carta (type STRING) (access initialize-only) (create-accessor read))
    (slot posicion (type INTEGER)(access read-write) (create-accessor read-write))

)

(defclass RONDA_INTRODUCE_BARCO
    (is-a USER)
    (slot nombre_ronda (type SYMBOL))
    (slot nombre_carta (type STRING) (access initialize-only) (create-accessor read))
)

(defclass RONDA_ASIGNA_EDIFICIO
    (is-a USER)
    (slot nombre_ronda (type SYMBOL))
    (slot id_mazo (type INTEGER) (access initialize-read) (create-accessor read))
    (slot nombre_carta (type STRING) (access initialize-only) (create-accessor read))
)

; HACER UN HECHO, PORQ SOLO SE INSTANCIA UNA VEZ!!!!!!!!!!!!!!!!!!!!!!
(defclass JUGADOR_DENTRO_EDIFICIO
    (is-a USER)
    (slot nombre_jugador (type STRING))
    (slot nombre_carta (type STRING) (access initialize-only) (create-accessor read))
)

(defclass COSTE_ENTRADA_CARTA
    (is-a USER)
    (slot nombre_carta (type STRING))
    (slot recurso (type SYMBOL)
        (allowed-values FRANCOS, MADERA, PESCADO, ARCILLA, HIERRO, GRANO, GANADO, CARBON, PIEL,
            PESCADO_AHUMADO, CARBON_VEGETAL, LADRILLOS, ACERO, PAN, CARNE, COQUE, CUERO)
        (access initialize-only) (create-accessor read))
    (slot cantidad (type INTEGER) (access initialize-only) (create-accessor read))
)

(defclass EDIFICIO_INPUT
    (is-a USER)
    (slot nombre_carta (type STRING))
    (slot recurso (type SYMBOL)
        (allowed-values FRANCOS, MADERA, PESCADO, ARCILLA, HIERRO, GRANO, GANADO, CARBON, PIEL,
            PESCADO_AHUMADO, CARBON_VEGETAL, LADRILLOS, ACERO, PAN, CARNE, COQUE, CUERO)
        (access initialize-only) (create-accessor read))
)

(defclass EDIFICIO_OUTPUT
    (is-a USER)
    (slot nombre_carta (type STRING))
    (slot recurso (type SYMBOL)
        (allowed-values FRANCOS, MADERA, PESCADO, ARCILLA, HIERRO, GRANO, GANADO, CARBON, PIEL,
            PESCADO_AHUMADO, CARBON_VEGETAL, LADRILLOS, ACERO, PAN, CARNE, COQUE, CUERO)
        (access initialize-only) (create-accessor read))

)
(defclass COSTE_ENERGIA
    (is-a USER)
    (slot nombre_carta (type STRING) (access initialize-only) (create-accessor read))
    (slot cantidad (type INTEGER) (access initialize-only) (create-accessor read))
)