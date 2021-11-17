pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StarChamberDAO is ERC721Enumerable, Ownable {
  using Strings for uint256;

  string public baseURI;
  string public baseExtension = ".json";
  string public notRevealedUri;
  uint256 public cost = 0.3 ether;
  uint256 public maxSupply = 100;
  uint256 public maxMintAmount = 20;
  uint256 public nftPerAddressLimt = 3;
  bool public paused = false;
  bool public revealed = false;
  bool public onlyWhitelisted = true;
  address[] public whitelistedAddresses;
  mapping(address => uint256) public addressMintedBalance;

  constructor(
    string memory _name,
    string memory _symbol,
    string memory _initBaseURI,
    string memory _initNotRevealedUri
  ) ERC721(_name, _symbol) {
    setBaseURI(_initBaseURI);
    setNotRevealedURI(_initNotRevealedUri);
  }

  // internal
  function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }

  // public
  function mint(uint256 _mintAmount) public payable {
    require(!paused, "Minting has paused.");
    uint256 supply = totalSupply();
    require(_mintAmount > 0, "You must mint at least 1 NFT.");
    require(_mintAmount <= maxMintAmount, "You are attempting to mint more than the maximum per user allocation.");
    require(supply + _mintAmount <= maxSupply, "Required amount will surpass token max supply");

    if (msg.sender != owner()) {
        if (onlyWhitelisted == true) {
            require(isWhitelisted(msg.sender), "User is not whitelisted.");
            uint256 ownerMintedCount = addressMintedBalance[msg.sender];
            require(ownerMintedCount + _mintAmount <= nftPerAddressLimt, "The maximum NFT's per address has been reached.");
        }
          require(msg.value >= cost * _mintAmount, "You have insufficient funds to proceed with the transaction.");
    }

    for (uint256 i = 1; i <= _mintAmount; i++) {
        addressMintedBalance[msg.sender]++;
      _safeMint(msg.sender, supply + i);
    }
  }

  function isWhitelisted(address _user) public view returns (bool) {
      for(uint256 i = 0; i < whitelistedAddresses.length; i++) {
          if(whitelistedAddresses[i] == _user) {
              return true;
          }
      }
      return false;
  } 

  function walletOfOwner(address _owner)
    public
    view
    returns (uint256[] memory)
  {
    uint256 ownerTokenCount = balanceOf(_owner);
    uint256[] memory tokenIds = new uint256[](ownerTokenCount);
    for (uint256 i; i < ownerTokenCount; i++) {
      tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
    }
    return tokenIds;
  }

  function tokenURI(uint256 tokenId)
    public
    view
    virtual
    override
    returns (string memory)
  {
    require(
      _exists(tokenId),
      "ERC721Metadata: URI query for nonexistent token"
    );
    
    if(revealed == false) {
        return notRevealedUri;
    }

    string memory currentBaseURI = _baseURI();
    return bytes(currentBaseURI).length > 0
        ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
        : "";
  }

  //only owner
  function reveal() public onlyOwner() {
      revealed = true;
  }
  
  function setNftPerAddressLmit(uint256 _limit) public onlyOwner {
    nftPerAddressLimt = _limit;
  }
  
  function setCost(uint256 _newCost) public onlyOwner {
    cost = _newCost;
  }

  function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
    maxMintAmount = _newmaxMintAmount;
  }

  function setBaseURI(string memory _newBaseURI) public onlyOwner {
    baseURI = _newBaseURI;
  }
  
  function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
    notRevealedUri = _notRevealedURI;
  }

  function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
    baseExtension = _newBaseExtension;
  }

  function pause(bool _state) public onlyOwner {
    paused = _state;
  }
 
  function setOnlyWhitelisted(bool _state) public onlyOwner {
    onlyWhitelisted = _state;
  }  
  
 function whitelistUsers(address[] calldata _users) public onlyOwner {
    delete whitelistedAddresses;
    whitelistedAddresses = _users;
  }
 
  function withdraw() public payable onlyOwner {
    (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
    require(success);
  }
}

//**

