#include QMK_KEYBOARD_H
#include "keycodes.h"

#include <string.h>

// 5x3 Pinta el logo de QMQ
void render_qmk_logo(void) {
    static const char PROGMEM font_qmk_logo[16] = {
        0x80, 0x81, 0x82, 0x83, 0x84,
        0xa0, 0xa1, 0xa2, 0xa3, 0xa4,
        0xc0, 0xc1, 0xc2, 0xc3, 0xc4,
        0
    };
    oled_write_P(font_qmk_logo, false);
};

// 5x2 Pinta Imagen de teclado dividido
void render_kb_split(void) {
    static const char PROGMEM font_kb_split[11] = {
        0xb5, 0xb6, 0xb7, 0xb8, 0xb9,
        0xd5, 0xd6, 0xd7, 0xd8, 0xd9,
        0
    };
    oled_write_P(font_kb_split, false);
};

// 5x1 indicador de capa OLED derecho,
// dependiendo de la capa en la estes se visualizara una imagen distinta

void render_layer_sym(void) {
    static const char PROGMEM font_layer[5][6] = {
        {0x9a, 0x9b, 0x9c, 0x9d, 0x9e, 0},//--o--
        {0xba, 0xbb, 0xbc, 0xbd, 0xbe, 0},//((o--
        {0xda, 0xdb, 0xdc, 0xdd, 0xde, 0},//--o))
		{0xba, 0xbb, 0x9c, 0xdd, 0xde, 0},//((o))prueba para capa extra
        {0x95, 0x96, 0x97, 0x98, 0x99, 0},//--🔧--
    };

    uint8_t layer = 0;
    if (layer_state_is(_NAV)) {
        layer = 1;
    } else if (layer_state_is(_SYMBOL)) {
        layer = 2;
    } else if (layer_state_is(_NUMPAD)) {
        layer = 3;
    } else if (layer_state_is(_CONFIG)) {
        layer = 4;
    }
    oled_write_P(font_layer[layer], false);
};


#if defined(RGB_MATRIX_ENABLE) || defined(RGBLIGHT_ENABLE)
	void render_rgb_status(void) {
		static const char PROGMEM font_rgb_off[3] = {0xd1, 0xd2, 0};
		static const char PROGMEM font_rgb_on[3]  = {0xd3, 0xd4, 0};
		bool rgb_enabled =
	#    if defined(RGBLIGHT_ENABLE)
			rgblight_is_enabled();
	#    elif defined(RGB_MATRIX_ENABLE)
			rgb_matrix_is_enabled();
	#    endif

		oled_write_P(rgb_enabled ? font_rgb_on : font_rgb_off, false);
	};
#endif

// 2x1 Ctrl, Alt, Shift, GUI, Caps
// pinta los iconos segun la tecla presionada
void render_mod_ctrl(void) { //pinta icono de ctrl
    static const char PROGMEM font_ctrl[3] = {0x91, 0x92, 0};
    oled_write_P(font_ctrl, false);
};

void render_mod_gui(void) {//pinta icono de GUI
    static const char PROGMEM font_gui[3] = {0xD1, 0xD2, 0};
    oled_write_P(font_gui, false);
};

void render_mod_alt(void) {//pinta icono de alt/option
    static const char PROGMEM font_alt[3] = {0xb1, 0xb2, 0};
    oled_write_P(font_alt, false);
};

void render_mod_shift(void) {//pinta icono de shift
    static const char PROGMEM font_shift[3] = {0xb3, 0xb4, 0};
    oled_write_P(font_shift, false);
};

void render_caps_lock(void) {// pinta icono de bloqueo de mayusculas
    static const char PROGMEM font_caps[3] = {0x9f, 0xbf, 0};
    oled_write_P(font_caps, false);
};


// 5x2 Pinta segun la tecla presionada, al soltarse pinta dos espacios vacios en su lugar

void render_mod_status(void) {
#if defined(NO_ACTION_ONESHOT)
    uint8_t modifiers = get_mods();
#else
    uint8_t modifiers = get_mods() | get_oneshot_mods();
#endif

    (modifiers & MOD_MASK_CTRL) ? render_mod_ctrl() : oled_write_P(PSTR("  "), false);
    oled_write_P(PSTR(" "), false);
    (modifiers & MOD_MASK_SHIFT) ? render_mod_shift() : oled_write_P(PSTR("  "), false);

    (modifiers & MOD_MASK_ALT) ? render_mod_alt() : oled_write_P(PSTR("  "), false);
    oled_write_P(PSTR(" "), false);
    (modifiers & MOD_MASK_GUI) ? render_mod_gui() : oled_write_P(PSTR("  "), false);

    led_t led_state = host_keyboard_led_state();
    (led_state.caps_lock) ? render_caps_lock() : oled_write_P(PSTR("  "), false);
}

void render_feature_status(void) {
#if defined(RGB_MATRIX_ENABLE) || defined(RGBLIGHT_ENABLE)
    render_rgb_status();
#endif
};


static uint16_t key_timer  = 0;
static bool is_key_processed = true;
static char last_keylog[4] = "...";

static void set_last_keylog_text(const char *text) {
    strncpy(last_keylog, text, sizeof(last_keylog) - 1);
    last_keylog[sizeof(last_keylog) - 1] = '\0';
}

