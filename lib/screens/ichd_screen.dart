import 'package:flutter/material.dart';
import '../models/ichd_data.dart';
import '../services/patient_service.dart';
import '../models/completed_score.dart';

class ICHDScreen extends StatefulWidget {
  const ICHDScreen({super.key});

  @override
  State<ICHDScreen> createState() => _ICHDScreenState();
}

class _ICHDScreenState extends State<ICHDScreen> {
  final ICHD3Data _data = ICHD3Data();

  final List<Map<String, String>> _tiposCefaleia = [
    {'code': '1.1', 'name': '1.1 Migrânea sem aura'},
    {'code': '1.2', 'name': '1.2 Migrânea com aura'},
    {'code': '2.1', 'name': '2.1 Cefaleia tipo tensão episódica'},
    {'code': '2.3', 'name': '2.3 Cefaleia tipo tensão crônica'},
    {'code': '3.1', 'name': '3.1 Cefaleia em salvas'},
    {'code': '3.2', 'name': '3.2 Hemicrania paroxística'},
  ];

  final TextEditingController _duracaoAtaqueController = TextEditingController();
  final TextEditingController _duracaoAuraController = TextEditingController();
  final TextEditingController _duracaoEpisodioTensaoController = TextEditingController();
  final TextEditingController _duracaoAtaqueSalvasController = TextEditingController();
  final TextEditingController _duracaoAtaqueHemicraniaController = TextEditingController();

  @override
  void dispose() {
    _duracaoAtaqueController.dispose();
    _duracaoAuraController.dispose();
    _duracaoEpisodioTensaoController.dispose();
    _duracaoAtaqueSalvasController.dispose();
    _duracaoAtaqueHemicraniaController.dispose();
    super.dispose();
  }

