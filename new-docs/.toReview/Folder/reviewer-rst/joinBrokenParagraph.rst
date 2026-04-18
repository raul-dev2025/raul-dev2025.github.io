.. code-block:: python

   def join_broken_paragraphs(lines):
      if not lines:
         return []

      1. Identificar todos los títulos del documento para la heurística del TOC
      Filtramos líneas que son títulos usando is_structural_break
      doc_titles = []
      for i, L in enumerate(lines):
         nxt = lines[i+1] if i+1 < len(lines) else None
         if is_structural_break(L.strip(), next_line=nxt):
               Si es un título subrayado, el texto está en L
               if nxt and is_underline(nxt):
                  doc_titles.append(L.strip())

      blocks = []
      Insertamos la directiva TOC oficial al inicio
      blocks.extend(get_toc_directive())
      
      current_block = []
      first_text_block_processed = False

      for i in range(len(lines)):
         line = lines[i].strip()
         
         if not line:
               if current_block and i + 1 < len(lines):
                  if is_likely_same_paragraph(current_block[-1], lines[i+1].strip()):
                     continue
               
               if current_block:
                  text_content = " ".join(current_block)
                  
                  Heurística de limpieza de TOC residual
                  if not first_text_block_processed:
                     if is_legacy_toc(text_content, doc_titles):
                           current_block = []
                           first_text_block_processed = True
                           continue
                  
                  blocks.append(text_content)
                  first_text_block_processed = True
                  current_block = []
               continue

         Lógica de detección estructural (Títulos/Bloques)
         next_l = lines[i+1] if i+1 < len(lines) else None
         if is_structural_break(line, next_line=next_l):
               if current_block:
                  blocks.append(" ".join(current_block))
                  current_block = []
               blocks.append(line)
         else:
               current_block.append(line)

      if current_block:
         blocks.append(" ".join(current_block))

      return blocks


