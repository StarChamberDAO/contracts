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

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    function initialize() initializer public {
        __ERC721_init("Star Chamber DAO", "SCD");
        __ERC721Enumerable_init();
        __Pausable_init();
        __Ownable_init();
    }
    
      uint256 public cost = 0.3 ether;
      uint256 public maxSupply = 100;
      uint256 public maxMintAmount = 20;
      uint256 public nftPerAddressLimt = 3;
      bool public onlyWhitelisted = true;
      address[] public whitelistedAddresses;
      mapping(address => uint256) public addressMintedBalance;

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://Qmbrj4ui5wgrsHeCbSu9XeogotTX3o6jneooRk3zSuCfgh/contract.json";
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }
    
    function setCost(uint256 _newCost) public onlyOwner {
        cost = _newCost;
    }
    
// Fix all these onlyOwners to the Gnosis multi-sig    
// Add whitelist functions, add name , total supply etc public viewers
    
    function withdraw() public payable onlyOwner {
        (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(success);
    }
    
     function isWhitelisted(address _user) public view returns (bool) {
      for(uint256 i = 0; i < whitelistedAddresses.length; i++) {
          if(whitelistedAddresses[i] == _user) {
              return true;
          }
      }
      return false;
    } 


// Workshop

    function mint(uint256 _mintAmount) public payable {
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
              require(msg.value >= cost * _mintAmount, "You have insufficient funds to proceedwith the transaction.");
        }
        
        for (uint256 i = 1; i <= _mintAmount; i++) {
            addressMintedBalance[msg.sender]++;
            _safeMint(msg.sender, supply +i);
        }
    }
    
// Workshop

    

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
