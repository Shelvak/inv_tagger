class Printer < ActiveRecord::Base

  def self.generate_cardboard(analysis)
    Prawn::Document.generate("#{analysis.id}.pdf", margin: 22) do |pdf|
      date = analysis.generated_at

      blanquito =  [ { content: nil, colspan: 6, borders: [:right, :left] } ]

      tabla = [
        # MBM + Acta
        duplicate_gilada([
          { content: "<b>M.B.M.<b>", align: :center, colspan: 3, size: 14, borders: [:left, :top] },
          { content: 'ACTA Nº', align: :left, colspan: 3, borders: [:right, :top] }
        ]),

        # Representantes
        duplicate_gilada([
          { content: "Representantes de Bodegas \n Rioja 363 - Ciudad", align: :center, colspan: 3, 
            size: 7, borders: [:left] },
          { content: nil, colspan: 3, borders: [:right] }
        ]),

        # Blanco
        duplicate_gilada(blanquito),
        
        # Inst Nac.  + Dia/Mes/Año
        duplicate_gilada([
          { content: 'INSTITUTO NACIONAL', align: :left, colspan: 3, size: 10,
            borders: [:left] },
          { content: 'Día', align: :center, size: 10 },
          { content: 'Mes', align: :center, size: 10 },
          { content: 'Año', align: :center, size: 10 }
        ]),

        # vitivinicultura + fecha
        duplicate_gilada([
          { content: 'DE VITIVINICULTURA', align: :left, colspan: 3, size: 10,
            borders: [:left] },
          { content: "#{date.day}", align: :center, size: 10 },
          { content: "#{date.month}", align: :center, size: 10 },
          { content: "#{date.year}", align: :center, size: 10 }
        ]),
        
        # Blanco
        duplicate_gilada(blanquito),

        # Muestra de:
        duplicate_gilada([
          { content: 'Muestra para obtener análisis de: ', align: :left, 
            colspan: 6, borders: [:left, :bottom, :right] }
        ]),

        # Tipo de 
        duplicate_gilada([
          { content: 'APTITUD DE EXPORTACIÓN', align: :center, colspan: 6, 
            borders: [:left, :bottom, :right] }
        ]),

        # Titulo de razón
        duplicate_gilada([
          { content: 'Firma o Razón Social: ', align: :left, colspan: 6,
            borders: [:left, :bottom, :right], size: 10 }
        ]),

        # Razon del solicitante
        duplicate_gilada([
          { content: chomp_white_spaces(analysis.enrolle.nombre), align: :center, colspan: 6, borders: [:left, :bottom, :right], size: 10 }
        ]),

        # Inscripcion + código solicitante
        duplicate_gilada([
          { content: 'Inscripción I.N.V.:', align: :left, colspan: 2, borders: [:left, :bottom], size: 10 },
          { content: analysis.enrolle_code.to_s, align: :left, colspan: 4, borders: [:bottom, :right], size: 10 }
        ]),

        # Producto
        duplicate_gilada([
          { content: 'Producto :', align: :left, borders: [:left, :bottom], size: 10 },
          { content: chomp_white_spaces(analysis.product.design), align: :left, colspan: 5, borders: [:bottom, :right], size: 10 }
        ]),

        # Variedad + Año
        duplicate_gilada([
          { content: chomp_white_spaces(analysis.variety.design), align: :center, colspan: 5, borders: [:left, :bottom], size: 10 },
          { content: analysis.harvest.to_s, align: :left, colspan: 1, borders: [:bottom, :right], size: 10 }
        ]),

        # Cantidad litros
        duplicate_gilada([
          { content: 'Cantidad :' , borders: [:left, :bottom], size: 10 },
          { content: analysis.quantity.to_s, align: :right, borders: [:bottom], size: 10, colspan: 2 },
          { content: 'LTS.', align: :left, colspan: 3, borders: [:bottom, :right], size: 10 }
        ]),

        # Observaciones
        duplicate_gilada([
          { content: 'Observaciones: ', align: :left, colspan: 6, 
            borders: [:left, :bottom, :right], size: 10 }
        ]),

        # triple espacio
        duplicate_gilada(blanquito),
        duplicate_gilada(blanquito),
        duplicate_gilada(blanquito),

        # Firma
        duplicate_gilada([
          { content: 'Firma Poseedor o Responsable', align: :center, colspan: 6, size: 8, border_width: 2 }
        ])
      ]

      tabla_con_opciones = [ 
        tabla, 
        column_widths: [62, 42, 41, 29, 29, 29, 8, 62, 42, 41, 29, 29], 
        cell_style: { inline_format: true, padding: [0, 0, 0, 4], border_width: 0.2, height: 15 }
      ]

      pdf.table *tabla_con_opciones
      pdf.move_down 8
      pdf.table *tabla_con_opciones
    end
  end

  def self.duplicate_gilada(hashes = [])
    [
      hashes,
      { content: nil, borders: [] },
      hashes
    ].flatten
  end

  def self.chomp_white_spaces(string)
    string[-1] == ' ' ? chomp_white_spaces(string[0...-1]) : string
  end
end
