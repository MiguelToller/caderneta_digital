import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../database/database.dart';

class PdfService {
  static int _calcularIdade(DateTime dataNasc) {
    final hoje = DateTime.now();
    int idade = hoje.year - dataNasc.year;
    if (hoje.month < dataNasc.month || (hoje.month == dataNasc.month && hoje.day < dataNasc.day)) {
      idade--;
    }
    return idade;
  }

  static Future<void> generateAndPrintVaccineHistory(
    Usuario user,
    List<AgendaWithVacina> historico,
    List<Alergia> alergias,
  ) async {
    final pdf = pw.Document();

    final dateFormat = DateFormat('dd/MM/yyyy');
    
    // Ordena o histórico por data (mais recentes primeiro)
    final sortedHistorico = List<AgendaWithVacina>.from(historico)
      ..sort((a, b) => b.agenda.dataAplicacao.compareTo(a.agenda.dataAplicacao));

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildHeader(user),
        build: (pw.Context context) {
          return [
            if (alergias.isNotEmpty) ...[
              _buildAllergiesAlertBox(alergias),
              pw.SizedBox(height: 15),
            ],
            pw.SizedBox(height: 10),
            _buildVaccineTable(sortedHistorico, dateFormat),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'caderneta_${user.nome.replaceAll(' ', '_')}.pdf',
    );
  }

  static pw.Widget _buildHeader(Usuario user) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Caderneta Digital de Vacinação', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
        pw.Divider(color: PdfColors.grey300),
        pw.SizedBox(height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Paciente: ${user.nome}', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.Text('Tipo Sanguíneo: ${user.tipoSanguineo ?? 'N/A'}', style: pw.TextStyle(fontSize: 14)),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('E-mail: ${user.email}', style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
            if (user.dataNascimento != null)
              pw.Text('Idade: ${_calcularIdade(user.dataNascimento!)} anos', style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
          ],
        ),
        pw.SizedBox(height: 10),
      ],
    );
  }

  static pw.Widget _buildAllergiesAlertBox(List<Alergia> alergias) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.red50,
        border: pw.Border.all(color: PdfColors.red700, width: 1),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'ALERTAS DE ALERGIAS',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.red800, fontSize: 10, letterSpacing: 0.5),
          ),
          pw.SizedBox(height: 8),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: alergias.map((alergia) {
              return pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 4),
                child: pw.RichText(
                  text: pw.TextSpan(
                    children: [
                      pw.TextSpan(
                        text: '${alergia.categoria}: ',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.red900, fontSize: 10),
                      ),
                      pw.TextSpan(
                        text: '${alergia.nome} ',
                        style: pw.TextStyle(color: PdfColors.red900, fontSize: 10),
                      ),
                      pw.TextSpan(
                        text: '(${alergia.gravidade})',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.red700, fontSize: 9),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildVaccineTable(List<AgendaWithVacina> historico, DateFormat format) {
    if (historico.isEmpty) {
      return pw.Center(child: pw.Text('Nenhuma vacina registrada.', style: const pw.TextStyle(fontSize: 12)));
    }

    return pw.TableHelper.fromTextArray(
      headers: ['Vacina', 'Dose', 'Data', 'Lote', 'Fabricante', 'Local'],
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 10),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
      cellStyle: const pw.TextStyle(fontSize: 10),
      cellHeight: 30,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
        4: pw.Alignment.centerLeft,
        5: pw.Alignment.centerLeft,
      },
      data: historico.map((item) {
        return [
          item.vacina.nome,
          item.agenda.dose,
          format.format(item.agenda.dataAplicacao),
          item.agenda.lote ?? '-',
          item.agenda.fabricante ?? '-',
          item.agenda.local ?? '-',
        ];
      }).toList(),
    );
  }
}
