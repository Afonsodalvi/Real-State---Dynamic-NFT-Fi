# <h1 align="center">Real State - Dynamic NFT-Fi</h1>

**Já vi muitos projetos de tokenização imobiliária e uma das maiores discussões no tema envolve a regulação, sendo o ativo uma fração do imóvel, se será caracterizado como valor mobiliário ou não. Quis usar um pouco de criatividade e construí um projeto que ainda não vi no mercado, um protótipo de ideia que gostaria que analisassem e compartilhassem. 

O código tem muita coisa ainda que pode ser feita, até possibilidades de viabilidade jurídica é possível pensando na arquitetura dele. Se você é desenvolvedor, advogado ou empreendedor, fiquem à vontade para me chamar no direct para trocarmos ideia sobre o assunto. @afonsod.eth
Então, vamos lá.

Diversos projetos implementam padrões de smart contract comuns e sem muita criatividade, nada que na minha opinião, agregasse certo valor. Alguns deles, parecem mais que estão se aproveitando do hype da tecnologia blockchain. Assim, pensei em uma forma que poderia agregar e implementei algumas coisas diferentes que façam sentido de fato. Estudei sobre os NFT dinâmicos (Tokens não fungíveis que utilizam oráculos para mudar de forma automatizada os metadados) e como poderia usá-los em uma possibilidade de tokenização imobiliária.

Fui um pouco além, inseri algo parecido com o que existe no mercado tradicional de FIIs (Fundos imobiliários), só que lógico, tudo utilizando os smart contracts. Estruturei pensando na hipótese dos cartórios ou imobiliárias como provedores e agregadores do preço de um determinado imóvel. Então segue o smart contract na rede Goerli que possibilita qualquer pessoa ser o provedor (imagine que você seja o cartório ou a imobiliária): https://goerli.etherscan.io/address/0x43e8defb58fef865ef14cffba39830724bed33c8#writeContract

Deste modo, o projeto a seguir é o que eu chamo de Dynamic NFT-Fi e vocês vão entender. 

São duas classes do mesmo imóvel, o básico e o de luxo. A alteração das classes depende de um contrato interface denominado de PriceImobAgregadorV3Interface, que é o mesmo do AggregatorV3Interface da Chainlink. Assim, utilizei o contrato MockAggregatorV3 sendo um contrato teste, usando-o no lugar dos existentes que retornam valores do mercado de cripto, por exemplo o valor do ETH/USD, só que no nosso projeto, os agregadores serão os cartórios ou imobiliárias que provem o valor do imóvel atual do mercado.

Toda vez que o imóvel é valorizado ele é considerado luxo e toda vez que é desvalorizado, é considerado básico. Para automatizar a mudança dos metadados utilizamos os Atomates Contracts da Chainlink. Portanto, quem comprar as frações do imóvel, conseguirá ver na imagem e informações do NFT se ele foi valorizado ou desvalorizado, conforme a automatização e atualização dos metadados. Observem as imagens:

<div align="center">
<img src="https://ipfs.io/ipfs/bafybeibap5bfwehbojehwvf3pzzbcxhrdrllgski3gyim4v6ozlyo3vbbu" width="700px" />
</div>
<div align="center">
<img src=" https://ipfs.io/ipfs/bafybeiczv6ofxnzoug7zaxbwwov6jy5emjk6sog4xe5c4pqbxvw7zfgsau" width="700px" />
</div>

Até aqui já é inovador, mas quis inserir algo diferente, o que você ganharia ou perderia caso seu imóvel valoriza ou desvaloriza? Logo pensei em algo parecido com fundos imobiliários. 

Dessa forma, cada proprietário do NFT poderá tirar seus “dividendos” a cada 30 dias (coloquei 30 segundos no código para ficar mais fácil de testarem). Mas o valor de dividendos depende da classe do seu imóvel, se seu imóvel estiver no basic só conseguirá tirar 5 token imob, caso esteja no luxury conseguirá retirar 10 token imob. Segue as transações de retiradas dos dividendos: 
https://goerli.etherscan.io/token/0x04f5b206925f159f0d7773f77964dad8f3c59d1b?a=0xe87f6bfc43a1bd961fe556dffb0a2fb06c334cd5 


Tem muita lógica que ainda podemos implementar na estrutura do código, mas neste projeto conseguimos entender a dimensão de aplicações utilizando a Web3. O código está no meu Github: Afonsodalvi. Espero que tenham gostado, mas peço que divulguem o material, precisamos trazer melhores soluções para o mercado e queremos inovações benéficas para todos. Vamos construir na Web3!

**

![Github Actions]()

### Getting Started

-- Se usar o git configurar para ser usado no Linux/Unix e no Windows: https://pt.stackoverflow.com/questions/44373/aviso-git-lf-will-be-replaced-by-crlf

```bash
git config --global core.autocrlf true
```

- Use Foundry na pasta foundry: (Os testes no foundry são mais rápidos)

```bash
yarn

forge build
```

- Install libraries with Foundry which work with Hardhat.

```bash
forge install transmissions11/solmate Openzeppelin/openzeppelin-contracts
 # Already in this repo, just an example
```

```bash
forge test

forge test -vv
```

```bash
forge test --gas-report

```


- Caso esteja usando uma máquina virtual Linux ou um Mac conseguirá executar os comandos abaixo sem problemas:

```bash
avil   (blockchain do foundry)
```

- Para o deploy e verificação dos contratos no foundry deve configurar o env. e executar os comandos na ordem:

```bash
source .env
```

```bash
forge script script/NFT.s.sol:MyScript --rpc-url $RINKEBY_RPC_URL  --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_KEY -vvvv
```

- Use Hardhat na pasta principal template-deploy (melhor opção de deploy e verificação caso esteja usando o Windows):

```bash
yarn
yarn test
```

- Use compile watch or test watch:

```bash
yarn hardhat compile:watch
yarn hardhat test:watch
```

```bash
truffle dashboard  (para não precisar configurar as chaves privadas no seu .env)
```

- Deploy your smart-contract using testnet Truffle Dashboard:

```bash
yarn deploy --network truffle
```

### Features

- Write / run tests with either Hardhat or Foundry:

```bash
forge test
# or
yarn test
```

- Use Truffle Dashboard:

```bash
truffle dashboard
```

- Use Truffle ppara deployar e verificar seus contratos sem necessidade de inserir suas chaves privadas:
(obs. o truffle dashboard precisa estar executado)

```bash
yarn deploy:truffle

```
```bash
yarn deploy:NFT
```

```bash
yarn hardhat verify --network truffle 0xCF00fd269fE5Ad09E0907b96AfeeD7e04F8423C6 argumentos

```

- Use Prettier

```bash
yarn prettier
```



### Notes

Fiz um conjunto de implementações para ficar mais fácil o uso de diversos frameworks necessários para iniciar qualquer projeto.

