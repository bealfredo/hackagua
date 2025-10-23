"""
Script simplificado para reconverter modelo TFLite
Arrastar e soltar o arquivo .h5 sobre este script
"""

import sys
import os
import tensorflow as tf
import numpy as np

def convert_model(model_path):
    """Converte modelo com configurações de compatibilidade"""
    
    print("=" * 60)
    print(f"Convertendo: {model_path}")
    print("=" * 60)
    
    # Carregar modelo
    print("\n1. Carregando modelo...")
    model = tf.keras.models.load_model(model_path)
    print("   ✓ Modelo carregado")
    
    # Mostrar informações do modelo
    print("\n2. Informações do modelo:")
    model.summary()
    
    # Configurar conversor com opções de compatibilidade
    print("\n3. Configurando conversor TFLite...")
    converter = tf.lite.TFLiteConverter.from_keras_model(model)
    
    # CONFIGURAÇÕES CRUCIAIS PARA COMPATIBILIDADE
    converter.optimizations = [tf.lite.Optimize.DEFAULT]
    converter.target_spec.supported_ops = [
        tf.lite.OpsSet.TFLITE_BUILTINS,  # Apenas operações built-in
    ]
    converter.experimental_new_converter = True
    
    # Configurações adicionais para melhor compatibilidade
    converter.target_spec.supported_types = [tf.float32]
    
    print("   ✓ Configurações aplicadas:")
    print("     - Otimização: DEFAULT")
    print("     - Operações: TFLITE_BUILTINS apenas")
    print("     - Tipo: float32")
    
    # Converter
    print("\n4. Convertendo modelo...")
    tflite_model = converter.convert()
    print(f"   ✓ Conversão concluída ({len(tflite_model) / 1024:.2f} KB)")
    
    # Criar diretório de saída
    output_dir = os.path.join(os.path.dirname(__file__), 'assets', 'tflite')
    os.makedirs(output_dir, exist_ok=True)
    
    # Salvar modelo
    output_path = os.path.join(output_dir, 'classificador_agua_hackathon.tflite')
    print(f"\n5. Salvando modelo em: {output_path}")
    
    with open(output_path, 'wb') as f:
        f.write(tflite_model)
    
    print("   ✓ Modelo salvo")
    
    # Verificar modelo
    print("\n6. Verificando modelo...")
    interpreter = tf.lite.Interpreter(model_path=output_path)
    interpreter.allocate_tensors()
    
    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()
    
    print("\n   Entrada:")
    for i, detail in enumerate(input_details):
        print(f"     [{i}] Shape: {detail['shape']}, Type: {detail['dtype'].__name__}")
    
    print("\n   Saída:")
    for i, detail in enumerate(output_details):
        print(f"     [{i}] Shape: {detail['shape']}, Type: {detail['dtype'].__name__}")
    
    # Teste rápido
    print("\n7. Teste rápido...")
    input_shape = input_details[0]['shape']
    test_data = np.array(np.random.random_sample(input_shape), dtype=np.float32)
    
    interpreter.set_tensor(input_details[0]['index'], test_data)
    interpreter.invoke()
    output = interpreter.get_tensor(output_details[0]['index'])
    
    print(f"   ✓ Teste bem-sucedido! Output shape: {output.shape}")
    
    print("\n" + "=" * 60)
    print("CONVERSÃO CONCLUÍDA COM SUCESSO!")
    print("=" * 60)
    print(f"\nArquivo gerado: {output_path}")
    print("\nPróximos passos:")
    print("1. flutter clean")
    print("2. flutter pub get")
    print("3. flutter run")
    
    return output_path

if __name__ == "__main__":
    print("\n🌊 Conversor de Modelo TFLite - HackAgua 🌊\n")
    
    # Verificar se foi passado um arquivo
    if len(sys.argv) > 1:
        model_path = sys.argv[1]
        if not os.path.exists(model_path):
            print(f"❌ Erro: Arquivo não encontrado: {model_path}")
            input("\nPressione Enter para sair...")
            sys.exit(1)
    else:
        # Solicitar caminho do arquivo
        model_path = input("Digite o caminho completo do modelo .h5: ").strip('"')
        
        if not model_path or not os.path.exists(model_path):
            print("❌ Erro: Arquivo não encontrado!")
            input("\nPressione Enter para sair...")
            sys.exit(1)
    
    try:
        convert_model(model_path)
        print("\n✅ Tudo pronto!")
        
    except Exception as e:
        print(f"\n❌ Erro durante a conversão:")
        print(f"   {type(e).__name__}: {str(e)}")
        print("\nVerifique se:")
        print("  - O arquivo é um modelo Keras válido (.h5)")
        print("  - O TensorFlow está instalado: pip install tensorflow")
        print("  - Você tem permissão para escrever na pasta assets/tflite/")
    
    input("\nPressione Enter para sair...")
