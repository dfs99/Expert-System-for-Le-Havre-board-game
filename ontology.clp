


; CONCEPTOS
(defclass RECURSO
    (is-a USER)
    (role concrete)
    (slot nombre (type SYMBOL)
        (allowed-values FRANCO, MADERA, PESCADO, ARCILLA, HIERRO, GRANO, GANADO, CARBON, PIEL,
            PESCADO_AHUMADO, CARBON_VEGETAL, LADRILLOS, ACERO, PAN, CARNE, COQUE, CUERO)
        (access initialize-only) (create-accessor read))
)

; Necesitamos un concepto para representar la oferta y la posesión de las cartas desplegadas en
; el tablero. Para ello, hemos pensado en usar este concepto 'Dummy' con id para representar las
; relaciones.
;        (defclass PARTIDA
;            (is-a USER)
;            (role concrete)
;            (slot id (type INTEGER) (access initialize-only) (create-accessor read))
;        )
;
; Otra alternativa sería emplear un deftemplate para representar la oferta y eliminar la partida.
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
    (slot tipo (type SYMBOL)
        (allowed-values ECONOMICO, CONSTRUCCION, INDUSTRIAL, BARCO, OTRO)
        (access initialize-only)
        (create-accessor read))
    (slot nombre (type STRING) (access initialize-only) (create-accessor read))
    (slot coste_compra (type INTEGER) (access initialize-only) (create-accessor read))
    (slot valor_proporciona (type INTEGER) (access initialize-only) (create-accessor read))
)

; Validada sintácticamente en CLIPS.
(defclass BARCO
    (is-a CARTA)
    (role abstract)
    (slot tipo (source composite))
    ; en el nombre indicar q es el barco de acero.
    (slot nombre (source composite))
    (slot coste_compra (source composite))
    (slot valor_proporciona (source composite))
    (slot comida_genera (type INTEGER) (access initialize-only) (create-accessor read))
    (slot num_energia_necesaria (type INTEGER) (access initialize-only) (create-accessor read))
)

(defclass BARCO_MADERA
    (is-a BARCO)
    (slot tipo (source composite))
    (slot nombre (source composite))
    (slot coste_compra (source composite))
    (slot valor_proporciona (source composite))
    (slot comida_genera (source composite))
    (slot num_energia_necesaria (source composite))
    (slot unidades_madera (type INTEGER) (access initialize-only) (create-accessor read))
)

(defclass BARCO_HIERRO
    (is-a BARCO)
    (slot tipo (source composite))
    (slot nombre (source composite))
    (slot coste_compra (source composite))
    (slot valor_proporciona (source composite))
    (slot comida_genera (source composite))
    (slot num_energia_necesaria (source composite))
    (slot unidades_hierro (type INTEGER) (access initialize-only) (create-accessor read))
)

(defclass BARCO_ACERO
    (is-a BARCO)
    (slot tipo (source composite))
    (slot nombre (source composite))
    (slot coste_compra (source composite))
    (slot valor_proporciona (source composite))
    (slot comida_genera (source composite))
    (slot num_energia_necesaria (source composite))
    (slot unidades_acero (type INTEGER) (access initialize-only) (create-accessor read))
)

; Dudas con edificio
; El mazo podría ser representado con un atributo.
; La posición en el mazo como otro atributo. ¿tiene sentido? Puede ser muy costoso
; tener q recorrer todos los edificios para actualizar su posición en el mazo, ¿no?

