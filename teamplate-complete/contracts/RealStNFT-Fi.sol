// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


//  _______                       __         ______     __               __                    
// |       \                     |  \       /      \   |  \             |  \                   
// | $$$$$$$\  ______    ______  | $$      |  $$$$$$\ _| $$_    ______ _| $$_    ______        
// | $$__| $$ /      \  |      \ | $$      | $$___\$$|   $$ \  |      \   $$ \  /      \       
// | $$    $$|  $$$$$$\  \$$$$$$\| $$       \$$    \  \$$$$$$   \$$$$$$\$$$$$$ |  $$$$$$\      
// | $$$$$$$\| $$    $$ /      $$| $$       _\$$$$$$\  | $$ __ /      $$| $$ __| $$    $$      
// | $$  | $$| $$$$$$$$|  $$$$$$$| $$      |  \__| $$  | $$|  \  $$$$$$$| $$|  \ $$$$$$$$      
// | $$  | $$ \$$     \ \$$    $$| $$       \$$    $$   \$$  $$\$$    $$ \$$  $$\$$     \      
//  \$$   \$$  \$$$$$$$  \$$$$$$$ \$$        \$$$$$$     \$$$$  \$$$$$$$  \$$$$  \$$$$$$$    


//   _____                              _        _   _ ______ _______     ______ _  
//  |  __ \                            (_)      | \ | |  ____|__   __|   |  ____(_) 
//  | |  | |_   _ _ __   __ _ _ __ ___  _  ___  |  \| | |__     | |______| |__   _  
//  | |  | | | | | '_ \ / _` | '_ ` _ \| |/ __| | . ` |  __|    | |______|  __| | | 
//  | |__| | |_| | | | | (_| | | | | | | | (__  | |\  | |       | |      | |    | | 
//  |_____/ \__, |_| |_|\__,_|_| |_| |_|_|\___| |_| \_|_|       |_|      |_|    |_| 
//           __/ |                                                                  
//          |___/                                                                   

/////@author Omnes Blockchain, Copyright © , 2022, the MIT License
// /// (https://github.com/Afonsodalvi) @afonsod.eth
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


import "./PriceImobAgregadorV3Interface.sol";

// This import includes functions from both ./KeeperBase.sol and
// ./interfaces/KeeperCompatibleInterface.sol
import "@chainlink/contracts/src/v0.8/KeeperCompatible.sol";

// Dev imports. This only works on a local dev network
// and will not work on any test or main livenets.
import "hardhat/console.sol";

