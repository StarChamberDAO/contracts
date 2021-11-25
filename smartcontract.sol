// File contracts/smartcontract.sol
// Star Chamber DAO NFT.

// ******************************************************************************************************************************
// *************************************************** Start of Main Contract ***************************************************
// ******************************************************************************************************************************

pragma solidity ^0.8.0;

contract SCDAO is ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;

    // Primary Settings
    uint256 public constant maxTokens = 100; // Maximum supply.
    uint public constant PRICE = 0.3 ether; // Current price = 0.3 ETH.
    uint256 public PURCHASE_LIMIT = 2; // Per Wallet mint limit.
    uint256 public PublicSaleMaxMint = 1; // Public Sale mint limit.
    uint256 public WhiteListMaxMint = 2; // Pre Sale mint limit.
    string private _contractURI = "ipfs://Qmbrj4ui5wgrsHeCbSu9XeogotTX3o6jneooRk3zSuCfgh/"; // Pre-reveal .json metadata.
    string private _tokenBaseURI = "ipfs://Qmbrj4ui5wgrsHeCbSu9XeogotTX3o6jneooRk3zSuCfgh/"; // Post-reveal .json metadata.
    bool public revealed = false; // Initial reveal status false.

    mapping(address => bool) private _WhiteList;
    mapping(address => uint256) private _WhiteListClaimed;

    enum State {NoSale, Presale, PublicSale} // Declare sale status.
    State public saleState;
    
    Counters.Counter private _publicSCDAO;

    // Initalize contract and enable pre-deployment whitelist.
    constructor() ERC721("Star Chamber DAO", "SCD"){
        _publicSCDAO.increment();
        saleState = State.NoSale;
        _WhiteList[0x411Ca81c33A02e181Aa4534abEE62Bd55895Ad7b]=true;
        _WhiteList[0xfAD941DC8cb86eCC112E717AE3EC38b3023e4c4C]=true;
        _WhiteList[0xC63e77B019E308d1C44b9771a8a28167e6de30ec]=true;
        _WhiteList[0x04BEb13d3fbC35d48ac7C1a71690931Ea330f41f]=true;
        _WhiteList[0x2884d01A4915B05f23084DD210b57f57f1A81eeD]=true;
        _WhiteList[0xeFD9EaDD0cAE4973195333C9270Bf2C6CecCAD85]=true;
        _WhiteList[0x59891E64C54E4fC96927d26090377a5A3504b49B]=true;
        _WhiteList[0x3efEA80c8d3827160cbd23c8AF4C77EB408578ac]=true;
        _WhiteList[0xc0f4b2D44D36E588d87981b3bE39EEf2D44dE4ae]=true;
        _WhiteList[0x2283195B491A4413Fb76FFd6243d33b87C2003fc]=true;
        _WhiteList[0x2D8d16721eDb851e076616fcd59E0dFbbc607A4f]=true;
        _WhiteList[0xe7Cb26f13cA7876b368A837EE17696EceDda1182]=true;
        _WhiteList[0xceAB4bcd42B18588836f3962AA785E7CA88c5838]=true;
        _WhiteList[0x4bEe51A0236BB79C3f21ef24470a66b9490c1928]=true;
        _WhiteList[0x96f3b156dCB5B2bdB8C4CB793d85AF6ac7E5DEcE]=true;
        _WhiteList[0xa8265836b6f0C7e90d62aa3C2ba4f5F1d197307C]=true;
        _WhiteList[0x6Bb0b9FDA26418af2831FF3a26049e9F7Ce37A47]=true;
        _WhiteList[0x78D3cE60a4d803268AFeAD2d3aaD5B6C6e8AF3Aa]=true;
        _WhiteList[0x11a6bF219544bE24a77121e1EcaD01A7CA10D09D]=true;
        _WhiteList[0xe0D84A7bcCBE2fAd2aa5Fde1047E81D65606F2A0]=true;
        _WhiteList[0x091f3B40936d0df412e0606892E34a324aE86F83]=true;
        _WhiteList[0xAaC46C32E84da0a13629B4d59292B0b53a3eb695]=true;
        _WhiteList[0x1C94a99Dd48B251cCb529a23c055CabD6F057e76]=true;
        _WhiteList[0xff0e16F7995d049E307223261BdE011a339A3E6A]=true;
        _WhiteList[0x2526B26D31500d8D7711b80e22a9F48D2142a2eF]=true;
        _WhiteList[0x7Cdc685adA9a074ceC9a761173ec28d418206AB5]=true;
        _WhiteList[0x3e44938A81fb0DD0379985F019e0833F5ED279DA]=true;
        _WhiteList[0xa35B5e6D3A913ce3845F8F24a5e93a9E51d6e76C]=true;
        _WhiteList[0x30DB7a96E9b32c35b9D9caF4491f4e39B354f274]=true;
        _WhiteList[0x80eA679f52D527c0bFc89E2C9be958D838bf2157]=true;
        _WhiteList[0x95D3a3C78020Bbae4658DF09f71511D4f402e4ED]=true;
        _WhiteList[0x98E26214667592Ae8b92c35b4C04F189069a8A5f]=true;
        _WhiteList[0x36Ba357C27c999fc0a686a6B5B553f134C770A9d]=true;
        _WhiteList[0xD679B64eBFe72d501E7d66f5B572fc1EFCc399D9]=true;
        _WhiteList[0xCd687d24Fb957d403B44dC40A26bCC21E2DadeD7]=true;
        _WhiteList[0x3f6eD0F870520b08D0D6bE73430c6DA9997747FF]=true;
        _WhiteList[0x4955Fd9959d4B26e0AB22953652AF21d97CE8310]=true;
        _WhiteList[0x73D396a8A851f93D989E127a4F411A682640B7bc]=true;
        _WhiteList[0xa03F563F22b09d6aBf68eC89B1784654682f1930]=true;
        _WhiteList[0x641C6C7168F5A678bAF5F1b2141f71FDef27a82e]=true;
        _WhiteList[0xe12D731750E222eC53b001E00d978901B134CFC9]=true;
        _WhiteList[0x7375Ca5219408A75966C1565E517D05bd2BBCB46]=true;
        _WhiteList[0x7598356c8F70Aec7e5bb3A49DFC988FB6b208B45]=true;
        _WhiteList[0x963Fa2F4d38ab13bAEB6ce7433b620E636B1E511]=true;
        _WhiteList[0x4ad5c87ec83F71603BDe4e71686C7CE4E354b83c]=true;
        _WhiteList[0x55e390BA832B062fD369C9C6F4717B13Cff3d59b]=true;
        _WhiteList[0xb9550D222AAB2751D3384b28f7ef2062bc64dAe9]=true;
        _WhiteList[0xfd45B7f5428Fb114305fbC40972deE6Ab4C0002c]=true;
        _WhiteList[0x1bC79d11b99a71Ad7d586Ea4cD6513609D2c374b]=true;
        _WhiteList[0x47668a9A8f3004A0f07CdC346a7020ca4010B602]=true;
        _WhiteList[0xbF8d494C35BB50BFF3aCE7129Cc718928fc5BE60]=true;
        _WhiteList[0xD0d8c68d5B9e45Cc6a74abB5A5234a6330a45b0B]=true;
        _WhiteList[0x58F4Ee50A924244A18041bCbc529f9B2376306a1]=true;
        _WhiteList[0x4eB043D6Bd3D8DeEE60D12C9C87f23f4BA5c98C5]=true;
        _WhiteList[0x020f45082E99E4aef3cfaE89A341F9e5E6fAc3Bb]=true;
        _WhiteList[0x832F4f4f88ab27a00b7683C9b5Fc191e797187F3]=true;
        _WhiteList[0xbB3fb86Ae33Cee705E5ee52A72fcdEC87A9d9233]=true;
        _WhiteList[0xA2b1861a76d25A308E5aC5be72136fc892aD8D97]=true;
        _WhiteList[0xEE51DFBB440224B999bed3BF135Eba5c14F3A027]=true;
        _WhiteList[0x77e96e34A71F97D39600860FdBc939EAd4A2AFc4]=true;
        _WhiteList[0xe0D84A7bcCBE2fAd2aa5Fde1047E81D65606F2A0]=true;
        _WhiteList[0xD5a10C5f957cE8A0686F41CffC57Df219b72797d]=true;
        _WhiteList[0x7E45bf7Bc3FF86785d2741C11EB8f5D914647257]=true;
        _WhiteList[0x69b384d61D477D93624A2E90aAB2Dd1BC22b9698]=true;
        _WhiteList[0x52419168b03823EfDFE2a123E66e6976fAbe27C6]=true;
        _WhiteList[0x433e55070d0f5097307384f1aB09BBa49a3d6399]=true;
        _WhiteList[0x22e5841a95b312fA0A92CDB83E663dA80A7422A0]=true;        
    }

    receive() payable external {}
    fallback() payable external {}

