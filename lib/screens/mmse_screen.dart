import 'package:flutter/material.dart';
import '../models/mmse_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';
import '../helpers/auto_save_mixin.dart';

class MMSEScreen extends StatefulWidget {
  const MMSEScreen({super.key});

  @override
  State<MMSEScreen> createState() => _MMSEScreenState();
}

class _MMSEScreenState extends State<MMSEScreen> with AutoSaveMixin {
  final MMSEData _data = MMSEData();

  @override
  String get scaleName => 'mmse';

  @override
  Map<String, dynamic> getDataToSave() {
    return {
      'ano': _data.ano,
      'estacao': _data.estacao,
      'mes': _data.mes,
      'dia': _data.dia,
      'diaSemana': _data.diaSemana,
      'pais': _data.pais,
      'estado': _data.estado,
      'cidade': _data.cidade,
      'hospital': _data.hospital,
      'andar': _data.andar,
      'palavra1': _data.palavra1,
      'palavra2': _data.palavra2,
      'palavra3': _data.palavra3,
      'subtracao1': _data.subtracao1,
      'subtracao2': _data.subtracao2,
      'subtracao3': _data.subtracao3,
      'subtracao4': _data.subtracao4,
      'subtracao5': _data.subtracao5,
      'recordacao1': _data.recordacao1,
      'recordacao2': _data.recordacao2,
      'recordacao3': _data.recordacao3,
      'lapis': _data.lapis,
      'relogio': _data.relogio,
      'repeticao': _data.repeticao,
      'comando1': _data.comando1,
      'comando2': _data.comando2,
      'comando3': _data.comando3,
      'leitura': _data.leitura,
      'escrita': _data.escrita,
      'desenho': _data.desenho,
    };
  }

  @override
  Future<void> restoreData(Map<String, dynamic> data) async {
    _data.ano = data['ano'] ?? 0;
    _data.estacao = data['estacao'] ?? 0;
    _data.mes = data['mes'] ?? 0;
    _data.dia = data['dia'] ?? 0;
    _data.diaSemana = data['diaSemana'] ?? 0;
    _data.pais = data['pais'] ?? 0;
    _data.estado = data['estado'] ?? 0;
    _data.cidade = data['cidade'] ?? 0;
    _data.hospital = data['hospital'] ?? 0;
    _data.andar = data['andar'] ?? 0;
    _data.palavra1 = data['palavra1'] ?? 0;
    _data.palavra2 = data['palavra2'] ?? 0;
    _data.palavra3 = data['palavra3'] ?? 0;
    _data.subtracao1 = data['subtracao1'] ?? 0;
    _data.subtracao2 = data['subtracao2'] ?? 0;
    _data.subtracao3 = data['subtracao3'] ?? 0;
    _data.subtracao4 = data['subtracao4'] ?? 0;
    _data.subtracao5 = data['subtracao5'] ?? 0;
    _data.recordacao1 = data['recordacao1'] ?? 0;
    _data.recordacao2 = data['recordacao2'] ?? 0;
    _data.recordacao3 = data['recordacao3'] ?? 0;
    _data.lapis = data['lapis'] ?? 0;
    _data.relogio = data['relogio'] ?? 0;
    _data.repeticao = data['repeticao'] ?? 0;
    _data.comando1 = data['comando1'] ?? 0;
    _data.comando2 = data['comando2'] ?? 0;
    _data.comando3 = data['comando3'] ?? 0;
    _data.leitura = data['leitura'] ?? 0;
    _data.escrita = data['escrita'] ?? 0;
    _data.desenho = data['desenho'] ?? 0;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadTemporaryData();
  }

