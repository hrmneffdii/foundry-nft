// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNft is ERC721{
    error BasicNft__TokenUriNotFound();

    uint256 private s_tokenCounter;
    mapping (uint256 => string) private s_tokenIdToUri;
    
    constructor () ERC721("Dogie", "DOG") {
        s_tokenCounter = 0;
    }

    function mintNft(string memory _tokenUri) public {
        s_tokenIdToUri[s_tokenCounter] = _tokenUri;
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        if(ownerOf(_tokenId) == address(0)) {
            revert BasicNft__TokenUriNotFound();
        }
        return s_tokenIdToUri[_tokenId];
    }

    //** Getter functions */

    function tokenCounter() external view returns (uint256) {
        return s_tokenCounter;
    }
}