// ******************************************************************************************************************************
// **************************************************** Setters and Getters  ****************************************************
// ******************************************************************************************************************************

    // Set Pre-reveal .json metadata.
    function setContractURI(string memory URI) external onlyOwner {
        _contractURI = URI;
    }
    
    // Set Post-reveal .json metadata.
    function setBaseURI(string memory URI) external onlyOwner {
        _tokenBaseURI = URI;
    }

    // Set Status Presale.
    function switchToPresale() public {
        address ow = owner();
        require(msg.sender == ow, "Error: Only available for the Owner of the Contract");
        saleState = State.Presale;
    }
    
    // Set Status Public Sale.
    function switchToPublicSale() public {
        address ow = owner();
        require(msg.sender == ow, "Error: Only available for the Owner of the Contract");
        saleState = State.PublicSale;
    }
    
    // Set Status No Sale (default).
    function switchToNoSale() public {
        address ow = owner();
        require(msg.sender == ow, "Error: Only available for the Owner of the Contract");
        saleState = State.NoSale;
    }

    // Set White List Max Mint Amount.
    function setWhiteListMaxMint(uint256 maxMint) external onlyOwner {
        WhiteListMaxMint = maxMint;
    }
    
    // Add White List address. Use format ["0x000000000000000000000000000000000000dEaD"].
    function addToWhiteList(address[] calldata addresses) external onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) {
          require(addresses[i] != address(0), "Error: Can not add a null address.");                   
          _WhiteList[addresses[i]] = true;
          _WhiteListClaimed[addresses[i]] > 0 ? _WhiteListClaimed[addresses[i]] : 0;
        }
    }

    //       
    function WhiteListClaimedBy(address owner) external view returns (uint256){
        require(owner != address(0), "Error: Address is not on the White List.");
    
        return _WhiteListClaimed[owner];
    }
    
    // Return White List address.
    function onWhiteList(address addr) external view returns (bool) {
        return _WhiteList[addr];
    }
    
    // Remove White List address. Use format ["0x000000000000000000000000000000000000dEaD"].
    function removeFromWhiteList(address[] calldata addresses) external onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) {
          require(addresses[i] != address(0), "Error: Can not remove a null address.");
    
          _WhiteList[addresses[i]] = false;
        }
    }

    // Return Pre-reveal URI with apended contract.json.
    function contractURI() public view returns (string memory) {
            return string(abi.encodePacked(_tokenBaseURI,"contract.json"));
    }

    // Return Post-reveal URI with apended .json.
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721)
        returns (string memory)
    {
        require(_exists(tokenId), "Error: Token ID does not exist.");

        if(revealed == false) {
        return contractURI();
    }
        return string(abi.encodePacked(_tokenBaseURI, tokenId.toString(), ".json"));
    }

    // Return revealed status.
    function reveal() public onlyOwner() {
      revealed = true;
    }

    // Allow contract owner withdrawl.
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;

        payable(msg.sender).transfer(balance);
    }

