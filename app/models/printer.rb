class Printer < ActiveRecord::Base

  def self.generate_cardboard(analysis)
    Prawn::Document.generate(analysis.file_path(:cardboard), margin: 22) do |pdf|
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
          { content: "Representantes de Bodegas \n Rioja 360 - Ciudad", align: :center, colspan: 3,
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
          { content: "<b>#{chomp_white_spaces(analysis.enrolle.nombre)}</b>", align: :center, colspan: 6, borders: [:left, :bottom, :right], size: 10 }
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
          { content: chomp_white_spaces(analysis.try(:variety).try(:design)), align: :center, colspan: 5, borders: [:left, :bottom], size: 10 },
          { content: number_with_delimiter(analysis.harvest).to_s, align: :left, colspan: 1, borders: [:bottom, :right], size: 10 }
        ]),

        # Cantidad litros
        duplicate_gilada([
          { content: 'Cantidad :' , borders: [:left, :bottom], size: 10 },
          { content: "<b>#{number_with_delimiter(analysis.quantity)}</b>", align: :right, borders: [:bottom], size: 10, colspan: 2 },
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

  def self.generate_form(analysis)
    Prawn::Document.generate(analysis.file_path(:form), page_layout: :landscape, page_size: 'A4', margin: 22) do |pdf|
      #height = 25
      full_destinies = analysis.destinies
      destinies = full_destinies.map(&:codpais).map(&:to_s)
      full_destinies_name = full_destinies.map { |d| chomp_white_spaces(d.try(:nombre)) }.join(', ')

      blanquito = [ { content: nil, colspan: 7, borders: [], height: 5 } ]

      tabla = [
        # Solicitud + MBM
        [
          { content: '<u>SOLICITUD PARA ANALISIS DE APTITUD DE EXPORTACIÓN</u>',
            align: :center, colspan: 7, size: 17, borders: [] },
          { content: "<b>M.B.M.<b>", align: :center, colspan: 4, size: 14, borders: [] }
        ],
        blanquito,
        [
          { content: '<u>INSTITUTO NACIONAL</u>', align: :left,  borders: [], size: 10, height: 12 }
        ],
        [
          { content: '<u>DE VITIVINICULTURA</u>', align: :left, borders: [], size: 10, height: 12 }
        ],
        blanquito,
        [
          { content: 'RAZÓN SOCIAL:', align: :left,  borders: [], size: 11, height: 15 },
          { content: analysis.try(:enrolle).try(:nombre).upcase, align: :center, colspan: 4, borders: [:bottom], size: 12, height: 15 },
          { content: nil, borders: [] },
          { content: 'FECHA:', align: :left, borders: [], size: 10 },
          { content: I18n.l(analysis.generated_at.to_date), align: :center, colspan: 4, borders: [:bottom], size: 12 }
        ],
        blanquito,
        [
          { content: 'Nº DE EXPORTADOR:', align: :left,  borders: [], size: 11, height: 15 },
          { content: analysis.try(:enrolle_code).try(:to_s), align: :center, colspan: 4, borders: [:bottom], size: 12, height: 15 },
          { content: nil, borders: [] },
          { content: 'MUESTRA Nº:', align: :left, borders: [], size: 10 },
          { content: nil, colspan: 4, borders: [:bottom] }
        ],
        blanquito,
        [
          { content: 'Nº BGA/FCA. DEPOSITARIA:', align: :left,  borders: [], size: 11, height: 15 },
          { content: analysis.depositary_enrolle_code, align: :center, colspan: 4, borders: [:bottom], size: 12, height: 15 },
          { content: nil, borders: [] },
          { content: '<b>COMÚN:</b>', align: :left, borders: [], size: 8 },
          { content: nil, borders: [] },
          { content: (analysis.common? ? 'X' : nil), align: :center, border_width: 3 },
          { content: nil, borders: [] }
        ],
        [
          { content: 'DOMICILIO DEPOSITARIO:', align: :left,  colspan: 4, borders: [], size: 8, height: 15 },
          { content: nil, colspan: 2, borders: [] },
          { content: '<b>PREFERENCIAL:</b>', align: :left, borders: [], size: 8 },
          { content: nil, borders: [] },
          { content: (analysis.preferential? ? 'X' : nil), align: :center, border_width: 3 },
          { content: nil, borders: [] }
        ],
        [
          { content: nil, colspan: 4, borders: [], height: 15 },
          { content: nil, colspan: 2, borders: [] },
          { content: '<b>DECLARACIÓN JURADA:</b>', align: :left, borders: [], size: 8 },
          { content: nil, borders: [] },
          { content: (analysis.affidavit? ? 'X' : nil), align: :center, border_width: 3 },
          { content: nil, borders: [] }
        ],
        blanquito,
        blanquito,
        [
          { content: "TIPO DE\nPRODUCTO/MUESTRA\nVINO BLANCO (Io)", align: :center, size: 8 },
          { content: 'CÓDIGO', align: :center, size: 10 },
          { content: 'COSECHA', align: :center, size: 10 },
          { content: 'LITROS', align: :center, size: 10 },
          { content: 'VARIEDAD', align: :center, size: 10 },
          { content: 'CÓDIGO', align: :center, size: 10 },
          { content: "CÓDIGO DEL\nOBJETIVO\nDEL ANÁLISIS", align: :center, size: 8 },
          { content: "CÓDIGO PAÍS\nDESTINO", align: :center, size: 8 },
          { content: "DETERMINA.\nANALÍTICAS\nESPECIALES", align: :center, size: 7.5 },
          { content: "DICT.\nCOMIS.\NDEGUST.", align: :center, size: 7.5 },
          { content: "CANTIDAD\nDE COPIAS", align: :center, size: 8 }
        ],
        [
          { content: [chomp_white_spaces(analysis.try(:product).try(:design)), ' (O)'].join, align: :center, size: 12, height: 130, borders: [:left, :bottom] },
          { content: analysis.try(:product_code).try(:to_s), align: :center, size: 11, borders: [:bottom] },
          { content: number_with_delimiter(analysis.try(:harvest)).try(:to_s), align: :center, size: 11, borders: [:bottom] },
          { content: number_with_delimiter(analysis.try(:quantity)).try(:to_s), align: :center, size: 11, borders: [:bottom] },
          { content: chomp_white_spaces(analysis.try(:variety).try(:design)), align: :center, size: 11, borders: [:bottom] },
          { content: analysis.try(:variety_code).try(:to_s), align: :center, size: 11, borders: [:bottom] },
          { content: "3053", align: :center, size: 12, borders: [:bottom] },
          { content: destinies.join("\n"), align: :center, size: 11, borders: [:bottom] },
          { content: (analysis.special_analysis ? 'SI' : ' '), align: :center, size: 11, borders: [:bottom] },
          { content: (analysis.tasting ? 'SI' : ' '), align: :center, size: 11, borders: [:bottom] },
          { content: analysis.copies.to_s, align: :center, size: 11, borders: [:right, :bottom] }
        ],
        blanquito,
        blanquito,
        [
          { content: "<u>ANALISIS DE ORIGEN:</u>", align: :left, size: 9.5, height: 14, borders: [:top, :left] },
          { content: analysis.source_analysis, colspan: 8, size: 8, borders: [:top] },
          { content: nil, colspan: 2, borders: [:top, :right] }
        ],
        [
          { content: "<color rgb='FFFFFF'>...</color>            <u>OBSERVACIONES:</u>", colspan: 1, align: :left, size: 12, height: 55, borders: [:left] },
          { content: analysis.try(:observations).to_s, colspan: 8, size: 11, height: 75, borders: [] },
          { content: nil, colspan: 2, borders: [:right] }
        ],
        [
          { content: "DESTINO:             #{full_destinies_name}", colspan: 7, size: 9, height: 12, borders: [:left] },
          { content: '  ', colspan: 2, borders: [] },
          { content: nil, colspan: 2, borders: [:right] }
        ],
        [
          { content: "EN CASO DE PRESENTAR MUESTRAS SE DEJA EXPRESA CONSTANCIA DE SU EXCLUSIVA RESPONSABILIDAD, SIN NINGÚN DERECHO A RECLAMO\nPOR LAS DEFERENCIAS DE COMPOSICIÓN QUE PUDIERAN EXISTIR ENTRE LAS MISMAS, LA PRESENTE REVISTE CARÁCTER DE DECLARACIÓN JURADA.", colspan: 7, size: 6, borders: [:left, :bottom] },
          { content: '', colspan: 4, size: 6, borders: [:right, :bottom], height: 20 }
        ], blanquito, blanquito,
        [
          { content: nil, colspan: 3, height: 80, borders: [] },
          { content: nil, colspan: 4, height: 80, borders: [:left, :top, :right] },
          { content: nil, colspan: 4, height: 80, borders: [] }
        ],
        [
          { content: 'FIRMA SOLICITANTE Y ACLARACIÓN', align: :center, colspan: 3, size: 8, height: 20, borders: [:top] },
          { content: 'SELLO RECEPCIÓN I.N.V.', align: :center, colspan: 4, borders: [:left, :bottom, :right] },
          { content: 'FIRMA Y SELLO EMPREADO I.N.V.', align: :center, colspan: 4, size: 8, borders: [:top] }
        ]
      ]

      tabla_con_opciones = [
        tabla,
        column_widths: [150,10,30,65,70,30,100,45,52,40],
        cell_style: { inline_format: true, padding: [0, 1, 0, 1] }
      ]

      pdf.table *tabla_con_opciones

      # Do the fuck1ng MBM circle
      pdf.stroke do
        pdf.rounded_rectangle [658, 559], 65, 35, 18
      end
    end
  end

  def self.duplicate_gilada(hashes = [])
    [
      hashes,
      { content: nil, borders: [] },
      hashes
    ].flatten
  end

  def self.number_with_delimiter(number)
    ActionController::Base.helpers.number_with_delimiter number
  end

  def self.chomp_white_spaces(string)
    (string && string[-1] == ' ') ? chomp_white_spaces(string[0...-1]) : string
  end
end