//inseiri a interface do Keepers
contract RealStNFTFi is ERC721, 
ERC721Enumerable, ERC721URIStorage, 
Ownable, KeeperCompatibleInterface 
 {

    error Itsnottime();
    error Donthaveproperty();


    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint public /*immutable*/ interval;
    uint public lastTimeStamp;
     address public immutable rewardToken;

    mapping(address => uint) timereward;
    


    PriceImobAgregadorV3Interface public priceFeed; //vai pegar o preço de algum Token
    int256 public currentPrice;
    uint256 public maxSupply;

    // IPFS URIs for the dynamic nft https://nft.storage/
    // NOTE: this project is a demonstration of the possibilities that can be made in the real estate sector
    // You should upload the contents of the /ipfs folder to your own node for development.
     string[] LuxImobUrisIpfs = [
        "https://ipfs.io/ipfs/bafkreict23k7iv2nsg2regrxxai7hhur3mxjlgj5iwm5h7d7d34633vclm"
    ];
    string[] BasicImobUrisIpfs = [
        "https://ipfs.io/ipfs/bafkreigjavi7g36f2mwuncke4j33erd2ymt6sd6xsmi67miphzzvs4matu"
    ];

    event TokenUpdated(string marketTrend);
    event RewardPaid(address indexed user, uint256 reward);

     /**
     * Network: Goerli
     * Aggregator: Normalmente seria ETH/USD ou qualquer outro Pricee Feed: https://docs.chain.link/docs/data-feeds/price-feeds/addresses/ 
     // Aqui estamos simulando que é o valor do mercado imobiliário referente aos imóveis em específico.
     * Address: deployado
     */
     // interval é em segundos e endereço do _priceFeed ou usar o do MockPrice ou pegar um dos existentes no site chainlinlk como o mencionado acima
     //Ao inserir e dar o deploy, connsegue interagir na função getlatestprice e terá o valor inicial do contrato MockPriceFeed definido por vc
   constructor(uint updateInterval, address _priceFeed,address _rewardToken, uint256 _maxSupply) ERC721("Imoveis Premium", "IMOVPRE") {
        //sets the keepers update interval
        interval = updateInterval;
        lastTimeStamp = block.timestamp;
        rewardToken = _rewardToken;
        maxSupply = _maxSupply;


    // o valor do imóvel é atualizado do contrato interface que é do cartório ou imobiliária
        priceFeed = PriceImobAgregadorV3Interface(_priceFeed);
        currentPrice = getLatestPrice();
    }

     modifier mintCompliance() {
        require(totalSupply() + 1 <= maxSupply, 'Max supply exceeded!');
    _;
     }


      //Get a property reward when it is luxury
    function rewardDivdLux()public {
    if(block.timestamp < timereward[msg.sender] + 30 seconds) revert Itsnottime();
    uint quantity = balanceOf(msg.sender)-1;
    require(balanceOf(msg.sender)  > 0, "dont have property");
    string memory toke = tokenURI(quantity);
    require(compareStrings("https://ipfs.io/ipfs/bafkreict23k7iv2nsg2regrxxai7hhur3mxjlgj5iwm5h7d7d34633vclm", toke)==true, "not lux");
    timereward[msg.sender] = block.timestamp;
    IERC20(rewardToken).transfer(msg.sender, 10);
    emit RewardPaid(msg.sender, 10);
    }

    //Get a property reward when it is basic
    function rewardDivdBasic()public {
    if(block.timestamp < timereward[msg.sender] + 30 seconds) revert Itsnottime();
    uint quantity = balanceOf(msg.sender)-1;
    require(balanceOf(msg.sender) > 0, "dont have property");
    string memory toke = tokenURI(quantity);
    require(compareStrings("https://ipfs.io/ipfs/bafkreigjavi7g36f2mwuncke4j33erd2ymt6sd6xsmi67miphzzvs4matu", toke)==true, "not basic");
    timereward[msg.sender] = block.timestamp;
    IERC20(rewardToken).transfer(msg.sender, 5);
    emit RewardPaid(msg.sender, 5);
    }

    function safeMint(address to) public {
        // o Token Id é a quantidade atual já contabilizada com os mints anteriores
        uint256 tokenId = _tokenIdCounter.current();

        // Incrementando mais um NFT que está sendo mintado
        _tokenIdCounter.increment();

        // Mintando para o endereço definido e o TokenID já somado mais um
        _safeMint(to, tokenId);

        // Default to a bull NFT - vc pode mudar esse padrão de ERC721 depois para o mais barato.
        //sempre que mintarmos o NFT será por padrão o priimeiro URI da array referente ao basic imóvel
        string memory defaultUri = BasicImobUrisIpfs[0];
        _setTokenURI(tokenId, defaultUri);

        console.log(
            "DONE!!! minted token ",
            tokenId,
            " and assigned token url: ",
            defaultUri
        );
    }

// função do keepers para checar a data aqui por exemplo podia ser o tempo.
//https://docs.chain.link/docs/chainlink-keepers/compatible-contracts/
//Estude o link acima, mas basicamente a função abaixo ela verifica o dado inserido, um dos exemplos poderia ser o balance de um deterinado endereço
// A função é ovverride que deve ser exatamete igual ao definido no contrato herdado.                  /// performData verifica offchain o gas utilizado para dar mais perfromace
//Registre seu upKeep para conseguir verificar
// https://keepers.chain.link/?_ga=2.242618306.19640795.1664047080-2058578950.1640689712
    function checkUpkeep(bytes calldata /* checkData */) external view override returns(bool upkeepNeeded, bytes memory /*performData*/) {
        upkeepNeeded = (block.timestamp - lastTimeStamp) > interval;
    }

//A função de performace é referente ao limite de gas, onde na hora de registrar o keepers vc consegue definir o limite para a execução
//Caso ultrapasse o limite definido a função não é executada. Assim, consegue da mais performace ao especificar no callGasLimit o limite de gas de execção da função ao ser inserido os dados
//
    function performUpkeep(bytes calldata /*performData*/) external override {
        if ((block.timestamp - lastTimeStamp) > interval){
            lastTimeStamp = block.timestamp;

            //vamos pegar o ultimo preço definido do cartório ou imobiliária
            int latestPrice = getLatestPrice(); // PriceImobAgregadorV3Interface

            if(latestPrice == currentPrice){
                return;
            } /// se o ultimo preço for menor que o preço atual atualiza o URI dos tokens para os URIs de bear
            if(latestPrice < currentPrice){
                //bear
                updateAllTokenUris("basic");
            } else {
                ///bull
                updateAllTokenUris("luxo");
            }

        currentPrice = latestPrice;
        } else {
            // interval nor elapsed. intervalo não decorrido. No upkeep

        }
    }

    function getLatestPrice() public view returns(int256){
        //priceFeed.latestRoundData(); //olhe que definimos o contrato do AgregatorV3 que inserimos o endereço do contrato que puxa o perço do ativo que queremos em dolár
        // Assim, aqui irá retornar o valor que queremos..
        //Olhe as específicações no próprio site da Chainlink em API References:
        //https://docs.chain.link/docs/data-feeds/price-feeds/api-reference/
        //repare que estamos retornando a função definida no próprio contrato da chainlink data feed para retornar o preço do ativo
        (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        return price; //repare a quantidade de decimais do atuvo clicando em mais detalhes: https://docs.chain.link/docs/data-feeds/price-feeds/addresses/
    } // example price return 3034715771688

    //Olha a quantidade de decimais que é o ativo antes de inserir.

//se o trend for igual a string bear ele vai setar a array com o ipfs definido como o do basic, se não vai ser o do lux
    function updateAllTokenUris(string memory trend) internal{
        if(compareStrings("basic", trend)){
            for(uint i = 0; i < _tokenIdCounter.current(); i++){
                _setTokenURI(i, BasicImobUrisIpfs[0]);
            }
        }else {
              for(uint i = 0; i < _tokenIdCounter.current(); i++){
                _setTokenURI(i, LuxImobUrisIpfs[0]);
            }
        }

        emit TokenUpdated(trend);
    }

    function setInterval(uint256 newInterval)public onlyOwner{
        interval = newInterval;
    }

    function setPriceFeed(address newFeed) public onlyOwner{
        priceFeed = PriceImobAgregadorV3Interface(newFeed);
    }

    //Helpers -- vai chegcar se a string de a encodada vai ser a de b.
    function compareStrings(string memory a, string memory b) internal pure returns(bool){
        return (keccak256(abi.encodePacked(a)) ==  keccak256(abi.encodePacked(b)));
    }

    // The following functions are overrides required by Solidity.
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
