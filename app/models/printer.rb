class Printer < ActiveRecord::Base

  def self.generate_cardboard(analysis)
    owner = APP_CONFIG['owner']

    Prawn::Document.generate(analysis.file_path(:cardboard), margin: 22) do |pdf|
      pdf.font_families.update(
        'Times' => {
          bold: Rails.root.join('private/Times_New_Roman_Bold_Italic.ttf').to_s,
          italic: Rails.root.join('private/Times_New_Roman_Italic.ttf').to_s,
          normal: Rails.root.join('private/Times_New_Roman_Italic.ttf').to_s
        }
      )
      pdf.font 'Times'
      date = analysis.generated_at

      blanquito = [ { content: nil, colspan: 6, borders: [:right, :left] } ]

      tabla = [
        duplicate_gilada([
          { content: nil, colspan: 6, borders: [:left, :top, :right] },
        ]),

        # Title + Acta
        duplicate_gilada([
          { content: nil, align: :center, colspan: 3, size: 14, borders: [:left] },
          { content: 'ACTA Nº', align: :left, colspan: 3, borders: [:right] }
        ]),

        # Blanco
        duplicate_gilada(blanquito),
        duplicate_gilada(blanquito),
        duplicate_gilada(blanquito),

        # Inst Nac.  + Dia/Mes/Año
        duplicate_gilada([
          { content: 'INSTITUTO NACIONAL', align: :left, colspan: 3, size: 10, borders: [:left] },
          { content: 'Día', align: :center, size: 10, borders: [] },
          { content: 'Mes', align: :center, size: 10, borders: [] },
          { content: 'Año', align: :center, size: 10, borders: [:right] }
        ]),

        # vitivinicultura + fecha
        duplicate_gilada([
          { content: 'DE VITIVINICULTURA', align: :left, colspan: 3, size: 10, borders: [:left] },
          { content: "#{date.day}", align: :center, size: 10, borders: [] },
          { content: "#{date.month}", align: :center, size: 10, borders: [] },
          { content: "#{date.year}", align: :center, size: 10, borders: [:right] }
        ]),

        # Blanco
        duplicate_gilada(blanquito),

        # Muestra de:
        duplicate_gilada([
          { content: 'Muestra para obtener análisis de: ', align: :left,
            colspan: 6, borders: [:left, :right], size: 10 }
        ]),

        # Tipo de
        duplicate_gilada([
          { content: 'APTITUD DE EXPORTACIÓN', align: :center, colspan: 6,
            borders: [:left, :right], font_style: :italic }
        ]),

        # Titulo de razón
        duplicate_gilada([
          { content: 'Firma o Razón Social: ', align: :left, colspan: 6,
            borders: [:left, :right], size: 10 }
        ]),

        # Razon del solicitante
        duplicate_gilada([
          { content: "<b>#{analysis.enrolle.name}</b>", align: :center, colspan: 6, borders: [:left, :right], size: 10 }
        ]),

        # Inscripcion + código solicitante
        duplicate_gilada([
          { content: 'Inscripción I.N.V.:', align: :left, colspan: 2, borders: [:left], size: 10 },
          { content: analysis.enrolle_code.to_s, align: :left, colspan: 4, borders: [:right], size: 10, font_style: :bold }
        ]),

        # Producto
        duplicate_gilada([
          { content: 'Producto :', align: :left, borders: [:left], size: 10 },
          { content: analysis.product.name, align: :left, colspan: 5, borders: [:right], size: 10, font_style: :bold }
        ]),

        # Variedad + Año
        duplicate_gilada([
          { content: analysis.try(:variety_short_names).try(:join, ' - '), align: :center, colspan: 6, borders: [:left, :right], size: 10, font_style: :bold }
        ]),

        duplicate_gilada([
          { content: 'Cosecha :', align: :left, borders: [:left], size: 10 },
          { content: (analysis.try(:harvest) ? number_with_delimiter(analysis.harvest).to_s : '--'),
            colspan: 5, align: :left, borders: [:right], size: 10, font_style: :bold }

        ]),

        # Cantidad litros
        duplicate_gilada([
          { content: 'Cantidad :' , borders: [:left], size: 10, colspan: 2, borders: [:left]},
          { content: "<b>#{number_with_delimiter(analysis.quantity)}LTS.</b>", align: :left, size: 10, colspan: 4, borders: [:right] },
        ]),

        # Observaciones
        duplicate_gilada([
          { content: 'Observaciones: ', align: :left, colspan: 6,
            borders: [:left, :right], size: 10 }
        ]),

        # triple espacio
        duplicate_gilada(blanquito),
        duplicate_gilada(blanquito),
        duplicate_gilada(blanquito),

        # Firma
        duplicate_gilada([
          { content: 'Firma Poseedor o Responsable', align: :left, colspan: 6, size: 6, borders: [:right, :left] }
        ]),

        duplicate_gilada([
          { content: nil, colspan: 6, borders: [:left, :bottom, :right] },
        ]),
      ]

      pdf.image 'public/baco.jpg', at: [30,390], width: 90
      pdf.image 'public/baco.jpg', at: [30,750], width: 90
      pdf.image 'public/baco.jpg', at: [300,390], width: 90
      pdf.image 'public/baco.jpg', at: [300,750], width: 90

      tabla_con_opciones = [
        tabla,
        column_widths: [62, 42, 41, 29, 29, 29, 8, 62, 42, 41, 29, 29],
        cell_style: { inline_format: true, padding: [0, 0, 0, 4], border_width: 2.2, height: 15 }
      ]

      pdf.table *tabla_con_opciones
      pdf.move_down 8
      pdf.table *tabla_con_opciones
    end
  end

  def self.generate_form(analysis)

    Prawn::Document.generate(analysis.file_path(:form), page_layout: :landscape, page_size: 'A4', margin: 22) do |pdf|
      pdf.font_families.update(
        'Times' => {
          bold: Rails.root.join('private/Times_New_Roman_Bold_Italic.ttf').to_s,
          italic: Rails.root.join('private/Times_New_Roman_Italic.ttf').to_s,
          normal: Rails.root.join('private/Times_New_Roman_Italic.ttf').to_s
        }
      )
      pdf.font 'Times'

      #height = 25
      full_destinies = analysis.destinies
      destinies = full_destinies.map(&:form_code).map(&:to_s)
      full_destinies_name = full_destinies.map { |d| d.try(:name) }.join(', ')
      counts = analysis.observations.to_s.count("\n")
      observation_size = if counts < 6
                           11
                         elsif counts < 7
                           9
                         elsif counts < 9
                           7
                         else
                           5
                         end

      blanquito = [ { content: nil, colspan: 7, borders: [], height: 5 } ]

      pdf.image 'public/baco.jpg', at: [620, 570], width: 120

      tabla = [
        # Solicitud + MBM
        [
          { content: '<u>SOLICITUD PARA ANALISIS DE APTITUD DE EXPORTACIÓN</u>',
            align: :center, colspan: 7, size: 12, borders: [], font_style: :italic }
        ],
        blanquito,
        blanquito,
        [
          { content: '<u>INSTITUTO NACIONAL DE VITIVINICULTURA</u>', align: :left,  borders: [], size: 6, height: 12 }
        ],
        blanquito,
        blanquito,
        blanquito,
        [
          { content: 'RAZÓN SOCIAL:', align: :left,  borders: [], size: 9, font_style: :italic, height: 15 },
          { content: analysis.try(:enrolle).try(:name).upcase, align: :center, colspan: 4, borders: [], size: 12, height: 15 },
          { content: nil, borders: [] },
          { content: 'FECHA:', align: :left, borders: [], size: 9, font_style: :italic },
          { content: I18n.l(analysis.generated_at.to_date), align: :left, colspan: 4, borders: [], size: 12 }
        ],
        blanquito,
        [
          { content: 'Nº DE EXPORTADOR:', align: :left,  borders: [], size: 9, font_style: :italic, height: 15 },
          { content: analysis.try(:enrolle_code).try(:to_s), align: :center, colspan: 4, borders: [], size: 12, height: 15 },
          { content: nil, borders: [] },
          { content: 'MUESTRA Nº:', align: :left, borders: [], size: 10, font_style: :bold },
          { content: nil, colspan: 3, borders: [] }
        ],
        blanquito,
        [
          { content: 'Nº BGA/FCA. DEPOSITARIA:', align: :left,  borders: [], size: 9, font_style: :italic, height: 19 },
          { content: analysis.depositary_enrolle_code, align: :center, colspan: 4, borders: [], size: 12, height: 15 },
          { content: nil, borders: [] },
          {
            content: 'COMÚN:' + (analysis.common? ? '    XXX' : ''),
            font_style: analysis.common? ? :bold : nil,
            colspan: analysis.common? ? 3 : 1,
            align: :left, borders: [], size: 9
          },
          {
            content: 'PREFERENCIAL:' + (analysis.preferential? ? '  XXX' : ''),
            font_style: analysis.preferential? ? :bold : nil,
            colspan: analysis.preferential? ? 3 : 2,
            align: :left, borders: [], size: 9
          },
        ],
        [
          { content: 'DOMICILIO DEPOSITARIO:', align: :left,  colspan: 4, borders: [], size: 8, height: 15 },
          { content: nil, colspan: 2, borders: [] },
          {
            content: 'DECLARACIÓN JURADA:' + (analysis.affidavit? ? '    XXX' : ''),
            align: :left, borders: [], size: 9, colspan: 3,
            font_style: analysis.affidavit? ? :bold : nil
          },
          { content: nil, colspan: 1, borders: [] }
        ],
        blanquito,
        blanquito,
        blanquito,
        [
          { content: "TIPO DE\nPRODUCTO/MUESTRA\nMANIFESTADA", align: :center, size: 8, background_color: 'B8B8B8' },
          { content: "\nCÓDIGO", align: :center, size: 10, background_color: 'B8B8B8' },
          { content: "\nCOSECHA", align: :center, size: 10, background_color: 'B8B8B8' },
          { content: "\nLITROS", align: :center, size: 10, background_color: 'B8B8B8' },
          { content: "\nVARIEDAD", align: :center, size: 10, background_color: 'B8B8B8' },
          { content: "\nCÓDIGO", align: :center, size: 10, background_color: 'B8B8B8' },
          { content: "CÓDIGO DEL\nOBJETIVO\nDEL ANÁLISIS", align: :center, size: 8, background_color: 'B8B8B8' },
          { content: "CÓDIGO PAÍS\nDESTINO", align: :center, size: 8, background_color: 'B8B8B8' },
          { content: "DETERMINA.\nANALÍTICAS\nESPECIALES", align: :center, size: 7.5, background_color: 'B8B8B8' },
          { content: "DICT.\nCOMIS.\NDEGUST.", align: :center, size: 7.5, background_color: 'B8B8B8' },
          { content: "CANTIDAD\nDE COPIAS\nOFICIALES", align: :center, size: 6, background_color: 'B8B8B8' }
        ],
        [
          { content: [analysis.try(:product).try(:name), ' (O)'].join, align: :center, size: 12, height: 130, borders: [:left, :bottom, :right] },
          { content: analysis.try(:product_code).try(:to_s), align: :center, size: 11, borders: [:bottom, :right] },
          { content: (analysis.try(:harvest) ? number_with_delimiter(analysis.harvest).to_s : '--'), align: :center, size: 11, borders: [:bottom, :right] },
          { content: number_with_delimiter(analysis.try(:quantity)).try(:to_s), align: :center, size: 11, borders: [:bottom, :right] },
          { content: analysis.try(:variety_names).try(:join, "\n"), align: :center, size: 11, borders: [:bottom, :right] },
          { content: analysis.try(:variety_codes).try(:join, "\n"), align: :center, size: 11, borders: [:bottom, :right] },
          { content: "3053", align: :center, size: 12, borders: [:bottom, :right] },
          { content: destinies.join("\n"), align: :center, size: 11, borders: [:bottom, :right] },
          { content: (analysis.special_analysis ? 'SI' : ' '), align: :center, size: 11, borders: [:bottom, :right] },
          { content: (analysis.tasting ? 'SI' : ' '), align: :center, size: 11, borders: [:bottom, :right] },
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
          { content: "<u>OBSERVACIONES:</u>", colspan: 1, align: :left, size: 12, height: 55, borders: [:left] },
          { content: chomp_multi_whitespaces(analysis.try(:observations).to_s).gsub("\n ", "\n<color rgb='FFFFFF'>.</color>"),
            colspan: 8, size: observation_size, height: 75, borders: [] },
          { content: nil, colspan: 2, borders: [:right] }
        ],
        [
          { content: "DESTINO:             #{full_destinies_name}", colspan: 7, size: 9, height: 12, borders: [:left, :bottom] },
          { content: '  ', colspan: 2, borders: [:bottom] },
          { content: nil, colspan: 2, borders: [:bottom, :right] }
        ],
        blanquito,
        [
          { content: "EN CASO DE PRESENTAR MUESTRAS SE DEJA EXPRESA CONSTANCIA DE SU EXCLUSIVA RESPONSABILIDAD, SIN NINGÚN DERECHO A RECLAMO\nPOR LAS DEFERENCIAS DE COMPOSICIÓN QUE PUDIERAN EXISTIR ENTRE LAS MISMAS, LA PRESENTE REVISTE CARÁCTER DE DECLARACIÓN JURADA.", colspan: 7, size: 6, borders: [] },
          { content: '', colspan: 4, size: 6, borders: [], height: 20 }
        ], blanquito, blanquito,
        [
          { content: nil, colspan: 3, height: 80, borders: [] },
          { content: nil, colspan: 4, height: 80, borders: [:left, :top, :right] },
          { content: nil, colspan: 4, height: 80, borders: [] }
        ],
        [
          { content: 'FIRMA SOLICITANTE Y ACLARACIÓN', align: :center, colspan: 3, size: 7, height: 20, borders: [:top] },
          { content: 'SELLO RECEPCIÓN I.N.V.', align: :center, colspan: 4, borders: [:left, :bottom, :right] },
          { content: 'FIRMA Y SELLO EMPREADO I.N.V.', align: :center, colspan: 4, size: 7, borders: [:top] }
        ]
      ]

      tabla_con_opciones = [
        tabla,
        column_widths: [150,10,30,65,70,30,100,45,52,40],
        cell_style: { inline_format: true, padding: [0, 1, 0, 1], border_width: 2.2}
      ]

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

  def self.number_with_delimiter(number)
    ActionController::Base.helpers.number_with_delimiter number
  end

  def self.chomp_multi_whitespaces(string)
    string.split("\n").map do |e|
      e.gsub(/\S(\s{3,})\S/) { |g| g.gsub!($1, '  ') }
    end.join("\n")
  end
end
