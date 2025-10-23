# 🌊 EscutaD'Agua - Sistema de Monitoramento Inteligente de Água

![Flutter](https://img.shields.io/badge/Flutter-3.9.0-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.9.0-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey)

## 📋 Sobre o Projeto

**EscutaD'Agua** é um aplicativo móvel desenvolvido em Flutter que utiliza Inteligência Artificial para detectar e monitorar o consumo de água em tempo real através da análise de áudio. O sistema identifica padrões sonoros relacionados ao uso de água (chuveiro, torneira, vazamentos) e fornece insights sobre o consumo, ajudando usuários a economizar água e reduzir desperdícios.

### 🎯 Objetivos

- Monitorar o consumo de água em tempo real através de detecção de áudio
- Classificar eventos de uso de água (chuveiro, torneira, vazamento)
- Fornecer estatísticas e histórico de consumo
- Alertar sobre possíveis desperdícios
- Integrar com API backend para armazenamento de dados

---

## 🏗️ Arquitetura e Qualidade de Software

### 📊 Critérios de Qualidade Implementados

#### 1. **Legibilidade** ✅
- **Nomenclatura clara e descritiva**: Todas as classes, métodos e variáveis seguem convenções Dart
- **Comentários explicativos**: Código documentado com comentários onde necessário
- **Formatação consistente**: Uso de `dart format` para padronização
- **Organização lógica**: Estrutura de pastas intuitiva (`lib/models/`, `lib/services/`, `lib/screens/`)

#### 2. **Simplicidade** ✅
- **Código direto e objetivo**: Evita complexidade desnecessária
- **Funções pequenas e focadas**: Cada função tem responsabilidade única
- **Evita redundâncias**: Reutilização de componentes e widgets

#### 3. **Modularidade** ✅
- **Separação de responsabilidades**: Services isolados (API, Detecção, etc.)
- **Componentes reutilizáveis**: Widgets customizados em `lib/components/`
- **Baixo acoplamento**: Serviços independentes comunicam-se via interfaces

#### 4. **Confiabilidade** ✅
- **Tratamento de erros**: Try-catch em operações críticas
- **Validação de entrada**: Verificação de permissões e estados
- **Logs informativos**: Console logs para debugging
- **Testes de conexão**: Verificação de status da API

---

## 🚀 Tecnologias Utilizadas

### Core Framework
- **Flutter SDK**: ^3.9.0
- **Dart**: ^3.9.0

### Dependências Principais

| Pacote | Versão | Propósito |
|--------|--------|-----------|
| `tflite_flutter` | ^0.11.0 | Execução do modelo TensorFlow Lite |
| `record` | ^6.1.2 | Captura de áudio em tempo real |
| `http` | ^1.2.2 | Comunicação com API REST |
| `wav` | ^1.4.0 | Processamento de arquivos de áudio |
| `path_provider` | ^2.1.3 | Gerenciamento de arquivos temporários |
| `intl` | ^0.19.0 | Formatação de datas e localização |
| `provider` | ^6.1.2 | Gerenciamento de estado |

### Arquitetura

```
lib/
├── main.dart                 # Ponto de entrada do app
├── models/                   # Modelos de dados
│   ├── enums.dart           # Enumerações (TipoEvento, etc.)
│   ├── alerta.dart
│   ├── consumo_agua.dart
│   └── usuario.dart
├── services/                 # Camada de serviços
│   ├── detection_service.dart    # Detecção de áudio + ML
│   └── api_service.dart          # Comunicação com backend
├── screens/                  # Telas da aplicação
│   ├── home/
│   │   └── home_screen.dart
│   └── ...
├── components/              # Componentes reutilizáveis
│   └── info_card.dart
└── navigation/              # Navegação e roteamento
    └── navbar.dart
```

---

## 📦 Instalação e Configuração

### Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versão 3.9.0+)
- [Android Studio](https://developer.android.com/studio) ou [Xcode](https://developer.apple.com/xcode/)
- Dispositivo físico ou emulador configurado
- Conexão com internet para instalar dependências

### Passo a Passo

1. **Clone o repositório**
```bash
git clone https://github.com/bealfredo/hackagua.git
cd hackagua/hackagua_flutter
```

2. **Instale as dependências**
```bash
flutter pub get
```

3. **Configure o backend (Opcional)**
   
   Edite o arquivo `lib/services/api_service.dart` e atualize o endereço da API:
   ```dart
   static const String baseUrl = 'http://SEU_IP:8081';
   ```

4. **Execute o aplicativo**
```bash
flutter run
```

### Configuração do Modelo TensorFlow Lite

⚠️ **Importante**: O modelo `.tflite` incluído no projeto requer compatibilidade com TensorFlow Lite v2.16.1.

Se você encontrar o erro:
```
Didn't find op for builtin opcode 'FULLY_CONNECTED' version '12'
```

**Solução**: Reconverta seu modelo usando TensorFlow compatível com a versão 2.16.1:
```python
import tensorflow as tf

converter = tf.lite.TFLiteConverter.from_saved_model('seu_modelo')
converter.target_spec.supported_ops = [
    tf.lite.OpsSet.TFLITE_BUILTINS,
]
tflite_model = converter.convert()

with open('classificador_agua_hackathon.tflite', 'wb') as f:
    f.write(tflite_model)
```

---

## 🎮 Funcionalidades

### ✨ Principais Recursos

- **🎤 Detecção de Áudio em Tempo Real**
  - Captura áudio a cada 5 segundos
  - Classificação usando modelo TensorFlow Lite
  - Detecção de: Chuveiro, Torneira, Vazamento, Silêncio

- **📊 Monitoramento de Consumo**
  - Dashboard com consumo diário
  - Progresso em relação à meta
  - Histórico de eventos detectados

- **🔔 Alertas Inteligentes**
  - Notificações sobre eventos detectados
  - Registro de duração de cada evento
  - Timestamp preciso

- **🌐 Integração com API**
  - Envio automático de eventos para backend
  - Sincronização de estatísticas
  - Indicador de status de conexão

### 🎯 Telas Principais

1. **Home Screen** - Dashboard principal com status de detecção
2. **Histórico** - Visualização de eventos passados
3. **Configurações** - Ajustes e metas de consumo

---

## 🔧 Configurações de Desenvolvimento

### Permissões Necessárias

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>NSMicrophoneUsageDescription</key>
<string>Este app precisa acessar o microfone para detectar sons de água</string>
```

### Build para Produção

**Android:**
```bash
flutter build apk --release
# ou
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

---

## 🧪 Testes

### Executar Testes
```bash
flutter test
```

### Cobertura de Código
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

---

## 🐛 Troubleshooting

### Problema: Erro do AudioRecorder
```
PlatformException(record, Recorder has not yet been created...)
```
**Solução**: O app agora inicializa o gravador corretamente com delay de 500ms.

### Problema: API não conecta
**Solução**: 
1. Verifique se o backend está rodando
2. Confirme o IP/porta em `api_service.dart`
3. Certifique-se de que o dispositivo está na mesma rede

### Problema: Modelo TFLite não carrega
**Solução**: Reconverta o modelo para TFLite v2.16.1 (veja seção acima)


---

## 👥 Contribuindo

Contribuições são bem-vindas! Para contribuir:

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

### Padrões de Código

- Siga as [Dart Style Guidelines](https://dart.dev/guides/language/effective-dart/style)
- Execute `dart format .` antes de commitar
- Execute `dart analyze` para verificar problemas
- Escreva testes para novas funcionalidades

---

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

## 📞 Contato

**Equipe EscutaD'Agua**
- GitHub: [@bealfredo](https://github.com/bealfredo)
- Repositório: [hackagua](https://github.com/bealfredo/hackagua)

---

## 🙏 Agradecimentos

- Comunidade Flutter pela excelente documentação
- TensorFlow Lite pela framework de ML mobile
- Todos os contribuidores e testadores do projeto

---

**Desenvolvido com 💙 pela equipe EscutaD'Agua**

Importante: A URL base da API (_baseUrl) está definida em cada arquivo dentro da pasta lib/services/. Você deve atualizar esta URL para apontar para o seu servidor.

lib/services/auth_service.dart

lib/services/consumo_service.dart

lib/services/config_service.dart

lib/services/alerta_service.dart

lib/services/device_service.dart

lib/services/usuario_service.dart

Exemplo de alteração:

Dart

// Altere esta linha nos arquivos de serviço relevantes:
final String _baseUrl = "http://SUA_API_AQUI";
Para testar com um servidor local (localhost) no Emulador Android: Use o IP http://10.0.2.2:PORTA (onde PORTA é a porta do seu backend, ex: 8080).

Para testar com servidor local no Emulador iOS ou Dispositivo Físico (mesma rede Wi-Fi): Use o IP da sua máquina na rede local (ex: http://192.168.1.5:PORTA).

5. Configurar Permissões Nativas
O app requer permissões de Câmera (QR Code) e Microfone (Detecção de som). Elas já devem estar configuradas, mas verifique:

Para iOS (ios/Runner/Info.plist): Deve conter as chaves NSCameraUsageDescription e NSMicrophoneUsageDescription.

Para Android (android/app/src/main/AndroidManifest.xml): Deve conter as permissões <uses-permission android:name="android.permission.CAMERA" /> e <uses-permission android:name="android.permission.RECORD_AUDIO" />.

Para Android (android/app/build.gradle ou build.gradle.kts): O minSdkVersion deve ser 21 ou superior (verificado anteriormente).

6. Modelo TFLite e Labels
Certifique-se de que os arquivos do modelo TensorFlow Lite e seus rótulos estejam presentes na pasta assets/tflite/:

classificador_agua_hackathon.tflite

labels.json

7. Rodar o Aplicativo
Após instalar as dependências e verificar as configurações, você pode rodar o app:

Bash

flutter run
Observação: Pode ser necessário rodar flutter clean antes de flutter run se encontrar problemas de build após atualizações.

Estrutura do Projeto (Modularidade) 


O projeto segue uma arquitetura com separação de responsabilidades para facilitar a manutenção:

lib/models/: Contém as classes que definem a estrutura dos dados (ex: Usuario, Alerta, Configuracoes).

lib/services/: Contém a lógica de negócios, incluindo a comunicação com a API (ex: AuthService, AlertaService) e o processamento local (ex: DetectionService).

lib/screens/: Contém as telas (Widgets) responsáveis pela interface do usuário (UI).

Observações Importantes 

Simulação de API: Vários serviços (ConfigService, ConsumoService, AlertaService, UsuarioService) contêm dados simulados (mock) para permitir o desenvolvimento da UI sem um backend ativo. O código para chamadas reais (http.get, http.put) está comentado nesses arquivos e precisa ser habilitado/ajustado para produção.

Erro Conhecido - Modelo TFLite: Atualmente, há um erro em tempo de execução ao carregar o modelo TFLite (Invalid argument(s): Unable to create interpreter). Isso ocorre porque o arquivo classificador_agua_hackathon.tflite utiliza uma versão da operação FULLY_CONNECTED (v12) que não é suportada pelo runtime TFLite do plugin tflite_flutter.

Solução Necessária: É preciso re-converter o modelo .tflite usando o TensorFlow Lite Converter, especificando opções de compatibilidade para gerar um modelo que use operações/versões suportadas pelo runtime do plugin. Substitua o arquivo em assets/tflite/ pelo modelo re-convertido.

Tratamento de Token: A lógica para armazenar e enviar o token de autenticação JWT (obtido no login) nas chamadas subsequentes da API (Authorization: Bearer <token>) precisa ser implementada nos serviços (marcado com // TODO:).
rea

