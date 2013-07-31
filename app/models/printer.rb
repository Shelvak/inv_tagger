class Printer < ActiveRecord::Base

  def self.cartulina
    Prawn::Document.generate('lala.pdf', margin: 22) do |pdf|
      date = Time.zone.today

      blanquito =  [ { content: nil, colspan: 6, borders: [:right, :left], height: 11 } ]

      tabla = [
        # MBM + Acta
        duplicate_gilada([
          { content: "<b>M.B.M.<b>", align: :center, colspan: 3, size: 14, borders: [:left, :top], height: 22 },
          { content: 'ACTA Nº', align: :left, colspan: 3, borders: [:right, :top], height: 22 }
        ]),

        # Representantes
        duplicate_gilada([
          { content: "Representantes de Bodegas \n Rioja 363 - Ciudad", align: :center, colspan: 3, 
            size: 5, borders: [:left], height: 21 },
          { content: nil, colspan: 3, borders: [:right], height: 21 }
        ]),
        
        # Inst Nac.  + Dia/Mes/Año
        duplicate_gilada([
          { content: 'INSTITUTO NACIONAL', align: :left, colspan: 3, size: 10,
            borders: [:left], height: 20 },
          { content: 'Día', align: :center, height: 20, size: 10 },
          { content: 'Mes', align: :center, height: 20, size: 10 },
          { content: 'Año', align: :center, height: 20, size: 10 }
        ]),

        # vitivinicultura + fecha
        duplicate_gilada([
          { content: 'DE VITIVINICULTURA', align: :left, colspan: 3, size: 10,
            borders: [:left], height: 20 },
          { content: "#{date.day}", align: :center, height: 20, size: 10 },
          { content: "#{date.month}", align: :center, height: 20, size: 10 },
          { content: "#{date.year}", align: :center, height: 20, size: 10 }
        ]),

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
            borders: [:left, :bottom, :right] }
        ]),

        # Razon del solicitante
        duplicate_gilada([
          { content: 'Vieja', align: :center, colspan: 6, borders: [:left, :bottom, :right] }
        ]),

        # Inscripcion + código solicitante
        duplicate_gilada([
          { content: 'Inscripción I.N.V.:', align: :left, colspan: 2, borders: [:left, :bottom] },
          { content: 'Vieja', align: :left, colspan: 4, borders: [:bottom, :right] }
        ]),

        # Producto
        duplicate_gilada([
          { content: 'Producto :', align: :left, borders: [:left, :bottom] },
          { content: 'TITULO PRODUCTO', align: :left, colspan: 5, borders: [:bottom, :right] }
        ]),

        # Variedad + Año
        duplicate_gilada([
          { content: 'VARIEDAD', align: :center, colspan: 2, borders: [:left, :bottom] },
          { content: 'AÑO', align: :left, colspan: 4, borders: [:bottom, :right] }
        ]),

        # Cantidad litros
        duplicate_gilada([
          { content: 'Cantidad :' , borders: [:left, :bottom] },
          { content: 'Nº litros', align: :right, borders: [:bottom] },
          { content: 'LTS.', align: :left, colspan: 4, borders: [:bottom, :right] }
        ]),

        # Observaciones
        duplicate_gilada([
          { content: 'Observaciones: ', align: :left, colspan: 6, 
            borders: [:left, :bottom, :right] }
        ]),

        # triple espacio
        duplicate_gilada(blanquito),
        duplicate_gilada(blanquito),
        duplicate_gilada(blanquito),

        # Firma
        duplicate_gilada([
          { content: 'Firma Poseedor o Responsable', align: :center, colspan: 6 }
        ])
      ]
      var = [
        { content: '', align: :a, colspan: 7  }
      ]

      p tabla

      tabla_con_opciones = [ 
        tabla, 
        column_widths: [64, 44, 44, 29, 29, 29, 8, 64, 44, 29, 29, 29 ], 
        cell_style: { inline_format: true }
      ]

      pdf.table *tabla_con_opciones
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
end
