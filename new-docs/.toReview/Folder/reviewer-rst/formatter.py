# -*- coding: utf-8 -*-
from processor import is_potential_title_text, is_underline

LEVEL_STYLES = {
    1: {'char': '=', 'overline': True},
    2: {'char': '-', 'overline': False},
    3: {'char': '~', 'overline': False},
    4: {'char': '^', 'overline': False},
}

def apply_rst_title_format(blocks, filename_base):
    output = []
    symbol_to_level = {}
    next_available_level = 1
    title_count = 0
    
    # Referencia del símbolo del Nivel 1 para detectar repeticiones
    level_1_symbol = None

    i = 0
    while i < len(blocks):
        current = blocks[i].strip()
        next_b = blocks[i+1].strip() if i+1 < len(blocks) else ""        

        if is_potential_title_text(current) and is_underline(next_b):
            symbol = next_b[0]
            
            # Determinamos el nivel
            if symbol not in symbol_to_level:
                # Si es un símbolo nuevo, le asignamos el siguiente nivel
                # (Máximo nivel 4 según nuestros estilos)
                current_level = next_available_level
                symbol_to_level[symbol] = current_level
                
                if current_level == 1:
                    level_1_symbol = symbol
                
                if next_available_level < 4:
                    next_available_level += 1
            else:
                # Símbolo ya conocido
                current_level = symbol_to_level[symbol]
                
                # REGLA DE PROTECCIÓN NIVEL 1:
                # Si reaparece el símbolo del Nivel 1 después de haber
                # avanzado en la jerarquía, lo tratamos como Nivel 2.
                if symbol == level_1_symbol and title_count > 0 and current_level == 1:
                    # Lo degradamos visualmente a Nivel 2
                    current_level = 2

            # Aplicar el estilo estricto
            style = LEVEL_STYLES.get(current_level, {'char': symbol, 'overline': False})
            
            title_count += 1
            output.append(f".. _{filename_base}_{title_count}:")
            output.append("")
            
            char = style['char']
            underline = char * len(current)
            
            if style['overline']:
                output.append(underline)
                output.append(current)
                output.append(underline)
            else:
                output.append(current)
                output.append(underline)
            
            output.append("")
            i += 2  # Saltamos el texto y su subrayado original
        else:
            if current:
                output.append(current)
                output.append("")
            i += 1

    return "\n".join(output)