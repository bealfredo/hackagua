# Escuta d'Água (App Flutter)

Este é o repositório do aplicativo móvel (Flutter) do projeto Escuta d'Água. O aplicativo funciona como o "controlador" do ecossistema, permitindo que o usuário monitore seu consumo de água, receba alertas, configure metas e gerencie os dispositivos "escutadores".

[cite_start]O projeto foi desenvolvido buscando seguir critérios de **Legibilidade** [cite: 2, 3, 4][cite_start], **Simplicidade** [cite: 5, 6][cite_start], **Modularidade** [cite: 7, 8] [cite_start]e **Confiabilidade**[cite: 9, 10].

## [cite_start]Versão do Software 

* **Versão do App:** 1.0.0+1 (Conforme `pubspec.yaml`)

## [cite_start]Tecnologias Utilizadas 

* **Flutter (SDK ^3.9.0):** Framework principal para o desenvolvimento multiplataforma.
* **Dart:** Linguagem de programação.
* **http:** Pacote para realizar a comunicação com a API REST (fazer login, buscar e salvar dados).
* **intl:** Para formatação de datas e horas.
* **fl_chart:** Para a criação dos gráficos de consumo na tela de Histórico.
* **mobile_scanner:** Para a funcionalidade de leitura de QR Code na adição de novos dispositivos.
* **record:** Para a captura de áudio em tempo real.
* **tflite_flutter:** Para executar o modelo de classificação de áudio (`.tflite`) localmente no dispositivo.
* **wav:** Para processar os arquivos de áudio temporários (`.wav`).
* **path_provider:** Para gerenciar o diretório temporário onde o áudio é processado.
* **provider:** (Opcional, listado no `pubspec.yaml`, mas não usado extensivamente nos exemplos fornecidos - pode ser removido se não for usado).
* **hive / hive_flutter:** (Opcional, listado no `pubspec.yaml` - pode ser usado para armazenamento local, mas não foi implementado nos exemplos).
* **image_picker:** (Opcional, listado no `pubspec.yaml` - provavelmente para a foto do usuário, não implementado nos exemplos).

## [cite_start]Instruções para Rodar o Projeto 

Siga estes passos para configurar e executar o projeto em sua máquina local.

### 1. Pré-requisitos

* [Flutter SDK](https://docs.flutter.dev/get-started/install) (versão 3.9.0 ou superior compatível)
* [Android Studio](https://developer.android.com/studio) (para o emulador Android e build tools) ou [Xcode](https://developer.apple.com/xcode/) (para o simulador iOS)
* Um editor de código (como VS Code).
* Um dispositivo físico ou emulador/simulador configurado.

### 2. Clonar o Repositório

```bash
git clone <URL_DO_SEU_REPOSITORIO>
cd hackagua_flutter
3. Instalar Dependências
Rode o comando a seguir na raiz do projeto para baixar todos os pacotes listados no pubspec.yaml:

Bash

flutter pub get
4. Configurar o Backend (API)
O aplicativo precisa se conectar a um servidor de backend para autenticação e busca/salvamento de dados.

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

Formas de Contribuição 

(Opcional: Adicione aqui como outros podem contribuir, ex: Padrão de branches, como abrir Pull Requests, etc.)


---

Este `README.md` aborda todos os pontos solicitados no critério 5, incluindo a descrição