  Future<void> _salvarICHD() async {
    try {
      final score = CompletedScore(
        scoreName: 'ICHD-3 - ${_data.classificacao}',
        scoreData: {'tipoCefaleia': _data.tipoCefaleia ?? ''},
        resultado: '${_data.classificacao} - ${_data.interpretation}',
        totalScore: 0,
      );
      
      await PatientService.saveCompletedScore(score);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Escala ICHD-3 salva com sucesso!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Ver Relatório',
              textColor: Colors.white,
              onPressed: () => Navigator.pushReplacementNamed(context, '/report'),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Widget _buildCriterioCard(String titulo, String descricao, bool preenchido, {Widget? child}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      color: preenchido ? Colors.green.shade50 : Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(preenchido ? Icons.check_circle : Icons.radio_button_unchecked, 
                  color: preenchido ? Colors.green : Colors.grey, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(titulo, style: TextStyle(
                    fontSize: 13, 
                    fontWeight: FontWeight.bold,
                    color: preenchido ? Colors.green.shade900 : Colors.grey.shade700,
                  )),
                ),
              ],
            ),
            if (descricao.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(descricao, style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
            ],
            if (child != null) ...[
              const SizedBox(height: 8),
              child,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMigraneaSemAura() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('1.1 Migrânea sem aura (ICHD-3)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildCriterioCard(
          'Critério A: Número de ataques',
          'Pelo menos 5 ataques preenchendo os critérios B-D',
          _data.numeroAtaquesMigranea >= 5,
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Número de ataques', border: OutlineInputBorder()),
            onChanged: (v) => setState(() => _data.numeroAtaquesMigranea = int.tryParse(v) ?? 0),
          ),
        ),
        _buildCriterioCard(
          'Critério B: Duração do ataque',
          '4-72 horas (sem tratamento ou com tratamento ineficaz)',
          _data.duracaoAtaque >= 4 && _data.duracaoAtaque <= 72,
          child: TextField(
            controller: _duracaoAtaqueController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Duração (horas)', hintText: 'Ex: 8', border: OutlineInputBorder()),
            onChanged: (v) => setState(() => _data.duracaoAtaque = int.tryParse(v) ?? 0),
          ),
        ),
        _buildCriterioCard(
          'Critério C: Características da cefaleia',
          'Pelo menos 2 das seguintes características',
          [
            _data.unilateral,
            _data.pulsatil,
            _data.intensidadeModeradaSevera,
            _data.agravaAtividade,
          ].where((c) => c).length >= 2,
          child: Column(
            children: [
              CheckboxListTile(title: const Text('Unilateral'), value: _data.unilateral, onChanged: (v) => setState(() => _data.unilateral = v ?? false), dense: true),
              CheckboxListTile(title: const Text('Pulsátil'), value: _data.pulsatil, onChanged: (v) => setState(() => _data.pulsatil = v ?? false), dense: true),
              CheckboxListTile(title: const Text('Intensidade moderada ou severa'), value: _data.intensidadeModeradaSevera, onChanged: (v) => setState(() => _data.intensidadeModeradaSevera = v ?? false), dense: true),
              CheckboxListTile(title: const Text('Agrava com atividade física de rotina'), value: _data.agravaAtividade, onChanged: (v) => setState(() => _data.agravaAtividade = v ?? false), dense: true),
            ],
          ),
        ),
        _buildCriterioCard(
          'Critério D: Durante o ataque',
          'Pelo menos 1 dos seguintes',
          _data.nauseaVomito || _data.fotofobiaFonofobia,
          child: Column(
            children: [
              CheckboxListTile(title: const Text('Náusea e/ou vômito'), value: _data.nauseaVomito, onChanged: (v) => setState(() => _data.nauseaVomito = v ?? false), dense: true),
              CheckboxListTile(title: const Text('Fotofobia e fonofobia'), value: _data.fotofobiaFonofobia, onChanged: (v) => setState(() => _data.fotofobiaFonofobia = v ?? false), dense: true),
            ],
          ),
        ),
        _buildCriterioCard('Critério E: Não atribuída a outro transtorno', 'Não melhor explicada por outro diagnóstico ICHD-3', true),
      ],
    );
  }

  Widget _buildMigraneaComAura() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('1.2 Migrânea com aura (ICHD-3)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildCriterioCard(
          'Critério A: Número de ataques',
          'Pelo menos 2 ataques',
          _data.numeroAtaquesMigraneaAura >= 2,
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Número de ataques', border: OutlineInputBorder()),
            onChanged: (v) => setState(() => _data.numeroAtaquesMigraneaAura = int.tryParse(v) ?? 0),
          ),
        ),
        _buildCriterioCard(
          'Critério B: Tipo de aura',
          'Aura visual, sensorial, disfásica, motora, tronco encefálico ou retiniana',
          _data.tipoAura != null && _data.tipoAura!.isNotEmpty,
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Tipo de aura', border: OutlineInputBorder()),
            items: ['Visual', 'Sensorial', 'Disfásica', 'Motora', 'Tronco encefálico', 'Retiniana'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
            onChanged: (v) => setState(() => _data.tipoAura = v),
          ),
        ),
        _buildCriterioCard(
          'Critério C: Características da aura',
          'Todas as seguintes características',
          _data.duracaoAura >= 5 && _data.duracaoAura <= 60 && _data.auraExpandida && _data.auraUnilateral,
          child: Column(
            children: [
              TextField(
                controller: _duracaoAuraController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Duração do sintoma (5-60 min)', border: OutlineInputBorder()),
                onChanged: (v) => setState(() => _data.duracaoAura = int.tryParse(v) ?? 0),
              ),
              const SizedBox(height: 8),
              CheckboxListTile(title: const Text('Sintomas se expandem gradualmente'), value: _data.auraExpandida, onChanged: (v) => setState(() => _data.auraExpandida = v ?? false), dense: true),
              CheckboxListTile(title: const Text('Sintomas unilaterais'), value: _data.auraUnilateral, onChanged: (v) => setState(() => _data.auraUnilateral = v ?? false), dense: true),
              CheckboxListTile(title: const Text('Sintomas positivos (p.ex., escotoma cintilante)'), value: _data.auraPositiva, onChanged: (v) => setState(() => _data.auraPositiva = v ?? false), dense: true),
            ],
          ),
        ),
        _buildCriterioCard(
          'Critério D: Relação com cefaleia',
          'Aura ocorre durante ou antes da cefaleia',
          _data.auraAntesCefaleia,
          child: CheckboxListTile(title: const Text('Aura ocorre durante ou antes da cefaleia'), value: _data.auraAntesCefaleia, onChanged: (v) => setState(() => _data.auraAntesCefaleia = v ?? false)),
        ),
      ],
    );
  }

  Widget _buildTensaoEpisodica() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('2.1 Cefaleia tipo tensão episódica (ICHD-3)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildCriterioCard(
          'Critério A: Frequência',
          'Pelo menos 10 episódios',
          _data.numeroEpisodiosTensao >= 10,
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Número de episódios', border: OutlineInputBorder()),
            onChanged: (v) => setState(() => _data.numeroEpisodiosTensao = int.tryParse(v) ?? 0),
          ),
        ),
        _buildCriterioCard(
          'Critério B: Duração',
          '30 minutos a 7 dias',
          _data.duracaoEpisodioTensao >= 30 && _data.duracaoEpisodioTensao <= (7 * 24 * 60),
          child: TextField(
            controller: _duracaoEpisodioTensaoController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Duração (minutos)', hintText: 'Ex: 120', border: OutlineInputBorder()),
            onChanged: (v) => setState(() => _data.duracaoEpisodioTensao = int.tryParse(v) ?? 0),
          ),
        ),
        _buildCriterioCard(
          'Critério C: Características',
          'Pelo menos 2 das seguintes características',
          _data.tensaoBilateral && _data.tensaoPressao && _data.tensaoIntensidadeLeveModerada && _data.tensaoNaoAgravaAtividade,
          child: Column(
            children: [
              CheckboxListTile(title: const Text('Bilateral'), value: _data.tensaoBilateral, onChanged: (v) => setState(() => _data.tensaoBilateral = v ?? false), dense: true),
              CheckboxListTile(title: const Text('Qualidade de pressão/aperto (não pulsátil)'), value: _data.tensaoPressao, onChanged: (v) => setState(() => _data.tensaoPressao = v ?? false), dense: true),
              CheckboxListTile(title: const Text('Intensidade leve a moderada'), value: _data.tensaoIntensidadeLeveModerada, onChanged: (v) => setState(() => _data.tensaoIntensidadeLeveModerada = v ?? false), dense: true),
              CheckboxListTile(title: const Text('Não agrava com atividade física de rotina'), value: _data.tensaoNaoAgravaAtividade, onChanged: (v) => setState(() => _data.tensaoNaoAgravaAtividade = v ?? false), dense: true),
            ],
          ),
        ),
        _buildCriterioCard(
          'Critério D: Ausência de sintomas',
          'Ambos ausentes',
          _data.tensaoNaoNausea && _data.tensaoNaoFotofonia,
          child: Column(
            children: [
              CheckboxListTile(title: const Text('Ausência de náusea ou vômito'), value: _data.tensaoNaoNausea, onChanged: (v) => setState(() => _data.tensaoNaoNausea = v ?? false), dense: true),
              CheckboxListTile(title: const Text('Não fotofobia e fonofobia (ou apenas uma)'), value: _data.tensaoNaoFotofonia, onChanged: (v) => setState(() => _data.tensaoNaoFotofonia = v ?? false), dense: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSalvas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('3.1 Cefaleia em salvas (ICHD-3)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildCriterioCard(
          'Critério A: Número de ataques',
          'Pelo menos 5 ataques',
          _data.numeroAtaquesSalvas >= 5,
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Número de ataques', border: OutlineInputBorder()),
            onChanged: (v) => setState(() => _data.numeroAtaquesSalvas = int.tryParse(v) ?? 0),
          ),
        ),
        _buildCriterioCard(
          'Critério B: Duração e frequência',
          'Duração: 15-180 min. Frequência: de 1/2 dias a 8/dia',
          _data.duracaoAtaqueSalvas >= 15 && _data.duracaoAtaqueSalvas <= 180 && _data.frequenciaSalvas >= 1,
          child: Column(
            children: [
              TextField(
                controller: _duracaoAtaqueSalvasController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Duração (minutos)', hintText: '15-180', border: OutlineInputBorder()),
                onChanged: (v) => setState(() => _data.duracaoAtaqueSalvas = int.tryParse(v) ?? 0),
              ),
              const SizedBox(height: 8),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Frequência (ataques/dia)', hintText: '1-8', border: OutlineInputBorder()),
                onChanged: (v) => setState(() => _data.frequenciaSalvas = int.tryParse(v) ?? 0),
              ),
            ],
          ),
        ),
        _buildCriterioCard(
          'Critério C: Características da cefaleia',
          'Ambas presentes',
          _data.salvasUnilateral && _data.salvasSeveraMuitoSevera,
          child: Column(
            children: [
              CheckboxListTile(title: const Text('Unilateral (órbita, supra-orbital e/ou temporal)'), value: _data.salvasUnilateral, onChanged: (v) => setState(() => _data.salvasUnilateral = v ?? false), dense: true),
              CheckboxListTile(title: const Text('Severa ou muito severa'), value: _data.salvasSeveraMuitoSevera, onChanged: (v) => setState(() => _data.salvasSeveraMuitoSevera = v ?? false), dense: true),
            ],
          ),
        ),
        _buildCriterioCard(
          'Critério D: Sintomas associados',
          'Pelo menos 1 sintoma autonômico ipsilateral e/ou agitação',
          _data.salvasAgitacao && _data.salvasSintomasAutonomicos,
          child: Column(
            children: [
              CheckboxListTile(title: const Text('Agitação ou inquietação'), value: _data.salvasAgitacao, onChanged: (v) => setState(() => _data.salvasAgitacao = v ?? false), dense: true),
              const Text('Sintomas autonômicos ipsilaterais:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              CheckboxListTile(title: const Text('Rinorreia e/ou obstrução nasal'), value: _data.salvasRinorreia || _data.salvasObstrucaoNasal, onChanged: (v) => setState(() {
                if (v == true) {
                  _data.salvasRinorreia = true;
                  _data.salvasSintomasAutonomicos = true;
                }
              }), dense: true),
              CheckboxListTile(title: const Text('Ptose e/ou miose'), value: _data.salvasPtose, onChanged: (v) => setState(() {
                _data.salvasPtose = v ?? false;
                _data.salvasSintomasAutonomicos = _data.salvasRinorreia || _data.salvasObstrucaoNasal || _data.salvasLacrimejamento || _data.salvasPtose;
              }), dense: true),
              CheckboxListTile(title: const Text('Lacrimejamento'), value: _data.salvasLacrimejamento, onChanged: (v) => setState(() {
                _data.salvasLacrimejamento = v ?? false;
                _data.salvasSintomasAutonomicos = _data.salvasRinorreia || _data.salvasObstrucaoNasal || _data.salvasLacrimejamento || _data.salvasPtose;
              }), dense: true),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ICHD-3'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            color: Colors.blueGrey.shade50,
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ICHD-3 - Classificação Internacional de Cefaleias (3ª Edição)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text(
                    'Baseado na documentação oficial da International Headache Society (IHS).\n'
                    'Selecione o tipo de cefaleia para verificar os critérios diagnósticos.',
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Selecione o tipo de cefaleia:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Tipo de cefaleia'),
                    items: _tiposCefaleia.map((t) => DropdownMenuItem(value: t['code'], child: Text(t['name']!))).toList(),
                    onChanged: (v) => setState(() => _data.tipoCefaleia = v),
                  ),
                ],
              ),
            ),
          ),
          if (_data.tipoCefaleia != null && _data.tipoCefaleia!.isNotEmpty) ...[
            const SizedBox(height: 16),
            if (_data.tipoCefaleia == '1.1') _buildMigraneaSemAura(),
            if (_data.tipoCefaleia == '1.2') _buildMigraneaComAura(),
            if (_data.tipoCefaleia == '2.1') _buildTensaoEpisodica(),
            if (_data.tipoCefaleia == '3.1') _buildSalvas(),
            const SizedBox(height: 16),
            Card(
              color: _data.interpretation.contains('✓') ? Colors.green : Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text('Resultado ICHD-3', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 12),
                    Text(_data.classificacao, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white), textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    Text(_data.interpretation, style: const TextStyle(fontSize: 12, color: Colors.white70), textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _salvarICHD,
            icon: const Icon(Icons.save),
            label: const Text('Salvar Escala ICHD-3'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Voltar'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
  }
}
