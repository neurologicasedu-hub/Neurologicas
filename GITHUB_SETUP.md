# Como enviar o projeto para o GitHub

## Passo a Passo

### 1. Criar o repositório no GitHub

1. Acesse https://github.com
2. Clique no botão **"+"** no canto superior direito
3. Selecione **"New repository"**
4. Preencha:
   - **Repository name**: `neuro-calculator` (ou outro nome de sua escolha)
   - **Description**: "Aplicativo Flutter para cálculo de scores neurológicos (NIHSS e Glasgow Coma Scale)"
   - Marque **"Public"** ou **"Private"**
   - NÃO marque "Add a README file" (já temos um)
   - NÃO adicione .gitignore (já temos um)
   - NÃO escolha uma licença ainda
5. Clique em **"Create repository"**

### 2. No terminal do VS Code (na pasta do projeto)

Execute os seguintes comandos **UM POR VEZ**:

```bash
# Inicializar o Git no projeto
git init

# Adicionar todos os arquivos
git add .

# Fazer o primeiro commit
git commit -m "Initial commit: Calculadora Neurológica - NIHSS e Glasgow"

# Adicionar o repositório remoto do GitHub
git remote add origin https://github.com/mariaisabelaacd-ui/MentalScales

# Mudar para o branch main
git branch -M main

# Enviar para o GitHub
git push -u origin main
```

**⚠️ IMPORTANTE**: Substitua `SEU_USUARIO` pelo seu nome de usuário do GitHub!

### 3. Autenticação

Quando executar `git push`, o GitHub pode solicitar autenticação:
- Digite seu **username** do GitHub
- Digite um **Personal Access Token** (não a senha)

**Para criar um Personal Access Token:**
1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Clique em "Generate new token (classic)"
.gits: read:repo, read:user, user:email
4. Clique em "Generate token"
5. Copie o token e use como senha

### 4. Verificar

Acesse o repositório no GitHub e confirme se todos os arquivos foram enviados.

## Comandos Úteis

```bash
# Ver status dos arquivos
git status

# Ver histórico de commits
git log

# Adicionar arquivos modificados
git add .

# Fazer commit
git commit -m "Descrição das mudanças"

# Enviar para o GitHub
git push
```

## Estrutura que será enviada

✅ README.md (documentação completa)
✅ lib/ (todo o código fonte)
✅ test/ (testes)
✅ pubspec.yaml (dependências)
✅ android/ (configuração Android)
✅ ios/ (configuração iOS)
✅ .gitignore (arquivos ignorados)

❌ build/ (será ignorado)
❌ .dart_tool/ (será ignorado)
❌ local.properties (será ignorado)

## Pronto!

Seu projeto estará disponível em: `https://github.com/SEU_USUARIO/neuro-calculator`

