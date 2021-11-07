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
;                                     ╔═╗╔╗╔╔╦╗╔═╗╦  ╔═╗╔═╗╦╔═╗
;                                     ║ ║║║║ ║ ║ ║║  ║ ║║ ╦║╠═╣
;                                     ╚═╝╝╚╝ ╩ ╚═╝╩═╝╚═╝╚═╝╩╩ ╩
;             +-----------------------------+--------------+-------------------------+
;             |           Authors           |     NIAS     |          Githubs        |
;             +-----------------------------+--------------+-------------------------+
;             | Ricardo Grande Cros         |  100386336   |      ricardograndecros  |
;             | Diego Fernandez Sebastian   |  100387203   |      dfs99              |
;             +-----------------------------+--------------+-------------------------+
;
;

; 
; +==============================================================================================+
; |                                                                                              |
; |                                ╔═╗╔═╗╔╗╔╔═╗╔═╗╔═╗╔╦╗╔═╗╔═╗                                   |
; |                                ║  ║ ║║║║║  ║╣ ╠═╝ ║ ║ ║╚═╗                                   |
; |                                ╚═╝╚═╝╝╚╝╚═╝╚═╝╩   ╩ ╚═╝╚═╝                                   |
; |                                                                                              |
; +==============================================================================================+
;

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
        (allowed-values PESCADOR, MARTILLO) (access initialize-only) (create-accessor read))
)


(deftemplate OFERTA_RECURSO
    (slot recurso (type SYMBOL)
        (allowed-values FRANCO, MADERA, PESCADO, ARCILLA, HIERRO, GRANO, GANADO)
        (access initialize-only) (create-accessor read))
    (slot cantidad (type INTEGER) (access read-write) (create-accessor read-write))
)

; Representar la información de que en la partida el edificio con nombre X (el nombre será 
; único) corresponde al edificio. Creemos que es mejor alternativa a emplear conceptos.

; Comentario del presente: (06/11)
; Pensamos que su objetivo inicial era ligar todos aquellos edificios con el ayunto. El ayunto no hace
; falta que sea representado a través de un concepto pues no tiene atributos significativos, por esa razón
; se ha pensado en emplear un deftemplate.
(deftemplate EDIFICIO_AYUNTAMIENTO
    (slot nombre_edificio (type STRING) (access initialize-only) (create-accessor read))
)

(deftemplate JUGADOR_ESTA_EDIFICIO
    (slot nombre_edificio (type STRING) (access initialize-only) (create-accessor read))
    (slot nombre_jugador (type STRING) (access initialize-only) (create-accessor read))
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
    (role concrete)
    (slot nombre (type STRING) (access initialize-only) (create-accessor read))
    (slot valor (type INTEGER) (access initialize-only) (create-accessor read))
)

(defclass CARTA_BANCO
    (is-a CARTA)
    (role concrete)
    (slot coste (type INTEGER) (access initialize-only) (create-accessor read))
)

; Validada sintácticamente en CLIPS.
; IMPORTANTE: el barco lujoso, al no reducir la comida necesaria al final de ronda 
; ni poderse comprar con francos (coste), es sencillamente una instancia de la 
; clase carta. 
(defclass BARCO
    (is-a CARTA)
    (role concrete)
    (slot coste (type INTEGER) (access initialize-only) (create-accessor read))
    (slot uds_comida_genera (type INTEGER) (access initialize-only) (create-accessor read))
    (slot capacidad_envio (type INTEGER) (access initialize-only) (create-accessor read))
)

; Validada sintácticamente en CLIPS.
(defclass LOSETA
    (is-a USER)
    (role concrete)
    (slot posicion (type INTEGER) (access initialize-only) (create-accessor read))
    (slot visibilidad (type SYMBOL)
        (allowed-values TRUE, FALSE)
        (default FALSE)
        (access read-write) (create-accessor read-write))
    (slot intereses (type SYMBOL)
        (allowed-values TRUE, FALSE)
        (default FALSE)
        (access initialize-only) (create-accessor read))
)

