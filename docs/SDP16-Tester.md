**AC – Testador SDP16**

**Paço a paço Testador SDP16**

**Versão 1.0**

**Histórico de revisões**

| **Data** | **Versão** | **Descrição** | **Autor** |
| --- | --- | --- | --- |
| 16/11/2021 | 1.0 | Versão inicial | José Filipe Cruz dos Santos |


**Tabela de conteúdos**

1.Teste físico de hardware 4

2.Testes de manipulação de memória 4

3.Conexão com a placa de teste 4

4.Código de teste 4

4.1Carregar código na placa 4

4.2Correr o código na placa 4

**Paço a paço Testador SDP16**

1. **Teste físico de hardware**
2. **Testes de manipulação de memória**
3. **Conexão com a placa de teste**
4. **Código de teste**
  1. **Carregar código na placa**
  2. **Correr o código na placa**
5. **Teste de IO**

  1. **Output.S**

Passos:

Passo 1 – Compilar e carregar o código associado ao ficheiro output.S

Passo 2 – Colocar um breakpoint no endereço 0x001A e correr o código

Observações:

Devera-se observar os leds a acender sequencialmente cada Continue.

  1. **Out\_in.S**

Passos:

Passo 1 – Compilar e carregar o código associado ao ficheiro out\_in.S

Passo 2 – Colocar um breakpoint no endereço 0x000E e correr o código

Observações:

Devera-se obter como resultado da função _test\_in\_out_ o valor de retorno 1 no registo r0

  1. **In\_out.S**

Passos:

Passo 1 – Compilar e carregar o código associado ao ficheiro in\_out.S

Passo 2 – Correr o código

Passo 3 – Alterar os valores no input

Observações:

Devera-se observar os valores do output a alterar de acordo com os valores colocado no input

1. **Teste de memória**

Passos:

Passo 1 – Compilar e carregar o código associado ao ficheiro mem.S

Passo 2 – Colocar breakpoint nos endereços 0x001A e 0x400C

Observações:

Devera-se obter como resultado da função test\_in\_out o valor de retorno 1 no registo r0