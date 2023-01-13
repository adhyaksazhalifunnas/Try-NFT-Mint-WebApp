// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NanameNFT is ERC721, Ownable {
    uint256 public mintPrice;
    uint256 public totalSupply;
    uint256 public maxSupply;
    uint256 public maxPerWallet;
    bool public isPublicMintEnabled;
    string internal baseTokenUri;
    address payable public withdrawWallet;
    mapping(address => uint256) public walletMints;

    constructor () payable ERC721('NanameNFT', 'NNM') {
        mintPrice = 0.01 ether;
        totalSupply = 0;
        maxSupply = 1000;
        maxPerWallet = 3;
        //set withdraw wallet address
    }

    function setIsPublicMintEnabled(bool isPublicMintEnabled_) external onlyOwner {
        isPublicMintEnabled = isPublicMintEnabled_;
    }

    function setBaseTokenUri(string calldata baseTokenUri_) external onlyOwner {
        baseTokenUri = baseTokenUri_;
    }

    function tokenURI(uint256 tokenId_) public view override returns (string memory) {
        require(_exists(tokenId_), 'Token does not exist');
        return string(abi.encodePacked(baseTokenUri, Strings.toString(tokenId_), ".json"));
    }

    function withdraw() external onlyOwner {
        (bool success, ) = withdrawWallet.call{ value: address(this).balance }('');
        require(success, 'withdraw failed');
    }

    function mint(uint256 quantity_) public payable {
        require(isPublicMintEnabled, 'minting not enabled');
        require(msg.value == quantity_ * mintPrice, 'wrong mint value');
        require(totalSupply + quantity_ <= maxSupply, 'sold out');
        require(walletMints[msg.sender] + quantity_ <= maxPerWallet, 'exceed max wallet');

        for (uint256 i = 0; i < quantity_; i++) {
            uint256 newTokenId = totalSupply + 1;
            totalSupply++;
            _safeMint(msg.sender, newTokenId);
        }
    }

    // using Counters for Counters.Counter;
    // uint256 maxSupply = 50;

    // bool public publicMintOpen = false;
    // bool public allowListMintOpen = false;

    // mapping(address => bool) public allowList;

    // Counters.Counter private _tokenIdCounter;

    // constructor() ERC721("NanameNFT", "NNM") {}

    // function _baseURI() internal pure override returns (string memory) {
    //     return "ipfs://Qmaa6TuP2s9pSKczHF4rwWhTKUdygrrDs8RmYYqCjP3Hye/";
    // }

    // function pause() public onlyOwner {
    //     _pause();
    // }

    // function unpause() public onlyOwner {
    //     _unpause();
    // }

    // // Modify Mint Windows
    // function editMintWindows(
    //     bool _publicMintOpen,
    //     bool _allowListMintOpen
    // ) external onlyOwner {
    //     publicMintOpen = _publicMintOpen;
    //     allowListMintOpen = _allowListMintOpen;
    // }

    // // Only allowList User to Mint
    // function allowListMint() public payable {
    //     require(allowListMintOpen, "Allowlist Mint Closed");
    //     require(allowList[msg.sender], "You are not on the allow list");
    //     require(msg.value == 0.001 ether, "Not Enough Funds");
    //     internalMint();
    // }

    // // Payment and Supply Limit
    // function publicMint() public payable {
    //     require(publicMintOpen, "Public Mint Closed");
    //     require(msg.value == 0.01 ether, "Not Enough Funds");
    //     internalMint();
    // }

    // function internalMint() internal {
    //     require(totalSupply() < maxSupply, "No Supply to Mint");
    //     uint256 tokenId = _tokenIdCounter.current();
    //     _tokenIdCounter.increment();
    //     _safeMint(msg.sender, tokenId);
    // }

    // function withdraw(address _addr) external onlyOwner {
    //     // get contract bal
    //     uint256 balalnce = address(this).balance;
    //     payable(_addr).transfer(balalnce);
    // }

    // // Populate the Allow List
    // function setAllowList(address[] calldata addresses) external onlyOwner {
    //     for(uint256 i = 0; i < addresses.length; i++){
    //         allowList[addresses[i]] = true;
    //     }
    // }

    // function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
    //     internal
    //     whenNotPaused
    //     override(ERC721, ERC721Enumerable)
    // {
    //     super._beforeTokenTransfer(from, to, tokenId, batchSize);
    // }

    // The following functions are overrides required by Solidity.

    // function supportsInterface(bytes4 interfaceId)
    //     public
    //     view
    //     override(ERC721, ERC721Enumerable)
    //     returns (bool)
    // {
    //     return super.supportsInterface(interfaceId);
    // }
}