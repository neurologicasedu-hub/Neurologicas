# Briefing de Design: NeuroCalculator (MindCerto)

## 📌 Visão Geral do Produto
O **NeuroCalculator** é uma aplicação móvel especializada desenvolvida para neurologistas, neurocirurgiões, residentes e profissionais de saúde. O objetivo principal é consolidar mais de 90 escalas clínicas e calculadoras neurológicas em uma única ferramenta rápida e confiável, auxiliando no diagnóstico, prognóstico e acompanhamento de pacientes.

## 👥 Público-Alvo
- **Primário:** Neurologistas e Neurocirurgiões.
- **Secundário:** Residentes de Medicina, Enfermeiros Especialistas, Estudantes de Medicina.
- **Contexto de Uso:** Hospitais, Clínicas, Prontos-Socorros e UTI. O uso é frequentemente rápido, ao lado do leito do paciente.

## 🚀 Principais Funcionalidades

### 1. Biblioteca de Calculadoras (+90 Escalas)
O coração do aplicativo. As escalas são divididas em categorias lógicas:
- **Vascular (AVC):** NIHSS, ASPECTs, CHA2DS2-VASc, HAS-BLED, ICH Score, etc.
- **Cognitivo/Demência:** MoCA, MMSE, ACE-III, Nitrini (Sugerida), CDR.
- **Distúrbios do Movimento:** UPDRS, Hoehn & Yahr.
- **Neuroimunologia/Esclerose Múltipla:** EDSS.
- **Neuromuscular:** MGFA, QMG.
- **Sono:** ESS, PSQI.
- **Cefaleia:** MIDAS, HIT-6.
- **Urgência/UTI:** Glasgow, Apache II, Pressão Intracraniana.

### 2. Gestão de Pacientes
- Cadastro de pacientes (Nome, Data de Nascimento, Prontuário, etc.).
- Histórico de avaliações: Salvar resultados de escalas diretamente no perfil do paciente.
- Acompanhamento evolutivo.

### 3. Geração de Relatórios
- Geração automática de relatórios em PDF.
- Compilação dos dados do paciente e resultados das escalas aplicadas.
- Design precisa ser sóbrio e oficial para anexar a prontuários.

### 4. Sistema de Assinatura (Premium)
- Controle de acesso a funcionalidades avançadas e escalas complexas.
- Verificação de status de assinatura (Free vs Premium).

## 📱 Telas Principais para Design

### A. Login e Onboarding
- Tela de entrada limpa e segura.
- Design que transmita confiança e profissionalismo médico.

### B. Tela Inicial (Dashboard)
- Acesso rápido à **Lista de Pacientes**.
- **Busca Global**: O usuário precisa encontrar "NIHSS" ou "MoCA" em segundos.
- Navegação por categorias (ex: ícones ou cards para "Vascular", "Cognitivo").

### C. Interface da Calculadora (Crítico)
Esta é a tela mais usada.
- **Ergonomia:** Botões grandes e fáceis de tocar (uso com uma mão).
- **Clareza:** Perguntas e opções de resposta legíveis.
- **Feedback Imediato:** O score total deve atualizar em tempo real conforme as opções são marcadas.
- **Interpretação:** Mostrar o significado do resultado (ex: "Resultado: 25/30 - Normal").
- **Inputs Variados:** Radio buttons, Sliders, Checkboxes e Inputs numéricos. Algumas escalas (como MoCA) podem ter interações mais complexas (desenho, cronômetro).

### D. Lista e Perfil do Paciente
- Lista com busca fácil.
- Perfil mostrando dados demográficos e lista cronológica de avaliações realizadas.

### E. Tela de Relatório/Resultado
- Visualização resumo do que será gerado no PDF.
- Botões de ação claros: "Salvar", "Gerar PDF", "Compartilhar".

## 🎨 Diretrizes de Design (Look & Feel)

- **Estilo Sábio e Clínico:** Evitar "gamificação" excessiva. O app é uma ferramenta de trabalho séria.
- **Cores:** Atualmente o código base usa `Colors.blue`. Sugere-se uma paleta médica moderna:
  - Tons de Azul Profundo (Confiança, Saúde).
  - Azul Petróleo/Teal (Cirúrgico, Higiene).
  - Cinzas Neutros e Branco (Clean, Leitura fácil).
  - Cores de Alerta (Vermelho/Laranja) para resultados críticos ou avisos.
- **Tipografia:** Sans-serif moderna, legível em tamanhos pequenos. Alto contraste é essencial para ambientes hospitalares (que podem ser muito claros ou mal iluminados).
- **Minimalismo:** Reduzir ruído visual. O foco é a informação clínica.

## 🛠️ Contexto Técnico
- **Plataforma:** Flutter (Android, iOS e Web).
- **Base de Design:** Material Design (pode ser customizado, mas segue grid e comportamentos mobile padrão).
- **Performance:** O app deve parecer instantâneo. Animações devem ser rápidas e sutis.