static uint16_t normalize_keycode(uint16_t keycode) {
    if (keycode >= QK_MOD_TAP && keycode <= QK_MOD_TAP_MAX) {
        return QK_MOD_TAP_GET_TAP_KEYCODE(keycode);
    }
    if (keycode >= QK_LAYER_TAP && keycode <= QK_LAYER_TAP_MAX) {
        return QK_LAYER_TAP_GET_TAP_KEYCODE(keycode);
    }
    return keycode;
}

static void set_last_keylog(uint16_t keycode) {
    keycode = normalize_keycode(keycode);

    if (keycode >= KC_A && keycode <= KC_Z) {
        char key_char[2] = {(char)('A' + (keycode - KC_A)), '\0'};
        set_last_keylog_text(key_char);
        return;
    }

    if (keycode >= KC_1 && keycode <= KC_9) {
        char key_char[2] = {(char)('1' + (keycode - KC_1)), '\0'};
        set_last_keylog_text(key_char);
        return;
    }

    if (keycode == KC_0) {
        set_last_keylog_text("0");
        return;
    }

    switch (keycode) {
        case KC_MINUS:
            set_last_keylog_text("-");
            break;
        case KC_EQUAL:
            set_last_keylog_text("=");
            break;
        case KC_SLASH:
        case KC_KP_SLASH:
            set_last_keylog_text("/");
            break;
        case KC_BACKSLASH:
            set_last_keylog_text("\\");
            break;
        case KC_DOT:
        case KC_KP_DOT:
            set_last_keylog_text(".");
            break;
        case KC_COMM:
            set_last_keylog_text(",");
            break;
        case KC_SCLN:
            set_last_keylog_text(";");
            break;
        case KC_QUOT:
            set_last_keylog_text("'");
            break;
        case KC_GRV:
            set_last_keylog_text("`");
            break;
        case KC_LBRC:
            set_last_keylog_text("[");
            break;
        case KC_RBRC:
            set_last_keylog_text("]");
            break;
        case KC_NUBS:
            set_last_keylog_text("<>");
            break;
        case KC_NONUS_HASH:
            set_last_keylog_text("#");
            break;
        case KC_SPC:
            set_last_keylog_text("SPC");
            break;
        case KC_ENT:
            set_last_keylog_text("ENT");
            break;
        case KC_TAB:
            set_last_keylog_text("TAB");
            break;
        case KC_BSPC:
            set_last_keylog_text("BSP");
            break;
        default:
            set_last_keylog_text("...");
            break;
    }
}

void render_last_key(void) {
    oled_write_P(PSTR("key"), false);
    oled_write_P(PSTR(" "), false);
    oled_write(last_keylog, false);
}

//pinta el estatus de la capa en la que se encuentra
void render_prompt(void) {
    // Constantes para los nombres de las capas
    const char* nav_layer = "nav";
    const char* symbol_layer = "sy";
    const char* numpad_layer = "num";
    const char* config_layer = "cfg";
    const char* default_layer = "   ";  // Espacios en blanco

    if (layer_state_is(_NAV)) {
        oled_write(nav_layer, false);
    } else if (layer_state_is(_SYMBOL)) {
        oled_write(symbol_layer, false);
    } else if (layer_state_is(_NUMPAD)) {
        oled_write(numpad_layer, false);
    } else if (layer_state_is(_CONFIG)) {
        oled_write(config_layer, false);
    } else {
        oled_write(default_layer, false);
    }
};

//pinta sobre el oled secundario
void render_status_secondary(void) {
    oled_write_ln("", false);
    oled_write_ln("", false);

    render_kb_split();// pinta el icono del teclado dividido

    oled_write_ln("", false);
    oled_write_ln("", false);
    oled_write_ln("", false);

    render_layer_sym(); // pinta el icono de la capa

    oled_write_ln("", false);
    oled_write_ln("", false);
    oled_write_ln("", false);
// Pinta el icono dependiento la tecla de acceso que se presione
#if defined(RGB_MATRIX_ENABLE) || defined(RGBLIGHT_ENABLE)
    layer_state_is(_CONFIG) ? render_feature_status() : render_mod_status();
#else
    render_mod_status();
#endif
};

//Pinta sobre el oled principal
void render_status_main(void) {
    oled_write_ln("", false);
    oled_write_ln("", false);

    render_qmk_logo(); // pinta el logo de QMK

    oled_write_ln("", false);
    oled_write_ln("", false);

    render_last_key(); //Pinta la ultima tecla presionada

    oled_write_ln("", false);
    oled_write_ln("", false);

    render_prompt(); //Pinta letrero de la capa sobre la que se encuentra

    oled_write_ln("", false);

}

// gira las pantallas Oled para vertas en vertical
oled_rotation_t oled_init_user(oled_rotation_t rotation) {
    return OLED_ROTATION_270;
}

//determina acciones cuando no se ocupan las pantallas
bool oled_task_user(void) {
    if (is_keyboard_master()) {
        if (is_key_processed && (timer_elapsed(key_timer) < OLED_KEY_TIMEOUT)) {
            oled_on();
            render_status_main();
        } else if (is_key_processed) {
            is_key_processed = false;
            oled_off();
        }
    } else {
        render_status_secondary();
    }
    return false;
}

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
    if (record->event.pressed) {
        key_timer = timer_read();
        is_key_processed = true;
        set_last_keylog(keycode);
    }
    return true;
}