// ******************************************************************************************************************************
// *************************************************** Minting Functionality  ***************************************************
// ******************************************************************************************************************************

    function ownerMint(address to, uint256 numberOfTokens)
        external
        payable
        onlyOwner 
        {
            require(_publicSCDAO.current() < 100, "Error: Purchase would exceed the total supply.");
            
            for (uint256 i = 0; i < numberOfTokens; i++) {
                uint256 tokenId = _publicSCDAO.current();
    
                if (_publicSCDAO.current() < maxTokens) {
                    _publicSCDAO.increment();
                    _safeMint(msg.sender, tokenId);
                }
            }
    }

    function purchaseWhiteList(uint256 numberOfTokens) external payable {
        require(numberOfTokens <= PURCHASE_LIMIT, "Error: The maximum NFT's per wallet is 2.");
        require(balanceOf(msg.sender) < 2, "Error: The maximum NFT's per wallet is 2.");
        require(saleState != State.NoSale, "Error: Presale is not active.");
        require(_WhiteList[msg.sender], "Error: Current address is not White Listed.");
        require(_publicSCDAO.current() < maxTokens, "Error: Purchase would exceed the total supply.");
        require(numberOfTokens <= WhiteListMaxMint, "Error: The maximum White List allocation is 2.");
        require(_WhiteListClaimed[msg.sender] + numberOfTokens <= WhiteListMaxMint, "Error: The maximum White List allocation is 2.");
        require(PRICE * numberOfTokens <= msg.value, "Error: Submited ETH amount is insufficient.");
        require(_publicSCDAO.current() < maxTokens, "Error: Purchase would exceed the total supply.");
        for (uint256 i = 0; i < numberOfTokens; i++) {
            uint256 tokenId = _publicSCDAO.current();

            if (_publicSCDAO.current() < maxTokens) {
                _publicSCDAO.increment();
                _safeMint(msg.sender, tokenId);
            }
        }
      }

    function purchase(uint256 numberOfTokens) external payable {
        require(saleState == State.PublicSale, "Error: Public sale is not active."); 
        require(balanceOf(msg.sender) < 2, "Error: The maximum NFT's per wallet is 2.");
        require(numberOfTokens <= PURCHASE_LIMIT, "Error: The maximum NFT's per wallet is 2.");
        require(_publicSCDAO.current() < maxTokens, "Error: Purchase would exceed the total supply.");
        require(PRICE * numberOfTokens <= msg.value, "Error: Submited ETH amount is insufficient.");
        
        for (uint256 i = 0; i < numberOfTokens; i++) {
            uint256 tokenId = _publicSCDAO.current();

            if (_publicSCDAO.current() < maxTokens) {
                _publicSCDAO.increment();
                _safeMint(msg.sender, tokenId);
            }
        }
    }

}