; Validada sintácticamente en CLIPS.
(defclass EDIFICIO_GENERADOR
    (is-a CARTA)
    (role concrete)
    (slot tipo (source composite))
    (slot nombre (source composite))
    (slot coste_compra (source composite))
    (slot valor_proporciona (source composite))
    (slot tarifa_entrada_en_francos (type INTEGER) (access initialize-only) (create-accessor read))
    (slot tarifa_entrada_uds_recurso (type INTEGER) (access initialize-only) (create-accessor read))
    (slot tarifa_entrada_recurso (type SYMBOL) (access initialize-only) (create-accessor read))
    (slot recurso_genera (type SYMBOL) (access initialize-only) (create-accessor read))
    (slot num_recursos_genera (type INTEGER) (access initialize-only) (create-accessor read))
    (slot plus_por_bonus (type INTEGER) (access initialize-only) (create-accessor read))
    (slot bonus (type SYMBOL) 
        (allowed-values MARTILLO, PESCADOR, NONE)
        (access initialize-only) (create-accessor read))
)
; Validada sintácticamente en CLIPS.
(defclass EDIFICIO_TRANSFORMADOR
    (is-a CARTA)
    (role concrete)
    (slot tipo (source composite))
    (slot nombre (source composite))
    (slot coste_compra (source composite))
    (slot valor_proporciona (source composite))
    ; revisar multislots!
    (slot tarifa_entrada_en_francos (type INTEGER) (access initialize-only) (create-accessor read))
    (slot tarifa_entrada_uds_recurso (type INTEGER) (access initialize-only) (create-accessor read))
    (slot tarifa_entrada_recurso (type SYMBOL) (access initialize-only) (create-accessor read))
    ; podríamos simplificar y relajar esta restricción.
    (slot max_uds_recurso_input (type INTEGER) (access initialize-only) (create-accessor read))
    (slot  recurso_input (type SYMBOL) (access initialize-only) (create-accessor read))
    (slot ud_energia_necesaria_por_recurso (type INTEGER) (access initialize-only) (create-accessor read))
    ; la cantidad que se produce dependerá de las unidades 
    ; introducidas. Deberíamos sacarlo de la definición de 
    ; la clase.
    (slot recurso_output (type SYMBOL) (access initialize-only) (create-accessor read))
    (slot num_recursos_output (type INTEGER) (access initialize-only) (create-accessor read))
    (slot plus_por_bonus (type INTEGER) (access initialize-only) (create-accessor read))
    (slot bonus (type SYMBOL) 
        (allowed-values MARTILLO, PESCADOR, NONE)
        (access initialize-only) (create-accessor read))
)
; Validada sintácticamente en CLIPS.
(defclass EDIFICIO_CONSTRUCTOR
    (is-a CARTA)
    (role concrete)
    (slot tipo (source composite))
    (slot nombre (source composite))
    (slot coste_compra (source composite))
    (slot valor_proporciona (source composite))
    (slot tarifa_entrada_en_francos (type INTEGER) (access initialize-only) (create-accessor read))
    (slot tarifa_entrada_uds_recurso (type INTEGER) (access initialize-only) (create-accessor read))
    (slot tarifa_entrada_recurso (type SYMBOL) (access initialize-only) (create-accessor read))
    (slot tipo_constructor (type SYMBOL)
        (allowed-values BANCO, MERCADO, COMPAÑIA_NAVIERA)
        (access initialize-only) (create-accessor read))
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


; DUDA!
; Se puede realizar herencia en una relación? Por ejemplo de esta relación 
; generar subclases del tipo jugador_tiene_barco, jugador_tiene_edificio_generador, etc, etc
(defclass JUGADOR_TIENE_CARTA
    (is-a USER)
    (slot nombre_jugador (type STRING))
    (slot nombre_carta (type STRING))
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

(defclass JUGADOR_TOMA_RECURSOS_OFERTA
    (is-a USER)
    (slot id_partida (type INTEGER))
    (slot nombre_jugador (type STRING))
    (slot recurso (type SYMBOL))
    (slot num_recursos (type INTEGER))
)

(defclass RONDA_INTRODUCE_BARCO
    (is-a USER)
    (slot nombre_ronda (type SYMBOL))
    (slot nombre_carta (type STRING))
)

(defclass RONDA_ASIGNA_EDIFICIO
    (is-a USER)
    (slot nombre_ronda (type SYMBOL))
    (slot id_mazo (type INTEGER) (access initialize-read) (create-accessor read))
    (slot nombre_edificio (type STRING))
)

(defclass JUGADOR_DENTRO_EDIFICIO
    (is-a USER)
    (slot nombre_jugador (type STRING))
    (slot nombre_edificio (type STRING))
)

(defclass EDIFICIO_CUESTA_RECURSO
    (is-a USER)
    (slot nombre_edificio (type STRING))
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

(defclass CARTA_PERTENECE_A_MAZO
    (is-a USER)
    (role concrete)
    (slot id_mazo (type INTEGER) (access initialize-read) (create-accessor read))
    (slot nombre_carta (type STRING) (access initialize-only) (create-accessor read))
    (slot posicion (type INTEGER)(access read-write) (create-accessor read-write))

)