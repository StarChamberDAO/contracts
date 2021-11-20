// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";

/// @custom:security-contact admin@starchamber.io
contract StarChamberDAO is Initializable, ERC721Upgradeable, ERC721EnumerableUpgradeable, PausableUpgradeable, OwnableUpgradeable {
    using CountersUpgradeable for CountersUpgradeable.Counter;

    CountersUpgradeable.Counter private _tokenIdCounter;
    
/// Set parameters

  string public baseURI;
  string public baseExtension = ".json";
  string public notRevealedUri;
  uint256 public cost = 0.3 ether;
  uint256 public maxSupply = 100;
  uint256 public maxMintAmount = 20;
  uint256 public nftPerAddressLimt = 3;
  bool public _paused = false;
  bool public revealed = false;
  bool public onlyWhitelisted = true;
  address[] public whitelistedAddresses;
  mapping(address => uint256) public addressMintedBalance;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    function initialize() initializer public {

        __ERC721Enumerable_init();
        __Pausable_init();
        __Ownable_init();
        string memory _name;
        string memory _symbol;
        string memory _initBaseURI;
        string memory _initNotRevealedUri;
         __ERC721_init("_name, _symbol");
         setBaseURI(_initBaseURI);
         setNotRevealedURI(_initNotRevealedUri);
        }
    
    /// Internal

   function _baseURI() internal pure override returns (string memory) {
        return baseURI;
    }
    
  /// Public
  function mint(uint256 _mintAmount) public payable {
    require(_paused, "Minting has paused");
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
      _mint(msg.sender, supply + i);
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
  
  /// Only Owner
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

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }
    
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    } 
}