["0x411Ca81c33A02e181Aa4534abEE62Bd55895Ad7b",
"0x2884d01A4915B05f23084DD210b57f57f1A81eeD",
"0xeFD9EaDD0cAE4973195333C9270Bf2C6CecCAD85",
"0x59891E64C54E4fC96927d26090377a5A3504b49B",
"0x3efEA80c8d3827160cbd23c8AF4C77EB408578ac",
"0xc0f4b2D44D36E588d87981b3bE39EEf2D44dE4ae",
"0x2283195B491A4413Fb76FFd6243d33b87C2003fc",
"0x2D8d16721eDb851e076616fcd59E0dFbbc607A4f",
"0xe7Cb26f13cA7876b368A837EE17696EceDda1182",
"0xceAB4bcd42B18588836f3962AA785E7CA88c5838",
"0x4bEe51A0236BB79C3f21ef24470a66b9490c1928",
"0x96f3b156dCB5B2bdB8C4CB793d85AF6ac7E5DEcE",
"0xa8265836b6f0C7e90d62aa3C2ba4f5F1d197307C",
"0x6Bb0b9FDA26418af2831FF3a26049e9F7Ce37A47",
"0x78D3cE60a4d803268AFeAD2d3aaD5B6C6e8AF3Aa",
"0x11a6bF219544bE24a77121e1EcaD01A7CA10D09D",
"0xe0D84A7bcCBE2fAd2aa5Fde1047E81D65606F2A0",
"0x091f3B40936d0df412e0606892E34a324aE86F83",
"0xAaC46C32E84da0a13629B4d59292B0b53a3eb695",
"0x1C94a99Dd48B251cCb529a23c055CabD6F057e76",
"0x4d878F3CD729ae630D71f06b3e484f6bBE9786d0",
"0x2526B26D31500d8D7711b80e22a9F48D2142a2eF",
"0x7Cdc685adA9a074ceC9a761173ec28d418206AB5",
"0x3e44938A81fb0DD0379985F019e0833F5ED279DA",
"0xa35B5e6D3A913ce3845F8F24a5e93a9E51d6e76C",
"0x30DB7a96E9b32c35b9D9caF4491f4e39B354f274",
"0x80eA679f52D527c0bFc89E2C9be958D838bf2157",
"0x95D3a3C78020Bbae4658DF09f71511D4f402e4ED",
"0x98E26214667592Ae8b92c35b4C04F189069a8A5f",
"0x36Ba357C27c999fc0a686a6B5B553f134C770A9d",
"0xD679B64eBFe72d501E7d66f5B572fc1EFCc399D9",
"0xCd687d24Fb957d403B44dC40A26bCC21E2DadeD7",
"0x3f6eD0F870520b08D0D6bE73430c6DA9997747FF",
"0x4955Fd9959d4B26e0AB22953652AF21d97CE8310",
"0x73D396a8A851f93D989E127a4F411A682640B7bc",
"0xa03F563F22b09d6aBf68eC89B1784654682f1930",
"0x641C6C7168F5A678bAF5F1b2141f71FDef27a82e",
"0xe12D731750E222eC53b001E00d978901B134CFC9",
"0x7375Ca5219408A75966C1565E517D05bd2BBCB46",
"0x7598356c8F70Aec7e5bb3A49DFC988FB6b208B45",
"0x963Fa2F4d38ab13bAEB6ce7433b620E636B1E511",
"0x4ad5c87ec83F71603BDe4e71686C7CE4E354b83c",
"0x55e390BA832B062fD369C9C6F4717B13Cff3d59b",
"0xb9550D222AAB2751D3384b28f7ef2062bc64dAe9",
"0xfd45B7f5428Fb114305fbC40972deE6Ab4C0002c",
"0x1bC79d11b99a71Ad7d586Ea4cD6513609D2c374b",
"0x47668a9A8f3004A0f07CdC346a7020ca4010B602",
"0xbF8d494C35BB50BFF3aCE7129Cc718928fc5BE60",
"0xD0d8c68d5B9e45Cc6a74abB5A5234a6330a45b0B",
"0x58F4Ee50A924244A18041bCbc529f9B2376306a1",
"0x4eB043D6Bd3D8DeEE60D12C9C87f23f4BA5c98C5",
"0x020f45082E99E4aef3cfaE89A341F9e5E6fAc3Bb",
"0x832F4f4f88ab27a00b7683C9b5Fc191e797187F3",
"0xbB3fb86Ae33Cee705E5ee52A72fcdEC87A9d9233",
"0xa2b1861a76d25a308e5ac5be72136fc892ad8d97",
"0xEE51DFBB440224B999bed3BF135Eba5c14F3A027",
"0x77e96e34a71f97d39600860fdbc939ead4a2afc4",
"0xe0D84A7bcCBE2fAd2aa5Fde1047E81D65606F2A0",
"0xD5a10C5f957cE8A0686F41CffC57Df219b72797d",
"0xb8D1Ad99b3f585A8c6C9d1A146dCfDb6EfA7f6e8",
"0x69b384d61d477d93624a2e90aab2dd1bc22b9698",
"0x433e55070d0f5097307384f1aB09BBa49a3d6399",
"0x22e5841a95b312fA0A92CDB83E663dA80A7422A0"]

*/