; +==============================================================================================+
; |                                                                                              |
; |                                 ┬─┐┌─┐┬  ┌─┐┌─┐┬┌─┐┌┐┌┌─┐┌─┐                                 |
; |                                 ├┬┘├┤ │  ├─┤│  ││ ││││├┤ └─┐                                 |
; |                                 ┴└─└─┘┴─┘┴ ┴└─┘┴└─┘┘└┘└─┘└─┘                                 |
; |                                                                                              |
; +==============================================================================================+



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

(defclass LOSETA_TIENE_RECURSO
    (is-a USER)
    (slot posicion (type INTEGER))
    (slot recurso (type SYMBOL))
    (slot cantidad (type INTEGER))
)

(defclass JUGADOR_ESTA_EN_LOSETA
    (is-a USER)
    (slot posicion (type INTEGER))
    (slot nombre_jugador (type STRING))
)

;===================== CARTAS =================
(defclass CARTA_TIENE_BONUS
    (is-a USER)
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
    (slot posicion_en_mazo (type INTEGER)(access read-write) (create-accessor read-write))

)

(defclass RONDA_INTRODUCE_BARCO
    (is-a USER)
    (slot nombre_ronda (type SYMBOL))
    (slot nombre_carta (type STRING) (access initialize-only) (create-accessor read))
)

; Al final de una ronda, se escoge una carta de un mazo y se le asigna al ayuntamiento. 
; La carta a entregar no es fija, si un jugador la compra o construye, se otorgará al 
; ayuntamiento la siguiente carta de ese mazo. Por tanto, con el nombre de la ronda y
; el id del mazo ya está todo representado. 
(defclass RONDA_ASIGNA_EDIFICIO
    (is-a USER)
    (slot nombre_ronda (type SYMBOL))
    (slot id_mazo (type INTEGER) (access initialize-read) (create-accessor read))
)

; 
; (06/11) Mientras revisamos vimos que teníamos apuntado esto: "HACER UN HECHO, PORQ SOLO SE INSTANCIA UNA VEZ!!!!!!!!!!!!!!!!!!!!!!" 
; TODO: preguntar a Javier si es mejor tener un hecho compuesto (deftemplate) en lugar
; de una relación con clase. La duda es que no sabemos si podemos tenerlo en deftemplate
; porque al final está representando una relación entre Jugador y Carta. 
(defclass JUGADOR_DENTRO_EDIFICIO
    (is-a USER)
    (slot nombre_jugador (type STRING))
    (slot nombre_carta (type STRING) (access initialize-only) (create-accessor read))
)

(defclass COSTE_ENTRADA_CARTA
    (is-a USER)
    (slot nombre_carta (type STRING))
    (slot tipo (type SYMBOL)
        (allowed-values COMIDA, DINERO)
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
    (slot cantidad_maxima (type INTEGER)(access initialize-only)(create-accessor read))
    ; Se podría implementar el máx, pero de momento relajamos esta precondicion. 
)

(defclass EDIFICIO_OUTPUT
    (is-a USER)
    (slot nombre_carta (type STRING))
    (slot recurso (type SYMBOL)
        (allowed-values FRANCOS, MADERA, PESCADO, ARCILLA, HIERRO, GRANO, GANADO, CARBON, PIEL,
            PESCADO_AHUMADO, CARBON_VEGETAL, LADRILLOS, ACERO, PAN, CARNE, COQUE, CUERO)
        (access initialize-only) (create-accessor read))
    (slot cantidad_min_generada_por_unidad (type FLOAT) (access initialize-only) (create-accessor read))
)

(defclass COSTE_ENERGIA
    (is-a USER)
    (slot nombre_carta (type STRING) (access initialize-only) (create-accessor read))
    ; todo: En un futuro, puede q relajemos las precondiciones de costes de energía.
    ; existen edificios donde el coste de energía es unitario y otros en donde no.
    ; Definimos coste unitario como aquel coste energético que precisa una unidad de recurso para producir otra.
    ; Por ejemplo, en el ahumador, independientemente del nº de pescados, siempre te costará 1. No es el caso de 
    ; la fabrica de ladrillos, donde cada arcilla necesitará 0.5
    (slot coste_unitario (type SYMBOL) (allowed-values TRUE, FALSE) (access initialize-only) (create-accessor read))
    (slot cantidad (type FLOAT) (access initialize-only) (create-accessor read))
)