  Future<void> _salvarMMSE() async {
    try {
      final score = CompletedScore(
        scoreName: 'Mini-Mental State Examination (MMSE)',
        scoreData: {
          'ano': _data.ano,
          'estacao': _data.estacao,
          'mes': _data.mes,
          'dia': _data.dia,
          'diaSemana': _data.diaSemana,
          'pais': _data.pais,
          'estado': _data.estado,
          'cidade': _data.cidade,
          'hospital': _data.hospital,
          'andar': _data.andar,
        },
        resultado: '${_data.totalScore}/30 - ${_data.interpretation}',
        totalScore: _data.totalScore,
      );
      
      await PatientService.saveCompletedScore(score);
      clearTemporaryData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala MMSE salva com sucesso!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Ver Relatório',
              textColor: Colors.white,
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/report');
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildInstructionCard(String title, String instruction) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, size: 18, color: Colors.blue.shade800),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              instruction,
              style: TextStyle(fontSize: 11, color: Colors.blue.shade900),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxItem(String title, int value, ValueChanged<int> onChanged, {String? instruction}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (instruction != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text(
                instruction,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade700, fontStyle: FontStyle.italic),
              ),
            ),
          ],
          CheckboxListTile(
            title: Text(title, style: const TextStyle(fontSize: 13)),
            value: value == 1,
            onChanged: (val) {
              onChanged(val == true ? 1 : 0);
              onDataChanged();
            },
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildRadioItem(String title, int value, List<String> options, ValueChanged<int> onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...options.asMap().entries.map((entry) => RadioListTile<int>(
              title: Text(entry.value, style: const TextStyle(fontSize: 12)),
              value: entry.key,
              groupValue: value,
              onChanged: (val) {
                onChanged(val ?? 0);
                onDataChanged();
              },
              activeColor: Colors.blue,
              dense: true,
            )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final score = _data.totalScore;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini-Mental State Examination (MMSE)'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'MMSE - Avaliação Cognitiva (0-30 pontos)',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            color: Colors.blue.shade100,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Instruções Gerais',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '• Aplique as questões na ordem apresentada\n• Marque apenas quando o paciente responder CORRETAMENTE\n• Não dê pistas ou ajuda durante a avaliação\n• Se o paciente não souber uma resposta, marque como incorreto (não marque o checkbox)',
                    style: TextStyle(fontSize: 11, color: Colors.blue.shade900),
                  ),
                ],
              ),
            ),
          ),
          const Text('1. Orientação Temporal (5 pontos)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          _buildInstructionCard(
            'Instrução',
            'Faça as seguintes perguntas ao paciente. Marque apenas se a resposta estiver CORRETA. Não corrija erros.',
          ),
          _buildCheckboxItem('Ano', _data.ano, (val) => setState(() => _data.ano = val), instruction: 'Pergunte: "Que ano é este?"'),
          _buildCheckboxItem('Estação', _data.estacao, (val) => setState(() => _data.estacao = val), instruction: 'Pergunte: "Que estação do ano é esta?"'),
          _buildCheckboxItem('Mês', _data.mes, (val) => setState(() => _data.mes = val), instruction: 'Pergunte: "Que mês é este?"'),
          _buildCheckboxItem('Dia', _data.dia, (val) => setState(() => _data.dia = val), instruction: 'Pergunte: "Que dia do mês é hoje?"'),
          _buildCheckboxItem('Dia da Semana', _data.diaSemana, (val) => setState(() => _data.diaSemana = val), instruction: 'Pergunte: "Que dia da semana é hoje?"'),
          const SizedBox(height: 12),
          const Text('2. Orientação Espacial (5 pontos)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          _buildInstructionCard(
            'Instrução',
            'Faça as perguntas na ordem. Aceite o nome atual ou comum do local.',
          ),
          _buildCheckboxItem('País', _data.pais, (val) => setState(() => _data.pais = val), instruction: 'Pergunte: "Em que país nós estamos?"'),
          _buildCheckboxItem('Estado', _data.estado, (val) => setState(() => _data.estado = val), instruction: 'Pergunte: "Em que estado nós estamos?"'),
          _buildCheckboxItem('Cidade', _data.cidade, (val) => setState(() => _data.cidade = val), instruction: 'Pergunte: "Em que cidade nós estamos?"'),
          _buildCheckboxItem('Hospital', _data.hospital, (val) => setState(() => _data.hospital = val), instruction: 'Pergunte: "Que tipo de lugar é este?" ou "Qual o nome deste lugar?"'),
          _buildCheckboxItem('Andar/Piso', _data.andar, (val) => setState(() => _data.andar = val), instruction: 'Pergunte: "Em que andar/piso estamos?" ou "Qual o número do andar?"'),
          const SizedBox(height: 12),
          const Text('3. Registro (3 palavras)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          _buildInstructionCard(
            'Instrução',
            'Diga estas 3 palavras claramente (exemplo: "CASA, BOLA, GATO" ou "PAPEL, FLOR, MESA"). O paciente deve REPETIR as palavras. Marque cada palavra que ele repetir CORRETAMENTE. Se não repetir todas, pode dar até 6 tentativas. IMPORTANTE: Marque apenas quando repetir corretamente.',
          ),
          _buildCheckboxItem('Palavra 1 (repetiu corretamente)', _data.palavra1, (val) => setState(() => _data.palavra1 = val), instruction: 'Marque se o paciente repetiu a primeira palavra corretamente'),
          _buildCheckboxItem('Palavra 2 (repetiu corretamente)', _data.palavra2, (val) => setState(() => _data.palavra2 = val), instruction: 'Marque se o paciente repetiu a segunda palavra corretamente'),
          _buildCheckboxItem('Palavra 3 (repetiu corretamente)', _data.palavra3, (val) => setState(() => _data.palavra3 = val), instruction: 'Marque se o paciente repetiu a terceira palavra corretamente'),
          const SizedBox(height: 12),
          const Text('4. Atenção e Cálculo - Subtração por 7 (5 pontos)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          _buildInstructionCard(
            'Instrução',
            'Diga: "Agora vou fazer contas com você. Comece com 100 e vá subtraindo 7 de cada resposta. Quanto é 100 menos 7?" Continue perguntando: "E 93 menos 7?", "E 86 menos 7?", etc. Marque cada resposta CORRETA. Se errar uma, não pode continuar pontuando.',
          ),
          _buildCheckboxItem('100 - 7 = 93', _data.subtracao1, (val) => setState(() => _data.subtracao1 = val), instruction: 'Resposta correta: 93'),
          _buildCheckboxItem('93 - 7 = 86', _data.subtracao2, (val) => setState(() => _data.subtracao2 = val), instruction: 'Resposta correta: 86'),
          _buildCheckboxItem('86 - 7 = 79', _data.subtracao3, (val) => setState(() => _data.subtracao3 = val), instruction: 'Resposta correta: 79'),
          _buildCheckboxItem('79 - 7 = 72', _data.subtracao4, (val) => setState(() => _data.subtracao4 = val), instruction: 'Resposta correta: 72'),
          _buildCheckboxItem('72 - 7 = 65', _data.subtracao5, (val) => setState(() => _data.subtracao5 = val), instruction: 'Resposta correta: 65'),
          const SizedBox(height: 12),
          const Text('5. Recordação (3 palavras)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          _buildInstructionCard(
            'Instrução',
            'Pergunte: "Lembra-se das 3 palavras que eu falei antes? Quais eram?" Marque cada palavra que o paciente lembrar CORRETAMENTE, sem dar pistas.',
          ),
          _buildCheckboxItem('Recordação Palavra 1', _data.recordacao1, (val) => setState(() => _data.recordacao1 = val), instruction: 'Marque se o paciente lembrou da primeira palavra'),
          _buildCheckboxItem('Recordação Palavra 2', _data.recordacao2, (val) => setState(() => _data.recordacao2 = val), instruction: 'Marque se o paciente lembrou da segunda palavra'),
          _buildCheckboxItem('Recordação Palavra 3', _data.recordacao3, (val) => setState(() => _data.recordacao3 = val), instruction: 'Marque se o paciente lembrou da terceira palavra'),
          const SizedBox(height: 12),
          const Text('6. Linguagem - Nomeação (2 pontos)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          _buildInstructionCard(
            'Instrução',
            'Mostre um LÁPIS e um RELÓGIO (ou objetos similares). Pergunte: "O que é isto?" Aceite o nome comum do objeto. Marque apenas se nomear CORRETAMENTE.',
          ),
          _buildCheckboxItem('Lápis', _data.lapis, (val) => setState(() => _data.lapis = val), instruction: 'Paciente nomeou o lápis corretamente'),
          _buildCheckboxItem('Relógio', _data.relogio, (val) => setState(() => _data.relogio = val), instruction: 'Paciente nomeou o relógio corretamente'),
          const SizedBox(height: 12),
          const Text('7. Linguagem - Outros (6 pontos)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          _buildInstructionCard(
            'Instrução',
            'Aplique cada tarefa conforme descrito. Marque apenas quando completar CORRETAMENTE.',
          ),
          _buildCheckboxItem('Repetição', _data.repeticao, (val) => setState(() => _data.repeticao = val), instruction: 'Diga: "Repita esta frase: NEM AQUI, NEM LÁ, NEM EM LUGAR NENHUM". Marque se repetir sem erros.'),
          _buildCheckboxItem('Comando 1', _data.comando1, (val) => setState(() => _data.comando1 = val), instruction: 'Diga: "Pegue este papel com a mão direita". Marque se executar corretamente.'),
          _buildCheckboxItem('Comando 2', _data.comando2, (val) => setState(() => _data.comando2 = val), instruction: 'Diga: "Dobre o papel ao meio". Marque se executar corretamente.'),
          _buildCheckboxItem('Comando 3', _data.comando3, (val) => setState(() => _data.comando3 = val), instruction: 'Diga: "Coloque o papel no chão". Marque se executar corretamente.'),
          _buildCheckboxItem('Leitura', _data.leitura, (val) => setState(() => _data.leitura = val), instruction: 'Mostre um papel escrito: "FECHE OS OLHOS". Marque se ler corretamente.'),
          _buildCheckboxItem('Escrita', _data.escrita, (val) => setState(() => _data.escrita = val), instruction: 'Diga: "Escreva uma frase completa". Marque se escrever uma frase com sujeito e verbo.'),
          _buildCheckboxItem('Desenho', _data.desenho, (val) => setState(() => _data.desenho = val), instruction: 'Diga: "Copie este desenho" (mostre dois pentágonos entrelaçados). Marque se copiar com pelo menos 10 ângulos corretos e 2 interseções.'),
          const SizedBox(height: 16),
          Card(
            color: score >= 24 ? Colors.green : score >= 18 ? Colors.orange : Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('MMSE Score Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('$score/30', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(_data.interpretation, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              await _salvarMMSE();
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala MMSE'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
